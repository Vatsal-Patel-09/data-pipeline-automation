"""
Single source of truth for database configuration, connection and
instrumentation.

Before this module the repo resolved connection parameters in four independent
places with two different precedence orders, so a config carrying both
DATABASE_URL and the five discrete DB_* variables could have the schema created
in one database and the rows inserted into another. One resolver fixes that.

DATABASE_URL wins when present, matching what CLAUDE.md documents and what
Supabase hands you. When neither form is complete the resolver says so rather
than letting psycopg2 fall through to libpq defaults and connect to some local
database nobody intended.
"""

import logging
import os
import socket
import statistics
import time
from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional
from urllib.parse import urlparse

logger = logging.getLogger(__name__)

DISCRETE_VARS = ("DB_HOST", "DB_NAME", "DB_USER", "DB_PASSWORD")

# Supavisor transaction-pooling port. Session-level SET does not persist across
# statements here, prepared statements break, and COPY behaviour is unreliable,
# so every session-tuning measurement taken through this port is meaningless.
SUPABASE_POOLER_PORTS = (6543,)


class DatabaseConfigError(RuntimeError):
    """Raised when no usable database configuration is present."""


@dataclass
class DbConfig:
    """A resolved, usable database target."""

    dsn: Optional[str] = None
    params: Dict[str, Any] = field(default_factory=dict)
    source: str = "none"
    host: Optional[str] = None
    port: Optional[int] = None
    host_kind: str = "none"

    @property
    def available(self) -> bool:
        return bool(self.dsn or self.params)

    def connect_args(self) -> Dict[str, Any]:
        if self.dsn:
            return {"dsn": self.dsn}
        return dict(self.params)

    def describe(self) -> str:
        """A log-safe description. Never includes the password."""
        if self.host:
            return f"{self.host_kind} {self.host}:{self.port or 5432} (via {self.source})"
        return f"{self.host_kind} (via {self.source})"


def classify_host(host: Optional[str], port: Optional[int]) -> str:
    """Classify a database target so the run report records what it measured."""
    if not host:
        return "unknown"
    lowered = host.lower()
    if lowered in ("localhost", "127.0.0.1", "::1", "host.docker.internal"):
        return "local"
    if "supabase" in lowered or "supabase" in lowered.replace("-", ""):
        if port in SUPABASE_POOLER_PORTS or "pooler" in lowered:
            return "supabase-pooler"
        return "supabase-direct"
    if port in SUPABASE_POOLER_PORTS:
        return "pooler"
    return "remote"


def resolve_db_config(env_file: Optional[str] = None) -> DbConfig:
    """
    Resolve the database target from the environment.

    Precedence: DATABASE_URL, then the five discrete DB_* variables. Returns a
    DbConfig with available=False rather than raising, so callers that can run
    without a database (dry-run, offline, file-only sinks) stay usable.
    """
    database_url = os.getenv("DATABASE_URL")
    if database_url:
        parsed = urlparse(database_url)
        port = parsed.port or 5432
        return DbConfig(
            dsn=database_url,
            source="DATABASE_URL",
            host=parsed.hostname,
            port=port,
            host_kind=classify_host(parsed.hostname, port),
        )

    values = {name: os.getenv(name) for name in DISCRETE_VARS}
    missing = [name for name, value in values.items() if not value]
    if missing:
        return DbConfig(source="none", host_kind="none")

    raw_port = os.getenv("DB_PORT", "5432")
    try:
        port = int(raw_port)
    except (TypeError, ValueError):
        port = 5432

    host = values["DB_HOST"]
    return DbConfig(
        params={
            "host": host,
            "port": port,
            "database": values["DB_NAME"],
            "user": values["DB_USER"],
            "password": values["DB_PASSWORD"],
        },
        source="DB_* variables",
        host=host,
        port=port,
        host_kind=classify_host(host, port),
    )


def require_db_config() -> DbConfig:
    """Resolve the database target, failing loudly with actionable guidance."""
    config = resolve_db_config()
    if not config.available:
        raise DatabaseConfigError(
            "No database configuration found. Set DATABASE_URL, or all of "
            + ", ".join(DISCRETE_VARS)
            + " in your .env file (copy example.env). "
            "To run without a database, use --offline or --dry-run."
        )
    return config


