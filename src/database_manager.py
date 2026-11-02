"""
Schema creation and post-load finalisation.

Two structural changes from the original:

  * Foreign key constraints can be created AFTER the bulk load instead of at
    schema time. That is not merely a reordering for speed, though it is also
    that: when constraints exist during the load, every inserted row pays an
    index probe against its parents. Adding them afterwards replaces ~85,400
    per-row probes with one sequential validation scan per constraint -- and it
    turns the operation into a server-side proof that the generator's
    cross-destination referential integrity actually holds. If generation were
    wrong, PostgreSQL rejects the constraint and names the offending row.

  * Sequences are advanced after loading explicit primary-key values. Without
    this the delivered database rejects the first application-level INSERT with
    a duplicate-key error, because every SERIAL sequence is still sitting at 1.
"""

import json
import logging
from typing import Any, Dict, Iterable, List, Optional, Sequence

import psycopg2
from psycopg2 import sql

try:
    from src.db import DbConfig, connect, measure_rtt_ms, resolve_db_config
    from src.metrics import NullMetrics
    from src.model_graph import ModelError, ModelGraph, parse_foreign_key
except ImportError:  # pragma: no cover - supports direct module execution
    from db import DbConfig, connect, measure_rtt_ms, resolve_db_config
    from metrics import NullMetrics
    from model_graph import ModelError, ModelGraph, parse_foreign_key

logger = logging.getLogger(__name__)

# Declared model type -> PostgreSQL type.
#
# Deliberately wider than the original nine entries. An unrecognised type used
# to fall through to TEXT with no warning, so a column declared 'bigint' became
# TEXT and a foreign key pointing at an integer parent then failed with a type
# mismatch. Anything genuinely unknown now raises instead.
TYPE_MAPPING = {
    "string": "VARCHAR",
    "text": "TEXT",
    "integer": "INTEGER",
    "bigint": "BIGINT",
    "smallint": "SMALLINT",
    "decimal": "DECIMAL",
    "numeric": "DECIMAL",
    "float": "DOUBLE PRECISION",
    "double": "DOUBLE PRECISION",
    "real": "REAL",
    "boolean": "BOOLEAN",
    "date": "DATE",
    "timestamp": "TIMESTAMP",
    "timestamptz": "TIMESTAMP WITH TIME ZONE",
    "time": "TIME",
    "json": "JSONB",
    "jsonb": "JSONB",
    "uuid": "UUID",
    "enum": "VARCHAR",
}

# Auto-increment needs a width-matched serial type, or a model declaring a
# bigint primary key silently gets a 32-bit sequence.
SERIAL_FOR = {
    "integer": "SERIAL",
    "smallint": "SMALLSERIAL",
    "bigint": "BIGSERIAL",
}


