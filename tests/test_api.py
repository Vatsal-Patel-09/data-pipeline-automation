"""
API behaviour, exercised with no database at all.

That this file can exist is itself one of the fixes. Previously the server
called sys-exiting code before uvicorn started if no database was reachable, and
docs/known-issues.md recorded that testing the API required stubbing a
connection. Serving from the generated JSON file makes the endpoints testable
directly, and makes an offline demo possible.
"""

import json
import os

import pytest
from fastapi.testclient import TestClient

from api_server import API_TABLE, APIConfig, create_app
from src.data_generator import DataGenerator
from src.output_handlers import OutputHandler


@pytest.fixture(scope="module")
def offline_export(tmp_path_factory, tiny_model, tiny_model_path):
    """Generate a dataset and write the offline API payload."""
    export_dir = str(tmp_path_factory.mktemp("exports"))
    generated = DataGenerator(tiny_model_path).generate_all_data()
    handler = OutputHandler(
        model=tiny_model, offline=True, export_dir=export_dir
    )
    handler.process_all_outputs(generated)
    assert os.path.exists(os.path.join(export_dir, "api", f"{API_TABLE}.json"))
    return export_dir, generated


@pytest.fixture(scope="module")
def client(offline_export, tiny_model_path):
    export_dir, _ = offline_export
    app = create_app(
        model_file=tiny_model_path, offline=True, export_dir=export_dir
    )
    with TestClient(app) as test_client:
        yield test_client


@pytest.fixture(scope="module")
def orders(offline_export):
    _, generated = offline_export
    return generated[API_TABLE]["data"]


# -- basics ----------------------------------------------------------------


def test_root_describes_the_api(client, tiny_model_path):
    body = client.get("/").json()
    assert body["mode"] == "offline"
    assert body["model"] == tiny_model_path
    assert API_TABLE in body["api_tables"]
    assert "/docs" in body["documentation"]


def test_health_reports_a_live_timestamp(client):
    """
    The original returned the hardcoded literal '2025-08-02T00:00:00Z', so a
    healthy response was indistinguishable from a stale one.
    """
    first = client.get("/health").json()
    assert first["status"] == "healthy"
    assert first["backend"] == "file"
    assert not first["timestamp"].startswith("2025-08-02")

    second = client.get("/health").json()
    assert second["timestamp"] >= first["timestamp"]


# -- the 404 that used to be a 500 ----------------------------------------


def test_missing_order_returns_404_not_500(client):
    """
    The regression this guards: the connection context manager wrapped its own
    yield in `except Exception`, so the HTTPException(404) raised inside the
    `with` body was caught and re-raised as a 500 "Database connection failed".
    """
    response = client.get("/orders/999999")
    assert response.status_code == 404
    assert response.json()["detail"] == "Order not found"


def test_existing_order_is_returned(client, orders):
    target = orders[0]
    body = client.get(f"/orders/{target['id']}").json()
    assert body["id"] == target["id"]
    assert body["order_number"] == target["order_number"]
    assert isinstance(body["shipping_address"], dict)


def test_non_integer_order_id_is_a_validation_error(client):
    assert client.get("/orders/not-a-number").status_code == 422


# -- status validation ----------------------------------------------------


def test_invalid_status_is_rejected_with_422(client):
    """
    Previously an unconstrained Optional[str], so a typo returned an empty list
    with HTTP 200 and looked like 'no such orders' rather than 'bad request'.
    """
    response = client.get("/orders", params={"status": "shippd"})
    assert response.status_code == 422
    detail = response.json()["detail"]
    assert detail["received"] == "shippd"
    assert "shipped" in detail["allowed"]


def test_valid_status_filters(client, tiny_model_path, orders):
    allowed = APIConfig(tiny_model_path).allowed_status_values()
    assert allowed, "model should declare a status enum"
    for value in allowed:
        response = client.get("/orders", params={"status": value, "limit": 500})
        assert response.status_code == 200
        body = response.json()
        expected = sum(1 for o in orders if o["status"] == value)
        assert body["total_count"] == expected
        assert all(o["status"] == value for o in body["orders"])


