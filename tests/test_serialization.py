"""
Value conversion per sink.

The COPY escaping tests are the important ones. products.description and
reviews.review_text come from Faker's text generator and contain real newlines.
An unescaped newline in a text-format COPY stream terminates the record early,
so the failure mode is silently corrupted rows rather than an error -- the worst
possible shape for a bug in a bulk loader.
"""

import datetime
import json
from decimal import Decimal

import pytest

from src.serialization import (
    PG_NULL,
    RecordJSONEncoder,
    to_csv_scalar,
    to_json_scalar,
    to_parquet_scalar,
    to_pg_param,
    to_pg_text,
)


# -- parameterised statements ---------------------------------------------


def test_decimal_passes_through_to_psycopg2_unchanged():
    """
    The old code converted Decimal to float before insert, which is slower and
    lossier. psycopg2 adapts Decimal natively and exactly.
    """
    value = Decimal("12345.678")
    result = to_pg_param(value)
    assert isinstance(result, Decimal)
    assert result == value


def test_high_scale_decimal_keeps_every_digit():
    # products.weight is scale 3; float conversion is where this would drift.
    value = Decimal("0.001")
    assert str(to_pg_param(value)) == "0.001"


def test_containers_become_json_for_parameters():
    assert json.loads(to_pg_param({"city": "Pune"})) == {"city": "Pune"}
    assert json.loads(to_pg_param([1, 2])) == [1, 2]


@pytest.mark.parametrize(
    "value",
    [None, True, False, 0, -5, "text", datetime.date(2026, 1, 1),
     datetime.datetime(2026, 1, 1, 12, 30)],
)
def test_natively_adapted_values_pass_through(value):
    assert to_pg_param(value) is value or to_pg_param(value) == value


# -- COPY text format -----------------------------------------------------


def test_null_uses_the_dedicated_marker():
    """
    CSV format cannot express this: Python's csv module writes both None and ''
    as an empty field, so NULL and the empty string become indistinguishable.
    """
    assert to_pg_text(None) == PG_NULL
    assert to_pg_text("") == ""
    assert to_pg_text(None) != to_pg_text("")


def test_newlines_are_escaped():
    text = "Significant take future skin.\nExecutive fear only."
    escaped = to_pg_text(text)
    assert "\n" not in escaped
    assert "\\n" in escaped


def test_carriage_returns_and_tabs_are_escaped():
    escaped = to_pg_text("a\tb\r\nc")
    for raw in ("\t", "\r", "\n"):
        assert raw not in escaped
    assert "\\t" in escaped and "\\r" in escaped and "\\n" in escaped


def test_backslashes_are_escaped_before_anything_else():
    """
    Ordering matters: escaping newlines first would introduce backslashes that
    the backslash rule would then double, corrupting the value.
    """
    assert to_pg_text("a\\b") == "a\\\\b"
    # A literal backslash-n in the source must not be confused with a newline.
    assert to_pg_text("a\\nb") == "a\\\\nb"
    assert to_pg_text("a\nb") == "a\\nb"


def test_a_literal_null_marker_in_data_survives():
    """A value that happens to look like the NULL marker must not become NULL."""
    assert to_pg_text("\\N") == "\\\\N"
    assert to_pg_text("\\N") != PG_NULL


def test_booleans_use_postgres_literals():
    assert to_pg_text(True) == "t"
    assert to_pg_text(False) == "f"


def test_decimal_keeps_full_precision_in_copy():
    assert to_pg_text(Decimal("0.001")) == "0.001"
    assert to_pg_text(Decimal("1234567.89")) == "1234567.89"


def test_temporal_values_are_rendered_unambiguously():
    assert to_pg_text(datetime.date(2026, 3, 4)) == "2026-03-04"
    assert to_pg_text(
        datetime.datetime(2026, 3, 4, 11, 22, 33)
    ) == "2026-03-04 11:22:33"


def pg_text_unescape(text):
    """
    Reverse to_pg_text, the way PostgreSQL itself does: a single left-to-right
    pass over escape pairs.

    Sequential str.replace cannot do this correctly. Replacing '\\t' with a tab
    first would also consume the '\\' + 't' that came from escaping a literal
    backslash followed by the letter t.
    """
    mapping = {"n": "\n", "r": "\r", "t": "\t", "\\": "\\"}
    out = []
    index = 0
    while index < len(text):
        char = text[index]
        if char == "\\" and index + 1 < len(text):
            following = text[index + 1]
            out.append(mapping.get(following, "\\" + following))
            index += 2
        else:
            out.append(char)
            index += 1
    return "".join(out)


def test_json_columns_are_escaped_as_text():
    original = {"street": "12\tMain\nSt"}
    rendered = to_pg_text(original)
    assert "\t" not in rendered and "\n" not in rendered
    assert json.loads(pg_text_unescape(rendered)) == original


@pytest.mark.parametrize(
    "value",
    [
        "plain",
        "",
        "line\nbreak",
        "tab\tseparated",
        "carriage\rreturn",
        "back\\slash",
        "looks like \\N but is not",
        "\\t not a tab",
        "mixed \\ \n \t \r all",
    ],
)
def test_escaping_round_trips_for_awkward_strings(value):
    assert pg_text_unescape(to_pg_text(value)) == value


def test_a_full_row_round_trips_through_escaping():
    """
    Simulates what a COPY stream does: join on tab, split on tab, unescape.
    If escaping is wrong, the column count changes and the row is corrupt.
    """
    row = [
        1,
        "Zenith Travel Smartphone X 6643",
        "Line one.\nLine two.\tTabbed.",
        None,
        Decimal("19.99"),
        {"city": "Pune", "note": "has\nnewline"},
        datetime.datetime(2026, 1, 1, 9, 0, 0),
        True,
    ]
    line = "\t".join(to_pg_text(v) for v in row)
    assert "\n" not in line
    fields = line.split("\t")
    assert len(fields) == len(row), "escaping changed the column count"
    assert fields[3] == PG_NULL


# -- file sinks -----------------------------------------------------------

def test_json_sink_keeps_containers_structured():
    assert to_json_scalar({"a": 1}) == {"a": 1}
    assert to_json_scalar(Decimal("1.50")) == 1.5
    assert to_json_scalar(datetime.date(2026, 1, 2)) == "2026-01-02"


def test_csv_sink_flattens_containers():
    assert json.loads(to_csv_scalar({"a": 1})) == {"a": 1}
    assert to_csv_scalar(Decimal("2.25")) == 2.25


def test_parquet_sink_keeps_temporal_types_native():
    """Storing timestamps as strings would defeat the point of a columnar file."""
    moment = datetime.datetime(2026, 1, 2, 3, 4, 5)
    assert to_parquet_scalar(moment) is moment
    assert to_parquet_scalar(datetime.date(2026, 1, 2)) == datetime.date(2026, 1, 2)
    assert json.loads(to_parquet_scalar({"a": 1})) == {"a": 1}


def test_encoder_handles_anything_left_over():
    payload = {"d": Decimal("3.5"), "t": datetime.datetime(2026, 1, 1)}
    decoded = json.loads(json.dumps(payload, cls=RecordJSONEncoder))
    assert decoded["d"] == 3.5
    assert decoded["t"].startswith("2026-01-01")


def test_unsupported_type_still_raises():
    with pytest.raises(TypeError):
        json.dumps({"x": object()}, cls=RecordJSONEncoder)
