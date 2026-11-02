# CLAUDE.md

## What this is

A **BDA (Big Data Analytics) sem-7 college project**. It reads a JSON data
model, generates realistic synthetic records, and fans them out to five
destinations — PostgreSQL (Supabase), CSV, JSON, Parquet and a FastAPI endpoint
— while preserving foreign-key integrity *across* those destinations.

The thesis, stated in full in `docs/why-synthetic-data.md`: the engineering that
matters only becomes visible at scale, the data that exhibits scale is held by
organisations that will not release it, so understanding of scale is gated by
employment. This project makes volume a parameter so that gate goes away.

It is a coursework demonstrator, **not** a production ELT tool. Scope decisions
should be read in that light: correctness, measurement and clarity matter;
horizontal multi-node scale does not.

> **Naming:** a rename is pending and deliberately not yet applied, so nothing
> downstream blocks on it. The current strings say "data pipeline". When a name
> is chosen it is a find-replace over `README.md:1`, `data_pipeline.py` and
> `api_server.py`.

## The files

| Path | Status |
|---|---|
| `data_pipeline.py` | **Live** — CLI entrypoint and orchestrator |
| `api_server.py` | **Live** — FastAPI server over the `orders` table |
| `src/model_graph.py` | **Live** — the one model loader, FK parser and topological sort |
| `src/data_generator.py` | **Live** — record generation |
| `src/realism.py` | **Live** — post-generation semantic repair |
| `src/output_handlers.py` | **Live** — multi-destination writes |
| `src/database_manager.py` | **Live** — model JSON → DDL, plus post-load finalisation |
| `src/load_strategies.py` | **Live** — rowwise / execute_values / copy |
| `src/serialization.py` | **Live** — per-sink value conversion |
| `src/db.py` | **Live** — connection config, instrumented cursor, host diagnosis |
| `src/metrics.py` | **Live** — run metrics and the run report |
| `ecommerce_model.json` | **Live** — the data model that drives everything |
| `tests/` | **Live** — real pytest suite, 149 offline + 16 db-marked |
| `runs/headline/` | **Live** — committed benchmark evidence and its harnesses |
| `exports/`, `runs/*.json` | Generated output. Untracked. Never hand-edit |

Deleted on this branch, recoverable from git history:

- `src/initial_db_manager.py` — a superseded draft built against an
  **incompatible** model shape.
- `final_integration_test.py`, `test_api_server.py`, `test_data_generator.py`,
  `test_db_connection.py` — assertion-free print-scripts. One asserted row
  counts of 1,575 against a model generating 100,400, so it could never pass;
  another was collected by pytest and "passed" green on a connection error.
  Their purpose now lives in `tests/test_integration.py` with real assertions.

## The model-JSON contract

Every live module agrees on this shape. `src/model_graph.py` is the single
implementation; do not re-parse the model anywhere else.

```json
{
  "database": { "name": "ecommerce_platform", "version": "1.0" },
  "tables": [
    {
      "name": "products",
      "sample_size": 20000,
      "output_format": "json",
      "fields": [
        { "name": "id", "type": "integer", "primary_key": true, "auto_increment": true },
        { "name": "category_id", "type": "integer", "foreign_key": "categories.id" },
        { "name": "price", "type": "decimal", "precision": 10, "scale": 2 }
      ]
    }
  ]
}
```

Non-negotiable points, because an earlier draft got each of them wrong:

- `tables` is a **list**, not a dict keyed by name.
- `fields` is a **list** of field objects, not a dict keyed by field name.
- `foreign_key` is a **string**, either `"table.field"` or the shorthand
  `"table"` (which defaults the field to `id`). Both resolve identically
  everywhere; `output_handlers` used to silently ignore the shorthand, which
  produced a valid constraint with no parent in the load set.
- `output_format` is one of `postgres` | `postgresql` | `csv` | `json` |
  `parquet` | `api`. Normalised in `src/model_graph.normalize_output_format`.
  An unrecognised value now **raises** rather than silently defaulting to
  PostgreSQL.
- `sample_size` defaults to 100 when absent.
- Field `type` is one of `string`, `text`, `integer`, `bigint`, `smallint`,
  `decimal`, `numeric`, `float`, `double`, `real`, `boolean`, `date`,
  `timestamp`, `timestamptz`, `time`, `json`, `jsonb`, `uuid`, `enum`. An
  unknown type **raises**; it used to produce a `TEXT` column full of the
  literal string `"sample_<type>"`.
