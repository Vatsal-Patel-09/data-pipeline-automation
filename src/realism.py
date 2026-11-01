"""
Semantic repair pass over generated data.

The generator produces structurally sound data: every foreign key resolves,
every type matches, every unique column is unique. It does not produce
semantically sound data. Measured on the shipped model before this pass:

  * every user was between 0.1 and 2.0 years old, because date fields ignored
    the field name entirely;
  * 57% of orders were placed before the user who placed them registered;
  * 138 of 138 sampled orders had a total_amount unrelated to the sum of their
    line items -- not most of them, all of them;
  * order_items.unit_price was drawn at random with no relationship to the
    price of the product being bought, which makes any total meaningless;
  * products.cost was independent of products.price, so margins were routinely
    negative;
  * 20,000 products shared 30 names, because a field named exactly 'name' was
    treated as a category name.

Every rule here is driven by field names and the foreign-key graph, not by
hardcoded table names, which preserves the project's central claim: a new
domain is a JSON file, not a code change. A model whose fields are named
'price', 'cost', 'total_amount', 'created_at' and so on gets these
relationships for free; a model that names things differently simply does not
trigger the rules.
"""

import logging
import random
import re
from dataclasses import dataclass, field as dataclass_field
from datetime import date, datetime, timedelta
from decimal import Decimal
from typing import Any, Dict, List, Optional, Sequence, Tuple

logger = logging.getLogger(__name__)

# Field-name classification. A 'birth' date is a property of an entity rather
# than an event in its life, so it must not be dragged forward by causality.
BIRTH_HINTS = ("birth", "dob", "born")

EVENT_DATE_HINTS = (
    "created",
    "registration",
    "registered",
    "joined",
    "signup",
    "signed_up",
    "order_date",
    "placed",
    "updated",
    "modified",
    "shipped",
    "delivered",
)

# Reasonable adult age bounds, in years.
MIN_ADULT_AGE = 18
MAX_ADULT_AGE = 80

# A line item's price relative to its product's list price.
MIN_PRICE_FACTOR = 0.85
MAX_PRICE_FACTOR = 1.0

# A product's cost relative to its price, i.e. a 20%-60% gross margin.
MIN_COST_RATIO = 0.40
MAX_COST_RATIO = 0.80

BRAND_WORDS = (
    "Aurora", "Bastion", "Cobalt", "Dynamo", "Everest", "Forge", "Granite",
    "Harbour", "Ironwood", "Juniper", "Kestrel", "Lumen", "Meridian", "Nimbus",
    "Onyx", "Pinnacle", "Quarry", "Redwood", "Summit", "Tundra", "Umbra",
    "Vertex", "Westgate", "Zenith",
)

MODIFIER_WORDS = (
    "Classic", "Compact", "Deluxe", "Essential", "Everyday", "Heavy-Duty",
    "Lightweight", "Performance", "Premium", "Pro", "Signature", "Standard",
    "Studio", "Travel", "Ultra",
)

VARIANT_WORDS = ("", "Plus", "Max", "Pro", "Lite", "II", "III", "X", "SE")


def _lower(name: str) -> str:
    return name.lower()


def is_birth_field(field_name: str) -> bool:
    lowered = _lower(field_name)
    return any(hint in lowered for hint in BIRTH_HINTS)


def is_event_date_field(field_name: str) -> bool:
    lowered = _lower(field_name)
    if is_birth_field(field_name):
        return False
    return any(hint in lowered for hint in EVENT_DATE_HINTS)


def _singularize(word: str) -> str:
    """Crude but adequate singularization for composing entity names."""
    if word.endswith("ies") and len(word) > 4:
        return word[:-3] + "y"
    if word.endswith("ses") or word.endswith("xes") or word.endswith("zes"):
        return word[:-2]
    if word.endswith("s") and not word.endswith("ss"):
        return word[:-1]
    return word


def _as_decimal(value: Any, scale: int) -> Decimal:
    quant = Decimal(1).scaleb(-scale)
    return Decimal(str(value)).quantize(quant)


