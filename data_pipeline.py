#!/usr/bin/env python3
"""
Declarative synthetic data pipeline.

Reads a JSON data model and materialises a complete, referentially-consistent
synthetic dataset into PostgreSQL, CSV, JSON, Parquet and a REST API, reporting
exactly what it did and how long each part took.

CLI entrypoint and orchestrator.
"""

import json
import logging
import os
import sys
from pathlib import Path
from typing import Any, Dict, List, Optional

import click
from dotenv import load_dotenv

from src.database_manager import DatabaseManager
from src.data_generator import DataGenerator
from src.db import preflight, resolve_db_config
from src.load_strategies import DEFAULT_PAGE_SIZE, DEFAULT_STRATEGY, STRATEGIES
from src.metrics import MetricsCollector
from src.model_graph import ModelGraph
from src.serialization import to_pg_param
from src.output_handlers import OutputHandler

logging.basicConfig(
    level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s"
)
logger = logging.getLogger(__name__)

DEFAULT_MODEL = "ecommerce_model.json"
DEFAULT_REPORT = "runs/run_report.json"


class DataPipeline:
    def __init__(self, model_file: str, env_file: str, *,
                 seed: int = DataGenerator.DEFAULT_SEED,
                 scale: float = 1.0,
                 realism: bool = True,
                 reference_date: Optional[str] = None,
                 load_strategy: str = DEFAULT_STRATEGY,
                 page_size: int = DEFAULT_PAGE_SIZE,
                 parallel_loads: int = 1,
                 defer_constraints: bool = True,
                 truncate: bool = False,
                 offline: bool = False,
                 keep_partial: bool = False,
                 verify_writes: bool = False,
                 measure_bytes: bool = False,
                 export_dir: str = "exports",
                 report_path: str = DEFAULT_REPORT):
        self.model_file = model_file
        self.env_file = env_file
        self.offline = offline
        self.defer_constraints = defer_constraints
        self.keep_partial = keep_partial
        self.verify_writes = verify_writes
        self.report_path = report_path

        load_dotenv(env_file)

        self.metrics = MetricsCollector()
        self.model = self._load_model(model_file)
        self.graph = ModelGraph(self.model)

        self.metrics.set_config(
            model_file=model_file,
            model_hash=self.graph.model_hash(),
            engine="legacy",
            seed=seed,
            scale=scale,
            realism=realism,
            reference_date=reference_date or DataGenerator.DEFAULT_REFERENCE_DATE,
            load_strategy=load_strategy,
            page_size=page_size if load_strategy == "execute_values" else None,
            parallel_loads=parallel_loads,
            defer_constraints=defer_constraints,
            offline=offline,
        )
        self.metrics.set_graph(**self.graph.describe())

        self.db_manager = DatabaseManager(env_file, metrics=self.metrics)
        self.data_generator = DataGenerator(
            model_file, seed=seed, scale=scale, metrics=self.metrics,
            reference_date=reference_date, realism=realism,
        )
        self.output_handler = OutputHandler(
            model=self.model, metrics=self.metrics, load_strategy=load_strategy,
            page_size=page_size, parallel_loads=parallel_loads,
            truncate=truncate, offline=offline, export_dir=export_dir,
            measure_bytes=measure_bytes, defer_constraints=defer_constraints,
        )

        logger.info(f"Pipeline initialized with model: {model_file}")

    @staticmethod
    def _load_model(model_file: str) -> Dict[str, Any]:
        with open(model_file, "r", encoding="utf-8") as handle:
            return json.load(handle)

    # -- planning ----------------------------------------------------------

    def plan(self) -> Dict[str, Any]:
        """
        Describe what a run would do, without generating or writing anything.

        Possible only because the model graph is computed from the model rather
        than from already-generated data.
        """
        scale = self.metrics.config.get("scale", 1.0)
        closure = self.graph.postgres_closure()
        tables = []
        for name in self.graph.topological_order():
            rows = self.graph.sample_size(name, scale)
            destinations = [self.graph.output_format(name)]
            if name in closure and self.graph.output_format(name) not in (
                "postgresql", "api"
            ):
                destinations.append("postgresql")
            tables.append(
                {
                    "table": name,
                    "rows": rows,
                    "fields": len(self.graph.config(name).get("fields", [])),
                    "destinations": destinations,
                }
            )

        problems = self.graph.validate()
        plan = {
            "model": self.model_file,
            "total_rows": sum(t["rows"] for t in tables),
            "tables": tables,
            "postgres_closure": sorted(closure),
            "load_waves": self.output_handler.load_waves(
                {
                    n: {"config": self.graph.config(n)}
                    for n in self.graph.table_names
                },
                closure,
            ),
            "cycles": self.graph.cycles(),
            "problems": problems,
        }

        logger.info("=" * 72)
        logger.info("DRY RUN: execution plan only, nothing generated or written")
        logger.info("=" * 72)
        logger.info(f"{'table':<16}{'rows':>10}  destinations")
        for entry in tables:
            logger.info(
                f"{entry['table']:<16}{entry['rows']:>10,}  "
                + " + ".join(entry["destinations"])
            )
        logger.info(f"{'TOTAL':<16}{plan['total_rows']:>10,}")
        logger.info("")
        logger.info(f"creation order   : {', '.join(self.graph.topological_order())}")
        logger.info(f"postgres closure : {', '.join(plan['postgres_closure'])}")
        logger.info(f"load waves       : {plan['load_waves']}")
        if problems:
            logger.error("model problems:")
            for problem in problems:
                logger.error(f"  - {problem}")
        else:
            logger.info("model validates clean")
        return plan

    # -- the run -----------------------------------------------------------

    def run_complete_pipeline(self) -> bool:
        """
        Execute the pipeline.

        The run report is always written, including on failure. Previously an
        exception was swallowed into a False return, so the run you most want
        evidence from produced none.
        """
        logger.info("=" * 72)
        logger.info("STARTING PIPELINE EXECUTION")
        logger.info("=" * 72)

        status = "success"
        db_state = "not_touched"
        loaded_tables: List[str] = []

        try:
            if not self.offline:
                config = resolve_db_config()
                preflight(config, self.metrics)
                self.db_manager.measure_rtt()

            with self.metrics.span("schema"):
                if self.offline:
                    logger.info("STEP 1: Rendering schema DDL (offline)")
                    self._render_offline_schema()
                else:
                    logger.info("STEP 1: Creating database schema")
                    self.db_manager.create_schema(
                        self.model_file,
                        with_foreign_keys=not self.defer_constraints,
                    )
                    db_state = "schema_only"

            with self.metrics.span("generate"):
                logger.info("STEP 2: Generating data")
                generated_data = self.data_generator.generate_all_data()

            with self.metrics.span("output"):
                logger.info("STEP 3: Writing to all destinations")
                self.output_handler.process_all_outputs(generated_data)
                loaded_tables = sorted(
                    self.output_handler.find_postgresql_dependencies(generated_data)
                )
                db_state = (
                    "loaded_unconstrained" if self.defer_constraints else "loaded"
                )

            with self.metrics.span("finalize"):
                logger.info("STEP 4: Finalising and verifying")
                db_state = self._finalize(generated_data, loaded_tables)

            with self.metrics.span("report"):
                logger.info("STEP 5: Summary")
                self.generate_summary_report(generated_data)

            logger.info("=" * 72)
            logger.info("PIPELINE EXECUTION FINISHED SUCCESSFULLY")
            logger.info("=" * 72)
            return True

        except Exception as exc:
            status = "failed"
            self.metrics.record_exception(exc)
            logger.error(f"Pipeline execution failed: {exc}", exc_info=True)

            if (
                db_state == "loaded_unconstrained"
                and not self.offline
                and not self.keep_partial
            ):
                # Deferring constraints introduces a failure mode the original
                # did not have: a half-loaded database that looks populated but
                # guarantees nothing. Restore the invariant that the database is
                # either fully loaded and constrained, or empty.
                db_state = self._rollback_partial_load(loaded_tables)
            elif db_state == "loaded_unconstrained":
                db_state = "partial_unconstrained"
                logger.error(
                    "DATABASE LEFT LOADED BUT UNCONSTRAINED. Foreign keys were "
                    "not validated and sequences were not advanced. Re-run the "
                    "pipeline, or drop the schema."
                )
            return False

        finally:
            self.metrics.db_state = db_state
            try:
                archive = self.metrics.write(self.report_path, status=status)
                logger.info(f"Run report written to {archive}")
            except Exception as exc:  # pragma: no cover
                logger.error(f"Could not write run report: {exc}")

    def _render_offline_schema(self) -> None:
        """Write the DDL that would have been executed, as a usable artifact."""
        statements = []
        for name in reversed(self.graph.topological_order()):
            statements.append(f'DROP TABLE IF EXISTS "{name}" CASCADE;')
        for name in self.graph.topological_order():
            statements.append(
                self.db_manager.generate_create_table_sql(self.graph.config(name))
            )
        statements.extend(
            self.db_manager.generate_foreign_key_constraints(self.model)
        )
        directory = os.path.join(
            self.output_handler.export_dir, "sql"
        )
        os.makedirs(directory, exist_ok=True)
        path = os.path.join(directory, "schema.sql")
        with open(path, "w", encoding="utf-8") as handle:
            handle.write(
                "-- Schema rendered by the pipeline in offline mode.\n"
                f"-- Model: {self.model_file}\n\n"
            )
            handle.write("\n\n".join(statements))
            handle.write("\n")
        logger.info(f"Offline: schema DDL written to {path}")

    def _finalize(self, generated_data: Dict[str, Dict],
                  loaded_tables: List[str]) -> str:
        """Add deferred constraints, advance sequences, verify."""
        if self.offline:
            logger.info("Offline: skipping constraint validation and verification")
            return "offline"

        if self.defer_constraints:
            self.db_manager.add_foreign_key_constraints(self.model)

        self.db_manager.advance_sequences(self.model)

        expected = {
            name: len(generated_data[name]["data"])
            for name in loaded_tables
            if name in generated_data
        }
        self.db_manager.verify_row_counts(expected)

        if self.verify_writes:
            self.db_manager.write_probe(self.model)

        return "loaded_constrained"

    def _rollback_partial_load(self, loaded_tables: List[str]) -> str:
        """Truncate what was loaded, so a failed run leaves a clean database."""
        if not loaded_tables:
            return "schema_only"
        logger.warning(
            "Load failed with constraints deferred; truncating "
            f"{len(loaded_tables)} table(s) so the database is not left in an "
            "unverified state. Use --keep-partial to inspect it instead."
        )
        try:
            if not self.db_manager.connect():
                return "partial_unconstrained"
            ordered = list(reversed(
                self.graph.subgraph(loaded_tables).topological_order()
            ))
            quoted = ", ".join(f'"{t}"' for t in ordered)
            self.db_manager.cursor.execute(f"TRUNCATE TABLE {quoted};")
            self.db_manager.connection.commit()
            logger.info("Partial load truncated; database is empty but valid")
            return "rolled_back"
        except Exception as exc:
            logger.error(f"Could not truncate partial load: {exc}")
            return "partial_unconstrained"
        finally:
            self.db_manager.disconnect()

    # -- reporting ---------------------------------------------------------

    def generate_summary_report(self, generated_data: Dict[str, Dict]) -> None:
        """Print a human-readable summary of what the run produced."""
        report = self.metrics.finish(status="success")
        totals = report["totals"]

        logger.info("")
        logger.info("PIPELINE EXECUTION SUMMARY")
        logger.info("-" * 72)
        logger.info(
            f"{'table':<14}{'rows':>9}{'gen s':>8}{'load s':>8}"
            f"{'trips':>7}  destinations"
        )
        for entry in report["tables"]:
            load = entry.get("load") or {}
            logger.info(
                f"{entry['table']:<14}{entry['rows']:>9,}"
                f"{entry['generate_s']:>8.2f}"
                f"{load.get('duration_s', 0):>8.2f}"
                f"{load.get('roundtrips', 0):>7}  "
                + ", ".join(entry["destinations"])
            )
        logger.info("-" * 72)
        logger.info(
            f"{'TOTAL':<14}{totals['rows_generated']:>9,}"
            f"{totals['generate_s']:>8.2f}{totals['load_s']:>8.2f}"
            f"{totals['roundtrips_db']:>7}"
        )
        logger.info("")
        logger.info(
            f"generation throughput : "
            f"{totals.get('generate_rows_per_s', 0):,.0f} rows/s"
        )
        if totals.get("load_rows_per_s"):
            logger.info(
                f"load throughput       : {totals['load_rows_per_s']:,.0f} rows/s"
            )
        logger.info(
            f"bytes to database     : {totals['bytes_sent_db']:,}"
        )
        logger.info(
            f"bytes to files        : {totals['bytes_written_files']:,}"
        )
        rtt = report["environment"].get("db_rtt_ms")
        if rtt:
            logger.info(f"database round trip   : {rtt} ms median")
            logger.info(
                f"  a row-at-a-time load of {totals['rows_loaded']:,} rows would "
                f"have cost ~{totals['rows_loaded'] * rtt / 1000 / 60:.1f} minutes "
                "in round trips alone"
            )

        verification = report.get("verification", {})
        shown = [
            key
            for key in (
                "fk_constraints_added", "fk_violations", "row_counts_match",
                "sequences_advanced", "write_probe",
            )
            if key in verification
        ]
        if shown:
            logger.info("")
            logger.info("VERIFICATION")
            for key in shown:
                logger.info(f"  {key:<22} {verification[key]}")

        realism = verification.get("realism")
        if realism:
            logger.info("")
            logger.info("SEMANTIC REPAIR")
            for key, value in realism.items():
                if key != "details" and value:
                    logger.info(f"  {key:<26} {value:,}")

    # -- export ------------------------------------------------------------

    def export_database(self, output_file: str) -> bool:
        """Export the database to a restorable SQL file."""
        logger.info("=" * 72)
        logger.info("STARTING DATABASE EXPORT")
        logger.info("=" * 72)
        try:
            Path(output_file).parent.mkdir(parents=True, exist_ok=True)

            # The original required all five discrete DB_* variables here, then
            # called a dump routine that preferred DATABASE_URL -- so the
            # single-URL config that Supabase hands you, and that the docs
            # recommend, made this subcommand fail even though the code beneath
            # it would have worked.
            config = resolve_db_config()
            if not config.available:
                raise ValueError(
                    "No database configuration found. Set DATABASE_URL, or all "
                    "of DB_HOST, DB_NAME, DB_USER and DB_PASSWORD."
                )
            logger.info(f"Exporting from {config.describe()}")

            self.generate_sql_dump(output_file)

            if not os.path.exists(output_file):
                raise FileNotFoundError("Export file was not created")
            size = os.path.getsize(output_file)
            logger.info(f"Export file: {output_file}")
            logger.info(f"File size: {size:,} bytes")
            logger.info("DATABASE EXPORT COMPLETED")
            return True
        except Exception as exc:
            logger.error(f"Database export failed: {exc}", exc_info=True)
            return False

    def generate_sql_dump(self, output_file: str) -> None:
        """
        Write a restorable SQL dump.

        The original produced a file that could not be restored, for two
        independent reasons:

          * DDL was reconstructed from information_schema.columns.data_type,
            which carries no length or precision, so VARCHAR(50) became
            CHARACTER VARYING and DECIMAL(12,2) became NUMERIC. No primary keys,
            unique constraints, foreign keys or enum checks were emitted at all,
            while column_default was copied verbatim -- so a DEFAULT
            nextval('..._seq'::regclass) survived even though DROP TABLE CASCADE
            had just destroyed the sequence.
          * Values were written with str(), so every date and timestamp was
            emitted unquoted and every INSERT touching a temporal column was a
            syntax error.

        Both are fixed by generating DDL from the model, which actually knows
        the types, and by letting psycopg2 quote the values.
        """
        from src.db import connect

        conn = connect()
        cursor = conn.cursor()
        try:
            with open(output_file, "w", encoding="utf-8") as handle:
                handle.write("--\n")
                handle.write("-- Synthetic data pipeline database export\n")
                handle.write(f"-- Model: {self.model_file}\n")
                handle.write(f"-- Generated: {self.get_timestamp()}\n")
                handle.write("--\n\n")
                handle.write("BEGIN;\n\n")

                order = self.graph.topological_order()

                handle.write("-- Schema\n")
                for name in reversed(order):
                    handle.write(f'DROP TABLE IF EXISTS "{name}" CASCADE;\n')
                handle.write("\n")
                for name in order:
                    handle.write(
                        self.db_manager.generate_create_table_sql(
                            self.graph.config(name)
                        )
                    )
                    handle.write("\n\n")

                handle.write("-- Data\n")
                for name in order:
                    columns = [
                        field["name"]
                        for field in self.graph.config(name).get("fields", [])
                    ]
                    column_list = ", ".join(f'"{c}"' for c in columns)
                    select_list = ", ".join(f'"{c}"' for c in columns)

                    cursor.execute(f'SELECT COUNT(*) FROM "{name}";')
                    count = cursor.fetchone()[0]
                    handle.write(f"\n-- {name}: {count} rows\n")
                    if not count:
                        continue

                    # A named (server-side) cursor streams instead of pulling
                    # every row into client memory at once.
                    stream = conn.cursor(name=f"dump_{name}")
                    stream.itersize = 2000
                    stream.execute(f'SELECT {select_list} FROM "{name}";')
                    template = "(" + ", ".join(["%s"] * len(columns)) + ")"
                    for row in stream:
                        # mogrify applies PostgreSQL's own quoting rules, so
                        # dates, strings and NULL are all correct. JSONB comes
                        # back as a Python dict, which has no SQL adapter, so
                        # the shared converter encodes it first.
                        values = cursor.mogrify(
                            template, [to_pg_param(value) for value in row]
                        ).decode("utf-8")
                        handle.write(
                            f'INSERT INTO "{name}" ({column_list}) VALUES {values};\n'
                        )
                    stream.close()

                handle.write("\n-- Foreign keys, added after the data\n")
                for statement in self.db_manager.generate_foreign_key_constraints(
                    self.model
                ):
                    handle.write(statement + "\n")

                handle.write("\n-- Sequence positions\n")
                for name in order:
                    for field in self.graph.config(name).get("fields", []):
                        if field.get("primary_key") and field.get("auto_increment"):
                            handle.write(
                                "SELECT setval(pg_get_serial_sequence("
                                f"'{name}', '{field['name']}'), "
                                f'COALESCE((SELECT MAX("{field["name"]}") '
                                f'FROM "{name}"), 0) + 1, false);\n'
                            )

                handle.write("\nCOMMIT;\n")
                handle.write("-- Export completed\n")
        finally:
            cursor.close()
            conn.close()

    @staticmethod
    def get_timestamp() -> str:
        from datetime import datetime, timezone

        return datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M:%S UTC")


