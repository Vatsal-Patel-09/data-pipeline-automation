# Branch map

**`master` is not the whole project.** A third of the real work lives on an unmerged
branch with a different domain model. Read this before assuming the repo you see is
the repo there is.

Only `master` exists locally; the others are remote-only on
`https://github.com/Vatsal-Patel-09/data-pipeline-automation`.

## `master` — current

The ecommerce pipeline: 6 tables, 100,400 records, `ecommerce_model.json`,
`api_server.py` serving `/orders`.

This is the branch to work on. Its history was rewritten on 2026-11-01 — see
"Removed material" below.

## `origin/vatsal` — stale, superseded

Diverged at `537677a`. Identical to `master` except that it never received the three
unrelated files `master` picked up afterwards — so once those are removed from
`master`, this branch is a strict subset of it.

Nothing of value is here that is not on `master`. Treat it as a dead development
branch; it does not need merging.

## `origin/loan_mgmt` — unmerged, different domain, has real work

Diverged at `9d8fda8` (2025-08-11), three commits ahead:
`11716e6 new task` → `dcc815b Loan managment done` → `b3d1b8b deleted usesless data`.

This is **the same engine pointed at an entirely different domain**: Indian
loan-management / NBFC collections. It is not a refactor of the ecommerce branch,
it is a parallel application of it.

### What it adds

**`loan_mgmt_model.json`** — 14 tables (versus 6 on master):

| Table | `sample_size` | `output_format` |
|---|---|---|
| `loan_products` | 20 | json |
| `customers` | 200 | csv |
| `cibil_reports` | 200 | postgres |
| `loan_applications` | 250 | postgres |
| `loan_accounts` | 300 | postgres |
| `payment_schedules` | 1,000 | postgres |
| `transactions` | 1,000 | **api** |
| `collection_agents` | 50 | postgres |
| `collections` | 200 | postgres |
| `charges` | 150 | postgres |
| `write_offs` | 200 | postgres |
| `customer_notes` | 400 | csv |
| `agent_performance` | 50 | postgres |
| `system_audit_log` | 500 | postgres |

**`api_server.py`** rewritten: `OrderResponse` → `TransactionResponse` plus a new
`LoanAccountResponse`; `/orders` → `/transactions` and `/loan-accounts`; filters
become `loan_account_id`, `payment_mode`, `transaction_status`. Also de-emojified,
which `master`'s copy still is not.

**`src/data_generator.py`** — +89/−44 lines of domain logic that **`master` does not
have**, and this is the part actually worth salvaging:

- loan-type vocabulary (`personal`, `business`, `vehicle`, `mortgage`, `salaried`,
  `overdraft`)
- `cibil_score` constrained to the real 300–900 range
- `loan_amount` handling
- `generate_foreign_key_value` gains a `field_config` parameter, giving FK generation
  access to the field's own configuration — a genuine signature improvement over
  `master`'s version

It also **deletes** `exports/csv/reviews.csv` and `exports/csv/users.csv` (84,510 lines
of committed generated data) and adds its own `exports/loan_database_dump.sql`.

### Status

**Unmerged, and intentionally left that way** (decision taken 2026-11-01). The
generator improvements above are stranded on this branch. If the loan domain becomes
the active direction, or if someone wants the `field_config` improvement on `master`,
start here:

```bash
git diff origin/master origin/loan_mgmt -- src/data_generator.py
```

Do not merge it casually — it rewrites `api_server.py` around a different schema, so a
naive merge produces a server that queries tables the ecommerce model does not define.

## Recovering deleted files

`src/initial_db_manager.py` was deleted on the `ai-dev-ready` work. It exists in
history on all three branches:

```bash
git show origin/master:src/initial_db_manager.py
```

It is a superseded draft built against an incompatible model shape. Recover it for
reference only — do not reintroduce its conventions. See `CLAUDE.md`.

## Removed material

**`master`'s history was rewritten on 2026-11-01.** Three commits were dropped, each
of which had added exactly one file belonging to an unrelated data-integration
product: a zipped Flask/Airflow backend, a Salesforce connector design PDF, and a
status note about them. They were committed on 2025-08-22 and 2025-08-23, twelve days
after the pipeline work itself finished on 2025-08-11, and the status note referenced
frontend files that never existed in this repository.

Nothing of the pipeline was lost. Each of those three commits changed one file and
nothing else, so `master` now reads:

```
537677a  Merge pull request #6 ...     <- last real pipeline commit
   |
   +-- AI development context layer
   +-- archive removal + verified doc corrections
```

If you are looking for that other product, it is not here and was never meant to be.
Do not restore it: the removal was deliberate and requested.

### If you find a stale reference
`origin/vatsal` and `origin/loan_mgmt` never contained these files, so they are
unaffected. Old clones made before the rewrite will still have the three commits;
re-clone rather than merging from one, or you will reintroduce the files.
