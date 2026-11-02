"""
Interchangeable PostgreSQL load strategies.

The load path is where essentially all of a run's wall time goes: the original
implementation issued one `cursor.execute` per row, which for the shipped model
is roughly 85,400 sequential network round trips. The fix is not to send fewer
bytes -- the whole payload is only tens of megabytes -- it is to stop waiting
85,400 times.

Three strategies are provided, and 'rowwise' is kept deliberately so the
comparison can be measured rather than asserted:

  rowwise         one statement per row. The baseline. O(rows) round trips.
  execute_values  one statement per page. O(rows / page_size) round trips.
                  This is where almost the entire improvement comes from.
  copy            one COPY stream per table. O(1) round trips.

Expectation-setting, because it matters for honest reporting: the large factor
is rowwise -> execute_values. After that the work is bandwidth-bound rather than
latency-bound, so COPY buys a further small multiple, not another order of
magnitude.

Identifiers are composed with psycopg2.sql.Identifier rather than f-strings.
They come from a trusted local model file, so this was not exploitable, but
quoting them correctly costs nothing and removes the question.
"""

import io
import logging
import time
from typing import Any, Dict, Iterable, List, Optional, Sequence

from psycopg2 import sql
from psycopg2.extras import execute_values

try:
    from src.serialization import to_pg_param, to_pg_text
except ImportError:  # pragma: no cover
    from serialization import to_pg_param, to_pg_text

logger = logging.getLogger(__name__)

DEFAULT_PAGE_SIZE = 1000
DEFAULT_STRATEGY = "copy"


class LoadStrategy:
    """Base class. Subclasses implement load() and declare a name."""

    name = "abstract"
    #: Whether this strategy can represent every value the model can produce.
    universal = True

    def load(self, cursor, table: str, columns: Sequence[str],
             records: Sequence[Dict[str, Any]]) -> Dict[str, Any]:
        """
        Insert records into table, returning load statistics.

        The cursor is expected to be an InstrumentedCursor so round trips are
        counted rather than estimated.
        """
        raise NotImplementedError

    @staticmethod
    def _qualified(table: str, columns: Sequence[str]):
        return (
            sql.Identifier(table),
            sql.SQL(", ").join(sql.Identifier(c) for c in columns),
        )

    @staticmethod
    def _stats(cursor, started: float, rows: int, batches: int,
               page_size: Optional[int], bytes_sent: int,
               bytes_exact: bool, strategy: str) -> Dict[str, Any]:
        return {
            "strategy": strategy,
            "duration_s": round(time.perf_counter() - started, 6),
            "rows": rows,
            "roundtrips": getattr(cursor, "roundtrips", 0),
            "bytes_sent": bytes_sent,
            "bytes_exact": bytes_exact,
            "batches": batches,
            "page_size": page_size,
        }


class RowwiseStrategy(LoadStrategy):
    """
    One INSERT per row: the original behaviour, retained as the benchmark
    baseline. Never make this the default.
    """

    name = "rowwise"

    def load(self, cursor, table, columns, records):
        started = time.perf_counter()
        identifier, column_list = self._qualified(table, columns)
        statement = sql.SQL("INSERT INTO {} ({}) VALUES ({})").format(
            identifier,
            column_list,
            sql.SQL(", ").join(sql.Placeholder() * len(columns)),
        )
        rendered = statement.as_string(getattr(cursor, "raw", cursor))
        count = 0
        for record in records:
            cursor.execute(
                rendered, [to_pg_param(record.get(c)) for c in columns]
            )
            count += 1
        return self._stats(
            cursor, started, count, count, None, 0, False, self.name
        )


