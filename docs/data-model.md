# The data model

The model JSON is the whole interface. A new domain is a new model file, not a
code change — that claim is the project's main design constraint, so everything
here is driven by data in the file or by field *names*, never by hardcoded table
names.

Validate any model without touching a database:

```bash
python data_pipeline.py validate --model your_model.json
```

## Shape

```json
{
  "database": { "name": "ecommerce_platform", "version": "1.0" },
  "tables": [
    {
      "name": "products",
      "sample_size": 20000,
      "output_format": "json",
      "description": "Optional. Documentation only.",
      "fields": [
        { "name": "id", "type": "integer", "primary_key": true, "auto_increment": true },
        { "name": "sku", "type": "string", "max_length": 50, "unique": true },
        { "name": "category_id", "type": "integer", "foreign_key": "categories.id" },
        { "name": "price", "type": "decimal", "precision": 10, "scale": 2 },
        { "name": "weight", "type": "decimal", "precision": 8, "scale": 3, "nullable": true },
        { "name": "status", "type": "enum", "values": ["draft", "live"] }
      ]
    }
  ]
}
```

`tables` is a **list**. `fields` is a **list**. Neither is a dict keyed by name.
An earlier draft of this project used dicts and the two shapes are not
interchangeable.

### Table keys

| Key | Required | Meaning |
|---|---|---|
| `name` | yes | Table name. Becomes the SQL identifier and the filename. |
| `fields` | yes | List of field objects. |
| `sample_size` | no | Rows to generate. Defaults to 100. Multiplied by `--scale`. |
| `output_format` | no | Destination. Defaults to `postgresql`. |
| `description` | no | Documentation only. |

### Field keys

| Key | Applies to | Meaning |
|---|---|---|
| `name` | all | Field name. Also **drives the generated values** — see below. |
| `type` | all | One of the types in the next section. |
| `primary_key` | all | Marks the primary key. Exactly one per table. |
| `auto_increment` | integer PKs | Emits `SERIAL` / `BIGSERIAL`. |
| `foreign_key` | all | `"table.field"`, or `"table"` to default the field to `id`. |
| `nullable` | all | Allows NULL. Default `true` in the DDL. |
| `unique` | all | Emits `UNIQUE` and enforces uniqueness during generation. |
| `max_length` | string | Emits `VARCHAR(n)` and truncates generated values. |
| `precision`, `scale` | decimal | Emits `DECIMAL(p,s)` and rounds to `s` places. |
| `values` | enum | Allowed values. Emits a `CHECK` constraint. |
| `default` | all | SQL default. Strings are quoted and escaped. |

### Types

| Model type | PostgreSQL | Notes |
|---|---|---|
| `string` | `VARCHAR(n)` | `n` from `max_length`, else unbounded |
| `text` | `TEXT` | Multi-sentence generated prose |
| `integer` | `INTEGER` / `SERIAL` | `SERIAL` when `auto_increment` |
| `bigint` | `BIGINT` / `BIGSERIAL` | |
| `smallint` | `SMALLINT` / `SMALLSERIAL` | |
| `decimal`, `numeric` | `DECIMAL(p,s)` | Generated as `Decimal`, never float |
| `float`, `double` | `DOUBLE PRECISION` | |
| `real` | `REAL` | |
| `boolean` | `BOOLEAN` | |
| `date` | `DATE` | |
| `timestamp` | `TIMESTAMP` | |
| `timestamptz` | `TIMESTAMP WITH TIME ZONE` | |
| `time` | `TIME` | |
| `json`, `jsonb` | `JSONB` | Generated as a Python dict |
| `uuid` | `UUID` | |
| `enum` | `VARCHAR(n)` + `CHECK` | `n` sized to the longest value |

An unknown type **raises**. It used to produce a `TEXT` column filled with the
literal string `"sample_<type>"` — a plausible-looking column full of junk, with
no warning anywhere.

### Destinations

| `output_format` | Where rows go |
|---|---|
| `postgres`, `postgresql` | PostgreSQL |
| `csv` | `exports/csv/<table>.csv` |
| `json` | `exports/json/<table>.json` |
| `parquet` | `exports/parquet/<table>.parquet` |
| `api` | PostgreSQL, served at `GET /<table>` |

