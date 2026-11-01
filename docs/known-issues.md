# Known issues

Found while mapping the repo (2025-11-01) and deliberately **not fixed** — the cleanup
pass was scoped to removing misleading material, not changing behaviour. Recorded here
so they are visible rather than rediscovered. None of these is a regression; all predate
the context work.

## Bugs

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

### Four dependencies are unpinned
`psycopg2-binary`, `faker`, `fastapi` and `uvicorn` are not installed in the
development environment, so they were left unpinned rather than pinned to a guess.
Pin them from `pip freeze` once a working venv exists. The other six are pinned.

### `api_server.py` response models are hand-written
`OrderResponse` and `OrderListResponse` are maintained by hand against the `orders`
table rather than generated from the model JSON. `APIConfig` loads the model and
exposes `get_orders_table_config`, but no endpoint uses it. Change `orders` in the
model and the API will drift silently until something 500s.

### Repo history carries ~57 MB of generated data
`exports/` and `log.txt` are untracked as of the `ai-dev-ready` branch, but the old
blobs remain in history: `exports/database_dump.sql` at 34 MB,
`exports/json/products.json` at 14 MB, `exports/csv/reviews.csv` at 7 MB. Clearing
them requires rewriting history (`git filter-repo`), which was explicitly left alone.
`.git` is ~15 MB compressed.