class ExecuteValuesStrategy(LoadStrategy):
    """
    One multi-row INSERT per page.

    This is the change that removes the bottleneck: round trips drop from one
    per row to one per page_size rows.
    """

    name = "execute_values"

    def __init__(self, page_size: int = DEFAULT_PAGE_SIZE,
                 measure_bytes: bool = False):
        self.page_size = max(1, int(page_size))
        self.measure_bytes = measure_bytes

    def load(self, cursor, table, columns, records):
        started = time.perf_counter()
        identifier, column_list = self._qualified(table, columns)
        statement = sql.SQL("INSERT INTO {} ({}) VALUES %s").format(
            identifier, column_list
        )

        # execute_values renders a Composable via sql.as_string(cur), which
        # type-checks at the C level and would reject the instrumented wrapper.
        # Render it here against the real cursor and pass a plain string, so
        # execute_values still calls execute() on the wrapper and each page is
        # counted as a round trip.
        rendered = statement.as_string(getattr(cursor, "raw", cursor))

        rows = [
            tuple(to_pg_param(record.get(c)) for c in columns)
            for record in records
        ]

        bytes_sent, bytes_exact = 0, False
        if self.measure_bytes and rows:
            # Exact byte accounting needs mogrify per row, which roughly doubles
            # the work. Opt-in, so the headline runs are not distorted by the
            # cost of measuring them.
            template = b"(" + b",".join([b"%s"] * len(columns)) + b")"
            bytes_sent = sum(
                len(cursor.mogrify(template.decode(), row)) for row in rows
            )
            bytes_exact = True

        execute_values(cursor, rendered, rows, page_size=self.page_size)
        batches = (len(rows) + self.page_size - 1) // self.page_size
        return self._stats(
            cursor, started, len(rows), batches, self.page_size,
            bytes_sent, bytes_exact, self.name,
        )


class CopyStrategy(LoadStrategy):
    """
    One COPY FROM STDIN stream per table.

    Uses the text format with explicit escaping rather than CSV format, because
    CSV mode cannot distinguish NULL from the empty string. Byte counts here are
    exact, since the payload is built in memory before being handed to libpq.
    """

    name = "copy"

    def load(self, cursor, table, columns, records):
        started = time.perf_counter()
        buffer = io.StringIO()
        count = 0
        for record in records:
            buffer.write(
                "\t".join(to_pg_text(record.get(c)) for c in columns)
            )
            buffer.write("\n")
            count += 1
        payload_bytes = len(buffer.getvalue().encode("utf-8"))
        buffer.seek(0)

        identifier, column_list = self._qualified(table, columns)
        statement = sql.SQL(
            "COPY {} ({}) FROM STDIN WITH (FORMAT text)"
        ).format(identifier, column_list)

        # as_string type-checks at the C level and rejects a wrapper, so hand it
        # the underlying cursor while still calling copy_expert on the wrapper
        # (which is what counts the round trip and the bytes).
        rendered = statement.as_string(getattr(cursor, "raw", cursor))
        cursor.copy_expert(rendered, buffer)
        return self._stats(
            cursor, started, count, 1, None, payload_bytes, True, self.name
        )


STRATEGIES = {
    RowwiseStrategy.name: RowwiseStrategy,
    ExecuteValuesStrategy.name: ExecuteValuesStrategy,
    CopyStrategy.name: CopyStrategy,
}


def get_strategy(name: str = DEFAULT_STRATEGY, page_size: int = DEFAULT_PAGE_SIZE,
                 measure_bytes: bool = False) -> LoadStrategy:
    """
    Build a load strategy by name.

    Selection lives on the CLI rather than in the model file: which strategy to
    use is a property of the run and the host (what am I benchmarking, what does
    this server permit), not of the data model. Keeping it out of the model file
    means ecommerce_model.json stays a pure description of the data.
    """
    key = (name or DEFAULT_STRATEGY).strip().lower()
    if key not in STRATEGIES:
        raise ValueError(
            f"Unknown load strategy {name!r}. Expected one of: "
            + ", ".join(sorted(STRATEGIES))
        )
    if key == ExecuteValuesStrategy.name:
        return ExecuteValuesStrategy(page_size=page_size, measure_bytes=measure_bytes)
    if key == CopyStrategy.name:
        return CopyStrategy()
    return RowwiseStrategy()
