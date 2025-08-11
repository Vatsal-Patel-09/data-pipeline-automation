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
class TransactionResponse(BaseModel):
    id: int
    loan_account_id: int
    transaction_date: str
    amount: float
    amount_principal: float
    amount_interest: float
    payment_mode: str
    transaction_status: str
    bank_reference: str

class LoanAccountResponse(BaseModel):
    id: int
    account_number: str
    customer_id: int
    loan_amount_sanctioned: float
    outstanding_principal: float
    outstanding_interest: float
    status: str
    disbursal_date: str
    maturity_date: str

class TransactionListResponse(BaseModel):
    transactions: List[TransactionResponse]
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
    title="Loan Management Data Pipeline API",
    description="REST API serving generated loan management data",
    version="1.0.0"
)


@app.on_event("startup")
async def startup_event():
    """Initialize API on startup"""
    logger.info("Starting Loan Management Data Pipeline API...")
    logger.info("API server ready to serve transactions data")

@app.get("/")
async def root():
    """Root endpoint with API information"""
    return {
        "message": "Loan Management Data Pipeline API",
        "version": "1.0.0",
        "endpoints": {
            "transactions": "/transactions",
            "loan_accounts": "/loan-accounts",
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

@app.get("/transactions", response_model=TransactionListResponse)
async def get_transactions(
    skip: int = Query(0, ge=0, description="Number of records to skip"),
    limit: int = Query(50, ge=1, le=500, description="Maximum number of records to return"),
    loan_account_id: Optional[int] = Query(None, description="Filter by loan account ID"),
    payment_mode: Optional[str] = Query(None, description="Filter by payment mode"),
    transaction_status: Optional[str] = Query(None, description="Filter by transaction status")
):
    """
    Get paginated list of transactions with optional filtering
    """
    try:
        with db_connection.get_connection() as conn:
            cursor = conn.cursor()

            # Build base query
            base_query = """
            SELECT id, loan_account_id, transaction_date, amount, 
                   amount_principal, amount_interest, payment_mode, 
                   transaction_status, bank_reference
            FROM transactions
            """
            count_query = "SELECT COUNT(*) FROM transactions"

            # Add filtering conditions
            conditions = []
            params = []
            if loan_account_id:
                conditions.append("loan_account_id = %s")
                params.append(loan_account_id)
            if payment_mode:
                conditions.append("payment_mode = %s")
                params.append(payment_mode)
            if transaction_status:
                conditions.append("transaction_status = %s")
                params.append(transaction_status)

            if conditions:
                where_clause = " WHERE " + " AND ".join(conditions)
                base_query += where_clause
                count_query += where_clause

            # Get total count
            cursor.execute(count_query, params)
            total_count = cursor.fetchone()[0]

            # Add pagination
            base_query += " ORDER BY transaction_date DESC LIMIT %s OFFSET %s"
            params.extend([limit, skip])

            # Execute main query
            cursor.execute(base_query, params)
            rows = cursor.fetchall()

            # Convert to response format
            transactions = []
            for row in rows:
                transaction = TransactionResponse(
                    id=row[0],
                    loan_account_id=row[1],
                    transaction_date=row[2].isoformat() if row[2] else None,
                    amount=float(row[3]) if row[3] else 0.0,
                    amount_principal=float(row[4]) if row[4] else 0.0,
                    amount_interest=float(row[5]) if row[5] else 0.0,
                    payment_mode=row[6] or "unknown",
                    transaction_status=row[7] or "unknown",
                    bank_reference=row[8] or ""
                )
                transactions.append(transaction)

            # Calculate if there are more records
            has_more = (skip + limit) < total_count

            return TransactionListResponse(
                transactions=transactions,
                total_count=total_count,
                skip=skip,
                limit=limit,
                has_more=has_more
            )

    except Exception as e:
        logger.error(f"Error fetching transactions: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")

@app.get("/loan-accounts/{account_id}", response_model=LoanAccountResponse)
async def get_loan_account(account_id: int):
    """Get a specific loan account by ID"""
    try:
        with db_connection.get_connection() as conn:
            cursor = conn.cursor()
            query = """
            SELECT id, account_number, customer_id, loan_amount_sanctioned,
                   outstanding_principal, outstanding_interest, status,
                   disbursal_date, maturity_date
            FROM loan_accounts
            WHERE id = %s
            """
            cursor.execute(query, (account_id,))
            row = cursor.fetchone()

            if not row:
                raise HTTPException(status_code=404, detail="Loan account not found")

            return LoanAccountResponse(
                id=row[0],
                account_number=row[1],
                customer_id=row[2],
                loan_amount_sanctioned=float(row[3]) if row[3] else 0.0,
                outstanding_principal=float(row[4]) if row[4] else 0.0,
                outstanding_interest=float(row[5]) if row[5] else 0.0,
                status=row[6] or "unknown",
                disbursal_date=row[7].isoformat() if row[7] else None,
                maturity_date=row[8].isoformat() if row[8] else None
            )

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error fetching loan account {account_id}: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")

@app.get("/transactions/stats/summary")
async def get_transactions_summary():
    """Get summary statistics for transactions"""
    try:
        with db_connection.get_connection() as conn:
            cursor = conn.cursor()
            
            # Get various statistics
            stats_query = """
            SELECT
                COUNT(*) as total_transactions,
                COUNT(DISTINCT loan_account_id) as unique_loan_accounts,
                AVG(amount) as avg_transaction_amount,
                SUM(amount) as total_transaction_amount,
                MIN(amount) as min_transaction_amount,
                MAX(amount) as max_transaction_amount
            FROM transactions
            """
            cursor.execute(stats_query)
            stats = cursor.fetchone()

            # Get payment mode breakdown
            mode_query = """
            SELECT payment_mode, COUNT(*)
            FROM transactions
            GROUP BY payment_mode
            ORDER BY COUNT(*) DESC
            """
            cursor.execute(mode_query)
            payment_mode_breakdown = dict(cursor.fetchall())

            # Get status breakdown
            status_query = """
            SELECT transaction_status, COUNT(*)
            FROM transactions
            GROUP BY transaction_status
            ORDER BY COUNT(*) DESC
            """
            cursor.execute(status_query)
            status_breakdown = dict(cursor.fetchall())

            return {
                "total_transactions": stats[0],
                "unique_loan_accounts": stats[1],
                "average_transaction_amount": round(float(stats[2]), 2) if stats[2] else 0,
                "total_transaction_amount": round(float(stats[3]), 2) if stats[3] else 0,
                "min_transaction_amount": round(float(stats[4]), 2) if stats[4] else 0,
                "max_transaction_amount": round(float(stats[5]), 2) if stats[5] else 0,
                "payment_mode_breakdown": payment_mode_breakdown,
                "status_breakdown": status_breakdown
            }

    except Exception as e:
        logger.error(f"Error generating transaction summary: {e}")
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
            cursor.execute("SELECT COUNT(*) FROM transactions;")
            transaction_count = cursor.fetchone()[0]
            logger.info(f"Database connected - {transaction_count} transactions available")
    except Exception as e:
        logger.error(f"Database connection failed: {e}")
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
