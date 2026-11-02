#!/usr/bin/env python3
"""
Demo server: serves overview.html and runs the real pipeline behind it.

The page on its own replays a recorded run. Served from here it gets a live
button instead: pressing it executes the actual Python pipeline in a background
thread, and every log line, stage transition and per-table completion is pushed
to the browser over Server-Sent Events as it happens.

Nothing is simulated. The stages you watch are src/metrics.py spans, the logs
are the pipeline's own logging output, and the final numbers come from the run
report it writes.

    python serve_demo.py                 # http://127.0.0.1:8900
    python serve_demo.py --port 9000
    python serve_demo.py --no-browser

Only this file knows about the browser. The pipeline is unchanged apart from an
optional event hook that does nothing when nobody is listening.
"""

import argparse
import asyncio
import json
import logging
import os
import queue
import threading
import time
import webbrowser
from typing import Any, Dict, Optional

import uvicorn
from dotenv import load_dotenv
from fastapi import FastAPI
from fastapi.responses import FileResponse, JSONResponse, StreamingResponse
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel

REPO = os.path.dirname(os.path.abspath(__file__))
SITE = os.path.join(REPO, "site")
PAGE = os.path.join(SITE, "index.html")

# Load the environment up front so /api/status can report truthfully
# whether a database is reachable before anyone presses the button.
load_dotenv(os.path.join(REPO, ".env"))

logger = logging.getLogger("serve_demo")


# --------------------------------------------------------------------------
# One run at a time, with its events fanned out to every connected browser.
# --------------------------------------------------------------------------

class RunBroker:
    """Owns the current run and broadcasts its events to subscribers."""

    def __init__(self) -> None:
        self._lock = threading.Lock()
        self._subscribers: list = []
        self._thread: Optional[threading.Thread] = None
        self._cancel = threading.Event()
        self.state = "idle"
        self.history: list = []          # replayed to a browser that joins late
        self.last_report: Optional[Dict[str, Any]] = None

    # -- fan-out ----------------------------------------------------------

    def subscribe(self) -> "queue.Queue":
        """
        Attach a listener.

        Backlog is replayed only while a run is actually in progress, so a
        browser joining mid-run catches up. Replaying a finished run's history
        would hand a fresh listener a stale 'done' event and make it think the
        run it is waiting for had already ended.
        """
        q: "queue.Queue" = queue.Queue(maxsize=4096)
        with self._lock:
            self._subscribers.append(q)
            backlog = list(self.history) if self.busy else []
        for event in backlog:
            try:
                q.put_nowait(event)
            except queue.Full:
                break
        return q

    def unsubscribe(self, q: "queue.Queue") -> None:
        with self._lock:
            if q in self._subscribers:
                self._subscribers.remove(q)

    def publish(self, event: Dict[str, Any]) -> None:
        with self._lock:
            if event.get("type") != "log" or len(self.history) < 2000:
                self.history.append(event)
            subs = list(self._subscribers)
        for q in subs:
            try:
                q.put_nowait(event)
            except queue.Full:
                pass

    # -- running ----------------------------------------------------------

    @property
    def busy(self) -> bool:
        return self._thread is not None and self._thread.is_alive()

    def cancel(self) -> bool:
        if not self.busy:
            return False
        self._cancel.set()
        self.publish({"type": "log", "level": "WARNING",
                      "msg": "Stop requested; finishing the current step first."})
        return True

    def start(self, options: Dict[str, Any]) -> bool:
        if self.busy:
            return False
        with self._lock:
            self.history = []
            self.last_report = None
        self._cancel.clear()
        self.state = "running"
        self._thread = threading.Thread(
            target=self._run, args=(options,), name="pipeline-run", daemon=True
        )
        self._thread.start()
        return True

    # -- the actual pipeline ----------------------------------------------

    def _run(self, options: Dict[str, Any]) -> None:
        handler = _StreamingLogHandler(self.publish, self._cancel)
        root = logging.getLogger()
        previous_level = root.level
        root.addHandler(handler)
        root.setLevel(logging.INFO)

        started = time.perf_counter()
        self.publish({"type": "run", "state": "start", "options": options})

        try:
            from src.data_generator import DataGenerator
            from src.metrics import MetricsCollector
            from data_pipeline import DataPipeline

            collector = MetricsCollector(on_event=self.publish)

            pipeline = DataPipeline(
                options.get("model") or "ecommerce_model.json",
                options.get("env") or ".env",
                seed=int(options.get("seed", DataGenerator.DEFAULT_SEED)),
                scale=float(options.get("scale", 0.05)),
                realism=bool(options.get("realism", True)),
                load_strategy=options.get("strategy", "copy"),
                offline=bool(options.get("offline", False)),
                verify_writes=bool(options.get("verify_writes", True)),
                export_dir=os.path.join(REPO, "exports"),
                report_path=os.path.join(REPO, "runs", "demo_run.json"),
            )
            # Replace the pipeline's own collector so its spans reach the page.
            collector.set_config(**pipeline.metrics.config)
            collector.set_graph(**pipeline.metrics.graph)
            pipeline.metrics = collector
            pipeline.db_manager.metrics = collector
            pipeline.data_generator.metrics = collector
            pipeline.output_handler.metrics = collector

            self.publish({
                "type": "plan",
                "tables": [
                    {
                        "table": name,
                        "rows": pipeline.graph.sample_size(
                            name, float(options.get("scale", 0.05))),
                        "format": pipeline.graph.output_format(name),
                    }
                    for name in pipeline.graph.topological_order()
                ],
                "postgres_closure": sorted(pipeline.graph.postgres_closure()),
                "order": pipeline.graph.topological_order(),
            })

            ok = pipeline.run_complete_pipeline()
            report = None
            try:
                with open(pipeline.report_path, encoding="utf-8") as fh:
                    report = json.load(fh)
            except Exception:
                pass
            self.last_report = report
            self.state = "done" if ok else "failed"
            self.publish({
                "type": "run", "state": "done" if ok else "failed",
                "duration_s": round(time.perf_counter() - started, 3),
                "report": report,
            })
        except BaseException as exc:  # noqa: BLE001
            self.state = "failed"
            logger.exception("demo run failed")
            self.publish({
                "type": "run", "state": "failed",
                "duration_s": round(time.perf_counter() - started, 3),
                "error": f"{type(exc).__name__}: {exc}",
            })
        finally:
            root.removeHandler(handler)
            root.setLevel(previous_level)


