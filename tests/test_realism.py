"""
Semantic invariants: the properties the realism pass is supposed to establish.

These are the tests that distinguish "structurally valid" from "believable".
The repo previously had the former and documented the absence of the latter.
"""

import re
from datetime import date, datetime
from decimal import Decimal

import pytest

from src.data_generator import DataGenerator
from src.realism import (
    MAX_ADULT_AGE,
    MIN_ADULT_AGE,
    is_birth_field,
    is_event_date_field,
)


@pytest.fixture(scope="module")
def shipped_rows(shipped_model_path):
    """A small but structurally complete slice of the real model."""
    generated = DataGenerator(shipped_model_path, scale=0.02).generate_all_data()
    return {name: info["data"] for name, info in generated.items()}


@pytest.fixture(scope="module")
def raw_rows(shipped_model_path):
    """The same slice with the semantic pass disabled, for contrast."""
    generated = DataGenerator(
        shipped_model_path, scale=0.02, realism=False
    ).generate_all_data()
    return {name: info["data"] for name, info in generated.items()}


def as_dt(value):
    if isinstance(value, datetime):
        return value
    if isinstance(value, date):
        return datetime(value.year, value.month, value.day)
    return None


# -- field classification --------------------------------------------------


@pytest.mark.parametrize(
    "name", ["birth_date", "date_of_birth", "dob", "born_on", "BirthDate"]
)
def test_birth_fields_are_recognised(name):
    assert is_birth_field(name)
    assert not is_event_date_field(name)


@pytest.mark.parametrize(
    "name", ["created_at", "registration_date", "order_date", "joined_at", "shipped_at"]
)
def test_event_fields_are_recognised(name):
    assert is_event_date_field(name)
    assert not is_birth_field(name)


# -- rule 1: plausible ages ------------------------------------------------


def test_birth_dates_produce_adults(shipped_rows):
    reference = DataGenerator.DEFAULT_REFERENCE_DATE
    anchor = datetime.fromisoformat(reference)
    ages = [
        (anchor - as_dt(r["birth_date"])).days / 365.25
        for r in shipped_rows["users"]
        if r.get("birth_date") is not None
    ]
    assert ages, "no birth dates generated"
    assert min(ages) >= MIN_ADULT_AGE - 1
    assert max(ages) <= MAX_ADULT_AGE + 1


def test_raw_birth_dates_are_the_documented_defect(raw_rows):
    """
    Without the pass, every user is an infant. Pinning this keeps the
    before/after claim in the report honest.
    """
    anchor = datetime.fromisoformat(DataGenerator.DEFAULT_REFERENCE_DATE)
    ages = [
        (anchor - as_dt(r["birth_date"])).days / 365.25
        for r in raw_rows["users"]
        if r.get("birth_date") is not None
    ]
    assert max(ages) < 3, "expected the pre-fix behaviour: all users under 3"


# -- rule 2: causal ordering ----------------------------------------------


def test_no_order_precedes_its_user_registration(shipped_rows):
    registered = {
        r["id"]: as_dt(r["registration_date"]) for r in shipped_rows["users"]
    }
    offenders = [
        r["id"]
        for r in shipped_rows["orders"]
        if as_dt(r["order_date"]) < registered[r["user_id"]]
    ]
    assert not offenders, f"{len(offenders)} orders precede their user's registration"


def test_no_review_precedes_its_product(shipped_rows):
    created = {r["id"]: as_dt(r["created_at"]) for r in shipped_rows["products"]}
    offenders = [
        r["id"]
        for r in shipped_rows["reviews"]
        if as_dt(r["created_at"]) < created[r["product_id"]]
    ]
    assert not offenders, f"{len(offenders)} reviews predate their product"


def test_no_product_precedes_its_category(shipped_rows):
    created = {r["id"]: as_dt(r["created_at"]) for r in shipped_rows["categories"]}
    offenders = [
        r["id"]
        for r in shipped_rows["products"]
        if as_dt(r["created_at"]) < created[r["category_id"]]
    ]
    assert not offenders, f"{len(offenders)} products predate their category"


def test_raw_data_violates_causality(raw_rows):
    """Without the pass, roughly half of all orders precede registration."""
    registered = {r["id"]: as_dt(r["registration_date"]) for r in raw_rows["users"]}
    bad = sum(
        1
        for r in raw_rows["orders"]
        if as_dt(r["order_date"]) < registered[r["user_id"]]
    )
    assert bad > 0, "expected the pre-fix behaviour: causality violations present"


def test_no_date_exceeds_the_reference(shipped_rows):
    anchor = datetime.fromisoformat(DataGenerator.DEFAULT_REFERENCE_DATE)
    for table, rows in shipped_rows.items():
        for record in rows:
            for name, value in record.items():
                moment = as_dt(value) if isinstance(value, (date, datetime)) else None
                if moment is None or "birth" in name:
                    continue
                assert moment <= anchor, (
                    f"{table}.{name} = {value} is after the reference date"
                )


# -- rules 3-6: money adds up ---------------------------------------------


def test_line_totals_are_arithmetic(shipped_rows):
    for record in shipped_rows["order_items"]:
        expected = Decimal(str(record["unit_price"])) * Decimal(record["quantity"])
        expected -= Decimal(str(record["discount_amount"]))
        assert abs(Decimal(str(record["total_price"])) - expected) <= Decimal("0.01")


