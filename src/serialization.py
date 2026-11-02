"""
Per-sink value conversion, in one place.

Every destination needs the same Python values rendered slightly differently,
and the repo previously had those rules scattered across three partially
overlapping functions plus a JSON encoder, so the sinks could and did drift.
Centralising them means CSV, JSON, Parquet, parameterised INSERT and COPY
cannot disagree about what a value is.

Two decisions worth stating:

  * Decimal is passed through to psycopg2 rather than converted to float.
    The old code did `float(value)` before inserting into DECIMAL columns,
    which is both slower and lossier -- psycopg2 adapts Decimal natively and
    exactly. Visible on any column with scale other than 2, such as
    products.weight at scale 3.

  * COPY uses the text format with explicit escaping, not CSV format. CSV mode
    cannot distinguish NULL from the empty string: Python's csv module writes
    both None and '' as an empty field. Text format has a dedicated NULL marker
    (\\N) and unambiguous escapes.
"""

import datetime
import json
from decimal import Decimal
from typing import Any

# PostgreSQL COPY ... WITH (FORMAT text) NULL marker.
PG_NULL = r"\N"

# Order matters: the backslash substitution must run first, or it would
# re-escape the backslashes introduced by the later replacements.
_PG_TEXT_ESCAPES = (
    ("\\", "\\\\"),
    ("\n", "\\n"),
    ("\r", "\\r"),
    ("\t", "\\t"),
)


def to_pg_param(value: Any) -> Any:
    """
    Convert for a parameterised statement (rowwise INSERT, execute_values).

    psycopg2 adapts Decimal, datetime, date and bool natively, so those pass
    through untouched. Only containers need encoding, because the model's json
    columns arrive as Python dicts.
    """
    if isinstance(value, (dict, list)):
        return json.dumps(value)
    return value


def to_pg_text(value: Any) -> str:
    """
    Convert for COPY ... WITH (FORMAT text).

    This is the function that keeps bulk loading correct. products.description
    and reviews.review_text come from Faker's text generator and contain real
    newlines; an unescaped newline in a text-format COPY stream ends the record
    early, which corrupts rows silently rather than raising.
    """
    if value is None:
        return PG_NULL

    if isinstance(value, bool):
        return "t" if value else "f"
    if isinstance(value, (dict, list)):
        text = json.dumps(value)
    elif isinstance(value, Decimal):
        text = str(value)
    elif isinstance(value, datetime.datetime):
        text = value.isoformat(sep=" ")
    elif isinstance(value, datetime.date):
        text = value.isoformat()
    else:
        text = str(value)

    for target, replacement in _PG_TEXT_ESCAPES:
        text = text.replace(target, replacement)
    return text


def to_json_scalar(value: Any) -> Any:
    """Convert for a JSON document: containers stay structured."""
    if isinstance(value, Decimal):
        return float(value)
    if isinstance(value, (datetime.datetime, datetime.date)):
        return value.isoformat()
    return value


def to_csv_scalar(value: Any) -> Any:
    """Convert for a CSV cell: containers must become a single scalar."""
    if isinstance(value, (dict, list)):
        return json.dumps(value)
    if isinstance(value, Decimal):
        return float(value)
    if isinstance(value, (datetime.datetime, datetime.date)):
        return value.isoformat()
    return value


def to_parquet_scalar(value: Any) -> Any:
    """
    Convert for a Parquet column.

    Temporal values stay native so Arrow stores them as real timestamp types
    rather than strings, which is most of the point of a columnar format.
    Containers become JSON text, since the model does not declare a struct
    schema for them.
    """
    if isinstance(value, (dict, list)):
        return json.dumps(value)
    if isinstance(value, Decimal):
        return float(value)
    return value


class RecordJSONEncoder(json.JSONEncoder):
    """Fallback encoder for anything to_json_scalar did not already convert."""

    def default(self, o):
        if isinstance(o, Decimal):
            return float(o)
        if isinstance(o, (datetime.datetime, datetime.date)):
            return o.isoformat()
        return super().default(o)


SCALAR_CONVERTERS = {
    "csv": to_csv_scalar,
    "json": to_json_scalar,
    "parquet": to_parquet_scalar,
    "pg_param": to_pg_param,
}


def convert_record(record: dict, sink: str) -> dict:
    """Apply a sink's converter across one record."""
    convert = SCALAR_CONVERTERS[sink]
    return {key: convert(value) for key, value in record.items()}
