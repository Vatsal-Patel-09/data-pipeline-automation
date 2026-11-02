"""
Which tables actually reach PostgreSQL.

A table that declares a file destination and that nothing PostgreSQL-backed
references is created by the schema and then never loaded, so it sits empty in
the database while the run reports every row count as matching. That is real
behaviour, not a bug, but it was invisible: the summary counted the rows as
generated and verification only checked the tables it had loaded.

These tests pin both the gap and the --load-all escape hatch.
"""

import pytest

from src.data_generator import DataGenerator
from src.model_graph import ModelGraph
from src.output_handlers import OutputHandler


@pytest.fixture(scope="module")
def generated(shipped_model_path):
    return DataGenerator(shipped_model_path, scale=0.01).generate_all_data()


def test_reviews_is_outside_the_postgres_closure(shipped_model):
    """
    The specific gap, named. reviews declares csv and nothing references it.
    """
    graph = ModelGraph(shipped_model)
    closure = graph.postgres_closure()
    assert "reviews" not in closure
    assert graph.output_format("reviews") == "csv"
    assert graph.dependents("reviews") == []
    # Everything else does reach the database.
    assert set(graph.table_names) - closure == {"reviews"}


def test_default_run_reports_the_unloaded_table(shipped_model, generated):
    handler = OutputHandler(model=shipped_model)
    missing = handler.tables_not_loaded(generated)
    assert [m["table"] for m in missing] == ["reviews"]

    entry = missing[0]
    assert entry["declared"] == "csv"
    assert entry["referenced_by"] == []
    assert entry["rows_generated"] == len(generated["reviews"]["data"])
    assert entry["rows_generated"] > 0, "it really does generate rows"


def test_load_all_closes_the_gap(shipped_model, generated):
    handler = OutputHandler(model=shipped_model, load_all=True)
    assert handler.tables_not_loaded(generated) == []
    assert handler.find_postgresql_dependencies(generated) == set(
        ModelGraph(shipped_model).table_names
    )


def test_load_all_still_orders_by_dependency(shipped_model, generated):
    """Loading everything must not break the ordering the foreign keys need."""
    handler = OutputHandler(model=shipped_model, load_all=True)
    required = handler.find_postgresql_dependencies(generated)
    order = handler.get_postgresql_insertion_order(generated, required)
    assert set(order) == required

    graph = ModelGraph(shipped_model)
    position = {name: i for i, name in enumerate(order)}
    for table in order:
        for dependency in graph.dependencies(table):
            assert position[dependency] < position[table], (
                f"{table} would load before its parent {dependency}"
            )


def test_generated_rows_are_accounted_for(shipped_model, generated):
    """
    Every generated row either reaches the database or is named as not having.
    This is the invariant whose absence made the discrepancy invisible.
    """
    handler = OutputHandler(model=shipped_model)
    loaded = handler.find_postgresql_dependencies(generated)

    total = sum(len(info["data"]) for info in generated.values())
    into_db = sum(len(generated[t]["data"]) for t in loaded)
    reported_missing = sum(
        m["rows_generated"] for m in handler.tables_not_loaded(generated)
    )
    assert into_db + reported_missing == total