class _StreamingLogHandler(logging.Handler):
    """Pushes every log record to the browser as it is emitted."""

    def __init__(self, publish, cancel: threading.Event):
        super().__init__(level=logging.INFO)
        self._publish = publish
        self._cancel = cancel

    def emit(self, record: logging.LogRecord) -> None:
        try:
            self._publish({
                "type": "log",
                "level": record.levelname,
                "logger": record.name,
                "msg": self.format(record),
            })
        except Exception:
            pass


BROKER = RunBroker()


# --------------------------------------------------------------------------
# HTTP
# --------------------------------------------------------------------------

class RunRequest(BaseModel):
    scale: float = 0.05
    seed: int = 42
    strategy: str = "copy"
    realism: bool = True
    offline: bool = False
    verify_writes: bool = True
    model: Optional[str] = None
    env: Optional[str] = None


app = FastAPI(title="Pipeline demo server", docs_url=None, redoc_url=None)


@app.get("/")
async def index():
    if not os.path.exists(PAGE):
        return JSONResponse({"error": f"{PAGE} not found"}, status_code=404)
    return FileResponse(PAGE, media_type="text/html")


@app.get("/api/status")
async def status():
    """The page calls this on load to decide whether live running is available."""
    from src.db import resolve_db_config

    config = resolve_db_config()
    return {
        "live": True,
        "busy": BROKER.busy,
        "state": BROKER.state,
        "database_configured": config.available,
        "database_kind": config.host_kind,
        "cwd": REPO,
    }


@app.post("/api/run")
async def run(req: RunRequest):
    if BROKER.busy:
        return JSONResponse({"error": "a run is already in progress"}, status_code=409)
    started = BROKER.start(req.model_dump())
    return {"started": started}


@app.post("/api/stop")
async def stop():
    return {"stopping": BROKER.cancel()}


@app.get("/api/report")
async def report():
    if BROKER.last_report is None:
        return JSONResponse({"error": "no completed run yet"}, status_code=404)
    return BROKER.last_report


@app.get("/api/events")
async def events():
    """
    Server-Sent Events. One line of pipeline output becomes one message, so the
    browser sees the run unfold at the speed it actually happens.
    """
    q = BROKER.subscribe()

    async def stream():
        loop = asyncio.get_running_loop()
        try:
            yield "retry: 2000\n\n"
            while True:
                try:
                    event = await loop.run_in_executor(None, q.get, True, 15.0)
                except queue.Empty:
                    yield ": keep-alive\n\n"
                    continue
                yield "data: " + json.dumps(event, default=str) + "\n\n"
        except asyncio.CancelledError:
            raise
        finally:
            BROKER.unsubscribe(q)

    return StreamingResponse(
        stream(),
        media_type="text/event-stream",
        headers={"Cache-Control": "no-cache", "X-Accel-Buffering": "no"},
    )


app.mount("/", StaticFiles(directory=SITE, html=True), name="site")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--host", default="127.0.0.1")
    parser.add_argument("--port", type=int, default=8900)
    parser.add_argument("--no-browser", action="store_true")
    args = parser.parse_args()

    logging.basicConfig(
        level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s"
    )
    url = f"http://{args.host}:{args.port}/"
    print("=" * 64)
    print("  Pipeline demo server")
    print("=" * 64)
    print(f"  Page:      {url}")
    print(f"  Serving:   {SITE}")
    print("  The Live run section will offer a real run button.")
    print("  Press Ctrl+C to stop.")
    print("=" * 64)
    if not args.no_browser:
        threading.Timer(1.0, lambda: webbrowser.open(url)).start()
    uvicorn.run(app, host=args.host, port=args.port, log_level="warning")


if __name__ == "__main__":
    main()
