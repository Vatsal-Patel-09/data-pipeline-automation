#!/usr/bin/env python3
"""
REST API over the generated dataset.

The API is one of the pipeline's destinations: tables declared with
output_format 'api' are loaded into PostgreSQL and served from here.

Structural changes from the original:

  * Data access sits behind a repository, with a PostgreSQL implementation and a
    JSON-file implementation. The file-backed one is what makes an offline demo
    possible -- previously the server exited before uvicorn even started if no
    database was reachable, so with no database there was nothing to show. It
    also makes the endpoints testable with FastAPI's TestClient and no database
    at all.

  * Connections come from a pool. The original opened a fresh psycopg2
    connection per request, which against a hosted database means a TCP plus TLS
    handshake on every call -- the dominant cost of a small response.

  * A 404 is no longer reported as a 500. The connection context manager
    wrapped its own `yield` in `except Exception`, so an HTTPException raised
    inside the `with` body was caught and re-raised as "Database connection
    failed". GET /orders/999999 returned 500, and every genuine SQL error was
    logged as a connection problem.
"""

import json
import logging
import os
from contextlib import asynccontextmanager, contextmanager
from datetime import datetime, timezone
from typing import Any, Dict, List, Optional

import click
import uvicorn
from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException, Query
from pydantic import BaseModel

from src.db import DbConfig, resolve_db_config
from src.model_graph import ModelGraph

load_dotenv()

logging.basicConfig(
    level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s"
)
logger = logging.getLogger(__name__)

# Passed through the environment rather than set on a module global.
#
# uvicorn is started with the import string "api_server:app", which re-imports
# this module in a fresh interpreter (and, with --reload, in a child process).
# The original assigned its configuration to a module global in main() before
# that happened, so the server process always saw None. Nothing read it, which
# is the only reason it never broke.
ENV_MODEL = "PIPELINE_MODEL"
ENV_OFFLINE = "PIPELINE_OFFLINE"
ENV_EXPORT_DIR = "PIPELINE_EXPORT_DIR"

DEFAULT_MODEL = "ecommerce_model.json"
API_TABLE = "orders"

ORDER_COLUMNS = (
    "id", "order_number", "user_id", "order_date", "total_amount",
    "tax_amount", "shipping_cost", "status", "shipping_address",
    "payment_method",
)


# -- response models -------------------------------------------------------

class OrderResponse(BaseModel):
    id: int
    order_number: str
    user_id: int
    # Optional, because the column is nullable in the schema. Declaring it a
    # bare str meant a NULL order_date raised a pydantic ValidationError inside
    # the request handler, which the old connection wrapper then reported as a
    # database connection failure.
    order_date: Optional[str] = None
    total_amount: float
    tax_amount: float
    shipping_cost: float
    status: str
    shipping_address: Dict[str, Any]
    payment_method: str


class OrderListResponse(BaseModel):
    orders: List[OrderResponse]
    total_count: int
    skip: int
    limit: int
    has_more: bool
    next_cursor: Optional[int] = None


# -- configuration ---------------------------------------------------------

class APIConfig:
    """Model-derived configuration. Previously loaded and never used."""

    def __init__(self, model_file: str):
        self.model_file = model_file
        self.graph = ModelGraph.from_file(model_file)
        logger.info(f"Loaded API configuration from {model_file}")

    def get_orders_table_config(self) -> Optional[Dict[str, Any]]:
        if API_TABLE in self.graph:
            return self.graph.config(API_TABLE)
        return None

    def allowed_status_values(self) -> List[str]:
        """
        The status domain, taken from the model rather than hardcoded.

        The original accepted an unconstrained string, so a typo returned an
        empty list with HTTP 200 instead of a validation error.
        """
        config = self.get_orders_table_config()
        if not config:
            return []
        for field in config.get("fields", []):
            if field.get("name") == "status" and field.get("type") == "enum":
                return list(field.get("values", []))
        return []

    def api_tables(self) -> List[str]:
        return [
            name
            for name in self.graph.table_names
            if self.graph.output_format(name) == "api"
        ]