def connect(config: Optional[DbConfig] = None):
    """
    Open a psycopg2 connection to the resolved target.

    On failure, append any address-family diagnosis to the error, so an
    IPv6-only host reads as an explained problem with a fix rather than as a
    bare name-resolution failure.
    """
    import psycopg2

    cfg = config or require_db_config()
    try:
        return psycopg2.connect(**cfg.connect_args())
    except psycopg2.OperationalError as exc:
        notes = diagnose_unreachable_host(cfg.host or "")
        if not notes:
            raise
        detail = "\n  - ".join(notes)
        raise psycopg2.OperationalError(
            f"{exc}\n\nDiagnosis:\n  - {detail}"
        ) from exc


def diagnose_unreachable_host(host: str) -> List[str]:
    """
    Explain why a host could not be resolved or reached.

    Supabase's direct hostnames (db.<ref>.supabase.co) publish only an AAAA
    record, so they require IPv6. Networks without an IPv6 route get a bare
    'could not translate host name' from libpq, which gives no hint that the
    cause is address-family rather than a typo or a paused project. This turns
    that into something actionable.
    """
    notes: List[str] = []
    if not host:
        return notes

    has_ipv4 = has_ipv6 = False
    try:
        socket.getaddrinfo(host, None, socket.AF_INET)
        has_ipv4 = True
    except OSError:
        pass
    try:
        socket.getaddrinfo(host, None, socket.AF_INET6)
        has_ipv6 = True
    except OSError:
        pass

    if not has_ipv4 and not has_ipv6:
        notes.append(
            f"'{host}' does not resolve from this machine. If it is a Supabase "
            "direct host, the project may be paused, or your resolver may be "
            "unable to return its IPv6-only address."
        )
    elif not has_ipv4:
        notes.append(
            f"'{host}' publishes no IPv4 address; it is IPv6-only. "
            "Supabase direct hosts are IPv6-only unless the IPv4 add-on is "
            "enabled."
        )

    if not has_ipv4:
        route = _has_ipv6_route()
        if route is False:
            notes.append(
                "This machine has no usable IPv6 route, so an IPv6-only host "
                "cannot be reached at all."
            )
        notes.append(
            "Fix: use the Supavisor session pooler instead, which is IPv4. In "
            "the Supabase dashboard choose Connect, then 'Session pooler', and "
            "put that URI in DATABASE_URL. Use its port 5432 (session mode), "
            "not 6543 (transaction mode), because transaction mode does not "
            "persist session-level SET and makes COPY unreliable."
        )

    return notes


def _has_ipv6_route() -> Optional[bool]:
    """Whether a global IPv6 destination is routable. None if undetermined."""
    probe = socket.socket(socket.AF_INET6, socket.SOCK_DGRAM)
    try:
        probe.settimeout(3)
        probe.connect(("2001:4860:4860::8888", 53))
        return True
    except OSError:
        return False
    except Exception:
        return None
    finally:
        probe.close()


def preflight(config: DbConfig, metrics=None) -> Dict[str, Any]:
    """
    Inspect the target and warn about conditions that invalidate measurements.

    The pooler warning matters: on Supavisor's transaction-pooling port the
    session GUCs we set silently do not persist, so any benchmark row claiming
    to measure session tuning through it would be reporting nothing.
    """
    findings: Dict[str, Any] = {
        "host_kind": config.host_kind,
        "port": config.port,
        "source": config.source,
        "warnings": [],
    }

    if config.host_kind in ("supabase-pooler", "pooler"):
        warning = (
            f"Connected through a transaction pooler (port {config.port}). "
            "Session-level SET will not persist, prepared statements may fail, "
            "and COPY behaviour is unreliable. Use the direct port (5432) for "
            "load benchmarks, and treat session-tuning results from this host "
            "as not measured."
        )
        findings["warnings"].append(warning)
        logger.warning(warning)

    if metrics is not None:
        metrics.set_environment(db_host_kind=config.host_kind)
        for warning in findings["warnings"]:
            metrics.warn(warning)

    return findings


