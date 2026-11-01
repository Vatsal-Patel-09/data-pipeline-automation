"""
Generator correctness: reproducibility, a golden regression gate, and the
structural invariants the project's central claim rests on.

test_every_foreign_key_resolves_to_a_real_parent is the important one. The
project's distinctive claim is that one logical dataset is materialised into
heterogeneous sinks while foreign keys stay valid across all of them. That
claim was previously asserted in prose; here it is checked.
"""

import json
import os
import subprocess
import sys
from decimal import Decimal

import pytest

from conftest import canonical_hash, field_types
from src.data_generator import DataGenerator
from src.model_graph import ModelGraph

GOLDEN_PATH = os.path.join(
    os.path.dirname(os.path.abspath(__file__)), "fixtures", "golden_legacy_seed42.json"
)
REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


@pytest.fixture(scope="module")
def generated(tiny_model_path):
    """One generation run over the fixture model, shared across invariants."""
    generator = DataGenerator(tiny_model_path)
    return generator.generate_all_data()


@pytest.fixture(scope="module")
def rows(generated):
    return {name: info["data"] for name, info in generated.items()}


# -- reproducibility -------------------------------------------------------


def test_same_seed_reproduces_within_a_process(tiny_model_path):
    first = DataGenerator(tiny_model_path).generate_all_data()
    second = DataGenerator(tiny_model_path).generate_all_data()
    for table in first:
        assert canonical_hash(first[table]["data"]) == canonical_hash(
            second[table]["data"]
        ), f"{table} differs between two runs with the same seed"


def test_reproducible_across_processes_and_hash_seeds(tiny_model_path):
    """
    Run in subprocesses with different PYTHONHASHSEED values.

    The subprocess part is what actually proves the output does not depend on
    set/dict iteration order. An in-process check cannot establish this, and a
    PYTHONHASHSEED-dependent ordering bug is exactly what this repo already had
    in its schema-creation path.
    """
    script = (
        "import json,sys;"
        "sys.path.insert(0, sys.argv[2]);"
        "from src.data_generator import DataGenerator;"
        "d=DataGenerator(sys.argv[1]).generate_all_data();"
        "print(json.dumps({k: [str(r) for r in v['data']] for k,v in d.items()}))"
    )
    results = []
    for hash_seed in ("0", "1", "42", "12345"):
        env = dict(os.environ, PYTHONHASHSEED=hash_seed)
        completed = subprocess.run(
            [sys.executable, "-c", script, tiny_model_path, REPO_ROOT],
            capture_output=True,
            text=True,
            env=env,
            cwd=REPO_ROOT,
        )
        assert completed.returncode == 0, completed.stderr[-2000:]
        results.append(json.loads(completed.stdout.strip().splitlines()[-1]))

    reference = results[0]
    for index, result in enumerate(results[1:], start=1):
        assert result == reference, (
            f"output depends on PYTHONHASHSEED (run {index} differs)"
        )


def test_different_seed_changes_every_table(tiny_model_path):
    baseline = DataGenerator(tiny_model_path, seed=42).generate_all_data()
    other = DataGenerator(tiny_model_path, seed=43).generate_all_data()
    for table in baseline:
        assert canonical_hash(baseline[table]["data"]) != canonical_hash(
            other[table]["data"]
        ), f"{table} did not change with a different seed"


def test_reference_date_anchors_temporal_fields(tiny_model_path):
    """
    Temporal fields must derive from the reference date, not the wall clock.

    Before this was fixed, five of the six tables in the shipped model were
    nonreproducible for exactly this reason.
    """
    early = DataGenerator(tiny_model_path, reference_date="2020-06-01")
    late = DataGenerator(tiny_model_path, reference_date="2026-06-01")
    early_rows = early.generate_all_data()["users"]["data"]
    late_rows = late.generate_all_data()["users"]["data"]

    assert max(r["registration_date"] for r in early_rows).year <= 2020
    assert max(r["registration_date"] for r in late_rows).year >= 2025

    # And the default is a constant, so two generators agree.
    assert canonical_hash(
        DataGenerator(tiny_model_path).generate_all_data()["users"]["data"]
    ) == canonical_hash(
        DataGenerator(tiny_model_path).generate_all_data()["users"]["data"]
    )