# -- repositories ----------------------------------------------------------

class PostgresOrdersRepository:
    """Serves orders from PostgreSQL, using a connection pool."""

    def __init__(self, config: DbConfig, minconn: int = 1, maxconn: int = 8):
        from psycopg2.pool import ThreadedConnectionPool

        kwargs = config.connect_args()
        self._pool = ThreadedConnectionPool(minconn, maxconn, **kwargs)
        logger.info(
            f"Connection pool ready ({minconn}-{maxconn}) for "
            f"{config.describe()}"
        )

    @contextmanager
    def _connection(self):
        """
        Lease a pooled connection.

        Only connection acquisition is translated into a 503 here. Errors raised
        by the caller's body propagate untouched, which is what keeps a 404 a
        404.
        """
        try:
            conn = self._pool.getconn()
        except Exception as exc:
            logger.error(f"Could not obtain a database connection: {exc}")
            raise HTTPException(
                status_code=503, detail="Database unavailable"
            ) from exc
        try:
            yield conn
        finally:
            try:
                conn.rollback()
            except Exception:
                pass
            self._pool.putconn(conn)

    @staticmethod
    def _where(status: Optional[str], user_id: Optional[int]):
        conditions, params = [], []
        if status is not None:
            conditions.append("status = %s")
            params.append(status)
        # `is not None`, not truthiness: user_id=0 is a legitimate filter and
        # the original silently discarded it.
        if user_id is not None:
            conditions.append("user_id = %s")
            params.append(user_id)
        clause = (" WHERE " + " AND ".join(conditions)) if conditions else ""
        return clause, params

    def health(self) -> bool:
        with self._connection() as conn:
            with conn.cursor() as cursor:
                cursor.execute("SELECT 1;")
                return cursor.fetchone()[0] == 1

    def count(self, status=None, user_id=None) -> int:
        clause, params = self._where(status, user_id)
        with self._connection() as conn:
            with conn.cursor() as cursor:
                cursor.execute(
                    f"SELECT COUNT(*) FROM {API_TABLE}{clause};", params
                )
                return cursor.fetchone()[0]

    def page(self, skip=0, limit=50, status=None, user_id=None,
             after_id=None) -> List[Dict[str, Any]]:
        clause, params = self._where(status, user_id)
        columns = ", ".join(ORDER_COLUMNS)

        if after_id is not None:
            # Keyset pagination: unlike OFFSET, the cost does not grow with how
            # far into the result set you are.
            keyset = " AND id > %s" if clause else " WHERE id > %s"
            query = (
                f"SELECT {columns} FROM {API_TABLE}{clause}{keyset} "
                "ORDER BY id LIMIT %s;"
            )
            params = params + [after_id, limit]
        else:
            query = (
                f"SELECT {columns} FROM {API_TABLE}{clause} "
                "ORDER BY id LIMIT %s OFFSET %s;"
            )
            params = params + [limit, skip]

        with self._connection() as conn:
            with conn.cursor() as cursor:
                cursor.execute(query, params)
                return [
                    dict(zip(ORDER_COLUMNS, row)) for row in cursor.fetchall()
                ]

    def get(self, order_id: int) -> Optional[Dict[str, Any]]:
        columns = ", ".join(ORDER_COLUMNS)
        with self._connection() as conn:
            with conn.cursor() as cursor:
                cursor.execute(
                    f"SELECT {columns} FROM {API_TABLE} WHERE id = %s;",
                    (order_id,),
                )
                row = cursor.fetchone()
        return dict(zip(ORDER_COLUMNS, row)) if row else None

    def summary(self) -> Dict[str, Any]:
        with self._connection() as conn:
            with conn.cursor() as cursor:
                cursor.execute(
                    f"""
                    SELECT COUNT(*), COUNT(DISTINCT user_id),
                           AVG(total_amount), SUM(total_amount),
                           MIN(total_amount), MAX(total_amount)
                    FROM {API_TABLE};
                    """
                )
                stats = cursor.fetchone()
                cursor.execute(
                    f"SELECT status, COUNT(*) FROM {API_TABLE} "
                    "GROUP BY status ORDER BY COUNT(*) DESC;"
                )
                breakdown = dict(cursor.fetchall())
        return _build_summary(stats, breakdown)

    def close(self) -> None:
        try:
            self._pool.closeall()
        except Exception:
            pass