@dataclass
class PassStats:
    """What the semantic pass actually changed, for the run report."""

    birth_dates_corrected: int = 0
    dates_reordered: int = 0
    unit_prices_linked: int = 0
    line_totals_reconciled: int = 0
    parent_totals_reconciled: int = 0
    rollups_reconciled: int = 0
    costs_adjusted: int = 0
    names_composed: int = 0
    details: Dict[str, Any] = dataclass_field(default_factory=dict)

    def as_dict(self) -> Dict[str, Any]:
        return {
            "birth_dates_corrected": self.birth_dates_corrected,
            "dates_reordered": self.dates_reordered,
            "unit_prices_linked": self.unit_prices_linked,
            "line_totals_reconciled": self.line_totals_reconciled,
            "parent_totals_reconciled": self.parent_totals_reconciled,
            "rollups_reconciled": self.rollups_reconciled,
            "costs_adjusted": self.costs_adjusted,
            "names_composed": self.names_composed,
            "details": self.details,
        }


class SemanticPass:
    """
    Repairs semantic relationships after generation.

    Runs after all tables exist, because most of the rules are cross-table and
    cannot be evaluated while a single row is being built.
    """

    def __init__(self, graph, reference_datetime: datetime,
                 rng: Optional[random.Random] = None, enabled: bool = True):
        self.graph = graph
        self.reference_datetime = reference_datetime
        self.reference_date = reference_datetime.date()
        self.rng = rng or random.Random(0)
        self.enabled = enabled
        self.stats = PassStats()

    # -- helpers -----------------------------------------------------------

    def _fields(self, table: str) -> List[Dict[str, Any]]:
        return self.graph.config(table).get("fields", [])

    def _field_map(self, table: str) -> Dict[str, Dict[str, Any]]:
        return {f["name"]: f for f in self._fields(table)}

    def _typed_fields(self, table: str, types: Sequence[str]) -> List[str]:
        return [f["name"] for f in self._fields(table) if f.get("type") in types]

    def _primary_event_field(self, table: str) -> Optional[str]:
        """
        The field representing when this entity came into being.

        Prefers an explicitly event-shaped name, then falls back to any
        non-birth temporal field.
        """
        temporal = self._typed_fields(table, ("timestamp", "date"))
        preferred = [n for n in temporal if is_event_date_field(n)]
        if preferred:
            return preferred[0]
        remaining = [n for n in temporal if not is_birth_field(n)]
        return remaining[0] if remaining else None

    def _pk(self, table: str) -> Optional[str]:
        for f in self._fields(table):
            if f.get("primary_key"):
                return f["name"]
        return None

    @staticmethod
    def _to_datetime(value: Any) -> Optional[datetime]:
        if isinstance(value, datetime):
            return value
        if isinstance(value, date):
            return datetime(value.year, value.month, value.day)
        return None

    @staticmethod
    def _match_field(names: Sequence[str], patterns: Sequence[str]) -> Optional[str]:
        for pattern in patterns:
            for name in names:
                if re.fullmatch(pattern, name.lower()):
                    return name
        for pattern in patterns:
            for name in names:
                if pattern.strip("^$.*") in name.lower():
                    return name
        return None

    # -- entry point -------------------------------------------------------

    def apply(self, generated_data: Dict[str, Dict[str, Any]]) -> PassStats:
        if not self.enabled:
            return self.stats

        rows = {name: info["data"] for name, info in generated_data.items()}

        self._fix_birth_dates(rows)
        self._compose_entity_names(rows)
        self._fix_cost_margin(rows)
        self._enforce_causal_dates(rows)
        self._link_unit_prices(rows)
        self._reconcile_line_totals(rows)
        self._reconcile_parent_totals(rows)
        self._reconcile_rollups(rows)
        return self.stats

    # -- rule 1: birth dates are not event dates ---------------------------

    def _fix_birth_dates(self, rows: Dict[str, List[Dict]]) -> None:
        """
        A birth date must put the entity in a plausible adult age range.

        Before this, every date field used the same '-2y to today' window, so
        users.birth_date produced implied ages of 0.1 to 2.0 years.
        """
        for table in self.graph.table_names:
            fields = self._field_map(table)
            for name, config in fields.items():
                if config.get("type") not in ("date", "timestamp"):
                    continue
                if not is_birth_field(name):
                    continue
                for record in rows.get(table, []):
                    if record.get(name) is None:
                        continue
                    # 365.25 days per year, and one day past the lower bound,
                    # so nobody lands at 17.99 years old through leap-year drift.
                    age_days = self.rng.randint(
                        int(MIN_ADULT_AGE * 365.25) + 1,
                        int(MAX_ADULT_AGE * 365.25),
                    )
                    born = self.reference_date - timedelta(days=age_days)
                    record[name] = (
                        born
                        if config["type"] == "date"
                        else datetime(born.year, born.month, born.day)
                    )
                    self.stats.birth_dates_corrected += 1

    # -- rule 2: causal ordering across foreign keys -----------------------

    def _enforce_causal_dates(self, rows: Dict[str, List[Dict]]) -> None:
        """
        A child entity cannot predate its parents.

        Generic over the foreign-key graph: for every edge child -> parent where
        both carry a primary event date, the child's date is resampled into
        [parent_date, reference] whenever it falls earlier. Processing in
        topological order means a parent is already corrected before its
        children are considered, so the property holds transitively.
        """
        for table in self.graph.topological_order():
            child_field = self._primary_event_field(table)
            if not child_field:
                continue
            child_type = self._field_map(table)[child_field].get("type")

            parent_lookups: List[Tuple[str, str, Dict[Any, Any]]] = []
            for ref in self.graph.foreign_keys(table):
                if ref.self_ref or ref.ref_table not in rows:
                    continue
                parent_field = self._primary_event_field(ref.ref_table)
                if not parent_field:
                    continue
                index = {
                    parent[ref.ref_field]: parent.get(parent_field)
                    for parent in rows[ref.ref_table]
                }
                parent_lookups.append((ref.field, ref.ref_table, index))

            if not parent_lookups:
                continue

            for record in rows.get(table, []):
                current = self._to_datetime(record.get(child_field))
                if current is None:
                    continue

                earliest: Optional[datetime] = None
                for fk_field, _parent_table, index in parent_lookups:
                    key = record.get(fk_field)
                    if key is None:
                        continue
                    parent_value = self._to_datetime(index.get(key))
                    if parent_value is None:
                        continue
                    if earliest is None or parent_value > earliest:
                        earliest = parent_value

                if earliest is None or current >= earliest:
                    continue

                window = self.reference_datetime - earliest
                seconds = max(int(window.total_seconds()), 0)
                offset = self.rng.randint(0, seconds) if seconds > 0 else 0
                corrected = earliest + timedelta(seconds=offset)
                record[child_field] = (
                    corrected.date() if child_type == "date" else corrected
                )
                self.stats.dates_reordered += 1

    # -- rule 3: a line item's price comes from its product ----------------

    def _link_unit_prices(self, rows: Dict[str, List[Dict]]) -> None:
        """
        A unit price must come from the thing being bought.

        Without this, reconciling totals is arithmetic over noise: the line
        price bore no relationship to the product's price, so a 'correct' total
        would still describe an impossible order.
        """
        for table in self.graph.table_names:
            names = [f["name"] for f in self._fields(table)]
            unit_price = self._match_field(names, [r"unit_price", r".*unit_price.*"])
            if not unit_price:
                continue
            scale = self._field_map(table)[unit_price].get("scale", 2)

            for ref in self.graph.foreign_keys(table):
                if ref.self_ref or ref.ref_table not in rows:
                    continue
                parent_names = [f["name"] for f in self._fields(ref.ref_table)]
                parent_price = self._match_field(parent_names, [r"price", r".*price.*"])
                if not parent_price:
                    continue
                index = {
                    parent[ref.ref_field]: parent.get(parent_price)
                    for parent in rows[ref.ref_table]
                }
                for record in rows.get(table, []):
                    key = record.get(ref.field)
                    if key is None or index.get(key) is None:
                        continue
                    factor = self.rng.uniform(MIN_PRICE_FACTOR, MAX_PRICE_FACTOR)
                    record[unit_price] = _as_decimal(
                        Decimal(str(index[key])) * Decimal(str(factor)), scale
                    )
                    self.stats.unit_prices_linked += 1
                break

    # -- rule 4: line totals are arithmetic, not random --------------------

    def _reconcile_line_totals(self, rows: Dict[str, List[Dict]]) -> None:
        """total = quantity * unit_price - discount, within a single row."""
        for table in self.graph.table_names:
            names = [f["name"] for f in self._fields(table)]
            total = self._match_field(names, [r"total_price", r"line_total", r"amount"])
            unit_price = self._match_field(names, [r"unit_price"])
            quantity = self._match_field(names, [r"quantity", r"qty"])
            if not (total and unit_price and quantity):
                continue
            discount = self._match_field(names, [r"discount_amount", r"discount"])
            scale = self._field_map(table)[total].get("scale", 2)

            for record in rows.get(table, []):
                unit = record.get(unit_price)
                count = record.get(quantity)
                if unit is None or count is None:
                    continue
                value = Decimal(str(unit)) * Decimal(int(count))
                if discount and record.get(discount) is not None:
                    reduction = Decimal(str(record[discount]))
                    # A discount cannot exceed the line value.
                    if reduction > value:
                        reduction = _as_decimal(
                            value * Decimal("0.5"),
                            self._field_map(table)[discount].get("scale", 2),
                        )
                        record[discount] = reduction
                    value -= reduction
                record[total] = _as_decimal(value, scale)
                self.stats.line_totals_reconciled += 1

    # -- rule 5: parent totals equal the sum of their children -------------

    def _reconcile_parent_totals(self, rows: Dict[str, List[Dict]]) -> None:
        """
        A parent's total equals the sum of its children's line totals, plus any
        additive charges the parent itself declares (tax, shipping).
        """
        for child in self.graph.table_names:
            child_names = [f["name"] for f in self._fields(child)]
            child_total = self._match_field(
                child_names, [r"total_price", r"line_total"]
            )
            if not child_total:
                continue

            for ref in self.graph.foreign_keys(child):
                if ref.self_ref or ref.ref_table not in rows:
                    continue
                parent = ref.ref_table
                parent_names = [f["name"] for f in self._fields(parent)]
                parent_total = self._match_field(
                    parent_names, [r"total_amount", r"total", r"grand_total"]
                )
                if not parent_total:
                    continue

                sums: Dict[Any, Decimal] = {}
                for record in rows.get(child, []):
                    key = record.get(ref.field)
                    if key is None or record.get(child_total) is None:
                        continue
                    sums[key] = sums.get(key, Decimal(0)) + Decimal(
                        str(record[child_total])
                    )

                additive = [
                    name
                    for name in parent_names
                    if re.search(r"tax|shipping|freight|handling", name.lower())
                    and self._field_map(parent)[name].get("type") == "decimal"
                ]
                scale = self._field_map(parent)[parent_total].get("scale", 2)
                pk = ref.ref_field

                for record in rows.get(parent, []):
                    subtotal = sums.get(record.get(pk), Decimal(0))
                    for name in additive:
                        if record.get(name) is not None:
                            subtotal += Decimal(str(record[name]))
                    record[parent_total] = _as_decimal(subtotal, scale)
                    self.stats.parent_totals_reconciled += 1

                self.stats.details.setdefault("parent_totals", []).append(
                    {
                        "parent": parent,
                        "child": child,
                        "field": parent_total,
                        "additive_fields": additive,
                        "parents_with_no_children": sum(
                            1
                            for record in rows.get(parent, [])
                            if record.get(pk) not in sums
                        ),
                    }
                )
                break

    # -- rule 6: entity rollups (e.g. lifetime value) ----------------------

    def _reconcile_rollups(self, rows: Dict[str, List[Dict]]) -> None:
        """
        A 'total spent'-style field on a parent equals the sum of its children's
        totals. Distinct from rule 5: this aggregates an already-reconciled
        parent total one level further up.
        """
        for child in self.graph.table_names:
            child_names = [f["name"] for f in self._fields(child)]
            child_total = self._match_field(child_names, [r"total_amount", r"total"])
            if not child_total:
                continue

            for ref in self.graph.foreign_keys(child):
                if ref.self_ref or ref.ref_table not in rows:
                    continue
                parent = ref.ref_table
                parent_names = [f["name"] for f in self._fields(parent)]
                rollup = self._match_field(
                    parent_names, [r"total_spent", r"lifetime_value", r"total_revenue"]
                )
                if not rollup:
                    continue

                sums: Dict[Any, Decimal] = {}
                for record in rows.get(child, []):
                    key = record.get(ref.field)
                    if key is None or record.get(child_total) is None:
                        continue
                    sums[key] = sums.get(key, Decimal(0)) + Decimal(
                        str(record[child_total])
                    )

                scale = self._field_map(parent)[rollup].get("scale", 2)
                for record in rows.get(parent, []):
                    record[rollup] = _as_decimal(
                        sums.get(record.get(ref.ref_field), Decimal(0)), scale
                    )
                    self.stats.rollups_reconciled += 1
                break

    # -- rule 7: cost sits below price -------------------------------------

    def _fix_cost_margin(self, rows: Dict[str, List[Dict]]) -> None:
        """Cost must be below price, or the business is losing money per unit."""
        for table in self.graph.table_names:
            names = [f["name"] for f in self._fields(table)]
            price = self._match_field(names, [r"price", r"list_price", r"unit_price"])
            cost = self._match_field(names, [r"cost", r"unit_cost", r"cost_price"])
            if not (price and cost) or price == cost:
                continue
            scale = self._field_map(table)[cost].get("scale", 2)
            for record in rows.get(table, []):
                if record.get(price) is None:
                    continue
                ratio = self.rng.uniform(MIN_COST_RATIO, MAX_COST_RATIO)
                record[cost] = _as_decimal(
                    Decimal(str(record[price])) * Decimal(str(ratio)), scale
                )
                self.stats.costs_adjusted += 1

    # -- rule 8: entity names derived from their parent category -----------

    def _compose_entity_names(self, rows: Dict[str, List[Dict]]) -> None:
        """
        Compose a name from the parent's name rather than reusing it.

        A field named exactly 'name' was previously filled from a hardcoded
        30-item category list, so 20,000 products shared 30 names. Worse, a
        'name' field marked unique drew from that same 30-item pool, so roughly
        370 of 400 categories ended up as 'Electronics_7'.
        """
        for table in self.graph.table_names:
            field_map = self._field_map(table)
            if "name" not in field_map:
                continue
            if field_map["name"].get("unique"):
                # Unique names are handled by the generator's own uniqueness
                # machinery; composing here could collide.
                continue

            parent_names: Optional[Tuple[str, Dict[Any, Any]]] = None
            for ref in self.graph.foreign_keys(table):
                if ref.self_ref or ref.ref_table not in rows:
                    continue
                if "name" not in self._field_map(ref.ref_table):
                    continue
                parent_names = (
                    ref.field,
                    {p[ref.ref_field]: p.get("name") for p in rows[ref.ref_table]},
                )
                break

            if parent_names is None:
                continue

            fk_field, index = parent_names
            max_length = field_map["name"].get("max_length", 255)

            for record in rows.get(table, []):
                parent_label = index.get(record.get(fk_field))
                if not parent_label:
                    continue
                # Strip any '_N' uniqueness suffix the parent's name may carry
                # before borrowing a noun from it, so a fallback artefact does
                # not leak into the child's name.
                cleaned = re.sub(r"_\d+$", "", str(parent_label)).strip()
                words = [w for w in cleaned.split() if w.strip("&")]
                noun = _singularize(words[-1].strip("&").strip()) if words else "Item"
                brand = self.rng.choice(BRAND_WORDS)
                modifier = self.rng.choice(MODIFIER_WORDS)
                variant = self.rng.choice(VARIANT_WORDS)
                number = self.rng.randint(100, 9999)
                parts = [brand, modifier, noun, variant, str(number)]
                composed = " ".join(p for p in parts if p)
                record["name"] = composed[:max_length]
                self.stats.names_composed += 1
