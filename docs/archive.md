# Archive — out of scope

Three tracked files on `master` have **nothing to do with the BDA data pipeline**.
They belong to a different, unrelated product. They are documented here so nobody
wastes a context window working out what they are, and so nobody mistakes them for
part of the project.

| File | Size | What it is |
|---|---|---|
| `backend.zip` | 114 KB | A separate ELT platform. 66 entries |
| `report.txt` | 3.4 KB | A status note about that platform's Salesforce connector |
| `Salesforce_Connector_Architecture_Overview.pdf` | 106 KB | Design doc for the same |

**Do not read, extract, search, or modify these when working on the pipeline.**
`.claude/settings.json` has read-deny rules on `backend.zip` and `*.pdf` to keep them
out of context by accident.

## What is actually inside `backend.zip`

A Flask-based SaaS data-integration backend — the kind of thing the BDA project
*simulates* with Faker, except real. Structure:

```
backend/
  server.py                      Flask API, a CONNECTOR_REGISTRY, and generic
                                 /api/<connector>/{connect,validate,fetch-data,schema}
                                 endpoints
  log_manager.py
  Dockerfile                     python:3.9-slim, exposes 5000
  requirements.txt               Flask 2.1.3, sling 1.3.4, simple-salesforce,
                                 boto3, pymongo, PyYAML
  extractors/
    base/       api_connector.py, storage_manager.py, base_storage_manager.py
    connectors/ salesforce, google_ads, ga4, meta_ads, google_sheets  (implemented)
                hubspot (docstring only), zoho (empty file)
    extractors/ base_extractor.py, salesforce_extractor.py
    storage/    local_storage.py, s3_storage.py
    tests/      test_salesforce_extraction.py
  airflow/
    dags/       autonmis_dag_generator.py (25 KB), dynamic parent DAGs,
                edge_function_parent_dag.py, Repayment_Performance_DAG.py,
                salesforce_dag_soap.py
    config/     airflow.cfg (108 KB)
  sling/        app.py, sling_executor.py, job_monitor.py
  docker/       docker-compose.yaml, docker-compose.yml, Dockerfile
```

So: API connectors for five live SaaS sources, S3 and local storage backends, Airflow
orchestration with a dynamic DAG generator, and Sling for the actual data movement.
Internal naming suggests a product called "autonmis".

Checked and worth noting: the only `.env` in the archive
(`backend/airflow-backend/.env`) contains a single harmless line
(`_PIP_ADDITIONAL_REQUIREMENTS="requests boto3"`). **No credentials are leaked** by this
zip. That was verified rather than assumed, so nobody needs to re-check.

## What `report.txt` is about

A progress note on the Salesforce connector in that backend — OAuth flow, extraction
engine, S3 storage, Airflow integration — written as "85% complete". It references
frontend files **that do not exist in this repository**:

- `dbconnection.tsx`
- `route.ts`

Those live in a separate (presumably Next.js) frontend repo. The three open issues it
lists — an OAuth popup pointing at a non-existent `/oauthVerify` page, test-connection
logic that checks cookies before OAuth completes, and untidy environment variables —
are all problems in **that** codebase, not this one.

## Why they are here at all

Committed to `master` in its final three commits (`be86123 test file`,
`69907c0 New file`, `4597f86 added final backend`, 2025-08-23) — twelve days after the
pipeline work finished on 2025-08-11. They look like an unrelated file drop into a
convenient repo, not a change of project direction. `origin/vatsal` is the same branch
without them.

They are left in place rather than deleted: removing them would not shrink `.git`
(the blobs stay in history regardless) and deleting someone's only committed copy of
another project's backend is not a call to make while tidying documentation.