def test_invalid_reference_date_is_rejected(tiny_model_path):
    with pytest.raises(ValueError, match="Invalid reference_date"):
        DataGenerator(tiny_model_path, reference_date="last tuesday")


# -- golden regression gate ------------------------------------------------


def test_matches_committed_golden(tiny_model_path):
    """
    Gate against unintended behaviour change.

    Regenerate deliberately with:
        UPDATE_GOLDEN=1 python -m pytest tests/test_generator.py -k golden
    Any diff here means a refactor altered generated data, which for a
    behaviour-preserving change is a bug.
    """
    generated = DataGenerator(tiny_model_path).generate_all_data()
    actual = {name: canonical_hash(info["data"]) for name, info in generated.items()}

    if os.environ.get("UPDATE_GOLDEN") == "1":
        with open(GOLDEN_PATH, "w", encoding="utf-8") as handle:
            json.dump(
                {"engine": "legacy", "seed": 42, "hashes": actual}, handle, indent=2
            )
        pytest.skip("golden regenerated")

    assert os.path.exists(GOLDEN_PATH), (
        "golden missing; regenerate with UPDATE_GOLDEN=1"
    )
    with open(GOLDEN_PATH, encoding="utf-8") as handle:
        golden = json.load(handle)

    assert actual == golden["hashes"]


# -- structural invariants -------------------------------------------------


def test_row_counts_match_sample_size(rows, tiny_model):
    expected = {t["name"]: t["sample_size"] for t in tiny_model["tables"]}
    actual = {name: len(data) for name, data in rows.items()}
    assert actual == expected


def test_scale_multiplies_row_counts(tiny_model_path, tiny_model):
    generated = DataGenerator(tiny_model_path, scale=2.0).generate_all_data()
    for table in tiny_model["tables"]:
        assert len(generated[table["name"]]["data"]) == table["sample_size"] * 2


def test_scale_never_produces_an_empty_table(tiny_model_path, tiny_model):
    generated = DataGenerator(tiny_model_path, scale=0.001).generate_all_data()
    for table in tiny_model["tables"]:
        assert len(generated[table["name"]]["data"]) >= 1


def test_primary_keys_are_unique_and_sequential(rows, tiny_model):
    for table in tiny_model["tables"]:
        pk = next(
            f["name"] for f in table["fields"] if f.get("primary_key")
        )
        values = [r[pk] for r in rows[table["name"]]]
        assert len(set(values)) == len(values), f"{table['name']}.{pk} has duplicates"
        assert values == list(range(1, len(values) + 1))


def test_every_foreign_key_resolves_to_a_real_parent(rows, tiny_model):
    """
    The project's central claim, as a checked invariant.

    Every foreign-key value must be a member of its parent's primary-key set,
    regardless of which sink each table is routed to. In the fixture model the
    parents and children land in different destinations on purpose: products is
    json, its parent categories is postgres; reviews is parquet, its parents are
    json and csv.
    """
    graph = ModelGraph(tiny_model)
    checked = 0
    for table in graph.table_names:
        for ref in graph.foreign_keys(table):
            parent_ids = {r[ref.ref_field] for r in rows[ref.ref_table]}
            for index, record in enumerate(rows[table]):
                value = record[ref.field]
                if value is None:
                    assert ref.nullable or ref.self_ref, (
                        f"{table}.{ref.field} is NULL at row {index} but is not nullable"
                    )
                    continue
                assert value in parent_ids, (
                    f"{table}.{ref.field}={value} at row {index} has no parent in "
                    f"{ref.ref_table}.{ref.ref_field}"
                )
                checked += 1
    assert checked > 0, "no foreign keys were actually checked"


def test_self_reference_points_only_to_earlier_rows(rows):
    """
    categories.parent_id must reference an earlier row, which makes a cycle
    structurally impossible rather than incidentally absent.
    """
    categories = rows["categories"]
    by_id = {r["id"]: i for i, r in enumerate(categories)}
    for index, record in enumerate(categories):
        parent = record["parent_id"]
        if parent is None:
            continue
        assert by_id[parent] < index, (
            f"categories row {index} references a later or equal row {parent}"
        )


def test_category_hierarchy_is_acyclic(rows):
    parent_of = {r["id"]: r["parent_id"] for r in rows["categories"]}
    for start in parent_of:
        seen = set()
        node = start
        while node is not None:
            assert node not in seen, f"cycle in category hierarchy at {node}"
            seen.add(node)
            node = parent_of.get(node)


