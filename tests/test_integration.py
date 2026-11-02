"""
End-to-end integration, against a real database.

Replaces final_integration_test.py, which was a print-script with no assertions
that asserted (in prose) row counts of 1,575 against a model generating 100,400,
so it could never pass. Its actual purpose -- run the pipeline, check every
destination, check the database agrees -- is preserved here as real tests.

Every test is marked `db` and skips when no database is configured, so the
default offline suite stays green. Run them with:

    pytest -m db
"""

import json
import os
import subprocess
import sys

import pytest

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

pytestmark = pytest.mark.db


@pytest.fixture(scope="module")
def pipeline_run(tmp_path_factory, db_reachability):
    """
    Run the real pipeline once at small scale, against the real database.

    Scale 0.02 keeps it to ~2,000 rows, which exercises every code path --
    schema, all five sinks, constraint validation, sequence advancement,
    verification -- without a long wait.
    """
    reachable, reason = db_reachability
    if not reachable:
        pytest.skip(reason)

    export_dir = str(tmp_path_factory.mktemp("exports"))
    report = os.path.join(str(tmp_path_factory.mktemp("runs")), "report.json")

    completed = subprocess.run(
        [
            sys.executable, "data_pipeline.py", "run",
            "--model", "ecommerce_model.json",
            "--scale", "0.02",
            "--export-dir", export_dir,
            "--report", report,
            "--verify-writes",
        ],
        capture_output=True, text=True, cwd=REPO_ROOT, timeout=900,
    )
    assert completed.returncode == 0, (
        f"pipeline failed\nSTDOUT:\n{completed.stdout[-3000:]}\n"
        f"STDERR:\n{completed.stderr[-3000:]}"
    )
    with open(report, encoding="utf-8") as handle:
        return {"report": json.load(handle), "export_dir": export_dir}


# -- the run itself --------------------------------------------------------


def test_pipeline_reports_success(pipeline_run):
    report = pipeline_run["report"]
    assert report["status"] == "success"
    assert report["db_state"] == "loaded_constrained"
    assert not report["errors"]


def test_every_step_ran(pipeline_run):
    names = [step["name"] for step in pipeline_run["report"]["steps"]]
    for expected in ("schema", "generate", "output", "finalize"):
        assert expected in names
    assert all(s["status"] == "success" for s in pipeline_run["report"]["steps"])


def test_round_trips_were_measured_not_estimated(pipeline_run):
    """
    The instrumented cursor counts real round trips, which is what makes the
    before/after comparison credible.
    """
    totals = pipeline_run["report"]["totals"]
    assert totals["roundtrips_db"] > 0
    assert totals["rows_loaded"] > 0
    # The default strategy is COPY, so round trips must be far below row count.
    assert totals["roundtrips_db"] < totals["rows_loaded"], (
        "round trips should not scale with rows under a batched strategy"
    )


def test_rtt_was_probed(pipeline_run):
    rtt = pipeline_run["report"]["environment"].get("db_rtt_ms")
    assert rtt is not None and rtt > 0


# -- the destinations -----------------------------------------------------


def test_all_file_destinations_were_written(pipeline_run):
    export_dir = pipeline_run["export_dir"]
    for relative in ("csv/users.csv", "csv/reviews.csv", "json/products.json"):
        path = os.path.join(export_dir, relative)
        assert os.path.exists(path), f"missing {relative}"
        assert os.path.getsize(path) > 100, f"{relative} is suspiciously small"


def test_csv_row_counts_match_the_report(pipeline_run):
    import csv

    report = pipeline_run["report"]
    by_table = {t["table"]: t for t in report["tables"]}
    for table in ("users", "reviews"):
        path = os.path.join(pipeline_run["export_dir"], "csv", f"{table}.csv")
        with open(path, newline="", encoding="utf-8") as handle:
            rows = list(csv.DictReader(handle))
        assert len(rows) == by_table[table]["rows"]


