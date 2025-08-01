import json
import os
import logging
import psycopg2
import click
from typing import List, Dict, Any, Optional
from fastapi import FastAPI, Query, HTTPException
from pydantic import BaseModel
from dotenv import load_dotenv
import uvicorn
from contextlib import contextmanager

# Load environment variables
load_dotenv()

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class DatabaseConnection:
    def __init__(self):
        """Initialize database connection parameters"""
        self.db_params = {
            'host': os.getenv('DB_HOST'),
            'port': os.getenv('DB_PORT', 5432),
            'database': os.getenv('DB_NAME'),
            'user': os.getenv('DB_USER'),
            'password': os.getenv('DB_PASSWORD')
        }
        
        # Try DATABASE_URL if individual params not available
        self.database_url = os.getenv('DATABASE_URL')
    
    @contextmanager
    def get_connection(self):
        """Context manager for database connections"""
        conn = None
        try:
            if self.database_url:
                conn = psycopg2.connect(self.database_url)
            else:
                conn = psycopg2.connect(**self.db_params)
            
            yield conn
        except Exception as e:
            logger.error(f"Database connection failed: {e}")
            raise HTTPException(status_code=500, detail="Database connection failed")
        finally:
            if conn:
                conn.close()

# Pydantic models for API responses
class OrderResponse(BaseModel):
    id: int
    order_number: str
    user_id: int
    order_date: str
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

class APIConfig:
    def __init__(self, model_file: str):
        """Load configuration from JSON model file"""
        try:
            with open(model_file, 'r') as f:
                self.model = json.load(f)
            logger.info(f"Loaded API configuration from {model_file}")
        except Exception as e:
            logger.error(f"Failed to load model file: {e}")
            raise

    def get_orders_table_config(self):
        """Get configuration for orders table"""
        for table in self.model.get('tables', []):
            if table.get('name') == 'orders':
                return table
        return None

# Global instances
db_connection = DatabaseConnection()
api_config = None

# Create FastAPI app
app = FastAPI(
    title="E-commerce Data Pipeline API",
    description="REST API serving generated e-commerce data",
    version="1.0.0"
)

@app.on_event("startup")
async def startup_event():
    """Initialize API on startup"""
    logger.info("🚀 Starting E-commerce Data Pipeline API...")
    logger.info("✅ API server ready to serve orders data")

@app.get("/")
async def root():
    """Root endpoint with API information"""
    return {
        "message": "E-commerce Data Pipeline API",
        "version": "1.0.0",
        "endpoints": {
            "orders": "/orders",
            "health": "/health"
        },
        "documentation": "/docs"
    }

@app.get("/health")
async def health_check():
    """Health check endpoint"""
    try:
        with db_connection.get_connection() as conn:
            cursor = conn.cursor()
            cursor.execute("SELECT 1;")
            cursor.fetchone()
        
        return {
            "status": "healthy",
            "database": "connected",
            "timestamp": "2025-08-02T00:00:00Z"
        }
    except Exception as e:
        logger.error(f"Health check failed: {e}")
        raise HTTPException(status_code=503, detail="Service unavailable")

@app.get("/orders", response_model=OrderListResponse)
async def get_orders(
    skip: int = Query(0, ge=0, description="Number of records to skip"),
    limit: int = Query(50, ge=1, le=500, description="Maximum number of records to return"),
    status: Optional[str] = Query(None, description="Filter by order status"),
    user_id: Optional[int] = Query(None, description="Filter by user ID")
):
    """
    Get paginated list of orders with optional filtering
    """
    try:
        with db_connection.get_connection() as conn:
            cursor = conn.cursor()
            
            # Build base query
            base_query = """
                SELECT id, order_number, user_id, order_date, total_amount, 
                       tax_amount, shipping_cost, status, shipping_address, payment_method
                FROM orders
            """
            
            count_query = "SELECT COUNT(*) FROM orders"
            
            # Add filtering conditions
            conditions = []
            params = []
            
            if status:
                conditions.append("status = %s")
                params.append(status)
            
            if user_id:
                conditions.append("user_id = %s")
                params.append(user_id)
            
            if conditions:
                where_clause = " WHERE " + " AND ".join(conditions)
                base_query += where_clause
                count_query += where_clause
            
            # Get total count
            cursor.execute(count_query, params)
            total_count = cursor.fetchone()[0]
            
            # Add pagination
            base_query += " ORDER BY id LIMIT %s OFFSET %s"
            params.extend([limit, skip])
            
            # Execute main query
            cursor.execute(base_query, params)
            rows = cursor.fetchall()
            
            # Convert to response format
            orders = []
            for row in rows:
                # Parse shipping_address JSON if it's a string
                shipping_address = row[8]
                if isinstance(shipping_address, str):
                    try:
                        shipping_address = json.loads(shipping_address)
                    except:
                        shipping_address = {}
                
                order = OrderResponse(
                    id=row[0],
                    order_number=row[1],
                    user_id=row[2],
                    order_date=row[3].isoformat() if row[3] else None,
                    total_amount=float(row[4]) if row[4] else 0.0,
                    tax_amount=float(row[5]) if row[5] else 0.0,
                    shipping_cost=float(row[6]) if row[6] else 0.0,
                    status=row[7] or "unknown",
                    shipping_address=shipping_address or {},
                    payment_method=row[9] or "unknown"
                )
                orders.append(order)
            
            # Calculate if there are more records
            has_more = (skip + limit) < total_count
            
            return OrderListResponse(
                orders=orders,
                total_count=total_count,
                skip=skip,
                limit=limit,
                has_more=has_more
            )
            
    except Exception as e:
        logger.error(f"Error fetching orders: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")

