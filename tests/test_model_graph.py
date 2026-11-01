"""
Tests for the shared model graph.

The most important test here is test_shipped_closure_is_unchanged_by_transitivity:
the transitive-closure fix is provably a no-op on the model the project ships,
so it is a guard against a latent failure rather than a behaviour change. Pinning
that keeps it honest.
"""

import pytest

from src.model_graph import (
    ModelError,
    ModelGraph,
    normalize_output_format,
    parse_foreign_key,
)


# -- foreign key parsing ---------------------------------------------------


@pytest.mark.parametrize(
    "value,expected",
    [
        ("categories.id", ("categories", "id")),
        ("categories", ("categories", "id")),
        ("orders.order_id", ("orders", "order_id")),
        ("  orders.id  ", ("orders", "id")),
    ],
)
def test_parse_foreign_key_accepts_both_documented_shapes(value, expected):
    assert parse_foreign_key(value) == expected


@pytest.mark.parametrize("value", ["", "   ", ".id", "orders.", ".", None, 42])
def test_parse_foreign_key_rejects_malformed(value):
    with pytest.raises(ModelError):
        parse_foreign_key(value)


def test_bare_table_shorthand_matches_dotted_form():
    """
    The shorthand must resolve identically everywhere.

    Previously the generator and the DDL honoured 'categories' while the output
    handler silently ignored it, which created a real constraint with valid
    values but left the parent out of the load set -- a hard failure at load
    time, not a cosmetic inconsistency.
    """
    assert parse_foreign_key("categories") == parse_foreign_key("categories.id")


# -- output format normalisation -------------------------------------------


@pytest.mark.parametrize(
    "declared,expected",
    [
        ("postgres", "postgresql"),
        ("postgresql", "postgresql"),
        ("POSTGRES", "postgresql"),
        ("csv", "csv"),
        ("json", "json"),
        ("api", "api"),
        ("parquet", "parquet"),
    ],
)
def test_output_format_normalisation(declared, expected):
    assert normalize_output_format({"name": "t", "output_format": declared}) == expected


def test_output_format_defaults_to_postgresql():
    assert normalize_output_format({"name": "t"}) == "postgresql"


def test_unknown_output_format_is_rejected_loudly():
    with pytest.raises(ModelError, match="Unknown output_format"):
        normalize_output_format({"name": "t", "output_format": "mongo"})


# -- contract enforcement --------------------------------------------------


def test_tables_must_be_a_list_not_a_mapping():
    with pytest.raises(ModelError, match="must be a list"):
        ModelGraph({"tables": {"users": {}}})


def test_fields_must_be_a_list_not_a_mapping():
    with pytest.raises(ModelError, match="must be a list"):
        ModelGraph({"tables": [{"name": "users", "fields": {"id": {}}}]})


def test_duplicate_table_names_are_rejected():
    table = {"name": "users", "fields": []}
    with pytest.raises(ModelError, match="Duplicate table"):
        ModelGraph({"tables": [table, dict(table)]})


# -- ordering --------------------------------------------------------------


def test_topological_order_respects_dependencies(tiny_model):
    graph = ModelGraph(tiny_model)
    order = graph.topological_order()
    position = {name: i for i, name in enumerate(order)}
    for table in graph.table_names:
        for dependency in graph.dependencies(table):
            assert position[dependency] < position[table], (
                f"{table} is ordered before its dependency {dependency}"
            )


def test_topological_order_is_deterministic(tiny_model):
    graph = ModelGraph(tiny_model)
    orders = {tuple(ModelGraph(tiny_model).topological_order()) for _ in range(20)}
    assert len(orders) == 1, "ordering is not deterministic"
    assert tuple(graph.topological_order()) in orders


def test_shipped_model_order_is_the_historical_one(shipped_model):
    """
    The consolidated sort must reproduce the order the generator already used,
    because changing it would change which RNG draws each table consumes.
    """
    graph = ModelGraph(shipped_model)
    assert graph.topological_order() == [
        "categories",
        "users",
        "orders",
        "products",
        "order_items",
        "reviews",
    ]


def test_self_reference_is_excluded_from_ordering(tiny_model):
    graph = ModelGraph(tiny_model)
    # categories.parent_id -> categories.id must not make categories depend on
    # itself, which would be unsatisfiable.
    assert "categories" not in graph.dependencies("categories")
    assert "categories" in graph.dependencies("categories", include_self=True)


def test_waves_contain_only_resolved_dependencies(tiny_model):
    graph = ModelGraph(tiny_model)
    seen = set()
    for wave in graph.waves():
        for table in wave:
            unresolved = set(graph.dependencies(table)) - seen
            assert not unresolved, (
                f"{table} is in a wave before its dependencies {unresolved}"
            )
        seen.update(wave)
    assert seen == set(graph.table_names)


# -- closure ---------------------------------------------------------------


def test_closure_is_transitive():
    """
    A dependency of a dependency must be included. The previous implementation
    expanded only one level from the seed set.
    """
    model = {
        "tables": [
            {
                "name": "leaf",
                "output_format": "postgres",
                "fields": [
                    {"name": "id", "type": "integer", "primary_key": True},
                    {"name": "mid_id", "type": "integer", "foreign_key": "mid.id"},
                ],
            },
            {
                "name": "mid",
                "output_format": "json",
                "fields": [
                    {"name": "id", "type": "integer", "primary_key": True},
                    {"name": "root_id", "type": "integer", "foreign_key": "root.id"},
                ],
            },
            {
                "name": "root",
                "output_format": "csv",
                "fields": [{"name": "id", "type": "integer", "primary_key": True}],
            },
        ]
    }
    graph = ModelGraph(model)
    # Only 'leaf' declares postgres, but 'mid' and transitively 'root' must be
    # loaded too or leaf's foreign key has no parent.
    assert graph.postgres_closure() == {"leaf", "mid", "root"}