def test_status_values_come_from_the_model(tiny_model_path):
    config = APIConfig(tiny_model_path)
    assert config.allowed_status_values() == [
        "pending", "processing", "shipped", "delivered", "cancelled"
    ]
    # And the previously-unused accessor now has a caller.
    assert config.get_orders_table_config()["name"] == API_TABLE


# -- filtering and pagination ---------------------------------------------


def test_user_id_zero_is_an_honoured_filter(client):
    """
    The original used `if user_id:`, so user_id=0 was silently dropped and the
    request returned every order instead of none.
    """
    total = client.get("/orders").json()["total_count"]
    filtered = client.get("/orders", params={"user_id": 0}).json()
    assert filtered["total_count"] == 0
    assert filtered["total_count"] != total


def test_user_id_filter_works(client, orders):
    target = orders[0]["user_id"]
    body = client.get(
        "/orders", params={"user_id": target, "limit": 500}
    ).json()
    expected = sum(1 for o in orders if o["user_id"] == target)
    assert body["total_count"] == expected
    assert all(o["user_id"] == target for o in body["orders"])


def test_pagination_is_consistent_and_complete(client, orders):
    collected, skip, limit = [], 0, 3
    while True:
        body = client.get("/orders", params={"skip": skip, "limit": limit}).json()
        collected.extend(o["id"] for o in body["orders"])
        if not body["has_more"] or not body["orders"]:
            break
        skip += limit
    assert sorted(collected) == sorted(o["id"] for o in orders)
    assert len(collected) == len(set(collected)), "a row was returned twice"


def test_keyset_pagination_matches_offset_pagination(client, orders):
    by_offset = [o["id"] for o in client.get(
        "/orders", params={"limit": 500}
    ).json()["orders"]]

    collected, cursor = [], None
    while True:
        params = {"limit": 3}
        if cursor is not None:
            params["after_id"] = cursor
        body = client.get("/orders", params=params).json()
        page = [o["id"] for o in body["orders"]]
        if not page:
            break
        collected.extend(page)
        if not body["has_more"]:
            break
        cursor = page[-1]
    assert collected == by_offset


def test_limit_bounds_are_enforced(client):
    assert client.get("/orders", params={"limit": 0}).status_code == 422
    assert client.get("/orders", params={"limit": 501}).status_code == 422
    assert client.get("/orders", params={"skip": -1}).status_code == 422


# -- summary ---------------------------------------------------------------


def test_summary_matches_the_data(client, orders):
    body = client.get("/orders/stats/summary").json()
    assert body["total_orders"] == len(orders)
    assert body["unique_customers"] == len({o["user_id"] for o in orders})
    assert sum(body["status_breakdown"].values()) == len(orders)
    assert body["min_order_value"] <= body["average_order_value"]
    assert body["average_order_value"] <= body["max_order_value"]


def test_summary_route_is_not_shadowed_by_the_id_route(client):
    """
    /orders/stats/summary must not be captured by /orders/{order_id}. It is
    declared first, which is what keeps it reachable.
    """
    assert client.get("/orders/stats/summary").status_code == 200


# -- offline wiring --------------------------------------------------------


def test_offline_mode_requires_the_generated_payload(tmp_path, tiny_model_path):
    app = create_app(
        model_file=tiny_model_path, offline=True, export_dir=str(tmp_path)
    )
    with TestClient(app) as probe:
        # Startup logs the problem rather than preventing the server existing,
        # so /health can report it.
        assert probe.get("/health").status_code == 503


def test_malformed_shipping_address_does_not_crash(tmp_path, tiny_model_path):
    payload = [
        {
            "id": 1, "order_number": "ORD-1", "user_id": 1,
            "order_date": "2026-01-01T00:00:00", "total_amount": 10.0,
            "tax_amount": 1.0, "shipping_cost": 2.0, "status": "pending",
            "shipping_address": "{not valid json",
            "payment_method": "card",
        }
    ]
    directory = tmp_path / "api"
    directory.mkdir()
    (directory / f"{API_TABLE}.json").write_text(
        json.dumps(payload), encoding="utf-8"
    )
    app = create_app(
        model_file=tiny_model_path, offline=True, export_dir=str(tmp_path)
    )
    with TestClient(app) as probe:
        body = probe.get("/orders/1").json()
        assert body["shipping_address"] == {}