class JsonFileOrdersRepository:
    """
    Serves orders from the JSON file the pipeline writes in offline mode.

    This is what makes the API demonstrable with no database and no network.
    """

    def __init__(self, path: str):
        with open(path, "r", encoding="utf-8") as handle:
            self._rows = json.load(handle)
        for row in self._rows:
            row.setdefault("shipping_address", {})
        self._by_id = {row["id"]: row for row in self._rows}
        logger.info(f"Serving {len(self._rows)} orders from {path} (offline)")

    def _filtered(self, status=None, user_id=None) -> List[Dict[str, Any]]:
        rows = self._rows
        if status is not None:
            rows = [r for r in rows if r.get("status") == status]
        if user_id is not None:
            rows = [r for r in rows if r.get("user_id") == user_id]
        return rows

    def health(self) -> bool:
        return True

    def count(self, status=None, user_id=None) -> int:
        return len(self._filtered(status, user_id))

    def page(self, skip=0, limit=50, status=None, user_id=None, after_id=None):
        rows = sorted(self._filtered(status, user_id), key=lambda r: r["id"])
        if after_id is not None:
            rows = [r for r in rows if r["id"] > after_id]
            return rows[:limit]
        return rows[skip: skip + limit]

    def get(self, order_id: int) -> Optional[Dict[str, Any]]:
        return self._by_id.get(order_id)

    def summary(self) -> Dict[str, Any]:
        amounts = [float(r.get("total_amount") or 0) for r in self._rows]
        breakdown: Dict[str, int] = {}
        for row in self._rows:
            key = row.get("status") or "unknown"
            breakdown[key] = breakdown.get(key, 0) + 1
        stats = (
            len(self._rows),
            len({r.get("user_id") for r in self._rows}),
            (sum(amounts) / len(amounts)) if amounts else 0,
            sum(amounts),
            min(amounts) if amounts else 0,
            max(amounts) if amounts else 0,
        )
        return _build_summary(stats, breakdown)

    def close(self) -> None:
        pass


def _build_summary(stats, breakdown) -> Dict[str, Any]:
    return {
        "total_orders": stats[0],
        "unique_customers": stats[1],
        "average_order_value": round(float(stats[2]), 2) if stats[2] else 0,
        "total_revenue": round(float(stats[3]), 2) if stats[3] else 0,
        "min_order_value": round(float(stats[4]), 2) if stats[4] else 0,
        "max_order_value": round(float(stats[5]), 2) if stats[5] else 0,
        "status_breakdown": breakdown,
    }


# -- row to response -------------------------------------------------------

def _coerce_address(value: Any) -> Dict[str, Any]:
    if isinstance(value, dict):
        return value
    if isinstance(value, str):
        try:
            parsed = json.loads(value)
        except (TypeError, ValueError):
            # Narrow, unlike the original bare `except:`, which also swallowed
            # KeyboardInterrupt and made malformed JSON indistinguishable from
            # an empty address.
            logger.warning("Could not parse shipping_address as JSON")
            return {}
        return parsed if isinstance(parsed, dict) else {}
    return {}


