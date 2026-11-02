# Known issues

Three sections: what was **fixed** (with the measurement that proves it), what
is **still open**, and what was **deliberately declined**.

The register exists because an earlier pass through this repo found that the
README claimed capabilities the code did not have. Keeping a measured, honest
defect list is more useful than a feature list, and the fixed section below is
effectively the project's results.

Every figure here was produced by a harness committed in `runs/headline/`, run
uncontended and repeated. See [performance.md](performance.md) for method.

---

## Fixed

### Performance

**1. Foreign-key resolution was accidentally quadratic.** `generate_foreign_key_value`
rebuilt the entire candidate parent-id list on every single field call, for a
result that is invariant per `(table, field)`. For the shipped model that is
roughly 2.0 billion dictionary probes per run.

Memoized. This is behaviour-preserving rather than merely equivalent: tables are
generated in topological order, so the parent list is complete and immutable
before any child reads it, which means the cached list is the identical list in
the identical order and `random.choice` consumes the identical RNG draw.
Verified byte-identical on all six tables, all 49 fields.

| table | rows | before | after | speedup |
|---|---|---|---|---|
| `order_items` | 40,000 | 62.93s | 0.41s | **151.6x** |
| `reviews` | 15,000 | 24.24s | 1.74s | 13.9x |
| `orders` | 15,000 | 8.30s | 2.09s | 4.0x |
| `products` | 20,000 | 3.08s | 2.65s | 1.2x |
| `users` | 10,000 | 2.62s | 2.60s | 1.0x |
| `categories` | 400 | 0.07s | 0.05s | 1.4x |
| **total** | **100,400** | **101.24s** | **10.06s** | **10.1x** |

The speedup tracks rows x parent-rows, and the three tables with no meaningful
foreign-key load are flat — which is the signature of the right fix rather than
a lucky one.