# -- CLI ------------------------------------------------------------------

def _pipeline_options(function):
    """Shared options, so the group and the run subcommand cannot drift."""
    decorators = [
        click.option("--model", default=DEFAULT_MODEL, help="Path to JSON model file"),
        click.option("--env", default=".env", help="Path to environment file"),
        click.option("--seed", default=DataGenerator.DEFAULT_SEED, type=int,
                     show_default=True, help="RNG seed; identical seed and model "
                                             "reproduce identical data"),
        click.option("--scale", default=1.0, type=float, show_default=True,
                     help="Multiply every table's sample_size"),
        click.option("--reference-date", default=None,
                     help="Anchor for generated dates (ISO date, or 'today' to "
                          "use the wall clock and give up reproducibility)"),
        click.option("--realism/--no-realism", default=True, show_default=True,
                     help="Apply the semantic repair pass"),
        click.option("--load-strategy", default=DEFAULT_STRATEGY,
                     type=click.Choice(sorted(STRATEGIES)), show_default=True,
                     help="How rows are sent to PostgreSQL"),
        click.option("--page-size", default=DEFAULT_PAGE_SIZE, type=int,
                     show_default=True, help="Rows per batch for execute_values"),
        click.option("--parallel-loads", default=1, type=int, show_default=True,
                     help="Concurrent table loads, one connection each"),
        click.option("--defer-constraints/--no-defer-constraints", default=True,
                     show_default=True,
                     help="Add foreign keys after loading, which also makes the "
                          "server validate cross-destination integrity"),
        click.option("--truncate/--no-truncate", default=False, show_default=True,
                     help="Truncate tables before loading"),
        click.option("--offline", is_flag=True,
                     help="Do everything except touch the network"),
        click.option("--dry-run", is_flag=True,
                     help="Print the execution plan and exit"),
        click.option("--keep-partial", is_flag=True,
                     help="On failure, leave a partially loaded database for "
                          "inspection instead of truncating it"),
        click.option("--verify-writes", is_flag=True,
                     help="Prove the loaded database accepts an application "
                          "INSERT, then roll it back"),
        click.option("--measure-bytes", is_flag=True,
                     help="Exact byte accounting for execute_values (costs time)"),
        click.option("--export-dir", default="exports", show_default=True),
        click.option("--report", "report_path", default=DEFAULT_REPORT,
                     show_default=True, help="Where to write the run report"),
    ]
    for decorator in reversed(decorators):
        function = decorator(function)
    return function