def _to_order(row: Dict[str, Any]) -> OrderResponse:
    order_date = row.get("order_date")
    if hasattr(order_date, "isoformat"):
        order_date = order_date.isoformat()
    return OrderResponse(
        id=row["id"],
        order_number=row["order_number"],
        user_id=row["user_id"],
        order_date=order_date,
        total_amount=float(row.get("total_amount") or 0),
        tax_amount=float(row.get("tax_amount") or 0),
        shipping_cost=float(row.get("shipping_cost") or 0),
        status=row.get("status") or "unknown",
        payment_method=row.get("payment_method") or "unknown",
        shipping_address=_coerce_address(row.get("shipping_address")),
    )


# -- application -----------------------------------------------------------

def build_repository(config: APIConfig, offline: bool, export_dir: str):
    """Choose a backing store. Offline falls back to the generated JSON file."""
    if offline:
        path = os.path.join(export_dir, "api", f"{API_TABLE}.json")
        if not os.path.exists(path):
            raise FileNotFoundError(
                f"Offline mode needs {path}. Generate it with: "
                "python data_pipeline.py --offline"
            )
        return JsonFileOrdersRepository(path)

    db_config = resolve_db_config()
    if not db_config.available:
        raise RuntimeError(
            "No database configuration found. Set DATABASE_URL, or the DB_* "
            "variables, or start the server with --offline."
        )
    return PostgresOrdersRepository(db_config)


def create_app(model_file: Optional[str] = None, offline: Optional[bool] = None,
               export_dir: Optional[str] = None) -> FastAPI:
    """Build the application. Reads the environment so a reloaded child agrees."""
    model_file = model_file or os.getenv(ENV_MODEL, DEFAULT_MODEL)
    if offline is None:
        offline = os.getenv(ENV_OFFLINE, "").lower() in ("1", "true", "yes")
    export_dir = export_dir or os.getenv(ENV_EXPORT_DIR, "exports")

    config = APIConfig(model_file)
    allowed_status = config.allowed_status_values()

    holder: Dict[str, Any] = {"repository": None}

    def repository():
        if holder["repository"] is None:
            holder["repository"] = build_repository(config, offline, export_dir)
        return holder["repository"]

    @asynccontextmanager
    async def lifespan(_app: FastAPI):
        logger.info("Starting the data pipeline API")
        try:
            total = repository().count()
            logger.info(
                f"Ready: {total:,} {API_TABLE} available"
                + (" (offline, from file)" if offline else "")
            )
        except Exception as exc:
            # Log and keep serving. The original returned from main() before
            # uvicorn.run was reached, so a database problem meant no server at
            # all, and not even /health could report the cause.
            logger.error(f"Backing store not ready: {exc}")
        yield
        if holder["repository"] is not None:
            holder["repository"].close()
            holder["repository"] = None

    application = FastAPI(
        title="Synthetic Data Pipeline API",
        description=(
            "REST API serving a generated, referentially-consistent dataset. "
            "One of the pipeline's output destinations."
        ),
        version="2.0.0",
        lifespan=lifespan,
    )
    application.state.config = config
    application.state.offline = offline
    application.state.export_dir = export_dir

    @application.get("/")
    async def root():
        return {
            "message": "Synthetic Data Pipeline API",
            "version": "2.0.0",
            "mode": "offline" if offline else "database",
            "model": model_file,
            "api_tables": config.api_tables(),
            "endpoints": {
                "orders": "/orders",
                "order_by_id": "/orders/{order_id}",
                "summary": "/orders/stats/summary",
                "health": "/health",
            },
            "documentation": "/docs",
        }

    @application.get("/health")
    async def health_check():
        try:
            healthy = repository().health()
        except HTTPException:
            raise
        except Exception as exc:
            logger.error(f"Health check failed: {exc}")
            raise HTTPException(
                status_code=503, detail="Service unavailable"
            ) from exc
        return {
            "status": "healthy" if healthy else "degraded",
            "backend": "file" if offline else "postgresql",
            # A real timestamp. The original returned the hardcoded literal
            # "2025-08-02T00:00:00Z", so a healthy response was
            # indistinguishable from a stale one, defeating the endpoint.
            "timestamp": datetime.now(timezone.utc).isoformat(),
        }

    @application.get("/orders", response_model=OrderListResponse)
    async def get_orders(
        skip: int = Query(0, ge=0, description="Records to skip"),
        limit: int = Query(50, ge=1, le=500, description="Maximum records"),
        status: Optional[str] = Query(None, description="Filter by order status"),
        user_id: Optional[int] = Query(None, description="Filter by user ID"),
        after_id: Optional[int] = Query(
            None, description="Keyset pagination: return orders with id greater "
                             "than this. Preferred over skip for deep pages."
        ),
    ):
        """Paginated orders, with optional filtering."""
        if status is not None and allowed_status and status not in allowed_status:
            # 422 rather than an empty 200. The model declares the domain, so
            # there is no reason to accept a value outside it.
            raise HTTPException(
                status_code=422,
                detail={
                    "error": "invalid status",
                    "received": status,
                    "allowed": allowed_status,
                },
            )

        repo = repository()
        total = repo.count(status=status, user_id=user_id)
        rows = repo.page(
            skip=skip, limit=limit, status=status, user_id=user_id,
            after_id=after_id,
        )
        orders = [_to_order(row) for row in rows]
        has_more = (
            bool(rows) and len(rows) == limit
            if after_id is not None
            else (skip + limit) < total
        )
        return OrderListResponse(
            orders=orders,
            total_count=total,
            skip=skip,
            limit=limit,
            has_more=has_more,
            next_cursor=orders[-1].id if orders and has_more else None,
        )

    @application.get("/orders/stats/summary")
    async def get_orders_summary():
        """Summary statistics, shaped for a dashboard."""
        return repository().summary()

    @application.get("/orders/{order_id}", response_model=OrderResponse)
    async def get_order_by_id(order_id: int):
        """One order by id."""
        row = repository().get(order_id)
        if row is None:
            # This now actually reaches the client as a 404.
            raise HTTPException(status_code=404, detail="Order not found")
        return _to_order(row)

    return application