- `unique` and `foreign_key` on the same field is **invalid** and reported by
  `validate()`: FK values are drawn with replacement, so uniqueness cannot hold.

Check any model without touching a database:

```bash
python data_pipeline.py validate --model ecommerce_model.json
```

## Commands

```bash
# Full pipeline: schema -> generate -> all destinations -> verify
python data_pipeline.py run --model ecommerce_model.json --env .env

# Plan only. No generation, no writes, no database. Sub-second.
python data_pipeline.py --dry-run

# Everything except the network: renders DDL and COPY payloads to exports/
python data_pipeline.py --offline

# Fast iteration: 1% of every table's sample_size
python data_pipeline.py run --scale 0.01

# Load-strategy comparison
python data_pipeline.py run --load-strategy rowwise          # one round trip per row
python data_pipeline.py run --load-strategy execute_values --page-size 1000
python data_pipeline.py run --load-strategy copy             # default

# Restorable SQL dump (pure Python, no pg_dump needed)
python data_pipeline.py export-db --output exports/database_dump.sql

# API server; interactive docs at /docs
python api_server.py --model ecommerce_model.json --env .env --port 8000
python api_server.py --offline      # serves exports/api/orders.json, no database

# Tests
python -m pytest              # offline only; db-marked tests skip
python -m pytest -m db        # requires a reachable database
```

Only `run` and `export-db` need a reachable PostgreSQL instance. `--dry-run`,
`--offline`, `validate` and the default test suite do not.

## Conventions

- **No emoji in log strings.** Windows consoles using the `cp1252` code page
  raise `UnicodeEncodeError` on them, and several original occurrences were on
  *error* paths, so a real failure could be replaced by an encoding error. All
  live modules are currently clean — keep them that way.
- **Config comes from the environment** via `python-dotenv`, resolved in exactly
  one place (`src/db.resolve_db_config`). `DATABASE_URL` wins; the five `DB_*`
  vars are the fallback. There used to be four independent resolvers with two
  different precedence orders, so a config carrying both forms could create the
  schema in one database and insert rows into another. Never hardcode
  credentials, never commit `.env`.
- **Supabase connection note.** The direct host `db.<ref>.supabase.co` publishes
  only an AAAA record, so it needs IPv6. On a network without an IPv6 route, use
  the Supavisor session pooler on **port 5432** — not 6543, which is transaction
  mode and does not persist session-level `SET`, making COPY unreliable and any
  session-tuning measurement meaningless. `src/db.diagnose_unreachable_host`
  explains this at the point of failure.
- **Parameterise SQL values** with `%s` placeholders. Identifiers are composed
  with `psycopg2.sql.Identifier`; never let user input reach an identifier
  position.
- **Field names drive data quality.** The generator infers values from the field
  name, and `src/realism.py` infers *relationships* the same way: a field named
  `cost` is kept below one named `price`, a `total_amount` is reconciled against
  child `total_price` values, a `created_at` is ordered after its parent's. This
  is what keeps the project declarative — a new domain is a JSON file, not a
  code change. Name a field badly and you get junk data. See `docs/data-model.md`.
- **Determinism contract.** Identical `(engine, seed, model_hash)` produces
  identical output; a *different* engine produces statistically equivalent
  output, not identical output. All three appear in `run_report.json`'s config so
  incomparable runs are never compared.

  This replaces the previous claim that generation was reproducible because of
  `Faker.seed(42)`. It was not: date fields were anchored to the wall clock, so
  five of six tables produced different data on every run. Dates are now
  anchored to `DataGenerator.DEFAULT_REFERENCE_DATE`.
- **Benchmarks must be uncontended.** Run each configuration in its own
  subprocess, strictly sequentially, with nothing else executing, and repeat at
  least twice. A contended run once inflated a reported baseline by about 2x and
  had to be retracted. Use the harnesses in `runs/headline/`.
- Generated artefacts belong in `exports/` (gitignored). Run reports go to
  `runs/`, which is also gitignored except `runs/headline/`, where benchmark
  evidence is committed deliberately.

## Going deeper

| Document | When to read it |
|---|---|
| `docs/why-synthetic-data.md` | The thesis: why the project exists |
| `docs/performance.md` | Every measurement, with method and before/after tables |
| `docs/architecture.md` | Changing the pipeline flow or output routing |
| `docs/data-model.md` | Adding or editing tables and fields |
| `docs/branches.md` | Before assuming `master` is the whole project |
| `docs/known-issues.md` | Before reporting a bug as new |
