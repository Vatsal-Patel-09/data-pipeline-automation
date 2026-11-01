# CLAUDE.md

## What this is

A **BDA (Big Data Analytics) sem-7 college project**. It reads a JSON data model,
generates realistic synthetic records with Faker, and fans them out to four
destinations — PostgreSQL (Supabase), CSV, JSON and a FastAPI endpoint — while
preserving foreign-key integrity *across* those destinations.

It is a coursework demonstrator, **not** a production ELT tool. Scope decisions
should be read in that light: correctness and clarity matter, horizontal scale does not.

## The files

Every tracked file is part of the pipeline. Material belonging to an unrelated
product was removed from this repo entirely, so there is no longer anything here to
steer around.

| Path | Status |
|---|---|
| `data_pipeline.py` | **Live** — CLI entrypoint and orchestrator |
| `api_server.py` | **Live** — FastAPI server over the `orders` table |
| `src/database_manager.py` | **Live** — model JSON → schema DDL |
| `src/data_generator.py` | **Live** — Faker-based record generation |
| `src/output_handlers.py` | **Live** — multi-destination writes |
| `ecommerce_model.json` | **Live** — the data model that drives everything |
| `test_*.py`, `final_integration_test.py` | Manual print-scripts, **not** a pytest suite |
| `exports/`, `log.txt` | Generated output. Untracked. Never hand-edit |

`src/initial_db_manager.py` was deleted on this branch. It was a superseded draft of
`src/database_manager.py` built against an **incompatible** model shape, and it misled
anyone who read it first. Recover it from git history if you ever need it.

## The model-JSON contract

Every live module agrees on this shape. Follow it exactly.

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
- `foreign_key` is a **string** of the form `"table.field"`, not an object.
- `output_format` is one of `postgres` | `postgresql` | `csv` | `json` | `api`.
  Both `postgres` and `postgresql` are accepted and normalised in
  `DataGenerator.get_output_format`.
- `sample_size` defaults to 100 when absent.

## Commands

```bash
# Full pipeline: schema -> generate -> write all destinations
python data_pipeline.py --model ecommerce_model.json --env .env

# Dump the database to SQL (pure Python, no pg_dump needed)
python data_pipeline.py export-db --env .env --output exports/database_dump.sql

# API server; interactive docs at /docs
python api_server.py --model ecommerce_model.json --env .env --port 8000
```

All three need a populated `.env` (copy `example.env`) and a reachable PostgreSQL
instance. There is no offline or dry-run mode.

## Conventions

- **No emoji in log strings.** Windows consoles using the `cp1252` code page raise
  `UnicodeEncodeError` on them. `data_pipeline.py` was rewritten once for exactly
  this reason. Some emoji still survive in `src/database_manager.py` and
  `src/output_handlers.py` — do not add more, and prefer removing them when you
  touch a nearby line.
- **Config comes from the environment** via `python-dotenv`. `DATABASE_URL` is the
  preferred form; the five `DB_HOST` / `DB_PORT` / `DB_NAME` / `DB_USER` /
  `DB_PASSWORD` vars are the fallback. Never hardcode credentials, never commit `.env`.
- **Parameterise SQL values** with `%s` placeholders. Table and column *identifiers*
  are interpolated (they come from the trusted local model file) — keep it that way
  and never let user input reach an identifier position.
- **Field names drive data quality.** The generator infers realistic values from the
  field name: a field containing `email` gets an email, `price` gets a currency-shaped
  decimal, `rating` gets 1–5. Naming a field badly produces junk data. See
  `docs/data-model.md`.
- Generation is seeded (`Faker.seed(42)`, `random.seed(42)`) so record generation is
  reproducible. Schema creation order is **not** — see `docs/known-issues.md`.
- **The generated data is structurally sound but not semantically realistic.** Foreign
  keys are always valid (verified), but dates have no causal ordering, order totals do
  not reconcile with their line items, and `users.birth_date` yields infants. Know this
  before presenting the output as realistic. Details and measurements in
  `docs/known-issues.md`.
- Generated artefacts belong in `exports/`, which is gitignored. Do not commit them.

## Going deeper

| Document | When to read it |
|---|---|
| `docs/architecture.md` | Changing the pipeline flow or output routing |
| `docs/data-model.md` | Adding or editing tables and fields |
| `docs/branches.md` | Before assuming `master` is the whole project |
| `docs/known-issues.md` | Before reporting a bug as new |