def test_nullable_integers_are_not_written_as_floats(pipeline_run):
    """
    A single None in an integer column used to promote the whole column to
    float64, so a nullable foreign key was written as '1.0' instead of '1'.
    """
    import csv

    path = os.path.join(pipeline_run["export_dir"], "csv", "users.csv")
    with open(path, newline="", encoding="utf-8") as handle:
        rows = list(csv.DictReader(handle))
    for row in rows:
        for column in ("id",):
            assert "." not in row[column], (
                f"integer column {column} written as a float: {row[column]!r}"
            )


def test_json_destination_is_valid_json(pipeline_run):
    path = os.path.join(pipeline_run["export_dir"], "json", "products.json")
    with open(path, encoding="utf-8") as handle:
        rows = json.load(handle)
    assert isinstance(rows, list) and rows
    assert {"id", "sku", "name", "category_id", "price"} <= set(rows[0])


# -- the database agrees --------------------------------------------------


def test_database_row_counts_verified(pipeline_run):
    verification = pipeline_run["report"]["verification"]
    assert verification["row_counts_match"] is True
    for entry in verification["per_table"]:
        assert entry["ok"], (
            f"{entry['table']}: expected {entry['expected']}, "
            f"found {entry['actual']}"
        )


def test_foreign_key_constraints_validated_by_the_server(pipeline_run):
    """
    The project's central claim, proven by PostgreSQL rather than asserted.

    Constraints are added after the load, so the server validates every
    generated foreign key in one pass. If any failed to resolve, the constraint
    would have been refused and the pipeline would have failed.
    """
    verification = pipeline_run["report"]["verification"]
    assert verification["fk_constraints_added"] == 7
    assert verification["fk_violations"] == 0


def test_sequences_were_advanced_and_writes_work(pipeline_run):
    """
    Without the sequence fix the delivered database rejects the first
    application INSERT, because every SERIAL sequence is still at 1.
    """
    verification = pipeline_run["report"]["verification"]
    assert verification["sequences_advanced"] == 6
    assert verification["write_probe"] == "passed"


def test_cross_sink_referential_integrity_against_the_database(pipeline_run):
    """
    Check the claim from the other side: take foreign keys out of a CSV file and
    resolve them against rows in PostgreSQL.

    users lives in CSV, reviews lives in CSV, but reviews.user_id must resolve
    to a users row that the database holds.
    """
    import csv

    from src.db import connect

    path = os.path.join(pipeline_run["export_dir"], "csv", "reviews.csv")
    with open(path, newline="", encoding="utf-8") as handle:
        review_rows = list(csv.DictReader(handle))
    assert review_rows

    user_ids = {int(r["user_id"]) for r in review_rows if r["user_id"]}
    product_ids = {int(r["product_id"]) for r in review_rows if r["product_id"]}

    conn = connect()
    try:
        with conn.cursor() as cursor:
            cursor.execute(
                "SELECT id FROM users WHERE id = ANY(%s);", (list(user_ids),)
            )
            found_users = {row[0] for row in cursor.fetchall()}
            cursor.execute(
                "SELECT id FROM products WHERE id = ANY(%s);",
                (list(product_ids),),
            )
            found_products = {row[0] for row in cursor.fetchall()}
    finally:
        conn.close()

    assert user_ids == found_users, (
        f"{len(user_ids - found_users)} user_id values in the CSV have no row "
        "in PostgreSQL"
    )
    assert product_ids == found_products, (
        f"{len(product_ids - found_products)} product_id values in the CSV have "
        "no row in PostgreSQL"
    )


def test_semantic_relationships_hold_in_the_database(pipeline_run):
    """Verify the realism pass survived the round trip through PostgreSQL."""
    from src.db import connect

    conn = connect()
    try:
        with conn.cursor() as cursor:
            cursor.execute(
                """
                SELECT COUNT(*) FROM orders o
                JOIN users u ON u.id = o.user_id
                WHERE o.order_date < u.registration_date;
                """
            )
            assert cursor.fetchone()[0] == 0, "orders predate their user"

            cursor.execute(
                """
                SELECT COUNT(*) FROM (
                    SELECT o.id,
                           o.total_amount,
                           COALESCE(SUM(i.total_price), 0)
                             + o.tax_amount + o.shipping_cost AS expected
                    FROM orders o
                    LEFT JOIN order_items i ON i.order_id = o.id
                    GROUP BY o.id, o.total_amount, o.tax_amount, o.shipping_cost
                ) t
                WHERE ABS(t.total_amount - t.expected) > 0.01;
                """
            )
            assert cursor.fetchone()[0] == 0, "order totals do not reconcile"

            cursor.execute("SELECT COUNT(*) FROM products WHERE cost >= price;")
            assert cursor.fetchone()[0] == 0, "products priced at or below cost"
    finally:
        conn.close()