def test_discount_never_exceeds_the_line_value(shipped_rows):
    for record in shipped_rows["order_items"]:
        gross = Decimal(str(record["unit_price"])) * Decimal(record["quantity"])
        assert Decimal(str(record["discount_amount"])) <= gross


def test_order_totals_reconcile_with_line_items(shipped_rows):
    sums = {}
    for record in shipped_rows["order_items"]:
        sums[record["order_id"]] = sums.get(
            record["order_id"], Decimal(0)
        ) + Decimal(str(record["total_price"]))

    for record in shipped_rows["orders"]:
        expected = sums.get(record["id"], Decimal(0))
        expected += Decimal(str(record["tax_amount"]))
        expected += Decimal(str(record["shipping_cost"]))
        assert abs(Decimal(str(record["total_amount"])) - expected) <= Decimal("0.01"), (
            f"order {record['id']} total {record['total_amount']} != {expected}"
        )


def test_raw_order_totals_do_not_reconcile(raw_rows):
    """Without the pass this was 100%, not merely most."""
    sums = {}
    for record in raw_rows["order_items"]:
        sums[record["order_id"]] = sums.get(
            record["order_id"], Decimal(0)
        ) + Decimal(str(record["total_price"]))
    compared = [r for r in raw_rows["orders"] if r["id"] in sums]
    mismatched = sum(
        1
        for r in compared
        if abs(
            Decimal(str(r["total_amount"]))
            - (sums[r["id"]] + Decimal(str(r["tax_amount"]))
               + Decimal(str(r["shipping_cost"])))
        )
        > Decimal("0.01")
    )
    assert compared and mismatched == len(compared)


def test_unit_price_tracks_the_product_price(shipped_rows):
    prices = {r["id"]: Decimal(str(r["price"])) for r in shipped_rows["products"]}
    for record in shipped_rows["order_items"]:
        listed = prices[record["product_id"]]
        unit = Decimal(str(record["unit_price"]))
        assert listed * Decimal("0.5") <= unit <= listed * Decimal("1.05"), (
            f"unit_price {unit} is implausible against list price {listed}"
        )


def test_no_product_sells_below_cost(shipped_rows):
    for record in shipped_rows["products"]:
        assert Decimal(str(record["cost"])) < Decimal(str(record["price"])), (
            f"product {record['id']} costs more than it sells for"
        )


def test_total_spent_matches_order_history(shipped_rows):
    spent = {}
    for record in shipped_rows["orders"]:
        spent[record["user_id"]] = spent.get(
            record["user_id"], Decimal(0)
        ) + Decimal(str(record["total_amount"]))
    for record in shipped_rows["users"]:
        expected = spent.get(record["id"], Decimal(0))
        assert abs(Decimal(str(record["total_spent"])) - expected) <= Decimal("0.01")


# -- rule 8: names ---------------------------------------------------------


def test_category_names_are_unique_without_counter_suffixes(shipped_model_path):
    """
    400 unique category names must come from the vocabulary, not from the
    uniqueness fallback appending '_N'.
    """
    generated = DataGenerator(shipped_model_path).generate_all_data()
    names = [r["name"] for r in generated["categories"]["data"]]
    assert len(names) == len(set(names)) == 400
    suffixed = [n for n in names if re.search(r"_\d+$", n)]
    assert not suffixed, f"{len(suffixed)} category names use the counter fallback"


def test_product_names_are_varied_and_not_category_names(shipped_rows):
    names = [r["name"] for r in shipped_rows["products"]]
    distinct_ratio = len(set(names)) / len(names)
    assert distinct_ratio > 0.9, (
        f"only {len(set(names))} distinct names across {len(names)} products"
    )
    category_names = {r["name"] for r in shipped_rows["categories"]}
    assert not (set(names) & category_names), (
        "product names are being drawn from the category vocabulary"
    )


def test_composed_names_carry_no_uniqueness_artefacts(shipped_rows):
    for record in shipped_rows["products"]:
        assert not re.search(r"_\d+", record["name"]), (
            f"uniqueness artefact leaked into product name {record['name']!r}"
        )


def test_names_respect_max_length(shipped_rows, shipped_model):
    limits = {
        table["name"]: {
            f["name"]: f.get("max_length")
            for f in table["fields"]
            if f.get("max_length")
        }
        for table in shipped_model["tables"]
    }
    for table, rows in shipped_rows.items():
        for record in rows:
            for name, limit in limits.get(table, {}).items():
                value = record.get(name)
                if value is not None:
                    assert len(str(value)) <= limit


# -- the pass is optional and reports what it did --------------------------


def test_realism_can_be_disabled(shipped_model_path):
    generator = DataGenerator(shipped_model_path, scale=0.01, realism=False)
    generator.generate_all_data()
    assert generator.realism_stats is None


def test_realism_reports_what_it_changed(shipped_model_path):
    generator = DataGenerator(shipped_model_path, scale=0.01)
    generator.generate_all_data()
    stats = generator.realism_stats
    assert stats is not None
    assert stats.birth_dates_corrected > 0
    assert stats.line_totals_reconciled > 0
    assert stats.parent_totals_reconciled > 0
    assert stats.costs_adjusted > 0
    assert stats.names_composed > 0


def test_realism_is_reproducible(shipped_model_path):
    from conftest import canonical_hash

    first = DataGenerator(shipped_model_path, scale=0.01).generate_all_data()
    second = DataGenerator(shipped_model_path, scale=0.01).generate_all_data()
    for table in first:
        assert canonical_hash(first[table]["data"]) == canonical_hash(
            second[table]["data"]
        )