def measure_rtt_ms(conn, samples: int = 20) -> Optional[float]:
    """
    Median round-trip time for a trivial statement.

    Without this number every rows_per_s in the run report is uninterpretable,
    because the load path is dominated by round trips rather than by work.
    """
    if samples < 1:
        return None
    timings: List[float] = []
    try:
        with conn.cursor() as cursor:
            cursor.execute("SELECT 1;")
            cursor.fetchone()
            for _ in range(samples):
                started = time.perf_counter()
                cursor.execute("SELECT 1;")
                cursor.fetchone()
                timings.append((time.perf_counter() - started) * 1000.0)
    except Exception as exc:
        logger.warning(f"Could not measure database round-trip time: {exc}")
        return None
    if not timings:
        return None
    return round(statistics.median(timings), 3)


class InstrumentedCursor:
    """
    A counting proxy around a psycopg2 cursor.

    This is what makes the before/after table credible: round trips become a
    measured integer rather than an arithmetic estimate.

    Accuracy note, which matters for honest reporting: a plain psycopg2 cursor
    buffers the entire result set client-side when execute() returns, so
    fetchone/fetchmany/fetchall are local operations and are NOT counted as
    round trips. They are tracked separately as 'fetches'. executemany sends one
    statement per parameter set, so it is counted as len(argslist) round trips.
    """

    __slots__ = ("_cursor", "statements", "roundtrips", "fetches", "bytes_sent")

    def __init__(self, cursor):
        self._cursor = cursor
        self.statements = 0
        self.roundtrips = 0
        self.fetches = 0
        self.bytes_sent = 0

    # -- counted operations ------------------------------------------------

    def execute(self, query, vars=None):
        self.statements += 1
        self.roundtrips += 1
        return self._cursor.execute(query, vars)

    def executemany(self, query, argslist):
        materialized = list(argslist)
        self.statements += 1
        # psycopg2 issues one statement per parameter set.
        self.roundtrips += max(1, len(materialized))
        return self._cursor.executemany(query, materialized)

    def callproc(self, procname, parameters=None):
        self.statements += 1
        self.roundtrips += 1
        if parameters is None:
            return self._cursor.callproc(procname)
        return self._cursor.callproc(procname, parameters)

    def copy_expert(self, sql, file, size=8192):
        self.statements += 1
        self.roundtrips += 1
        position = None
        try:
            position = file.tell()
        except Exception:
            position = None
        result = self._cursor.copy_expert(sql, file, size)
        if position is not None:
            try:
                self.bytes_sent += max(0, file.tell() - position)
            except Exception:
                pass
        return result

    def fetchone(self):
        self.fetches += 1
        return self._cursor.fetchone()

    def fetchmany(self, size=None):
        self.fetches += 1
        if size is None:
            return self._cursor.fetchmany()
        return self._cursor.fetchmany(size)

    def fetchall(self):
        self.fetches += 1
        return self._cursor.fetchall()

    # -- transparent delegation -------------------------------------------

    def __getattr__(self, name):
        return getattr(self._cursor, name)

    def __iter__(self):
        return iter(self._cursor)

    def __enter__(self):
        self._cursor.__enter__()
        return self

    def __exit__(self, exc_type, exc, tb):
        return self._cursor.__exit__(exc_type, exc, tb)

    @property
    def raw(self):
        """
        The underlying psycopg2 cursor.

        Needed because some psycopg2 entry points type-check their argument at
        the C level rather than duck-typing it: psycopg2.sql.Composed.as_string
        rejects anything that is not literally a connection or cursor, so
        attribute delegation is not enough. Callers that must hand a real cursor
        to psycopg2 should use `getattr(cursor, "raw", cursor)`.
        """
        return self._cursor

    @property
    def counts(self) -> Dict[str, int]:
        return {
            "statements": self.statements,
            "roundtrips": self.roundtrips,
            "fetches": self.fetches,
            "bytes_sent": self.bytes_sent,
        }