A table also goes to PostgreSQL — *in addition* to its declared destination —
whenever any PostgreSQL-backed table references it. Otherwise the child's
foreign key would have no parent row. See
[architecture.md](architecture.md#destination-routing).

An unrecognised value **raises** rather than silently defaulting to PostgreSQL.

## Field names drive data quality

This is the mechanism that keeps the project declarative. Two layers read field
names: the generator picks *values*, and the semantic pass infers
*relationships*.

### Values, from `src/data_generator.py`

| Field name contains | Generated value |
|---|---|
| `email` | An email address |
| `phone` | A phone number |
| `address` (string) | A postal address |
| `address` (json) | `{street, city, state, zip_code, country}` |
| `full` + `name` | A person's name |
| `user` + `name` | A username |
| `company` + `name` | A company name |
| `name` (exactly), or `category` | A composed taxonomy name |
| `description` | A sentence or two |
| `sku` | `SKU-<8 digits>` |
| `order_number` | `ORD-<10 digits>` |
| `payment` | One of four payment methods |
| `rating` | 1–5 |
| `quantity` | 1–10 |
| `stock` | 0–1000 |
| `price`, `cost` | 1.00–999.99 |
| `total`, `amount` | 10.00–5000.00 |
| `tax` | 0.50–500.00 |
| `shipping` | 0.00–50.00 |
| `discount` | 0.00–100.00 |
| `weight` | 0.1–50.0 |
| anything else (string) | A single random word |

### Relationships, from `src/realism.py`

These run after generation, across tables, and are what make the data coherent
rather than merely type-correct.

| Rule | Triggered by | Effect |
|---|---|---|
| Adult ages | name contains `birth`, `dob`, `born` | 18–80 years before the reference date, and never dragged forward by causality |
| Causal ordering | any FK edge where both tables have an event date | child date ≥ every parent's date, applied in topological order so it holds transitively |
| Unit price from product | child has `unit_price`, parent has `price` | line price derives from the product's list price |
| Line totals | `quantity` + `unit_price` + `total_price` | `total = quantity × unit_price − discount`, and a discount can never exceed the line |
| Parent totals | parent has `total_amount`, child has `total_price` | parent total = sum of children + any `tax`/`shipping`/`freight`/`handling` it declares |
| Rollups | parent has `total_spent`, `lifetime_value` or `total_revenue` | equals the sum of that parent's children's totals |
| Margin | table has both `price` and `cost` | cost is 40–80% of price, so margin is never negative |
| Composed names | table has `name` (not unique) and an FK to a table with `name` | name composed from the parent's, rather than reusing it |

An event date is a field whose name contains `created`, `registration`,
`registered`, `joined`, `signup`, `order_date`, `placed`, `updated`, `modified`,
`shipped` or `delivered`.

Name a field badly and you get junk. Name it well and you get relationships for
free. Measurements for all of this are in
[performance.md](performance.md#data-realism).

## Adding a table

1. **Append to `tables`.** Order in the file does not matter; the creation order
   is derived from the foreign keys.
2. **Give it a primary key.** Usually `{"name": "id", "type": "integer",
   "primary_key": true, "auto_increment": true}`.
3. **Name fields for the values you want.** Consult the tables above rather than
   inventing names.
4. **Declare foreign keys as strings.** `"foreign_key": "parent.id"`.
5. **Pick an `output_format`.** Remember a referenced table is loaded into
   PostgreSQL regardless of what it declares.
6. **Validate**, then dry-run, then run small:

```bash
python data_pipeline.py validate --model ecommerce_model.json
python data_pipeline.py --dry-run
python data_pipeline.py run --scale 0.01
python -m pytest
```

### Things `validate` will catch

- `tables` or `fields` given as a dict instead of a list
- a missing or duplicated primary key
- a foreign key naming a table or field the model does not define
- `unique` and `foreign_key` on the same field — unsatisfiable, because FK
  values are drawn with replacement, yet the DDL would still emit `UNIQUE`
- an unknown `type` or `output_format`
- a circular foreign-key dependency, reported with its members

### Things to watch that `validate` cannot catch

- **A `unique` field needs enough vocabulary.** `categories.name` is unique with
  400 rows; a flat 30-item word list cannot supply 400 distinct values, so the
  uniqueness fallback appended a counter and roughly 370 of 400 names ended up
  as `Electronics_7`. If you mark a name-like field unique, make sure the
  generator has combinatorial room.
- **The API server only serves `orders`.** Declaring a second `api` table loads
  it into PostgreSQL but no endpoint exposes it.
- **`reviews` is a leaf.** Nothing references it, so it is created in PostgreSQL
  but only written to CSV. If you add a table referencing it, it joins the
  closure and starts being loaded.

## The shipped model

`ecommerce_model.json` — 6 tables, 49 fields, 100,400 rows at `--scale 1`.

| Table | Rows | Declared | Also in PostgreSQL | Fields |
|---|---|---|---|---|
| `categories` | 400 | postgres | — | 6 |
| `users` | 10,000 | csv | yes | 9 |
| `products` | 20,000 | json | yes | 11 |
| `orders` | 15,000 | api | yes | 10 |
| `order_items` | 40,000 | postgres | — | 7 |
| `reviews` | 15,000 | csv | no (leaf) | 6 |

85,400 of the 100,400 rows reach PostgreSQL.

```
categories.parent_id   -> categories.id   (self-referencing, nullable)
products.category_id   -> categories.id
orders.user_id         -> users.id
order_items.order_id   -> orders.id
order_items.product_id -> products.id
reviews.product_id     -> products.id
reviews.user_id        -> users.id
```

A second, unmerged model exists on the `loan_mgmt` branch — 14 tables of Indian
NBFC loan collections, the same engine pointed at a different domain. It is
described in [branches.md](branches.md) and is **not** merged; note it contains
three contract violations this project's `validate` would now reject.