@click.group(invoke_without_command=True)
@click.pass_context
@_pipeline_options
def cli(ctx, **options):
    """
    Declarative synthetic data pipeline.

    Reads a JSON data model and produces a referentially-consistent synthetic
    dataset across PostgreSQL, CSV, JSON, Parquet and a REST API.
    """
    if ctx.invoked_subcommand is None:
        _run(**options)


@cli.command()
@_pipeline_options
def run(**options):
    """Run the complete data pipeline."""
    _run(**options)


def _run(**options) -> None:
    dry_run = options.pop("dry_run", False)
    try:
        pipeline = DataPipeline(
            options.pop("model"), options.pop("env"), **options
        )
        if dry_run:
            plan = pipeline.plan()
            sys.exit(1 if plan["problems"] else 0)

        if pipeline.run_complete_pipeline():
            print("\nPipeline execution finished successfully.")
            print(f"Run report: {pipeline.report_path}")
            print(
                "Start the API server with: python api_server.py "
                f"--model {pipeline.model_file} --env {pipeline.env_file}"
            )
        else:
            print("\nPipeline execution FAILED. See the run report for details:")
            print(f"  {pipeline.report_path}")
            sys.exit(1)
    except SystemExit:
        raise
    except Exception as exc:
        logger.error(f"Error during pipeline execution: {exc}", exc_info=True)
        sys.exit(1)