class DatabaseManager:
    def __init__(self, config_path: str = None, metrics=None):
        """Initialize database manager with connection details."""
        if config_path:
            from dotenv import load_dotenv

            load_dotenv(config_path)

        self.metrics = metrics if metrics is not None else NullMetrics()
        self.db_config: DbConfig = resolve_db_config()
        # Kept for backwards compatibility with existing callers and scripts.
        self.connection_params = (
            self.db_config.dsn if self.db_config.dsn else self.db_config.params
        )
        self.connection = None
        self.cursor = None
        self.logger = logging.getLogger(__name__)

    # -- connection --------------------------------------------------------

    def connect(self) -> bool:
        """Establish a database connection."""
        try:
            self.connection = connect(
                self.db_config if self.db_config.available else None
            )
            self.cursor = self.connection.cursor()
            self.logger.info(
                f"Database connection established ({self.db_config.describe()})"
            )
            return True
        except Exception as exc:
            # Do not leave a half-open connection behind if cursor() was the
            # thing that failed.
            if self.connection is not None:
                try:
                    self.connection.close()
                except Exception:
                    pass
                self.connection = None
            self.cursor = None
            self.logger.error(f"Database connection failed: {exc}")
            return False

    def disconnect(self) -> None:
        """Close the database connection and clear the handles."""
        if self.cursor is not None:
            try:
                self.cursor.close()
            except Exception:
                pass
            self.cursor = None
        if self.connection is not None:
            try:
                self.connection.close()
            except Exception:
                pass
            self.connection = None
            self.logger.info("Database connection closed")

    def test_connection(self) -> bool:
        """Test the database connection, checking the result rather than ignoring it."""
        if not self.connect():
            return False
        try:
            self.cursor.execute("SELECT 1;")
            row = self.cursor.fetchone()
            if not row or row[0] != 1:
                self.logger.error(f"Connection test returned unexpected result: {row}")
                return False
            self.logger.info("Database connection test successful")
            return True
        except Exception as exc:
            self.logger.error(f"Connection test failed: {exc}")
            return False
        finally:
            self.disconnect()

    def measure_rtt(self, samples: int = 20) -> Optional[float]:
        """Median round-trip time, recorded into the run report."""
        if not self.connect():
            return None
        try:
            rtt = measure_rtt_ms(self.connection, samples=samples)
            if rtt is not None:
                self.metrics.set_environment(db_rtt_ms=rtt)
                self.logger.info(f"Median database round-trip time: {rtt} ms")
            return rtt
        finally:
            self.disconnect()

    # -- model -------------------------------------------------------------

    def load_model(self, model_file: str) -> Dict:
        """Load the JSON data model."""
        try:
            with open(model_file, "r", encoding="utf-8") as handle:
                model = json.load(handle)
            self.logger.info(f"Loaded data model from {model_file}")
            return model
        except Exception as exc:
            self.logger.error(f"Failed to load model file: {exc}")
            raise

    # -- DDL generation ----------------------------------------------------

    def get_postgres_type(self, field_type: str, field_config: Dict) -> str:
        """
        Convert a model field type to a PostgreSQL type.

        Raises on an unknown type rather than silently producing TEXT, which
        previously turned a typo or an unsupported type into a plausible-looking
        column holding the literal string 'sample_<type>'.
        """
        key = (field_type or "").strip().lower()
        if key not in TYPE_MAPPING:
            raise ModelError(
                f"Unknown field type {field_type!r} for field "
                f"{field_config.get('name')!r}. Supported types: "
                + ", ".join(sorted(TYPE_MAPPING))
            )

        if key == "string" and "max_length" in field_config:
            return f"VARCHAR({field_config['max_length']})"
        if key in ("decimal", "numeric"):
            precision = field_config.get("precision", 10)
            scale = field_config.get("scale", 2)
            return f"DECIMAL({precision},{scale})"
        if key == "enum" and "values" in field_config:
            longest = max(len(str(v)) for v in field_config["values"])
            return f"VARCHAR({longest})"
        return TYPE_MAPPING[key]

    def parse_foreign_key(self, fk_string: str) -> Dict:
        """Parse a foreign key string into table and field (shared implementation)."""
        table, field = parse_foreign_key(fk_string)
        return {"table": table, "field": field}

    def generate_create_table_sql(self, table_config: Dict) -> str:
        """Generate a CREATE TABLE statement."""
        table_name = table_config["name"]
        definitions: List[str] = []
        checks: List[str] = []

        for field in table_config["fields"]:
            field_name = field["name"]
            declared = (field.get("type") or "").strip().lower()

            if field.get("primary_key") and field.get("auto_increment"):
                serial = SERIAL_FOR.get(declared)
                if serial is None:
                    raise ModelError(
                        f"Field '{table_name}.{field_name}' is auto_increment but "
                        f"declared type {field.get('type')!r}; auto_increment "
                        "requires integer, smallint or bigint."
                    )
                definitions.append(f'    "{field_name}" {serial} PRIMARY KEY')
            else:
                column_type = self.get_postgres_type(field.get("type"), field)
                definition = f'    "{field_name}" {column_type}'
                if field.get("primary_key"):
                    definition += " PRIMARY KEY"
                elif field.get("unique"):
                    definition += " UNIQUE"
                if not field.get("nullable", True) and not field.get("primary_key"):
                    definition += " NOT NULL"
                if "default" in field:
                    definition += f" DEFAULT {self._render_default(field['default'])}"
                definitions.append(definition)

            if declared == "enum" and "values" in field:
                allowed = ", ".join(
                    "'" + str(v).replace("'", "''") + "'" for v in field["values"]
                )
                checks.append(
                    f'    CONSTRAINT "chk_{table_name}_{field_name}" '
                    f'CHECK ("{field_name}" IN ({allowed}))'
                )

        body = ",\n".join(definitions + checks)
        return f'CREATE TABLE IF NOT EXISTS "{table_name}" (\n{body}\n);'

    @staticmethod
    def _render_default(value: Any) -> str:
        """Render a default literal, escaping quotes in string values."""
        if isinstance(value, str):
            if value.upper() in ("CURRENT_TIMESTAMP", "NOW()", "CURRENT_DATE"):
                return value
            escaped = value.replace("'", "''")
            return f"'{escaped}'"
        if isinstance(value, bool):
            return "TRUE" if value else "FALSE"
        if value is None:
            return "NULL"
        return str(value)

    def generate_foreign_key_constraints(self, model: Dict) -> List[str]:
        """Generate the ALTER TABLE statements that add foreign keys."""
        graph = ModelGraph(model)
        statements: List[str] = []
        for table_name in graph.table_names:
            for ref in graph.foreign_keys(table_name):
                statements.append(
                    f'ALTER TABLE "{table_name}" '
                    f'ADD CONSTRAINT "fk_{table_name}_{ref.field}" '
                    f'FOREIGN KEY ("{ref.field}") '
                    f'REFERENCES "{ref.ref_table}" ("{ref.ref_field}") '
                    f"ON DELETE CASCADE;"
                )
        return statements

    def get_table_dependency_order(self, model: Dict) -> List[Dict]:
        """
        Table creation order.

        Uses the shared topological sort, which breaks ties by name. The
        previous local implementation appended from an unsorted set, so the
        order varied with PYTHONHASHSEED between runs.
        """
        graph = ModelGraph(model)
        return [graph.config(name) for name in graph.topological_order()]

    # -- schema ------------------------------------------------------------

    def create_schema(self, model_file: str, with_foreign_keys: bool = True) -> None:
        """
        Create the complete schema from the JSON model.

        with_foreign_keys=False defers constraint creation to after the load;
        call add_foreign_key_constraints once the data is in.

        All DDL is sent as a single multi-statement execute, so this costs one
        round trip rather than one per statement. Against a database ~7,000 km
        away that is the difference between a few seconds and a fraction of one.
        """
        if not self.connect():
            raise RuntimeError("Cannot connect to database")

        try:
            model = self.load_model(model_file)
            graph = ModelGraph(model)

            problems = graph.validate()
            if problems:
                raise ModelError(
                    "Model is not valid:\n  - " + "\n  - ".join(problems)
                )

            statements: List[str] = []
            # Drop in reverse dependency order so dependents go first. The
            # original iterated reverse declaration order, which only worked
            # because of CASCADE.
            for table_name in reversed(graph.topological_order()):
                statements.append(f'DROP TABLE IF EXISTS "{table_name}" CASCADE;')
            for table_config in self.get_table_dependency_order(model):
                statements.append(self.generate_create_table_sql(table_config))
            if with_foreign_keys:
                statements.extend(self.generate_foreign_key_constraints(model))

            self.logger.info(
                f"Applying schema: {len(graph)} tables, "
                f"{len(statements)} statements in one round trip"
            )
            self.cursor.execute("\n".join(statements))
            self.connection.commit()

            self.logger.info(
                "Database schema created successfully"
                + ("" if with_foreign_keys else " (foreign keys deferred)")
            )
            self.metrics.set_verification(
                schema_tables=len(graph),
                schema_statements=len(statements),
                foreign_keys_deferred=not with_foreign_keys,
            )
        except Exception as exc:
            if self.connection is not None:
                self.connection.rollback()
            self.logger.error(f"Schema creation failed: {exc}")
            raise
        finally:
            self.disconnect()

    def add_foreign_key_constraints(self, model: Dict) -> int:
        """
        Add the deferred foreign key constraints.

        This is the verification step for the project's central claim: if any
        generated foreign key failed to resolve, PostgreSQL refuses the
        constraint and names the offending row.
        """
        statements = self.generate_foreign_key_constraints(model)
        if not statements:
            return 0
        if not self.connect():
            raise RuntimeError("Cannot connect to database")
        try:
            self.logger.info(
                f"Validating and adding {len(statements)} foreign key constraints"
            )
            self.cursor.execute("\n".join(statements))
            self.connection.commit()
            self.logger.info("All foreign key constraints added and validated")
            self.metrics.set_verification(
                fk_constraints_added=len(statements), fk_violations=0
            )
            return len(statements)
        except psycopg2.Error as exc:
            self.connection.rollback()
            self.metrics.set_verification(
                fk_constraints_added=0, fk_violations=1,
                fk_error=str(exc).strip()[:400],
            )
            self.logger.error(
                "Foreign key validation FAILED, which means generated data "
                f"violates referential integrity: {exc}"
            )
            raise
        finally:
            self.disconnect()

    def advance_sequences(self, model: Dict) -> int:
        """
        Advance each auto-increment sequence past the loaded rows.

        The pipeline inserts explicit id values into SERIAL columns, which does
        not move the sequence. Without this the handed-over database rejects the
        first application INSERT that omits the id.

        COALESCE(max, 0) + 1 with is_called=false handles the empty-table case
        correctly; setval(seq, max, true) would error on a NULL max. That case
        is real here: a table can be created and never loaded.
        """
        graph = ModelGraph(model)
        targets = [
            (name, field["name"])
            for name in graph.table_names
            for field in graph.config(name).get("fields", [])
            if field.get("primary_key") and field.get("auto_increment")
        ]
        if not targets:
            return 0

        statements = [
            "SELECT setval("
            f"  pg_get_serial_sequence('{table}', '{column}'),"
            f"  COALESCE((SELECT MAX(\"{column}\") FROM \"{table}\"), 0) + 1,"
            "  false);"
            for table, column in targets
        ]

        if not self.connect():
            raise RuntimeError("Cannot connect to database")
        try:
            # One round trip for all of them.
            self.cursor.execute("\n".join(statements))
            self.connection.commit()
            self.logger.info(f"Advanced {len(targets)} primary key sequences")
            self.metrics.set_verification(sequences_advanced=len(targets))
            return len(targets)
        except Exception as exc:
            self.connection.rollback()
            self.logger.error(f"Failed to advance sequences: {exc}")
            raise
        finally:
            self.disconnect()

    def verify_row_counts(self, expected: Dict[str, int]) -> Dict[str, Any]:
        """Compare actual row counts against what was generated."""
        if not expected:
            return {"row_counts_match": True, "per_table": []}
        if not self.connect():
            raise RuntimeError("Cannot connect to database")
        try:
            union = "\nUNION ALL\n".join(
                f"SELECT '{table}' AS t, COUNT(*) AS n FROM \"{table}\""
                for table in sorted(expected)
            )
            self.cursor.execute(union + " ORDER BY t;")
            actual = {row[0]: row[1] for row in self.cursor.fetchall()}

            per_table = [
                {
                    "table": table,
                    "expected": count,
                    "actual": actual.get(table),
                    "ok": actual.get(table) == count,
                }
                for table, count in sorted(expected.items())
            ]
            matched = all(entry["ok"] for entry in per_table)
            for entry in per_table:
                if not entry["ok"]:
                    self.logger.error(
                        f"Row count mismatch for {entry['table']}: "
                        f"expected {entry['expected']}, found {entry['actual']}"
                    )
            result = {"row_counts_match": matched, "per_table": per_table}
            self.metrics.set_verification(**result)
            if matched:
                self.logger.info(
                    f"Row counts verified for {len(per_table)} tables"
                )
            return result
        finally:
            self.disconnect()

    def write_probe(self, model: Dict) -> str:
        """
        Prove the database accepts an application-level write, then roll back.

        Demonstrates the sequence fix without leaving data behind.
        """
        graph = ModelGraph(model)
        candidate = None
        for name in graph.topological_order():
            fields = graph.config(name).get("fields", [])
            if not any(
                f.get("primary_key") and f.get("auto_increment") for f in fields
            ):
                continue
            # Only safe on a table with no required non-PK columns beyond those
            # we can fill trivially.
            if graph.dependencies(name):
                continue
            candidate = (name, fields)
            break

        if candidate is None:
            self.metrics.set_verification(write_probe="skipped")
            return "skipped"

        table, fields = candidate
        if not self.connect():
            raise RuntimeError("Cannot connect to database")
        try:
            columns, values = [], []
            for field in fields:
                if field.get("primary_key"):
                    continue
                if field.get("nullable", True):
                    continue
                columns.append(field["name"])
                values.append(self._probe_value(field))
            placeholders = ", ".join(["%s"] * len(columns))
            column_list = ", ".join(f'"{c}"' for c in columns)
            statement = (
                f'INSERT INTO "{table}" ({column_list}) '
                f"VALUES ({placeholders}) RETURNING "
                + ", ".join(
                    f'"{f["name"]}"' for f in fields if f.get("primary_key")
                )
            ) if columns else (
                f'INSERT INTO "{table}" DEFAULT VALUES RETURNING '
                + ", ".join(
                    f'"{f["name"]}"' for f in fields if f.get("primary_key")
                )
            )
            self.cursor.execute(statement, values)
            new_id = self.cursor.fetchone()[0]
            self.connection.rollback()
            self.logger.info(
                f"Write probe succeeded on {table}: server assigned id {new_id}"
            )
            self.metrics.set_verification(write_probe="passed", write_probe_table=table)
            return "passed"
        except Exception as exc:
            if self.connection is not None:
                self.connection.rollback()
            self.logger.error(
                "Write probe FAILED, so the delivered database cannot accept "
                f"application writes: {exc}"
            )
            self.metrics.set_verification(
                write_probe="failed", write_probe_error=str(exc).strip()[:300]
            )
            return "failed"
        finally:
            self.disconnect()

    @staticmethod
    def _probe_value(field: Dict) -> Any:
        declared = (field.get("type") or "").lower()
        if declared == "enum" and field.get("values"):
            return field["values"][0]
        if declared in ("integer", "bigint", "smallint"):
            return 0
        if declared in ("decimal", "numeric", "float", "double", "real"):
            return 0
        if declared == "boolean":
            return False
        if declared in ("json", "jsonb"):
            return "{}"
        if declared == "date":
            return "2026-01-01"
        if declared in ("timestamp", "timestamptz"):
            return "2026-01-01 00:00:00"
        return "__write_probe__"