def test_shipped_closure_is_unchanged_by_transitivity(shipped_model):
    """
    The transitive fix must be a no-op on the shipped model.

    Reimplements the old one-level closure and asserts it agrees, so the claim
    'this refactor changes nothing about what you hand in' stays checked rather
    than remembered.
    """
    graph = ModelGraph(shipped_model)

    seeds = {
        name
        for name in graph.tables
        if graph.output_format(name) in ("postgresql", "api")
    }
    one_level = set(seeds)
    for name in seeds:
        for field in graph.config(name)["fields"]:
            fk = field.get("foreign_key")
            if fk and "." in fk:
                one_level.add(fk.split(".")[0])

    assert graph.postgres_closure() == one_level
    assert graph.postgres_closure() == {
        "categories",
        "users",
        "products",
        "orders",
        "order_items",
    }


def test_closure_ignores_unknown_seeds(tiny_model):
    graph = ModelGraph(tiny_model)
    assert graph.closure(["nope"]) == set()


def test_subgraph_restricts_and_keeps_order(tiny_model):
    graph = ModelGraph(tiny_model)
    closure = graph.postgres_closure()
    sub = graph.subgraph(closure)
    assert set(sub.table_names) == closure
    full_order = [t for t in graph.topological_order() if t in closure]
    assert sub.topological_order() == full_order


# -- diagnostics -----------------------------------------------------------


def test_shipped_model_validates_clean(shipped_model):
    assert ModelGraph(shipped_model).validate() == []


def test_tiny_model_validates_clean(tiny_model):
    assert ModelGraph(tiny_model).validate() == []


def test_no_cycles_in_shipped_model(shipped_model):
    assert ModelGraph(shipped_model).cycles() == []


def test_self_reference_is_not_reported_as_a_cycle(tiny_model):
    """A category tree is legitimate; only a genuine multi-table cycle is not."""
    assert ModelGraph(tiny_model).cycles() == []


def test_genuine_cycle_is_detected():
    model = {
        "tables": [
            {
                "name": "a",
                "fields": [
                    {"name": "id", "type": "integer", "primary_key": True},
                    {"name": "b_id", "type": "integer", "foreign_key": "b.id"},
                ],
            },
            {
                "name": "b",
                "fields": [
                    {"name": "id", "type": "integer", "primary_key": True},
                    {"name": "a_id", "type": "integer", "foreign_key": "a.id"},
                ],
            },
        ]
    }
    graph = ModelGraph(model)
    assert graph.cycles() == [["a", "b"]]
    assert any("Circular" in p for p in graph.validate())
    # It must still produce a complete order rather than hanging.
    assert sorted(graph.topological_order()) == ["a", "b"]


def test_dangling_foreign_key_target_is_reported():
    model = {
        "tables": [
            {
                "name": "orders",
                "fields": [
                    {"name": "id", "type": "integer", "primary_key": True},
                    {"name": "user_id", "type": "integer", "foreign_key": "users.id"},
                ],
            }
        ]
    }
    problems = ModelGraph(model).validate()
    assert any("does not define" in p for p in problems)


def test_foreign_key_to_missing_parent_field_is_reported():
    model = {
        "tables": [
            {
                "name": "users",
                "fields": [{"name": "id", "type": "integer", "primary_key": True}],
            },
            {
                "name": "orders",
                "fields": [
                    {"name": "id", "type": "integer", "primary_key": True},
                    {
                        "name": "user_id",
                        "type": "integer",
                        "foreign_key": "users.uuid",
                    },
                ],
            },
        ]
    }
    problems = ModelGraph(model).validate()
    assert any("users.uuid" in p for p in problems)


def test_unique_plus_foreign_key_is_reported():
    """
    This combination is unsatisfiable and it exists in the real loan model on
    the unmerged branch: foreign-key values are drawn with replacement from the
    parent, so uniqueness cannot hold, yet the DDL still emits UNIQUE.
    """
    model = {
        "tables": [
            {
                "name": "parent",
                "fields": [{"name": "id", "type": "integer", "primary_key": True}],
            },
            {
                "name": "child",
                "fields": [
                    {"name": "id", "type": "integer", "primary_key": True},
                    {
                        "name": "parent_id",
                        "type": "integer",
                        "foreign_key": "parent.id",
                        "unique": True,
                    },
                ],
            },
        ]
    }
    problems = ModelGraph(model).validate()
    assert any("unique" in p and "foreign_key" in p for p in problems)


def test_missing_primary_key_is_reported():
    model = {
        "tables": [{"name": "t", "fields": [{"name": "x", "type": "integer"}]}]
    }
    assert any("no primary key" in p for p in ModelGraph(model).validate())


def test_model_hash_is_stable_and_sensitive(shipped_model):
    import copy

    first = ModelGraph(shipped_model).model_hash()
    assert first == ModelGraph(copy.deepcopy(shipped_model)).model_hash()

    mutated = copy.deepcopy(shipped_model)
    mutated["tables"][0]["sample_size"] += 1
    assert ModelGraph(mutated).model_hash() != first


def test_describe_shape_is_dashboard_ready(shipped_model):
    described = ModelGraph(shipped_model).describe()
    for key in (
        "tables",
        "topological_order",
        "postgres_closure",
        "waves",
        "cycles",
        "model_hash",
        "foreign_keys",
    ):
        assert key in described
    assert described["tables"] == 6
    assert len(described["foreign_keys"]) == 7
