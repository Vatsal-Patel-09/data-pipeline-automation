"""
Shared fixtures.

Note on what is deliberately absent: there is no fixture that reaches a
database. Tests that need one are marked `db` and skip themselves when no
configuration is present, so the default `pytest` run is fully offline. That is
the opposite of the four print-scripts at the repo root, which cannot run at all
without a live PostgreSQL instance and a server on port 8000.
"""

import hashlib
import json
import os
import sys

import pytest

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if REPO_ROOT not in sys.path:
    sys.path.insert(0, REPO_ROOT)

FIXTURES = os.path.join(REPO_ROOT, "tests", "fixtures")

# Fields whose values are intentionally not compared against a golden, because
# they are anchored to a reference date that the model does not pin.
TEMPORAL_TYPES = ("date", "timestamp")


@pytest.fixture(scope="session")
def tiny_model_path():
    """Path to the small fixture model used for golden and invariant tests."""
    return os.path.join(FIXTURES, "tiny_model.json")


@pytest.fixture(scope="session")
def tiny_model(tiny_model_path):
    with open(tiny_model_path, encoding="utf-8") as handle:
        return json.load(handle)


@pytest.fixture(scope="session")
def shipped_model_path():
    """The real model the project ships with."""
    return os.path.join(REPO_ROOT, "ecommerce_model.json")


@pytest.fixture(scope="session")
def shipped_model(shipped_model_path):
    with open(shipped_model_path, encoding="utf-8") as handle:
        return json.load(handle)


def canonical_hash(records):
    """Stable hash over a list of record dicts, independent of key order."""
    blob = json.dumps(records, sort_keys=True, default=str, ensure_ascii=True)
    return hashlib.sha256(blob.encode("utf-8")).hexdigest()


def field_types(model, table_name):
    """Map field name to declared type for one table."""
    for table in model["tables"]:
        if table["name"] == table_name:
            return {f["name"]: f["type"] for f in table["fields"]}
    raise KeyError(table_name)


@pytest.fixture(scope="session")
def db_available():
    """True when a database target is configured."""
    from src.db import resolve_db_config

    return resolve_db_config().available


@pytest.fixture
def require_db(db_available):
    if not db_available:
        pytest.skip("no database configured (set DATABASE_URL or the DB_* vars)")