@cli.command("export-db")
@click.option("--model", default=DEFAULT_MODEL, help="Path to JSON model file")
@click.option("--env", default=".env", help="Path to environment file")
@click.option("--output", default="exports/database_dump.sql",
              help="Output SQL file path")
def export_database_cmd(model, env, output):
    """Export the database to a restorable SQL dump."""
    try:
        pipeline = DataPipeline(model, env)
        if pipeline.export_database(output):
            print("\nDatabase export completed successfully.")
            print(f"Export saved to: {output}")
        else:
            print("\nDatabase export failed.")
            sys.exit(1)
    except Exception as exc:
        print(f"Error during database export: {exc}")
        sys.exit(1)


@cli.command("validate")
@click.option("--model", default=DEFAULT_MODEL, help="Path to JSON model file")
def validate_cmd(model):
    """Check a model file against the contract, without touching anything."""
    graph = ModelGraph.from_file(model)
    problems = graph.validate()
    described = graph.describe()
    print(f"model            : {model}")
    print(f"tables           : {described['tables']}")
    print(f"foreign keys     : {len(described['foreign_keys'])}")
    print(f"creation order   : {', '.join(described['topological_order'])}")
    print(f"postgres closure : {', '.join(described['postgres_closure'])}")
    print(f"model hash       : {described['model_hash']}")
    if problems:
        print(f"\n{len(problems)} problem(s):")
        for problem in problems:
            print(f"  - {problem}")
        sys.exit(1)
    print("\nModel is valid.")


if __name__ == "__main__":
    cli()
