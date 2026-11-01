# Data model

## The contract

The model file is the single source of truth for the whole pipeline. Three modules
parse it independently (`database_manager`, `data_generator`, `output_handlers`), so
the shape below is load-bearing in all three.

```json
{
  "database": { "name": "ecommerce_platform", "version": "1.0" },
  "tables": [
    {
      "name": "order_items",
      "sample_size": 40000,
      "output_format": "postgres",
      "fields": [
        { "name": "id",         "type": "integer", "primary_key": true, "auto_increment": true },
        { "name": "order_id",   "type": "integer", "foreign_key": "orders.id", "nullable": false },
        { "name": "product_id", "type": "integer", "foreign_key": "products.id" },
        { "name": "quantity",   "type": "integer" },
        { "name": "unit_price", "type": "decimal", "precision": 10, "scale": 2 }
      ]
    }
  ]
}
```

### Table keys

| Key | Required | Notes |
|---|---|---|
| `name` | yes | Used verbatim as the SQL table name and the export filename |
| `fields` | yes | A **list** of field objects |
| `sample_size` | no | Records to generate. Defaults to `100` (`src/data_generator.py:31`) |
| `output_format` | no | Defaults to `postgresql` |

`output_format` accepts `postgres`, `postgresql`, `csv`, `json`, `api`. `postgres` and
`postgresql` are normalised to the same thing in `DataGenerator.get_output_format`
(`src/data_generator.py:33`); an unrecognised value silently falls back to `postgresql`.

### Field keys

| Key | Applies to | Effect |
|---|---|---|
| `name` | all | SQL column name, **and the generator's main realism signal** |
| `type` | all | `string`, `integer`, `decimal`, `boolean`, `date`, `timestamp`, `text`, `json`, `enum` |
| `primary_key` | all | Adds `PRIMARY KEY` |
| `auto_increment` | integer PKs | Emits `SERIAL PRIMARY KEY` and counts up during generation |
| `foreign_key` | all | **String** `"table.field"`. Drives schema DDL, ordering *and* value selection |
| `nullable` | all | Defaults to `true`. `false` emits `NOT NULL` |
| `unique` | all | Emits `UNIQUE`; generation retries up to 100 times for a distinct value |
| `default` | all | Literal, or the bare token `CURRENT_TIMESTAMP` |
| `max_length` | string | Becomes `VARCHAR(n)` and truncates generated values |
| `precision` / `scale` | decimal | Becomes `DECIMAL(p,s)`. Default `10,2` |
| `values` | enum | Becomes `VARCHAR(maxlen)` plus a `CHECK (... IN (...))` constraint |

Type mapping lives in `DatabaseManager.get_postgres_type` (`src/database_manager.py:73`).
Anything unrecognised becomes `TEXT`.

## Field naming drives data quality

This is the least obvious thing about the codebase and the easiest to get wrong.
The generator does not read a "faker provider" key — **it pattern-matches the field
name** to decide what a realistic value looks like.

`generate_string_value` (`src/data_generator.py:122`) checks the lowercased field name for
substrings, in this order:

| Name contains | Produces |
|---|---|
| `full` + `name` | a person's name |
| `user` + `name` | a username |
| `company` + `name` | a company name |
| `category`, or the name is exactly `name` | a value from a hardcoded 30-item category list |
| any other `name` | a single capitalised word |
| `email` | an email address |
| `phone` | a phone number |
| `address` | a street address |
| `description` | prose, capped at 200 chars |
| `sku` | `SKU-########` |
| `order_number` | `ORD-##########` |
| `payment` | one of `credit_card`, `debit_card`, `paypal`, `bank_transfer` |
| *anything else* | a single random word |

`generate_integer_value` (`:170`) matches `rating` → 1–5, `quantity` → 1–10,
`stock` → 0–1000, else 1–10 000.

`generate_decimal_value` (`:181`) matches `price`/`cost` → 1.00–999.99,
`total`/`amount` → 10–5000, `tax` → 0.50–500, `shipping` → 0–50,
`discount` → 0–100, `weight` → 0.1–50, else 1–1000.

`generate_json_value` (`:211`) matches `address` → a structured address object,
else a generic `{field, value}` pair.

**Practical consequence:** name a currency column `amount_paid` and you get a plausible
monetary value; name it `paid_val` and you get a random float in 1–1000. Name a column
`name` in a non-category table and you get category names like "Electronics". Check the
tables above before choosing a column name.

## Foreign key values

`generate_foreign_key_value` (`src/data_generator.py:231`) picks a *real* primary key from
the already-generated parent table, which is why generation order matters. Three cases:

- **Self-reference** (`categories.parent_id → categories.id`): 30% chance of `NULL`
  (a root node), otherwise a random id from the rows generated so far in this table.
- **Nullable FK**: 10% chance of `NULL`.
- **Parent not yet generated**: falls back to `NULL` if nullable, otherwise logs a
  warning and uses the literal `1`. If you see that warning, your dependency graph is
  wrong.

## The ecommerce model as shipped

`ecommerce_model.json`, 6 tables, **100,400 records** total.

| Table | `sample_size` | `output_format` | Also written to PG? | References |
|---|---|---|---|---|
| `categories` | 400 | `postgres` | — | `categories.id` (self, `parent_id`) |
| `users` | 10,000 | `csv` | **yes** — `orders.user_id` needs it | — |
| `products` | 20,000 | `json` | **yes** — `order_items.product_id` needs it | `categories.id` |
| `orders` | 15,000 | `api` | yes (API means PG) | `users.id` |
| `order_items` | 40,000 | `postgres` | — | `orders.id`, `products.id` |
| `reviews` | 15,000 | `csv` | — | `products.id`, `users.id` |

Generation order, **verified by running it**, is:

```
categories -> users -> orders -> products -> order_items -> reviews
```

Note `orders` comes *before* `products`. Both become eligible in the same round once
`categories` and `users` are done, and the tie is broken alphabetically by
`ready_tables.sort()`. This is correct — `orders` only depends on `users` — but it is
not the intuitive "parents before everything" order, so do not assume it.

Note that `reviews` goes to CSV only and is referenced by nothing, so it never lands in
PostgreSQL — its `product_id` and `user_id` columns are plain integers in a CSV file
that happen to match real PostgreSQL primary keys. That cross-format match is the whole
point of the project; see `docs/architecture.md`.

## Adding a table

Use the `add-table` skill (`.claude/skills/add-table/`), or follow it manually:

1. Append a table object to the `tables` list. Keep `fields` a list.
2. Pick `output_format`. If any PostgreSQL-or-API table will reference your table,
   it gets written to PostgreSQL too, automatically — you do not declare that.
3. Name fields so the generator infers good values (see the tables above).
4. Write `foreign_key` as `"parent_table.id"`, never as an object.
5. If the model is the ecommerce one and you touched `orders`, update the Pydantic
   models in `api_server.py` by hand — they are not generated.
6. Update the table above and the README's data-model table.