def test_unique_fields_are_unique(rows, tiny_model):
    for table in tiny_model["tables"]:
        for field in table["fields"]:
            if not field.get("unique"):
                continue
            values = [r[field["name"]] for r in rows[table["name"]]]
            duplicates = len(values) - len(set(values))
            assert duplicates == 0, (
                f"{table['name']}.{field['name']} has {duplicates} duplicate(s)"
            )


def test_enum_values_are_in_domain(rows, tiny_model):
    checked = 0
    for table in tiny_model["tables"]:
        for field in table["fields"]:
            if field["type"] != "enum":
                continue
            allowed = set(field["values"])
            for record in rows[table["name"]]:
                assert record[field["name"]] in allowed
                checked += 1
    assert checked > 0


def test_max_length_is_respected(rows, tiny_model):
    """
    Guards the unique-value fallback, which appends '_<counter>' AFTER the value
    has already been truncated and so can overflow the declared column width.
    """
    for table in tiny_model["tables"]:
        for field in table["fields"]:
            limit = field.get("max_length")
            if not limit or field["type"] != "string":
                continue
            for record in rows[table["name"]]:
                value = record[field["name"]]
                if value is None:
                    continue
                assert len(str(value)) <= limit, (
                    f"{table['name']}.{field['name']} is {len(str(value))} chars, "
                    f"exceeding max_length {limit}: {value!r}"
                )


def test_decimal_scale_is_respected(rows, tiny_model):
    for table in tiny_model["tables"]:
        for field in table["fields"]:
            if field["type"] != "decimal":
                continue
            scale = field.get("scale", 2)
            for record in rows[table["name"]]:
                value = record[field["name"]]
                assert isinstance(value, Decimal)
                exponent = -value.as_tuple().exponent
                assert exponent <= scale, (
                    f"{table['name']}.{field['name']}={value} has {exponent} "
                    f"decimal places, exceeding scale {scale}"
                )


def test_not_null_fields_are_never_null(rows, tiny_model):
    for table in tiny_model["tables"]:
        for field in table["fields"]:
            if field.get("nullable"):
                continue
            for index, record in enumerate(rows[table["name"]]):
                assert record[field["name"]] is not None, (
                    f"{table['name']}.{field['name']} is NULL at row {index} "
                    "but is not declared nullable"
                )


def test_declared_types_produce_matching_python_types(rows, tiny_model):
    import datetime

    expected = {
        "integer": int,
        "decimal": Decimal,
        "boolean": bool,
        "string": str,
        "text": str,
        "json": dict,
    }
    for table in tiny_model["tables"]:
        types = field_types(tiny_model, table["name"])
        for record in rows[table["name"]]:
            for name, declared in types.items():
                value = record[name]
                if value is None:
                    continue
                if declared in expected:
                    assert isinstance(value, expected[declared]), (
                        f"{table['name']}.{name} declared {declared} but produced "
                        f"{type(value).__name__}"
                    )
                elif declared == "date":
                    assert isinstance(value, datetime.date)
                elif declared == "timestamp":
                    assert isinstance(value, datetime.datetime)


def test_no_field_contains_the_unknown_type_placeholder(rows):
    """
    An unrecognised field type used to yield the literal string
    'sample_<type>' with no warning, producing a plausible-looking column full
    of junk. Nothing in a valid model should ever hit that path.
    """
    for table, data in rows.items():
        for record in data:
            for name, value in record.items():
                assert not (
                    isinstance(value, str) and value.startswith("sample_")
                ), f"{table}.{name} contains the unknown-type placeholder {value!r}"


def test_output_formats_are_normalised(generated, tiny_model):
    graph = ModelGraph(tiny_model)
    for name, info in generated.items():
        assert info["output_format"] == graph.output_format(name)
    # 'postgres' in the model must surface as 'postgresql'.
    assert generated["categories"]["output_format"] == "postgresql"


def test_generation_order_is_topological(tiny_model_path, tiny_model):
    generator = DataGenerator(tiny_model_path)
    order = [t["name"] for t in generator.get_table_generation_order()]
    assert order == ModelGraph(tiny_model).topological_order()
