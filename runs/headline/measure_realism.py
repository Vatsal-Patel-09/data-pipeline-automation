"""
Quantify the data-realism defects recorded in docs/known-issues.md.

Reproduces the original measurements so the before/after is comparable rather
than asserted. Run with --no-realism to reproduce the pre-fix numbers.

Usage:
    python runs/headline/measure_realism.py [--scale S] [--no-realism] [--json OUT]
"""

import argparse
import json
import os
import sys
from collections import Counter
from datetime import date, datetime
from decimal import Decimal

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
if REPO_ROOT not in sys.path:
    sys.path.insert(0, REPO_ROOT)

from src.data_generator import DataGenerator  # noqa: E402


def as_datetime(value):
    if isinstance(value, datetime):
        return value
    if isinstance(value, date):
        return datetime(value.year, value.month, value.day)
    return None


def measure(rows, reference):
    report = {}

    # 1. Implied age from users.birth_date.
    ages = []
    for record in rows.get("users", []):
        born = as_datetime(record.get("birth_date"))
        if born:
            ages.append((reference - born).days / 365.25)
    if ages:
        report["age_years"] = {
            "min": round(min(ages), 2),
            "max": round(max(ages), 2),
            "mean": round(sum(ages) / len(ages), 2),
            "under_18": sum(1 for a in ages if a < 18),
            "sampled": len(ages),
        }

    # 2. Orders placed before the user registered.
    registered = {
        r["id"]: as_datetime(r.get("registration_date"))
        for r in rows.get("users", [])
    }
    before = checked = 0
    for record in rows.get("orders", []):
        placed = as_datetime(record.get("order_date"))
        reg = registered.get(record.get("user_id"))
        if placed and reg:
            checked += 1
            if placed < reg:
                before += 1
    if checked:
        report["orders_before_registration"] = {
            "count": before,
            "checked": checked,
            "pct": round(100.0 * before / checked, 1),
        }

    # 3. Reviews written before the product existed.
    created = {
        r["id"]: as_datetime(r.get("created_at")) for r in rows.get("products", [])
    }
    bad = seen = 0
    for record in rows.get("reviews", []):
        written = as_datetime(record.get("created_at"))
        made = created.get(record.get("product_id"))
        if written and made:
            seen += 1
            if written < made:
                bad += 1
    if seen:
        report["reviews_before_product"] = {
            "count": bad,
            "checked": seen,
            "pct": round(100.0 * bad / seen, 1),
        }

    # 4. Order totals versus the sum of their line items.
    sums = {}
    for record in rows.get("order_items", []):
        key = record.get("order_id")
        if key is None or record.get("total_price") is None:
            continue
        sums[key] = sums.get(key, Decimal(0)) + Decimal(str(record["total_price"]))
    mismatched = compared = 0
    for record in rows.get("orders", []):
        subtotal = sums.get(record.get("id"))
        if subtotal is None:
            continue
        expected = subtotal
        for extra in ("tax_amount", "shipping_cost"):
            if record.get(extra) is not None:
                expected += Decimal(str(record[extra]))
        compared += 1
        if abs(Decimal(str(record["total_amount"])) - expected) > Decimal("0.01"):
            mismatched += 1
    if compared:
        report["order_total_mismatch"] = {
            "count": mismatched,
            "checked": compared,
            "pct": round(100.0 * mismatched / compared, 1),
        }

    # 5. Line totals versus quantity * unit_price - discount.
    bad_lines = line_count = 0
    for record in rows.get("order_items", []):
        unit, qty = record.get("unit_price"), record.get("quantity")
        if unit is None or qty is None or record.get("total_price") is None:
            continue
        expected = Decimal(str(unit)) * Decimal(int(qty))
        if record.get("discount_amount") is not None:
            expected -= Decimal(str(record["discount_amount"]))
        line_count += 1
        if abs(Decimal(str(record["total_price"])) - expected) > Decimal("0.01"):
            bad_lines += 1
    if line_count:
        report["line_total_mismatch"] = {
            "count": bad_lines,
            "checked": line_count,
            "pct": round(100.0 * bad_lines / line_count, 1),
        }

    # 6. Distinct product names.
    names = [r.get("name") for r in rows.get("products", []) if r.get("name")]
    if names:
        counts = Counter(names)
        report["product_names"] = {
            "rows": len(names),
            "distinct": len(counts),
            "distinct_ratio": round(len(counts) / len(names), 4),
            "most_common": counts.most_common(3),
        }

    # 7. Unit price versus the product's list price.
    prices = {r["id"]: r.get("price") for r in rows.get("products", [])}
    unrelated = pairs = 0
    for record in rows.get("order_items", []):
        listed = prices.get(record.get("product_id"))
        unit = record.get("unit_price")
        if listed is None or unit is None:
            continue
        pairs += 1
        # A plausible selling price sits within 50% of list.
        if not (Decimal(str(listed)) * Decimal("0.5") <= Decimal(str(unit))
                <= Decimal(str(listed)) * Decimal("1.5")):
            unrelated += 1
    if pairs:
        report["unit_price_unrelated_to_product"] = {
            "count": unrelated,
            "checked": pairs,
            "pct": round(100.0 * unrelated / pairs, 1),
        }

    # 8. Products sold below cost.
    negative = margin_count = 0
    for record in rows.get("products", []):
        price, cost = record.get("price"), record.get("cost")
        if price is None or cost is None:
            continue
        margin_count += 1
        if Decimal(str(cost)) >= Decimal(str(price)):
            negative += 1
    if margin_count:
        report["negative_margin_products"] = {
            "count": negative,
            "checked": margin_count,
            "pct": round(100.0 * negative / margin_count, 1),
        }

    # 9. users.total_spent versus the sum of their orders.
    spent = {}
    for record in rows.get("orders", []):
        key = record.get("user_id")
        if key is None or record.get("total_amount") is None:
            continue
        spent[key] = spent.get(key, Decimal(0)) + Decimal(str(record["total_amount"]))
    off = users_checked = 0
    for record in rows.get("users", []):
        if record.get("total_spent") is None:
            continue
        users_checked += 1
        if abs(Decimal(str(record["total_spent"]))
               - spent.get(record["id"], Decimal(0))) > Decimal("0.01"):
            off += 1
    if users_checked:
        report["total_spent_mismatch"] = {
            "count": off,
            "checked": users_checked,
            "pct": round(100.0 * off / users_checked, 1),
        }

    return report


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--scale", type=float, default=1.0)
    parser.add_argument("--no-realism", action="store_true")
    parser.add_argument("--model", default=os.path.join(REPO_ROOT, "ecommerce_model.json"))
    parser.add_argument("--json", default=None)
    args = parser.parse_args()

    generator = DataGenerator(
        args.model, scale=args.scale, realism=not args.no_realism
    )
    generated = generator.generate_all_data()
    rows = {name: info["data"] for name, info in generated.items()}

    report = measure(rows, generator.reference_datetime)
    label = "WITHOUT realism pass" if args.no_realism else "WITH realism pass"

    print()
    print("=" * 72)
    print(f"DATA REALISM MEASUREMENT - {label} (scale={args.scale})")
    print("=" * 72)
    for key, value in report.items():
        print(f"\n{key}:")
        for sub, val in value.items():
            print(f"    {sub:<16} {val}")

    if args.json:
        payload = {
            "label": label,
            "realism": not args.no_realism,
            "scale": args.scale,
            "reference_date": str(generator.reference_datetime),
            "measurements": report,
        }
        with open(args.json, "w", encoding="utf-8") as handle:
            json.dump(payload, handle, indent=2, default=str)
        print(f"\nwrote {args.json}")


if __name__ == "__main__":
    main()
