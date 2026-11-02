"""
Run metrics collection for the data pipeline.

Behaviour-neutral by design: a NullMetrics instance satisfies the whole
interface and does nothing, so every existing call site keeps working and the
legacy print-scripts are unaffected.

The collected structure is serialized to a run report and is the direct input
to the HTML dashboard, so the shape is deliberately dashboard-friendly: flat
arrays of uniform records, every duration suffixed _s, every rate _per_s.
"""

import json
import os
import platform
import threading
import time
import traceback
from contextlib import contextmanager
from dataclasses import dataclass, field, asdict
from datetime import datetime, timezone
from typing import Any, Dict, List, Optional

SCHEMA_VERSION = 1


def _utc_now_iso() -> str:
    return datetime.now(timezone.utc).isoformat().replace("+00:00", "Z")


def _safe_version(module_name: str) -> Optional[str]:
    """Best-effort version lookup. Faker exposes VERSION, not __version__."""
    try:
        mod = __import__(module_name)
    except Exception:
        return None
    for attr in ("__version__", "VERSION", "version"):
        value = getattr(mod, attr, None)
        if isinstance(value, str) and value:
            return value
    try:
        from importlib.metadata import version

        return version(module_name)
    except Exception:
        return None


@dataclass
class FileMetric:
    """One file written by a file sink."""

    sink: str
    path: str
    duration_s: float = 0.0
    bytes: int = 0


@dataclass
class LoadMetric:
    """One table's load into PostgreSQL."""

    strategy: str
    duration_s: float = 0.0
    rows: int = 0
    rows_per_s: float = 0.0
    roundtrips: int = 0
    bytes_sent: int = 0
    bytes_exact: bool = False
    batches: int = 0
    page_size: Optional[int] = None
    simulated: bool = False


@dataclass
class FieldDetail:
    """Per-field data-quality observation."""

    field: str
    distinct_ratio: Optional[float] = None
    null_ratio: Optional[float] = None


@dataclass
class TableMetric:
    table: str
    rows: int = 0
    fields: int = 0
    declared_format: str = ""
    destinations: List[str] = field(default_factory=list)
    generate_s: float = 0.0
    generate_rows_per_s: float = 0.0
    engine: str = ""
    load: Optional[LoadMetric] = None
    files: List[FileMetric] = field(default_factory=list)
    fields_detail: List[FieldDetail] = field(default_factory=list)


@dataclass
class Span:
    name: str
    start_wall: str
    duration_s: float = 0.0
    status: str = "success"
    attrs: Dict[str, Any] = field(default_factory=dict)


class NullMetrics:
    """No-op implementation. The default everywhere, so metrics stay optional."""

    enabled = False

    @contextmanager
    def span(self, name: str, **attrs):
        yield None

    def emit(self, kind: str, **payload) -> None:
        pass

    def table(self, name: str) -> TableMetric:
        return TableMetric(table=name)

    def adopt_table(self, tm: TableMetric) -> None:
        pass

    def counter(self, name: str, n: int = 1) -> None:
        pass

    def warn(self, message: str) -> None:
        pass

    def error(self, message: str) -> None:
        pass

    def record_exception(self, exc: BaseException) -> None:
        pass

    def set_config(self, **kwargs) -> None:
        pass

    def set_environment(self, **kwargs) -> None:
        pass

    def set_graph(self, **kwargs) -> None:
        pass

    def set_verification(self, **kwargs) -> None:
        pass

    def finish(self, status: str = "success") -> Dict[str, Any]:
        return {}

    def write(self, path: str = "", status: str = "success") -> Optional[str]:
        return None