# -- export ---------------------------------------------------------------


def test_export_db_produces_a_restorable_dump(tmp_path, db_reachability):
    """
    The original dump could not be restored: DDL came from information_schema
    and so carried no lengths or keys while copying nextval defaults whose
    sequences had just been dropped, and values went through str() so every
    temporal column produced an unquoted literal and a syntax error.
    """
    reachable, reason = db_reachability
    if not reachable:
        pytest.skip(reason)

    output = str(tmp_path / "dump.sql")
    completed = subprocess.run(
        [sys.executable, "data_pipeline.py", "export-db", "--output", output],
        capture_output=True, text=True, cwd=REPO_ROOT, timeout=900,
    )
    assert completed.returncode == 0, completed.stdout[-2000:] + completed.stderr[-2000:]
    assert os.path.getsize(output) > 1000

    with open(output, encoding="utf-8") as handle:
        sql = handle.read()

    # Types must carry their width, which information_schema could not provide.
    assert "VARCHAR(" in sql
    assert "DECIMAL(" in sql
    # Keys and constraints must be present at all.
    assert "PRIMARY KEY" in sql
    assert "ADD CONSTRAINT" in sql
    assert "setval(" in sql
    # No nextval default may survive, since DROP ... CASCADE removed the sequence.
    assert "nextval(" not in sql
    # Temporal literals must be quoted.
    import re

    assert not re.search(r"VALUES \([^)]*[^']\b\d{4}-\d{2}-\d{2}\b[^']", sql), (
        "found an unquoted date literal"
    )


def test_export_db_works_with_only_database_url(tmp_path, db_reachability):
    """
    export-db used to require all five discrete DB_* variables while the dump
    routine beneath it preferred DATABASE_URL, so the single-URL config that
    Supabase hands you -- and that CLAUDE.md recommends -- made the subcommand
    fail even though the code under it would have worked.
    """
    reachable, reason = db_reachability
    if not reachable:
        pytest.skip(reason)
    if not os.getenv("DATABASE_URL"):
        pytest.skip("DATABASE_URL not set")

    env = {k: v for k, v in os.environ.items() if not k.startswith("DB_")}
    output = str(tmp_path / "url_only.sql")
    completed = subprocess.run(
        [sys.executable, "data_pipeline.py", "export-db", "--output", output],
        capture_output=True, text=True, cwd=REPO_ROOT, env=env, timeout=900,
    )
    assert completed.returncode == 0, completed.stdout[-1500:] + completed.stderr[-1500:]
    assert os.path.getsize(output) > 1000


# -- the API against the real database ------------------------------------


def test_api_serves_from_the_database(db_reachability):
    reachable, reason = db_reachability
    if not reachable:
        pytest.skip(reason)

    from fastapi.testclient import TestClient

    import api_server

    app = api_server.create_app(
        model_file=os.path.join(REPO_ROOT, "ecommerce_model.json"), offline=False
    )
    with TestClient(app) as client:
        assert client.get("/health").json()["backend"] == "postgresql"

        listing = client.get("/orders", params={"limit": 5}).json()
        assert listing["total_count"] > 0
        assert len(listing["orders"]) <= 5

        first = listing["orders"][0]["id"]
        assert client.get(f"/orders/{first}").json()["id"] == first

        # The fixes, against a real backend.
        assert client.get("/orders/99999999").status_code == 404
        assert client.get("/orders", params={"status": "nope"}).status_code == 422
        assert client.get("/orders", params={"user_id": 0}).json()["total_count"] == 0

        summary = client.get("/orders/stats/summary").json()
        assert summary["total_orders"] == listing["total_count"]