app = create_app()


# -- CLI -------------------------------------------------------------------

@click.command()
@click.option("--model", default=DEFAULT_MODEL, help="Path to JSON model file")
@click.option("--env", default=".env", help="Path to environment file")
@click.option("--port", default=8000, help="Port to run the API server on")
@click.option("--host", default="0.0.0.0", help="Host to bind the server to")
@click.option("--reload", is_flag=True, help="Enable auto-reload for development")
@click.option("--offline", is_flag=True,
              help="Serve from the generated JSON file instead of a database")
@click.option("--export-dir", default="exports", show_default=True)
def main(model: str, env: str, port: int, host: str, reload: bool,
         offline: bool, export_dir: str):
    """
    Start the API server.

    Example:
        python api_server.py --model ecommerce_model.json --env .env --port 8000
        python api_server.py --offline
    """
    load_dotenv(env)

    # Set before uvicorn re-imports this module, so the server process and any
    # reload child build the same application.
    os.environ[ENV_MODEL] = model
    os.environ[ENV_OFFLINE] = "1" if offline else "0"
    os.environ[ENV_EXPORT_DIR] = export_dir

    logger.info("=" * 60)
    logger.info("STARTING THE DATA PIPELINE API SERVER")
    logger.info("=" * 60)
    logger.info(f"Model file:   {model}")
    logger.info(f"Environment:  {env}")
    logger.info(f"Server:       http://{host}:{port}")
    logger.info(f"Docs:         http://{host}:{port}/docs")
    logger.info(f"Mode:         {'offline (file-backed)' if offline else 'database'}")
    logger.info(f"Reload:       {'enabled' if reload else 'disabled'}")
    logger.info("=" * 60)

    uvicorn.run(
        "api_server:app", host=host, port=port, reload=reload, log_level="info"
    )


if __name__ == "__main__":
    main()