class MetricsCollector:
    """
    Collects timings, counts and verification results for one pipeline run.

    Injected rather than global: OutputHandler(metrics=...),
    DataGenerator(..., metrics=...). The lock guards registry mutation only;
    individual TableMetric objects are single-owner at any moment, so parallel
    table loads mutate their own object and the parent merges by collection.
    """

    enabled = True

    def __init__(self, run_id: Optional[str] = None, on_event=None):
        self._lock = threading.Lock()
        # Optional sink for live progress. Set by the demo server so a browser
        # can watch a real run; None everywhere else, so this costs nothing.
        self.on_event = on_event
        self.run_id = run_id or self._make_run_id()
        self.started_at = _utc_now_iso()
        self._t0 = time.perf_counter()
        self.finished_at: Optional[str] = None
        self.duration_s: float = 0.0
        self.status: str = "running"
        self.db_state: str = "unknown"

        self.spans: List[Span] = []
        self._tables: Dict[str, TableMetric] = {}
        self._table_order: List[str] = []
        self.counters: Dict[str, int] = {}
        self.warnings: List[str] = []
        self.errors: List[str] = []

        self.config: Dict[str, Any] = {}
        self.environment: Dict[str, Any] = self._collect_environment()
        self.graph: Dict[str, Any] = {}
        self.verification: Dict[str, Any] = {}
        self.traceback: Optional[str] = None

    @staticmethod
    def _make_run_id() -> str:
        stamp = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H-%M-%SZ")
        return stamp + "-" + str(os.getpid()).zfill(6)

    @staticmethod
    def _collect_environment() -> Dict[str, Any]:
        env: Dict[str, Any] = {
            "python": platform.python_version(),
            "platform": platform.platform(),
            "machine": platform.machine(),
            "cpu": platform.processor() or None,
            "cores": os.cpu_count(),
            "numpy": _safe_version("numpy"),
            "cupy": _safe_version("cupy"),
            "faker": _safe_version("faker"),
            "pandas": _safe_version("pandas"),
            "psycopg2": None,
            "db_host_kind": None,
            "db_rtt_ms": None,
            "peak_rss_mb": None,
        }
        try:
            import psycopg2

            raw = getattr(psycopg2, "__version__", "")
            env["psycopg2"] = raw.split(" ")[0] or None
        except Exception:
            pass
        return env

    def emit(self, kind: str, **payload) -> None:
        """
        Publish a live progress event, if anyone is listening.

        Never allowed to break a run: a failing listener is swallowed, because
        a UI watching the pipeline must not be able to kill it.
        """
        if self.on_event is None:
            return
        try:
            event = {"type": kind, "t": round(time.perf_counter() - self._t0, 3)}
            event.update(payload)
            self.on_event(event)
        except Exception:
            pass

    @contextmanager
    def span(self, name: str, **attrs):
        """Time a named step. Records status 'failed' and re-raises on error."""
        sp = Span(name=name, start_wall=_utc_now_iso(), attrs=dict(attrs))
        started = time.perf_counter()
        self.emit("stage", stage=name, state="start")
        try:
            yield sp
        except BaseException as exc:
            sp.duration_s = round(time.perf_counter() - started, 6)
            sp.status = "failed"
            with self._lock:
                self.spans.append(sp)
            self.emit("stage", stage=name, state="failed",
                      duration_s=sp.duration_s, error=str(exc)[:200])
            raise
        else:
            sp.duration_s = round(time.perf_counter() - started, 6)
            with self._lock:
                self.spans.append(sp)
            self.emit("stage", stage=name, state="end", duration_s=sp.duration_s)

    def table(self, name: str) -> TableMetric:
        """Get or create the metric record for a table."""
        with self._lock:
            tm = self._tables.get(name)
            if tm is None:
                tm = TableMetric(table=name)
                self._tables[name] = tm
                self._table_order.append(name)
            return tm

    def adopt_table(self, tm: TableMetric) -> None:
        """Merge a TableMetric produced by a worker thread."""
        with self._lock:
            self._tables[tm.table] = tm
            if tm.table not in self._table_order:
                self._table_order.append(tm.table)

    def counter(self, name: str, n: int = 1) -> None:
        with self._lock:
            self.counters[name] = self.counters.get(name, 0) + n

    def warn(self, message: str) -> None:
        with self._lock:
            self.warnings.append(message)

    def error(self, message: str) -> None:
        with self._lock:
            self.errors.append(message)

    def set_config(self, **kwargs) -> None:
        self.config.update(kwargs)

    def set_environment(self, **kwargs) -> None:
        self.environment.update(kwargs)

    def set_graph(self, **kwargs) -> None:
        self.graph.update(kwargs)

    def set_verification(self, **kwargs) -> None:
        self.verification.update(kwargs)

    def record_exception(self, exc: BaseException) -> None:
        self.error(type(exc).__name__ + ": " + str(exc))
        self.traceback = "".join(
            traceback.format_exception(type(exc), exc, exc.__traceback__)
        )

    def _peak_rss_mb(self) -> Optional[float]:
        try:
            import psutil

            info = psutil.Process().memory_info()
            peak = getattr(info, "peak_wset", None) or getattr(info, "rss", None)
            if peak:
                return round(peak / (1024 * 1024), 1)
        except Exception:
            pass
        try:
            import resource

            usage = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss
            return round(usage / 1024, 1)
        except Exception:
            return None

    def finish(self, status: str = "success") -> Dict[str, Any]:
        self.status = status
        self.duration_s = round(time.perf_counter() - self._t0, 6)
        self.finished_at = _utc_now_iso()
        self.environment["peak_rss_mb"] = self._peak_rss_mb()

        tables: List[Dict[str, Any]] = []
        totals: Dict[str, Any] = {
            "rows_generated": 0,
            "rows_loaded": 0,
            "bytes_written_files": 0,
            "bytes_sent_db": 0,
            "roundtrips_db": 0,
            "generate_s": 0.0,
            "load_s": 0.0,
        }

        for name in self._table_order:
            tm = self._tables[name]
            if tm.generate_s > 0 and tm.rows:
                tm.generate_rows_per_s = round(tm.rows / tm.generate_s, 1)
            if tm.load is not None:
                lm = tm.load
                if lm.duration_s > 0 and lm.rows:
                    lm.rows_per_s = round(lm.rows / lm.duration_s, 1)
                totals["rows_loaded"] += lm.rows
                totals["bytes_sent_db"] += lm.bytes_sent
                totals["roundtrips_db"] += lm.roundtrips
                totals["load_s"] += lm.duration_s
            totals["rows_generated"] += tm.rows
            totals["generate_s"] += tm.generate_s
            for fm in tm.files:
                totals["bytes_written_files"] += fm.bytes
            tables.append(asdict(tm))

        totals["generate_s"] = round(totals["generate_s"], 6)
        totals["load_s"] = round(totals["load_s"], 6)
        if totals["generate_s"] > 0:
            totals["generate_rows_per_s"] = round(
                totals["rows_generated"] / totals["generate_s"], 1
            )
        if totals["load_s"] > 0:
            totals["load_rows_per_s"] = round(
                totals["rows_loaded"] / totals["load_s"], 1
            )

        report: Dict[str, Any] = {
            "schema_version": SCHEMA_VERSION,
            "run_id": self.run_id,
            "started_at": self.started_at,
            "finished_at": self.finished_at,
            "duration_s": self.duration_s,
            "status": self.status,
            "db_state": self.db_state,
            "config": self.config,
            "environment": self.environment,
            "steps": [asdict(s) for s in self.spans],
            "tables": tables,
            "totals": totals,
            "counters": self.counters,
            "verification": self.verification,
            "graph": self.graph,
            "warnings": self.warnings,
            "errors": self.errors,
        }
        if self.traceback:
            report["traceback"] = self.traceback
        return report

    def write(self, path: str = "runs/run_report.json", status: str = "success") -> str:
        """
        Serialize the report. Always writes two files: runs/<run_id>.json as the
        durable record and the given path as 'latest', so a failed run still
        leaves evidence behind.
        """
        report = self.finish(status=status)
        directory = os.path.dirname(path) or "."
        os.makedirs(directory, exist_ok=True)
        payload = json.dumps(report, indent=2, default=str)
        with open(path, "w", encoding="utf-8") as handle:
            handle.write(payload)
        archive = os.path.join(directory, self.run_id + ".json")
        with open(archive, "w", encoding="utf-8") as handle:
            handle.write(payload)
        return archive