**2. The PostgreSQL load issued one network round trip per row.** ~85,400
sequential round trips for the shipped model. Replaced by three interchangeable
strategies (`rowwise`, `execute_values`, `copy`) so the comparison is measurable
rather than asserted. Measurements in [performance.md](performance.md#load-strategies).

**3. All DDL was sent one statement at a time.** 6 drops + 6 creates + 7
constraint additions, each its own round trip. Now a single multi-statement
execute: 19 round trips become 1.

**4. Foreign key constraints existed during the bulk load,** so every inserted
row paid index probes against its parents. Constraint creation moved to after
the load. Beyond the speed, this makes PostgreSQL itself prove cross-destination
referential integrity in one sequential pass.

**5. The API opened a fresh connection per request** — a TCP and TLS handshake
on every call, which for a small response is the dominant cost. Now a
`ThreadedConnectionPool`.

**6. Three redundant full-dataset copies** were built during output. One was
provably a no-op (its conversions were already performed by the JSON encoder
immediately afterwards) and was removed byte-identically.

### Correctness

**7. The documented reproducibility guarantee was false.** The project claimed
generation was reproducible because of `Faker.seed(42)` and `random.seed(42)`.
Date fields were anchored to the wall clock (`'-2y'` to `'today'`), so a seeded
run picked the same offset from a different origin.

Measured before the fix: **five of six tables produced different data on every
run**, and the only stable table was precisely the one with no temporal field.
Varying `PYTHONHASHSEED` across 0–4 gave the same result, ruling out hash
ordering. Dates are now anchored to a fixed reference date; reproducible across
six runs spanning six hash seeds.

**8. `GET /orders/<missing>` returned 500, not 404.** The connection context
manager wrapped its own `yield` in `except Exception`, so the `HTTPException(404)`
raised inside the `with` body was caught and re-raised as "Database connection
failed". The same bug reported every genuine SQL error as a connection problem,
destroying diagnosability of every endpoint.

**9. A failing output destination was swallowed, then the run reported success
with exit code 0.** Losing 35,000 CSV rows to a full disk while announcing
success is the worst available outcome for anything scripted. Failures are now
collected and re-raised, and the run report records them.

**10. Sequences were never advanced after inserting explicit primary keys,** so
every `SERIAL` sequence sat at 1 and the delivered database rejected the first
application-level `INSERT` with a duplicate-key error. Fixed with `setval` using
`COALESCE(max, 0) + 1, false`, which also handles the empty-table case — real
here, because `reviews` is created and never loaded. A `--verify-writes` probe
proves it.

**11. The SQL dump could not be restored,** for two independent reasons. DDL was
reconstructed from `information_schema.columns.data_type`, which carries no
length or precision, so `VARCHAR(50)` became `CHARACTER VARYING` and
`DECIMAL(12,2)` became `NUMERIC`; no primary keys, unique constraints, foreign
keys or enum checks were emitted at all, while `column_default` was copied
verbatim, so a `DEFAULT nextval(...)` survived even though `DROP TABLE CASCADE`
had just destroyed the sequence. Separately, values went through `str()`, so
every temporal column produced an unquoted literal and a syntax error. DDL now
comes from the model and psycopg2 quotes the values; a test asserts the output
contains typed columns, real keys and no orphaned `nextval`.

**12. `export-db` rejected a `DATABASE_URL`-only configuration** — exactly the
config Supabase hands you and the docs recommend — while the dump routine it
called preferred `DATABASE_URL`. The guard was wrong, not the code beneath it.

**13. Four independent connection resolvers with two different precedence
orders.** A config carrying both `DATABASE_URL` and the five `DB_*` variables
could create the schema in one database and insert rows into another. One
resolver now, `DATABASE_URL` wins consistently, and an incomplete config is
reported rather than falling through to libpq defaults and connecting to some
unintended local database.

**14. Schema creation order was not reproducible.** An unsorted set iteration
meant the order varied with `PYTHONHASHSEED`. All three topological sorts
consolidated into one that breaks ties by name.

**15. The PostgreSQL closure was not transitive.** Foreign keys were expanded
only one level from the seed set, so a dependency of a dependency was silently
omitted from the load plan. Combined with issue 16 this is a *latent hard
failure*: a real constraint is created with valid values whose parent table was
never loaded. Pinned by a test as a provable no-op on the shipped model, where
the one-level result happened to already be complete.

**16. The documented bare-table `foreign_key` shorthand was silently ignored by
one module.** `"categories"` was honoured by the generator and the DDL but
skipped by the output handler. One shared parser now.

**17. `Decimal` was downcast to `float` before insert** — slower *and* lossier
than psycopg2's native adapter. Visible on any column whose scale is not 2, such
as `products.weight` at scale 3.

**18. Nullable integers were written to CSV as `1.0`.** A single `None` promotes
a pandas integer column to float64. Now pandas' nullable `Int64`.

**19. `/health` returned a hardcoded timestamp** (`"2025-08-02T00:00:00Z"`), so
a healthy response was indistinguishable from a stale one, defeating the purpose
of the endpoint.

**20. The `status` filter was unvalidated.** A typo returned an empty list with
HTTP 200, reading as "no such orders" rather than "bad request". The allowed
values now come from the model's enum declaration, and an invalid one is a 422.

**21. `if user_id:` silently discarded `user_id=0`,** returning every order
instead of none.

**22. Two bare `except:` clauses** around `json.loads` also swallowed
`KeyboardInterrupt` and `SystemExit`, and made malformed JSONB indistinguishable
from an empty address.

**23. An unknown field type produced a `TEXT` column full of the literal string
`"sample_<type>"`,** with no warning. Now raises, and the type map is wider, so
a declared `bigint` no longer becomes `TEXT` and break its own foreign key.

**24. 35 emoji in log strings across four modules,** several on *error* paths,
so a `cp1252` Windows console could replace a real failure with a
`UnicodeEncodeError`. All live modules are now clean.

**25. `handle_api_output` was dead code.** Defined, documented in the
architecture notes as the API path, and never called. Now actually routed, which
also gives the offline API sink a home.

**26. `psycopg2.sql.Composed.as_string()` rejected the instrumented cursor**
because it type-checks at the C level, so attribute delegation could not help.
Found only by running against a live database.

**27. `export-db` could not re-encode JSONB.** Columns come back from psycopg2
as Python dicts, which have no SQL adapter. Also found only against a live
database.

### Data realism

The generator produced structurally sound and semantically absurd data. All
figures at full scale, 100,400 records.

| metric | before | after |
|---|---|---|
| `users.birth_date` implied age | 0.0–2.0 years | 18.0–79.99 years |
| users under 18 | 10,000 / 10,000 | 0 / 10,000 |
| orders placed before the user registered | 49.8% (7,467) | 0% |
| reviews written before the product existed | 49.9% (7,479) | 0% |
| line totals != qty x price − discount | 100% (40,000) | 0% |
| order totals != sum of line items | 100% (13,969) | 0% |
| `users.total_spent` != order history | 100% (10,000) | 0% |
| `unit_price` unrelated to the product's price | 58.4% (23,368) | 0% |
| products priced at or below cost | 50.0% (9,992) | 0% |
| category names using the `_N` fallback | ~370 / 400 | 0 / 400 |
| distinct product names | 30 / 20,000 | 20,000 / 20,000 |

Four of these were previously recorded here. Three were not: line totals were
*also* 100% wrong, `unit_price` bore no relationship to the product being bought
(which makes any total arithmetic over noise), and half of all products were
priced at or below cost.

The `30 / 20,000` figure is measured against the unmodified generator at the
branch point (`runs/headline/realism-original-code.json`), so the later
vocabulary fix does not contaminate it.

### Testing

**28. The four `test_*.py` files were not tests.** No assertions, all required a
live database, one required a server already listening on port 8000.
`final_integration_test.py` asserted row counts of 1,575 against a model
generating 100,400, so its final phase failed unconditionally.
`test_api_server.py` was named so pytest collected it and it "passed" green by
printing a connection-error message — worse than failing. There was no CI and no
`pytest` dependency.

Replaced by 165 real tests (149 offline, 16 db-marked). The most important is
`test_every_foreign_key_resolves_to_a_real_parent`, which converts the project's
central claim from prose into a checked invariant, and its integration
counterpart that resolves foreign keys taken from a CSV file against rows in
PostgreSQL.

---

## Still open

**A0. A declared table can be created in PostgreSQL and never loaded.** A table
whose `output_format` is a file sink, and which no PostgreSQL-backed table
references, falls outside the load closure. The schema creates it; nothing fills
it. On `ecommerce_model.json` that is `reviews`: its rows are written to
`exports/csv/reviews.csv` and the table sits empty in the database.

This is the intended routing, but it used to be invisible. The summary counted
the rows under a single generated total, and `verify_row_counts` only checked
the tables it had loaded, so a run could report `row_counts_match: True` with an
empty table in the database. Reported now: the run warns per table, the summary
prints rows-into-PostgreSQL against rows-generated, and `run_report.json`
carries `verification.tables_not_loaded`. Pass `--load-all` to materialise every
declared table instead.



**A. The API server only serves `orders`.** Response models are hand-written, so
declaring a second `api` table loads it into PostgreSQL but exposes no endpoint.
The status enum is now model-driven, but the response shape is not.

**B. Parallel loading is implemented but unproven.** `--parallel-loads N` exists
and defaults to 1. The hypothesis is that it is roughly flat, because once rows
are batched the work is bandwidth-bound and splitting one uplink N ways does not
create bandwidth. Measuring it is pending; a flat result is the expected finding,
not a failure.

**C. The vectorized and GPU generation engines are not built.** The engine
abstraction was planned for a scalability curve to 10M rows and a measured
CPU/GPU crossover. Current status: generation is a single row-at-a-time engine.
The honest expectation, recorded before building it, is that a GPU path is
*slower* at this project's scale — the first CuPy call initialises the CUDA
context in 0.5–2s, which exceeds the entire CPU cost of every numeric column in
the model, and the real remaining cost is string work that CuPy cannot touch.

**D. There is still no CI.** The suite is real and runs locally; nothing runs it
automatically.

**E. `max_length` can still be exceeded by the uniqueness fallback,** which
appends `_<counter>` *after* truncation. Now unreachable for the shipped model,
because the taxonomy vocabulary is large enough that the fallback never
triggers, but the ordering is still wrong in principle.

**F. Repository history carries ~57 MB of generated data** in pre-2026-11-01
commits. See the declined section below.

---

## Deliberately declined

**Purging the large blobs from git history.** `exports/database_dump.sql` (34 MB),
`exports/json/products.json` (14 MB) and `exports/csv/reviews.csv` (7 MB) sit in
old commits and account for essentially all of the packed `.git`. A purge was
considered and declined: `master`, `origin/vatsal` and `origin/loan_mgmt` each
carry the same blobs, so rewriting `master` alone shrinks nothing, and an
effective purge means a three-branch rewrite plus three force-pushes that would
renumber every commit on the unmerged `loan_mgmt` work. **Do not propose this
again as a new idea.**

**A SQLite fallback for offline mode.** No `COPY`, no `execute_values`, and
`SERIAL` / `JSONB` / `DECIMAL(p,s)` / `ALTER TABLE ADD CONSTRAINT` are
unsupported or no-ops, so it would require a second schema generator and a
second load path to test a path that is never shipped. Worse, foreign-key
enforcement is off by default, so it could not validate the one claim the
project rests on, while measuring local disk instead of a real network. Offline
mode renders DDL and COPY payloads to files instead.

**`UNLOGGED` tables during load.** `SET LOGGED` rewrites the table and writes
back all the WAL the load avoided, so the net saving is small and server-side
rather than network-side. It also conflicts with Supabase replication.

**Streaming the JSON sink.** `products.json` is ~14 MB and takes a couple of
seconds — not a bottleneck — and streaming would change the `indent=2`
formatting of an artefact that gets submitted.

**Migrating to psycopg3.** Nicer `COPY` support, but it touches every connection
path and buys nothing measurable here.

**Merging the `loan_mgmt` branch.** It rewrites `api_server.py` around a
different schema, so a naive merge produces a server querying tables the
ecommerce model does not define. It also contains three contract violations this
project's `validate` would now reject. See [branches.md](branches.md).