@app.get("/orders/{order_id}", response_model=OrderResponse)
async def get_order_by_id(order_id: int):
    """Get a specific order by ID"""
    try:
        with db_connection.get_connection() as conn:
            cursor = conn.cursor()
            
            query = """
                SELECT id, order_number, user_id, order_date, total_amount, 
                       tax_amount, shipping_cost, status, shipping_address, payment_method
                FROM orders 
                WHERE id = %s
            """
            
            cursor.execute(query, (order_id,))
            row = cursor.fetchone()
            
            if not row:
                raise HTTPException(status_code=404, detail="Order not found")
            
            # Parse shipping_address JSON if it's a string
            shipping_address = row[8]
            if isinstance(shipping_address, str):
                try:
                    shipping_address = json.loads(shipping_address)
                except:
                    shipping_address = {}
            
            return OrderResponse(
                id=row[0],
                order_number=row[1],
                user_id=row[2],
                order_date=row[3].isoformat() if row[3] else None,
                total_amount=float(row[4]) if row[4] else 0.0,
                tax_amount=float(row[5]) if row[5] else 0.0,
                shipping_cost=float(row[6]) if row[6] else 0.0,
                status=row[7] or "unknown",
                shipping_address=shipping_address or {},
                payment_method=row[9] or "unknown"
            )
            
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error fetching order {order_id}: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")

@app.get("/orders/stats/summary")
async def get_orders_summary():
    """Get summary statistics for orders"""
    try:
        with db_connection.get_connection() as conn:
            cursor = conn.cursor()
            
            # Get various statistics
            stats_query = """
                SELECT 
                    COUNT(*) as total_orders,
                    COUNT(DISTINCT user_id) as unique_customers,
                    AVG(total_amount) as avg_order_value,
                    SUM(total_amount) as total_revenue,
                    MIN(total_amount) as min_order_value,
                    MAX(total_amount) as max_order_value
                FROM orders
            """
            
            cursor.execute(stats_query)
            stats = cursor.fetchone()
            
            # Get status breakdown
            status_query = """
                SELECT status, COUNT(*) 
                FROM orders 
                GROUP BY status
                ORDER BY COUNT(*) DESC
            """
            
            cursor.execute(status_query)
            status_breakdown = dict(cursor.fetchall())
            
            return {
                "total_orders": stats[0],
                "unique_customers": stats[1],
                "average_order_value": round(float(stats[2]), 2) if stats[2] else 0,
                "total_revenue": round(float(stats[3]), 2) if stats[3] else 0,
                "min_order_value": round(float(stats[4]), 2) if stats[4] else 0,
                "max_order_value": round(float(stats[5]), 2) if stats[5] else 0,
                "status_breakdown": status_breakdown
            }
            
    except Exception as e:
        logger.error(f"Error generating order summary: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")

# CLI Interface
@click.command()
@click.option('--model', default='ecommerce_model.json', help='Path to JSON model file')
@click.option('--env', default='.env', help='Path to environment file')
@click.option('--port', default=8000, help='Port to run the API server on')
@click.option('--host', default='0.0.0.0', help='Host to bind the server to')
@click.option('--reload', is_flag=True, help='Enable auto-reload for development')
def main(model: str, env: str, port: int, host: str, reload: bool):
    """
    Start the FastAPI server for the E-commerce Data Pipeline
    
    Example usage:
    python api_server.py --model ecommerce_model.json --env .env --port 8000
    """
    global api_config
    
    # Load environment variables from specified file
    load_dotenv(env)
    
    # Initialize API configuration
    try:
        api_config = APIConfig(model)
        logger.info(f"✅ Configuration loaded from {model}")
    except Exception as e:
        logger.error(f"❌ Failed to load configuration: {e}")
        return
    
    # Log startup information
    logger.info("="*60)
    logger.info("🚀 STARTING E-COMMERCE DATA PIPELINE API SERVER")
    logger.info("="*60)
    logger.info(f"📁 Model file: {model}")
    logger.info(f"🔐 Environment file: {env}")
    logger.info(f"🌐 Server: http://{host}:{port}")
    logger.info(f"📖 API Documentation: http://{host}:{port}/docs")
    logger.info(f"🔄 Reload mode: {'Enabled' if reload else 'Disabled'}")
    logger.info("="*60)
    
    # Test database connection
    try:
        with db_connection.get_connection() as conn:
            cursor = conn.cursor()
            cursor.execute("SELECT COUNT(*) FROM orders;")
            order_count = cursor.fetchone()[0]
            logger.info(f"📊 Database connected - {order_count} orders available")
    except Exception as e:
        logger.error(f"❌ Database connection failed: {e}")
        return
    
    # Start the server
    try:
        uvicorn.run(
            "api_server:app",
            host=host,
            port=port,
            reload=reload,
            log_level="info"
        )
    except Exception as e:
        logger.error(f"❌ Failed to start server: {e}")

if __name__ == "__main__":
    main()
