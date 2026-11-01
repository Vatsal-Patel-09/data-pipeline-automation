# Architecture

## The call path

One command drives everything. `python data_pipeline.py --model ecommerce_model.json
--env .env` with no subcommand falls through to `run_pipeline`, which runs four steps
in order (`data_pipeline.py`, `DataPipeline.run_complete_pipeline`):

```
DataPipeline.__init__                      load .env, construct the three components
  │
  ├─ 1. DatabaseManager.create_schema      src/database_manager.py:227
  │        drop all tables (reverse order), CREATE TABLE in dependency order,
  │        then ALTER TABLE ... ADD CONSTRAINT for every foreign key.
  │        Wrapped in one transaction; rolls back on any failure.
  │
  ├─ 2. DataGenerator.generate_all_data    src/data_generator.py:343
  │        topologically order the tables, then generate `sample_size` records each,
  │        keeping every generated row in memory so later tables can point at
  │        real primary keys.
  │
  ├─ 3. OutputHandler.process_all_outputs  src/output_handlers.py:229
  │        the two-phase write described below.
  │
  └─ 4. DataPipeline.generate_summary_report
           prints counts and destinations, derived from the generated data.
```

Everything downstream is driven by the model JSON. There is no hardcoded table list
anywhere in the live code.

## The interesting part: cross-format referential integrity

The project's actual contribution is making foreign keys work when the parent and
child rows live in *different* destinations. `orders` is served from PostgreSQL but
`orders.user_id` must reference `users`, whose primary destination is a CSV file.
A CSV file cannot enforce anything, and PostgreSQL cannot reference a row it has
never seen.

The answer is a **dual-destination strategy**, implemented as two phases in
`process_all_outputs` (`src/output_handlers.py:229`):

**Phase 1 — PostgreSQL, dependencies first.**
`find_postgresql_dependencies` (`:89`) computes the closure of tables that must exist
in PostgreSQL: every table whose `output_format` is `postgresql` or `api`, *plus* every
table any of those reference through a `foreign_key`. That set is then ordered by
`get_postgresql_insertion_order` (`:289`) and written with `handle_postgresql_output`
(`:114`). A failure here aborts the run — continuing would violate FK constraints on
every dependent table.

**Phase 2 — primary destinations.**
Each table is then written to the destination its model declares:
`handle_csv_output` (`:158`) → `exports/csv/<table>.csv` via pandas,
`handle_json_output` (`:192`) → `exports/json/<table>.json`.
Tables already handled in Phase 1 are skipped. A failure here is logged and the loop
continues, since file outputs are independent of each other.

So `users` is written **twice**: to `exports/csv/users.csv` as its declared destination,
and to the `users` table in PostgreSQL so that `orders.user_id` has something real to
point at. Same for `products` and `order_items.product_id`.

`handle_api_output` (`:222`) is a thin alias for the PostgreSQL path — "serve via API"
just means "put it in PostgreSQL where `api_server.py` can read it". There is no
separate API-side store.

## Ordering

Tables must be created before they are referenced, and parent rows must exist before
child rows. The code solves this with a topological sort — implemented
**three separate times**, once per module:

| Location | Used for |
|---|---|
| `src/database_manager.py:187` `get_table_dependency_order` | CREATE TABLE order |
| `src/data_generator.py:268` `get_table_generation_order` | record generation order |
| `src/output_handlers.py:289` `get_postgresql_insertion_order` | INSERT order |

All three are the same algorithm: repeatedly take the tables whose dependencies are
already satisfied; if none qualify, break the cycle by picking an arbitrary remaining
table. Self-references (`categories.parent_id → categories.id`) are excluded from the
graph and handled during generation instead.

This is real duplication and a sensible thing to consolidate. It is **documented, not
refactored**, because the three copies have already diverged: `data_generator` and
`output_handlers` both sort `ready_tables` for deterministic ordering and log a warning
when they break a cycle, while `database_manager` does neither. Unifying them would
change CREATE TABLE ordering, so it is a behaviour change rather than a tidy-up.

## Database access

Four independent places open their own connection and read the environment themselves:

- `DatabaseManager.connect` (`src/database_manager.py:37`)
- `OutputHandler.connect_db` (`src/output_handlers.py:31`)
- `DatabaseConnection.get_connection` (`api_server.py:34`, a context manager)
- `DataPipeline.generate_sql_dump` (`data_pipeline.py`, inline)

Each supports `DATABASE_URL` or the five `DB_*` variables, with slightly different
precedence rules. Expect to touch all four if you change how configuration is read.
There is no connection pooling despite the README's claim.

## The API layer

`api_server.py` is deliberately narrow: it serves the `orders` table only, with
pagination (`skip` / `limit`), optional `status` and `user_id` filters, a by-id lookup,
and an aggregate at `/orders/stats/summary`. Responses are shaped by the Pydantic
models `OrderResponse` and `OrderListResponse`, which are **hand-written to match the
ecommerce model** — they are not generated from the model JSON. Change the `orders`
table and you must change those classes by hand.

`APIConfig` loads the model file at startup and exposes `get_orders_table_config`, but
nothing in the request path currently uses it.
