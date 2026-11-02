"""
Multi-destination writers.

Routes each table to its declared destination, and additionally to PostgreSQL
whenever some PostgreSQL-backed table depends on it. That dual-destination
closure is what makes foreign keys valid across heterogeneous sinks, which is
the project's central claim.

Notable changes from the original implementation:

  * The PostgreSQL load goes through an interchangeable strategy instead of a
    hardcoded row-at-a-time loop, so the dominant cost of a run is measurable
    and tunable rather than fixed.
  * A failure writing any file sink used to be logged and swallowed, after
    which the run announced success and exited 0. Losing 35,000 CSV rows to a
    full disk and reporting success is the worst possible outcome for anything
    scripted, so failures are now collected and re-raised.
  * Value conversion is delegated to src.serialization, so the sinks cannot
    drift apart. In particular Decimal is no longer downcast to float before
    insert, which was both slower and lossier than psycopg2's native adapter.
  * No emoji in log strings. Windows consoles using the cp1252 code page raise
    UnicodeEncodeError on them, and several of the original occurrences were on
    error paths, so a real failure could be replaced by an encoding error.
"""

import json
import logging
import os
import time
from concurrent.futures import ThreadPoolExecutor
from typing import Any, Dict, Iterable, List, Optional, Sequence, Set

import pandas as pd
import psycopg2
from dotenv import load_dotenv

try:
    from src.db import InstrumentedCursor, DbConfig, connect, resolve_db_config
    from src.load_strategies import DEFAULT_PAGE_SIZE, DEFAULT_STRATEGY, get_strategy
    from src.metrics import FileMetric, LoadMetric, NullMetrics
    from src.model_graph import ModelGraph, POSTGRES_BACKED_FORMATS
    from src.serialization import (
        RecordJSONEncoder,
        to_csv_scalar,
        to_json_scalar,
        to_parquet_scalar,
        to_pg_param,
    )
except ImportError:  # pragma: no cover - supports direct module execution
    from db import InstrumentedCursor, DbConfig, connect, resolve_db_config
    from load_strategies import DEFAULT_PAGE_SIZE, DEFAULT_STRATEGY, get_strategy
    from metrics import FileMetric, LoadMetric, NullMetrics
    from model_graph import ModelGraph, POSTGRES_BACKED_FORMATS
    from serialization import (
        RecordJSONEncoder,
        to_csv_scalar,
        to_json_scalar,
        to_parquet_scalar,
        to_pg_param,
    )

load_dotenv()

logger = logging.getLogger(__name__)

# Session settings applied to each load connection.
#
# synchronous_commit is included for completeness and is expected to change
# nothing measurable: once rows are batched there are only a handful of commits
# per run rather than one per row, so there are almost no fsyncs left to skip.
# statement_timeout matters more -- a multi-megabyte COPY on a slow uplink can
# exceed a role-level timeout and be killed mid-stream.
SESSION_TUNING = (
    ("statement_timeout", "0"),
    ("synchronous_commit", "off"),
)


