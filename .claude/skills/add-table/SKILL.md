---
name: add-table
description: Add or modify a table in a pipeline model JSON (ecommerce_model.json or loan_mgmt_model.json). Use when asked to add a table, add a field, change a column, or extend the data model.
---

# Add a table to the data model

Editing the model JSON is the main way this project changes — the schema, the generated
data, the export destinations and the ordering all derive from it. Read
`docs/data-model.md` for the full contract before a non-trivial change.

## The shape — get these four right

An earlier draft of this codebase (`src/initial_db_manager.py`, now deleted) used the
*opposite* convention for each of these. If you pattern-match from old code or from
git history, you will get them wrong.

1. `tables` is a **list**, not a dict keyed by table name.
2. `fields` is a **list** of field objects, not a dict keyed by field name.
3. `foreign_key` is a **string** `"parent_table.id"`, not an object.
4. `output_format` is one of `postgres` | `postgresql` | `csv` | `json` | `api`.

```json
{
  "name": "shipments",
  "sample_size": 5000,
  "output_format": "postgres",
  "fields": [
    { "name": "id", "type": "integer", "primary_key": true, "auto_increment": true },
    { "name": "order_id", "type": "integer", "foreign_key": "orders.id", "nullable": false },
    { "name": "carrier_name", "type": "string", "max_length": 100 },
    { "name": "shipping_cost", "type": "decimal", "precision": 10, "scale": 2 },
    { "name": "status", "type": "enum", "values": ["pending", "in_transit", "delivered"] },
    { "name": "shipped_at", "type": "timestamp" }
  ]
}
```

## Name fields so the generator produces realistic values

This is the step that is easy to skip and expensive to get wrong. The generator
pattern-matches the **field name** to decide what a value should look like — there is no
explicit provider key. `shipping_cost` yields a plausible 0–50 shipping figure;
`ship_cst` yields a random float in 1–1000.

Consult the lookup tables in `docs/data-model.md` before choosing a name. The main ones:
`email`, `phone`, `address`, `description`, `sku`, `order_number`, `payment`,
`price`/`cost`, `total`/`amount`, `tax`, `shipping`, `discount`, `weight`, `rating`,
`quantity`, `stock`, `cibil_score` (loan branch only).

Watch out: a field named exactly `name` draws from a hardcoded **product category**
list, which is wrong outside a categories table. Use `carrier_name`, `customer_name`,
`full_name` and so on instead.

## Foreign keys and destinations

You do **not** declare that a table needs to be in PostgreSQL for FK integrity — that
is computed. `find_postgresql_dependencies` (`src/output_handlers.py:89`) takes every
table whose `output_format` is `postgresql` or `api`, adds everything those reference,
and writes that whole closure to PostgreSQL in Phase 1. So a table with
`output_format: "csv"` that `orders` points at lands in *both* the CSV file and the
database, automatically.

What you must check:

- The parent table exists in the same model file and its `name` matches your
  `foreign_key` string exactly.
- The graph is acyclic. A cycle still "works" but the topological sort breaks it
  arbitrarily and logs `Circular dependency detected`, which means unreliable FK values.
- Self-references are fine (`parent_id` → the same table) and are handled specially:
  30% `NULL`, otherwise an id from rows already generated.

## If you touched `orders`

`api_server.py` serves `orders` through **hand-written** Pydantic models
(`OrderResponse`, `OrderListResponse`) and hand-written `SELECT` column lists. They are
not generated from the model. Add or rename a column in `orders` and you must update:

- the `OrderResponse` fields
- the `SELECT` lists in `get_orders` and `get_order_by_id`
- the positional row indices (`row[0]`, `row[1]`, …) in both handlers — these are
  index-based, so inserting a column mid-list silently shifts everything after it

## Verify

```bash
# 1. Valid JSON, and the contract holds
python -c "
import json
m = json.load(open('ecommerce_model.json', encoding='utf-8'))
assert isinstance(m['tables'], list)
names = {t['name'] for t in m['tables']}
total = 0
for t in m['tables']:
    assert isinstance(t['fields'], list), t['name']
    assert t.get('output_format', 'postgresql') in {'postgres','postgresql','csv','json','api'}, t['name']
    total += t.get('sample_size', 100)
    for f in t['fields']:
        fk = f.get('foreign_key')
        if fk:
            assert isinstance(fk, str) and '.' in fk, (t['name'], f['name'], fk)
            assert fk.split('.')[0] in names, f'unknown FK target: {fk}'
print(f'contract OK - {len(m[\"tables\"])} tables, {total:,} records')
"

# 2. The DDL it will produce, without touching a database
python -c "
from src.database_manager import DatabaseManager
import json
db = DatabaseManager()
m = json.load(open('ecommerce_model.json', encoding='utf-8'))
for t in m['tables']:
    if t['name'] == 'shipments':   # <- your table
        print(db.generate_create_table_sql(t))
"
```

Then run the pipeline (see the `run-pipeline` skill) and finally update the table lists
in `docs/data-model.md` and the data-model table in `README.md`.
