# Known issues

Found while mapping the repo (2026-11-01) and deliberately **not fixed** — the cleanup
pass was scoped to removing misleading material, not changing behaviour. Recorded here
so they are visible rather than rediscovered. None of these is a regression; all predate
the context work.

All findings below the first heading were **confirmed by executing the pipeline**
(generation and file output run without a database; the API was exercised through
FastAPI's `TestClient` against a stubbed connection), not by reading the code.

## Data realism — the generated data is less correct than the README claims

### `date` and `timestamp` ignore the field name
Every other type (`string`, `integer`, `decimal`, `json`) pattern-matches the field
name to pick a realistic value. `date` and `timestamp` do not
(`src/data_generator.py:109-112`): they always return
`date_between('-2y', 'today')` and `date_time_between('-1y', 'now')`.

Measured consequence: `users.birth_date` produces implied ages of **0.1 to 2.0 years**.
Every user in the dataset is an infant.

Affected fields: `users.birth_date`, `users.registration_date`, `categories.created_at`,
`products.created_at`, `orders.order_date`, `reviews.created_at`.

### No causal ordering between dates
Because each date is drawn independently, nothing enforces that related events happen
in a sensible sequence. Measured on a 150-order sample: **57% of orders were placed
before the user who placed them registered.** The same applies to reviews predating the
orders they review.

The README's "proper date sequences" claim has been corrected.

### Order totals are not reconciled with their line items
`orders.total_amount`, `tax_amount` and `shipping_cost` are generated independently of
the `order_items` rows that reference the order. Measured: **138 of 138 orders** whose
line-item `total_price` values do not sum to the order's `total_amount`. Not most —
all of them.

The README claimed "Order totals mathematically consistent with line items". That claim
was false and has been removed. Fixing it means a post-generation reconciliation pass
over `order_items` grouped by `order_id`.

### `products.name` draws from the category list
`generate_string_value` treats a field named exactly `name` as a category name
(`src/data_generator.py:134-144`). `products.name` is exactly that, so all 20,000
products are named from a hardcoded 30-item category list. Measured on a 200-product
sample: **30 distinct names**, every one a category ("Fiction", "Tablets",
"Home & Garden"). Renaming the column to `product_name` would not help either — it
would fall through to a single random word. Realistic product names need a new branch
in `generate_string_value`.

## Bugs

### Schema creation order is not reproducible
`DatabaseManager.get_table_dependency_order` (`src/database_manager.py:187`) iterates a
`set` without sorting, so CREATE TABLE order follows randomised string hash order.
Verified: five `PYTHONHASHSEED` values produce five different orders. All are valid
topological orders, so nothing breaks — but it undercuts the project's reproducibility
story, which `Faker.seed(42)` otherwise delivers. One `ready_tables.sort()` fixes it.
See `docs/architecture.md`.

### `/health` reports a frozen timestamp
`api_server.py:132` returns the string literal `"2025-08-02T00:00:00Z"` as the health
check's timestamp. It never changes, so the endpoint cannot be used to tell a live
server from a stale cached response. Should be `datetime.now(timezone.utc).isoformat()`.

### The `status` filter is not validated
`/orders?status=` takes an unconstrained `Optional[str]` (`api_server.py:142`) rather
than the model's enum (`pending`, `processing`, `shipped`, `delivered`, `cancelled`).
A typo returns an empty result set with HTTP 200 instead of a 422. The `orders` table
does carry a `CHECK` constraint on the column, so only the API surface is loose.

### `export-db` rejects a `DATABASE_URL`-only config
`data_pipeline.py:168` — `export_database` guards on
`all([db_host, db_name, db_user, db_password])` and raises
`ValueError("Missing database connection parameters")` if any is missing. But
`generate_sql_dump`, called immediately after, prefers `DATABASE_URL` and only falls
back to the individual vars. So a `.env` containing just `DATABASE_URL` — the form
`CLAUDE.md` recommends, and the form Supabase hands you — makes `export-db` fail even
though the code underneath it would have worked.

Fix would be to accept either shape in the guard, matching `generate_sql_dump`.

### Row-by-row inserts at 100k scale
`src/output_handlers.py:142-144` — `handle_postgresql_output` loops over records calling
`cursor.execute` once each. The ecommerce model generates 100,400 records, of which
~85,400 go to PostgreSQL across `categories`, `users`, `products`, `orders` and
`order_items`. That is ~85,000 individual round trips to a cloud database.

The README claims "Batch Processing: Database insertions in configurable batches" and
"Connection Pooling: Reused database connections". Neither exists in the code.

Fix would be `psycopg2.extras.execute_values` with a batch size, which is a
few lines and a large speedup.

### Emoji in log strings will crash Windows consoles
`data_pipeline.py` was rewritten once specifically to strip emoji, because Windows
consoles on the `cp1252` code page raise `UnicodeEncodeError` when `logging` tries to
write them. That rewrite missed the `src/` modules:

- `src/database_manager.py` — 4 occurrences (e.g. `:257`, `:264`, `:268`, `:273`)
- `src/output_handlers.py` — 9 occurrences

A run that reaches schema creation on such a console can still fail on a log line
rather than on anything real. `api_server.py` has the same exposure.

See the no-emoji convention in `CLAUDE.md`.

## Rough edges

### Identifiers interpolated into SQL
`generate_sql_dump` (`data_pipeline.py`) and `handle_postgresql_output`
(`src/output_handlers.py`) build SQL with f-string interpolation of table and column
names. **Not currently exploitable** — those identifiers come from the trusted local
model JSON, and all *values* are properly parameterised with `%s`. Worth knowing if the
model file ever becomes user-supplied, in which case `psycopg2.sql.Identifier` is the
right tool.

### Four independent connection paths
`DatabaseManager.connect`, `OutputHandler.connect_db`,
`DatabaseConnection.get_connection` and `DataPipeline.generate_sql_dump` each read the
environment and open their own connection, with slightly different `DATABASE_URL`
precedence. Changing configuration handling means touching all four.
See `docs/architecture.md`.

### Topological sort implemented three times
Once per module, with the copies already diverged. See `docs/architecture.md`.

### The `test_*.py` files are not tests
`test_api_server.py`, `test_data_generator.py`, `test_db_connection.py` and
`final_integration_test.py` are manual print-based scripts. They have no assertions,
require a live database and (for the API ones) a server already running on
`localhost:8000`, and `pytest` would collect them and then fail on connection errors.
There is no CI. Treat "the tests pass" as meaningless in this repo until a real suite
exists.

### `api_server.py` response models are hand-written
`OrderResponse` and `OrderListResponse` are maintained by hand against the `orders`
table rather than generated from the model JSON. `APIConfig` loads the model and
exposes `get_orders_table_config`, but no endpoint uses it. Change `orders` in the
model and the API will drift silently until something 500s.

### Repo history carries ~57 MB of generated data
`exports/` and `log.txt` are gitignored and no longer tracked, but their old blobs
remain in pre-2026-11-01 commits: `exports/database_dump.sql` at 34 MB,
`exports/json/products.json` at 14 MB, `exports/csv/reviews.csv` at 7 MB. That is
essentially all of the ~15 MB packed `.git`.

Clearing it was considered on 2026-11-01 and **deliberately declined**. The reason is
measurable: `master`, `origin/vatsal` and `origin/loan_mgmt` each carry the same
~57 MB of export blobs, so a `git filter-repo` purge of `master` alone shrinks nothing
— the blobs stay reachable through the other two. An effective purge means rewriting
all three branches and force-pushing all three, which would renumber every commit on
the unmerged `loan_mgmt` work. Not worth 14 MB on a college project.

Verify the claim yourself rather than trusting this paragraph:

```bash
for ref in master origin/vatsal origin/loan_mgmt; do
  echo "=== $ref ==="
  git rev-list --objects "$ref" \
    | git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' \
    | awk '$1=="blob" && $3>100000 {s+=$3} END {printf "  %.1f MB in blobs >100KB\n", s/1048576}'
done
```

Do not propose the purge again as a new idea. If it is ever wanted, it is a
three-branch rewrite, not a `master` cleanup.