class OutputHandler:
    def __init__(self, model: Optional[Dict[str, Any]] = None, metrics=None,
                 load_strategy: str = DEFAULT_STRATEGY,
                 page_size: int = DEFAULT_PAGE_SIZE,
                 parallel_loads: int = 1,
                 truncate: bool = False,
                 offline: bool = False,
                 export_dir: str = "exports",
                 measure_bytes: bool = False,
                 defer_constraints: bool = True):
        """
        Initialize output handler.

        Every argument has a default, so OutputHandler() still works exactly as
        before for the root-level demo scripts.
        """
        self.logger = logging.getLogger(__name__)
        self.metrics = metrics if metrics is not None else NullMetrics()
        self.model = model
        self._graph = ModelGraph(model) if model else None

        self.strategy_name = load_strategy
        self.page_size = page_size
        self.parallel_loads = max(1, int(parallel_loads))
        self.truncate = truncate
        self.offline = offline
        self.export_dir = export_dir
        self.measure_bytes = measure_bytes
        self.defer_constraints = defer_constraints

        self.db_config: DbConfig = resolve_db_config()
        # Retained for backwards compatibility with existing callers.
        self.database_url = os.getenv("DATABASE_URL")
        self.db_params = {
            "host": os.getenv("DB_HOST"),
            "port": os.getenv("DB_PORT", 5432),
            "database": os.getenv("DB_NAME"),
            "user": os.getenv("DB_USER"),
            "password": os.getenv("DB_PASSWORD"),
        }

    # -- connections -------------------------------------------------------

    def connect_db(self):
        """Establish a database connection via the shared resolver."""
        try:
            conn = connect(self.db_config if self.db_config.available else None)
            self._apply_session_tuning(conn)
            return conn
        except Exception as exc:
            self.logger.error(f"Database connection failed: {exc}")
            raise

    def _apply_session_tuning(self, conn) -> None:
        """
        Apply session settings, recording which the server refused.

        Nothing here is required for correctness, so a refusal is noted and the
        run continues. On a transaction-pooling connection these silently fail
        to persist, which is why the preflight warns about that port.
        """
        applied, rejected = {}, []
        for setting, value in SESSION_TUNING:
            try:
                with conn.cursor() as cursor:
                    cursor.execute(f"SET {setting} = %s;", (value,))
                applied[setting] = value
            except Exception as exc:
                conn.rollback()
                rejected.append({"setting": setting, "reason": str(exc).strip()[:120]})
        if applied or rejected:
            self.metrics.set_config(
                session_tuning={"applied": applied, "rejected": rejected}
            )

    # -- serialization shims (kept for compatibility) ----------------------

    def serialize_value_for_db(self, value):
        """
        Convert a Python value for database insertion.

        Delegates to the shared converter. Note Decimal is now passed through
        rather than converted to float: psycopg2 adapts it natively and
        exactly, so the previous conversion lost precision on any column whose
        scale was not 2.
        """
        return to_pg_param(value)

    def serialize_record_for_db(self, record: Dict) -> Dict:
        return {key: to_pg_param(value) for key, value in record.items()}

    def serialize_record_for_file(self, record: Dict) -> Dict:
        return {key: to_json_scalar(value) for key, value in record.items()}

    # -- routing -----------------------------------------------------------

    def graph_for(self, generated_data: Dict[str, Dict]) -> ModelGraph:
        """
        The model graph, reconstructed from generated data when no model was
        supplied, so older call sites keep working.
        """
        if self._graph is not None:
            return self._graph
        tables = [info["config"] for info in generated_data.values()]
        return ModelGraph({"tables": tables})

    def find_postgresql_dependencies(self, generated_data: Dict[str, Dict]) -> Set[str]:
        """
        Which tables must exist in PostgreSQL for foreign keys to resolve.

        Now a transitive closure. The previous version expanded foreign keys
        only from the seed set, so a dependency of a dependency was silently
        omitted and its children's constraints would fail at load. That happened
        to be harmless on the shipped model, where the one-level result was
        already complete, and would bite on any model with a deeper chain.
        """
        return self.graph_for(generated_data).postgres_closure()

    def get_postgresql_insertion_order(self, generated_data: Dict[str, Dict],
                                       required_tables: Set[str]) -> List[str]:
        """Dependency-respecting, deterministic insertion order."""
        graph = self.graph_for(generated_data)
        return graph.subgraph(required_tables).topological_order()

    def load_waves(self, generated_data: Dict[str, Dict],
                   required_tables: Set[str]) -> List[List[str]]:
        """
        Tables grouped so each wave depends only on earlier waves.

        With constraints deferred there are no foreign keys during the load, so
        the ordering is not required for correctness and every table could go at
        once. The waves are still computed because they are required when
        constraints are not deferred, and because they are what a parallel
        loader schedules against.
        """
        graph = self.graph_for(generated_data)
        if self.defer_constraints:
            return [sorted(required_tables)]
        return graph.subgraph(required_tables).waves()

    # -- PostgreSQL --------------------------------------------------------

    def handle_postgresql_output(self, table_name: str, data: List[Dict],
                                 config: Dict, conn=None) -> None:
        """Load one table into PostgreSQL using the configured strategy."""
        self.logger.info(
            f"Loading {len(data)} records into PostgreSQL table: {table_name}"
        )
        if not data:
            self.logger.warning(f"No data to insert for table: {table_name}")
            return

        if self.offline:
            self._write_offline_copy_payload(table_name, data)
            return

        owned = conn is None
        if owned:
            conn = self.connect_db()
        raw_cursor = conn.cursor()
        cursor = InstrumentedCursor(raw_cursor)

        try:
            if self.truncate:
                # The original issued DELETE FROM unconditionally. Immediately
                # after create_schema that table is empty, so it was pure
                # waste; TRUNCATE is the right operation when it is needed.
                cursor.execute(f'TRUNCATE TABLE "{table_name}";')

            columns = list(data[0].keys())
            strategy = get_strategy(
                self.strategy_name, self.page_size, self.measure_bytes
            )
            stats = strategy.load(cursor, table_name, columns, data)
            conn.commit()

            table_metric = self.metrics.table(table_name)
            table_metric.load = LoadMetric(**stats)
            if "postgresql" not in table_metric.destinations:
                table_metric.destinations.append("postgresql")
            self.metrics.emit("table", table=table_name, phase="load",
                              rows=stats["rows"], duration_s=stats["duration_s"],
                              roundtrips=stats["roundtrips"],
                              bytes_sent=stats["bytes_sent"],
                              strategy=stats["strategy"])

            self.logger.info(
                "Loaded %s records into %s via %s in %.2fs "
                "(%s round trips, %s bytes)",
                len(data), table_name, stats["strategy"], stats["duration_s"],
                stats["roundtrips"], stats["bytes_sent"] or "unmeasured",
            )
        except Exception as exc:
            conn.rollback()
            self.logger.error(f"Failed to load data into {table_name}: {exc}")
            raise
        finally:
            raw_cursor.close()
            if owned:
                conn.close()

    def _write_offline_copy_payload(self, table_name: str, data: List[Dict]) -> None:
        """
        In offline mode, write the exact bytes that would have gone over the
        wire, so the payload size is real even though the timing is not.
        """
        from src.serialization import to_pg_text

        directory = os.path.join(self.export_dir, "sql")
        os.makedirs(directory, exist_ok=True)
        path = os.path.join(directory, f"{table_name}.copy.tsv")
        columns = list(data[0].keys())
        started = time.perf_counter()
        with open(path, "w", encoding="utf-8", newline="") as handle:
            for record in data:
                handle.write("\t".join(to_pg_text(record.get(c)) for c in columns))
                handle.write("\n")
        size = os.path.getsize(path)

        table_metric = self.metrics.table(table_name)
        table_metric.load = LoadMetric(
            strategy=self.strategy_name,
            duration_s=round(time.perf_counter() - started, 6),
            rows=len(data),
            roundtrips=0,
            bytes_sent=size,
            bytes_exact=True,
            batches=1,
            simulated=True,
        )
        if "postgresql(offline)" not in table_metric.destinations:
            table_metric.destinations.append("postgresql(offline)")
        self.logger.info(
            f"Offline: wrote {len(data)} records for {table_name} to {path} "
            f"({size:,} bytes)"
        )

    def handle_api_output(self, table_name: str, data: List[Dict],
                          config: Dict, conn=None) -> None:
        """
        Prepare a table for API access.

        API tables are served from PostgreSQL, so this loads them there. In
        offline mode it also writes a JSON file the API server can serve
        without a database, which is what makes an offline demo possible.
        """
        self.logger.info(
            f"Preparing {len(data)} records for API access: {table_name}"
        )
        self.handle_postgresql_output(table_name, data, config, conn=conn)

        # Record 'api' alongside 'postgresql' so the run report shows that this
        # table is served, not merely stored.
        table_metric = self.metrics.table(table_name)
        if "api" not in table_metric.destinations:
            table_metric.destinations.append("api")

        if self.offline:
            self._write_file(
                table_name, data, sink="api",
                directory=os.path.join(self.export_dir, "api"),
                extension="json",
            )

    # -- file sinks --------------------------------------------------------

    def _write_file(self, table_name: str, data: List[Dict], sink: str,
                    directory: str, extension: str) -> str:
        path = os.path.join(directory, f"{table_name}.{extension}")
        os.makedirs(directory, exist_ok=True)
        started = time.perf_counter()

        if sink == "csv":
            frame = pd.DataFrame(
                [{k: to_csv_scalar(v) for k, v in r.items()} for r in data]
            )
            frame = self._tighten_integer_columns(frame, table_name)
            frame.to_csv(path, index=False)
        elif sink == "parquet":
            frame = pd.DataFrame(
                [{k: to_parquet_scalar(v) for k, v in r.items()} for r in data]
            )
            frame = self._tighten_integer_columns(frame, table_name)
            frame.to_parquet(path, index=False, compression="snappy")
        else:
            # JSON, including the offline API payload. Deliberately not
            # streamed: the largest file here is a few tens of megabytes and
            # takes a couple of seconds, and streaming would change the
            # indentation of an artefact that gets submitted.
            payload = [
                {k: to_json_scalar(v) for k, v in r.items()} for r in data
            ]
            with open(path, "w", encoding="utf-8") as handle:
                json.dump(payload, handle, indent=2, cls=RecordJSONEncoder)

        size = os.path.getsize(path)
        self.metrics.table(table_name).files.append(
            FileMetric(
                sink=sink,
                path=path,
                duration_s=round(time.perf_counter() - started, 6),
                bytes=size,
            )
        )
        table_metric = self.metrics.table(table_name)
        if sink not in table_metric.destinations:
            table_metric.destinations.append(sink)
        self.metrics.emit("file", table=table_name, sink=sink, path=path,
                          bytes=size, rows=len(data))
        self.logger.info(
            f"Exported {len(data)} records to {path} ({size:,} bytes)"
        )
        return path

    def _tighten_integer_columns(self, frame: "pd.DataFrame",
                                 table_name: str) -> "pd.DataFrame":
        """
        Keep nullable integer columns as integers.

        A single None in an integer column promotes the whole column to float64,
        so a nullable foreign key was written to CSV as '1.0' instead of '1'.
        pandas' nullable Int64 dtype represents the same data without the
        promotion.
        """
        if self._graph is None or table_name not in self._graph:
            return frame
        for field in self._graph.config(table_name).get("fields", []):
            name = field.get("name")
            if field.get("type") != "integer" or name not in frame.columns:
                continue
            try:
                frame[name] = frame[name].astype("Int64")
            except (TypeError, ValueError):
                pass
        return frame

    def handle_csv_output(self, table_name: str, data: List[Dict],
                          config: Dict) -> None:
        """Export data to a CSV file."""
        if not data:
            self.logger.warning(f"No data to export for CSV: {table_name}")
            return
        self._write_file(
            table_name, data, "csv", os.path.join(self.export_dir, "csv"), "csv"
        )

    def handle_json_output(self, table_name: str, data: List[Dict],
                           config: Dict) -> None:
        """Export data to a JSON file."""
        if not data:
            self.logger.warning(f"No data to export for JSON: {table_name}")
            return
        self._write_file(
            table_name, data, "json", os.path.join(self.export_dir, "json"), "json"
        )

    def handle_parquet_output(self, table_name: str, data: List[Dict],
                              config: Dict) -> None:
        """
        Export data to a Parquet file.

        The columnar destination: typed, compressed and the format big-data
        tooling actually consumes, which makes it the natural comparison point
        against the row-oriented CSV and document-oriented JSON sinks.
        """
        if not data:
            self.logger.warning(f"No data to export for Parquet: {table_name}")
            return
        self._write_file(
            table_name, data, "parquet",
            os.path.join(self.export_dir, "parquet"), "parquet",
        )

    # -- orchestration -----------------------------------------------------

    def process_all_outputs(self, generated_data: Dict[str, Dict]) -> None:
        """Write every table to its destinations, PostgreSQL dependencies first."""
        self.logger.info("Processing all data outputs...")

        graph = self.graph_for(generated_data)
        required = self.find_postgresql_dependencies(generated_data)

        self.logger.info("Foreign key dependency analysis:")
        for table_name in sorted(required):
            declared = generated_data[table_name]["output_format"]
            if declared in POSTGRES_BACKED_FORMATS:
                self.logger.info(f"   {table_name}: {declared}")
            else:
                self.logger.info(
                    f"   {table_name}: {declared} + PostgreSQL (for FK integrity)"
                )

        self.metrics.set_graph(
            postgres_closure=sorted(required),
            load_waves=self.load_waves(generated_data, required),
        )

        self.logger.info("PHASE 1: PostgreSQL tables (dependencies first)")
        self._run_postgres_phase(generated_data, required)

        self.logger.info("PHASE 2: primary file destinations")
        self._run_file_phase(generated_data)

        self.logger.info("All data outputs processed successfully")

    def _run_postgres_phase(self, generated_data: Dict[str, Dict],
                            required: Set[str]) -> None:
        waves = self.load_waves(generated_data, required)

        for wave in waves:
            members = [t for t in wave if t in required]
            if not members:
                continue
            if self.parallel_loads > 1 and len(members) > 1 and not self.offline:
                self._load_wave_parallel(generated_data, members)
            else:
                for table_name in members:
                    info = generated_data[table_name]
                    self._dispatch_postgres(table_name, info)

    def _dispatch_postgres(self, table_name: str, info: Dict, conn=None) -> None:
        handler = (
            self.handle_api_output
            if info["output_format"] == "api"
            else self.handle_postgresql_output
        )
        handler(table_name, info["data"], info["config"], conn=conn)

    def _load_wave_parallel(self, generated_data: Dict[str, Dict],
                            members: Sequence[str]) -> None:
        """
        Load independent tables concurrently, one connection per worker.

        Threads are appropriate here despite the GIL because psycopg2 releases
        it while waiting on the socket. Whether this actually helps is an open
        question worth measuring rather than assuming: once rows are batched the
        work is bandwidth-bound, and splitting one uplink N ways does not create
        bandwidth. It defaults to off.
        """
        workers = min(self.parallel_loads, len(members))
        self.logger.info(
            f"Loading {len(members)} tables concurrently with {workers} workers"
        )

        def worker(table_name: str):
            conn = self.connect_db()
            try:
                self._dispatch_postgres(table_name, generated_data[table_name], conn)
            finally:
                conn.close()

        errors: List[BaseException] = []
        with ThreadPoolExecutor(max_workers=workers) as pool:
            futures = {pool.submit(worker, t): t for t in members}
            for future, table_name in futures.items():
                try:
                    future.result()
                except BaseException as exc:  # noqa: BLE001
                    errors.append(exc)
                    self.logger.error(f"Parallel load failed for {table_name}: {exc}")
        if errors:
            raise errors[0]

    def _run_file_phase(self, generated_data: Dict[str, Dict]) -> None:
        """
        Write the file sinks.

        Failures are collected and re-raised rather than swallowed. The original
        logged an exception, continued, then unconditionally reported success
        and exited 0, so a full disk or a permissions error could silently lose
        tens of thousands of rows while the pipeline claimed to have worked.
        """
        writers = {
            "csv": self.handle_csv_output,
            "json": self.handle_json_output,
            "parquet": self.handle_parquet_output,
        }
        failures: List[str] = []

        for table_name, info in generated_data.items():
            output_format = info["output_format"]
            if output_format in POSTGRES_BACKED_FORMATS:
                continue  # Already handled in phase 1.

            writer = writers.get(output_format)
            if writer is None:
                message = (
                    f"Unknown output format '{output_format}' for table "
                    f"'{table_name}'"
                )
                self.logger.error(message)
                failures.append(message)
                continue

            self.logger.info(f"Processing {table_name} -> {output_format}")
            try:
                writer(table_name, info["data"], info["config"])
            except Exception as exc:
                message = f"Failed to write {output_format} for {table_name}: {exc}"
                self.logger.error(message)
                failures.append(message)

        if failures:
            for message in failures:
                self.metrics.error(message)
            raise RuntimeError(
                f"{len(failures)} output destination(s) failed: "
                + "; ".join(failures)
            )
