---
name: run-pipeline
description: Run the full data pipeline end to end (schema, generate, export) and verify the results. Use when asked to run the pipeline, regenerate data, repopulate the database, or check that the pipeline still works.
---

# Run the data pipeline

Running this writes ~85,000 rows to a live cloud PostgreSQL database and overwrites
every file in `exports/`. It is destructive — `create_schema` **drops every table**
before recreating it, and `handle_postgresql_output` runs `DELETE FROM <table>` before
inserting. Confirm with the user before starting unless they clearly just asked for it.

## 1. Preflight

```bash
python -c "import psycopg2, faker, fastapi, uvicorn, click, pandas, dotenv; print('deps ok')"
```

If this fails, dependencies are missing: `pip install -r requirements.txt`. All ten
are pinned to versions verified working.

Then confirm config exists:

```bash
test -f .env && echo ".env present" || echo "MISSING - copy example.env and fill it in"
```

`.env` is gitignored and must never be committed. Do not print its contents.

## 2. Choose the model

`ecommerce_model.json` is the only model on this branch (6 tables, 100,400 records).
`loan_mgmt_model.json` exists only on `origin/loan_mgmt` — see `docs/branches.md`.

## 3. Run

```bash
python data_pipeline.py --model ecommerce_model.json --env .env
```

This takes a while. The row-by-row insert path means ~85,000 sequential round trips to
the database; minutes, not seconds. Do not assume it has hung.

Watch for:
- `No data available for foreign key reference to ...` → the dependency graph is wrong,
  and the run is silently inserting the literal `1` as a foreign key.
- `UnicodeEncodeError` from a `logging` call → a `cp1252` console choking on an emoji in
  a log string, not a real failure. See `docs/known-issues.md`.
- `Circular dependency detected` → the model has a cycle the sort had to break arbitrarily.

## 4. Verify the file outputs

```bash
ls -l exports/csv/users.csv exports/csv/reviews.csv exports/json/products.json
```

Expect roughly 10,000 / 15,000 / 20,000 records respectively. Check the row counts, not
just that the files exist:

```bash
python -c "
import csv, json
for p, n in [('exports/csv/users.csv', 10000), ('exports/csv/reviews.csv', 15000)]:
    with open(p, newline='', encoding='utf-8') as f:
        got = sum(1 for _ in csv.reader(f)) - 1
    print(f'{p}: {got} rows (expected {n})', 'OK' if got == n else 'MISMATCH')
got = len(json.load(open('exports/json/products.json', encoding='utf-8')))
print(f'exports/json/products.json: {got} (expected 20000)', 'OK' if got == 20000 else 'MISMATCH')
"
```

These paths are read-denied in `.claude/settings.json`, so count them with a script as
above rather than reading them.

## 5. Verify the database

Expected counts: `categories` 400, `users` 10,000, `products` 20,000, `orders` 15,000,
`order_items` 40,000. `reviews` goes to CSV only and should **not** be in PostgreSQL.

```bash
python -c "
from src.database_manager import DatabaseManager
db = DatabaseManager('.env')
db.connect()
for t, exp in [('categories',400),('users',10000),('products',20000),('orders',15000),('order_items',40000)]:
    db.cursor.execute(f'SELECT COUNT(*) FROM {t};')
    got = db.cursor.fetchone()[0]
    print(f'{t}: {got} (expected {exp})', 'OK' if got == exp else 'MISMATCH')
db.disconnect()
"
```

## 6. Optional — SQL dump and API

```bash
python data_pipeline.py export-db --env .env --output exports/database_dump.sql
```

Known bug: this fails with `Missing database connection parameters` if `.env` has only
`DATABASE_URL` set. Populate the five `DB_*` vars as well, or fix the guard at
`data_pipeline.py:168`.

```bash
python api_server.py --model ecommerce_model.json --env .env --port 8000
# then, separately:
curl "http://localhost:8000/health"
curl "http://localhost:8000/orders?limit=5"
curl "http://localhost:8000/orders/stats/summary"
```

The server must already be running before `test_api_server.py` or
`final_integration_test.py` will do anything useful — they are print-scripts with no
assertions, not a test suite.
