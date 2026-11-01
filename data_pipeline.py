#!/usr/bin/env python3
"""
E-commerce Data Pipeline Automation System
Main CLI interface for the complete data pipeline
"""

import os
import sys
import json
import logging
import click
import subprocess
from pathlib import Path
from dotenv import load_dotenv

# Import our custom modules
from src.database_manager import DatabaseManager
from src.data_generator import DataGenerator
from src.output_handlers import OutputHandler

# Set up logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

class DataPipeline:
    def __init__(self, model_file: str, env_file: str):
        """Initialize the complete data pipeline"""
        self.model_file = model_file
        self.env_file = env_file
        
        # Load environment variables
        load_dotenv(env_file)
        
        # Initialize components
        self.db_manager = DatabaseManager(env_file)
        self.data_generator = DataGenerator(model_file)
        self.output_handler = OutputHandler()
        
        logger.info(f"Data Pipeline initialized with model: {model_file}")

    def run_complete_pipeline(self):
        """Execute the complete data pipeline from start to finish"""
        logger.info("="*80)
        logger.info("STARTING COMPLETE DATA PIPELINE EXECUTION")
        logger.info("="*80)
        
        try:
            # Step 1: Create database schema
            logger.info("\nSTEP 1: Creating Database Schema...")
            logger.info("-" * 50)
            
            self.db_manager.create_schema(self.model_file)
            logger.info("SUCCESS: Database schema created successfully")
            
            # Step 2: Generate realistic data
            logger.info("\nSTEP 2: Generating Realistic Data...")
            logger.info("-" * 50)
            
            generated_data = self.data_generator.generate_all_data()
            logger.info("SUCCESS: Data generation completed successfully")
            
            # Step 3: Process all outputs
            logger.info("\nSTEP 3: Processing Multi-Format Outputs...")
            logger.info("-" * 50)
            
            self.output_handler.process_all_outputs(generated_data)
            logger.info("SUCCESS: All outputs processed successfully")
            
            # Step 4: Summary report
            logger.info("\nSTEP 4: Pipeline Execution Summary")
            logger.info("-" * 50)
            
            self.generate_summary_report(generated_data)
            
            logger.info("\n" + "="*80)
            logger.info("SUCCESS: COMPLETE DATA PIPELINE EXECUTION FINISHED!")
            logger.info("="*80)
            
            return True
            
        except Exception as e:
            logger.error(f"ERROR: Pipeline execution failed: {e}")
            return False

    def generate_summary_report(self, generated_data):
        """Generate a comprehensive summary of the pipeline execution"""
        logger.info("\nPIPELINE EXECUTION SUMMARY:")
        logger.info("+" + "-"*50 + "+")
        logger.info("|" + " "*15 + "DATA GENERATION REPORT" + " "*13 + "|")
        logger.info("+" + "-"*50 + "+")
        
        total_records = 0
        
        for table_name, table_info in generated_data.items():
            record_count = len(table_info['data'])
            output_format = table_info['output_format']
            total_records += record_count
            
            # Format the output destination
            destination = {
                'postgresql': 'PostgreSQL DB',
                'csv': 'CSV File',
                'json': 'JSON File', 
                'api': 'API Endpoint'
            }.get(output_format, output_format)
            
            logger.info(f"| {table_name:<15} {record_count:>6} records -> {destination}")
        
        logger.info("+" + "-"*50 + "+")
        logger.info(f"| {'TOTAL':<15} {total_records:>6} records generated       |")
        logger.info("+" + "-"*50 + "+")
        
        # Output locations, derived from what was actually generated rather
        # than hardcoded, so this report cannot drift from the model file.
        file_outputs = []
        db_outputs = []
        api_tables = []
        # Which tables actually reach PostgreSQL: the ones that declare it, plus
        # every table they reference through a foreign key (the dual-destination
        # closure). Computed with the same function the writer uses, so the report
        # cannot disagree with what was actually written.
        in_postgres = self.output_handler.find_postgresql_dependencies(generated_data)

        for table_name, table_info in generated_data.items():
            count = len(table_info['data'])
            output_format = table_info['output_format']

            if output_format == 'csv':
                file_outputs.append(f"exports/csv/{table_name}.csv ({count:,} records)")
            elif output_format == 'json':
                file_outputs.append(f"exports/json/{table_name}.json ({count:,} records)")
            elif output_format == 'api':
                api_tables.append((table_name, count))

            if table_name in in_postgres:
                if output_format == 'api':
                    note = " - served via API"
                elif output_format not in ('postgresql', 'api'):
                    note = f" - dual destination, also {output_format.upper()}, for FK integrity"
                else:
                    note = ""
                db_outputs.append(f"{table_name} ({count:,} records){note}")

        logger.info("\nOUTPUT LOCATIONS:")
        logger.info("  File system:")
        for line in file_outputs or ["(none)"]:
            logger.info(f"    - {line}")
        logger.info("  PostgreSQL:")
        for line in db_outputs or ["(none)"]:
            logger.info(f"    - {line}")
        # API information
        logger.info("\nAPI SERVER INFORMATION:")
        logger.info("  Documentation: http://localhost:8000/docs")
        logger.info("  Health check:  http://localhost:8000/health")
        for table_name, count in api_tables:
            logger.info(f"  Endpoint:      http://localhost:8000/{table_name} ({count:,} records)")

    def export_database(self, output_file: str):
        """Export database to SQL dump file"""
        logger.info("="*80)
        logger.info("STARTING DATABASE EXPORT")
        logger.info("="*80)
        
        try:
            # Ensure output directory exists
            output_path = Path(output_file)
            output_path.parent.mkdir(parents=True, exist_ok=True)
            
            # Get database connection parameters
            db_host = os.getenv('DB_HOST')
            db_port = os.getenv('DB_PORT', 5432)
            db_name = os.getenv('DB_NAME')
            db_user = os.getenv('DB_USER')
            db_password = os.getenv('DB_PASSWORD')
            
            if not all([db_host, db_name, db_user, db_password]):
                raise ValueError("Missing database connection parameters")
            
            logger.info("Generating SQL dump using Python database connection...")
            
            self.generate_sql_dump(output_file)
            
            # Verify export file was created
            if os.path.exists(output_file):
                file_size = os.path.getsize(output_file)
                logger.info(f"SUCCESS: Database export completed successfully")
                logger.info(f"Export file: {output_file}")
                logger.info(f"File size: {file_size:,} bytes")
            else:
                raise FileNotFoundError("Export file was not created")
                
            logger.info("="*80)
            logger.info("SUCCESS: DATABASE EXPORT COMPLETED!")
            logger.info("="*80)
            
            return True
            
        except Exception as e:
            logger.error(f"ERROR: Database export failed: {e}")
            return False

    def generate_sql_dump(self, output_file: str):
        """Generate SQL dump using Python database connection"""
        import psycopg2
        
        # Connect to database
        database_url = os.getenv('DATABASE_URL')
        if database_url:
            conn = psycopg2.connect(database_url)
        else:
            conn = psycopg2.connect(
                host=os.getenv('DB_HOST'),
                port=os.getenv('DB_PORT', 5432),
                database=os.getenv('DB_NAME'),
                user=os.getenv('DB_USER'),
                password=os.getenv('DB_PASSWORD')
            )
        
        cursor = conn.cursor()
        
        try:
            with open(output_file, 'w', encoding='utf-8') as f:
                # Write header
                f.write("--\n")
                f.write("-- E-commerce Data Pipeline Database Export\n")
                f.write(f"-- Generated on: {self.get_timestamp()}\n")
                f.write("-- \n\n")
                
                # Get all tables
                cursor.execute("""
                    SELECT table_name 
                    FROM information_schema.tables 
                    WHERE table_schema = 'public' 
                    AND table_type = 'BASE TABLE'
                    ORDER BY table_name;
                """)
                
                tables = [row[0] for row in cursor.fetchall()]
                logger.info(f"Found {len(tables)} tables to export: {', '.join(tables)}")
                
                # Export each table
                for table_name in tables:
                    logger.info(f"Exporting table: {table_name}")
                    
                    # Get table structure
                    f.write(f"\n-- Table: {table_name}\n")
                    f.write(f"-- ================================================\n\n")
                    
                    # Get table schema
                    cursor.execute(f"""
                        SELECT column_name, data_type, is_nullable, column_default
                        FROM information_schema.columns 
                        WHERE table_name = '{table_name}'
                        ORDER BY ordinal_position;
                    """)
                    
                    columns_info = cursor.fetchall()
                    
                    # Create table statement
                    f.write(f"DROP TABLE IF EXISTS {table_name} CASCADE;\n\n")
                    f.write(f"CREATE TABLE {table_name} (\n")
                    
                    column_defs = []
                    for col_name, data_type, is_nullable, col_default in columns_info:
                        col_def = f"    {col_name} {data_type.upper()}"
                        if is_nullable == 'NO':
                            col_def += " NOT NULL"
                        if col_default:
                            col_def += f" DEFAULT {col_default}"
                        column_defs.append(col_def)
                    
                    f.write(",\n".join(column_defs))
                    f.write("\n);\n\n")
                    
                    # Export data
                    cursor.execute(f"SELECT COUNT(*) FROM {table_name};")
                    record_count = cursor.fetchone()[0]
                    
                    if record_count > 0:
                        f.write(f"-- Data for table {table_name} ({record_count} records)\n")
                        
                        cursor.execute(f"SELECT * FROM {table_name};")
                        rows = cursor.fetchall()
                        
                        if rows:
                            # Get column names
                            cursor.execute(f"""
                                SELECT column_name 
                                FROM information_schema.columns 
                                WHERE table_name = '{table_name}'
                                ORDER BY ordinal_position;
                            """)
                            column_names = [row[0] for row in cursor.fetchall()]
                            
                            # Insert statements
                            for row in rows:
                                values = []
                                for value in row:
                                    if value is None:
                                        values.append('NULL')
                                    elif isinstance(value, str):
                                        # Escape single quotes
                                        escaped = value.replace("'", "''")
                                        values.append(f"'{escaped}'")
                                    elif isinstance(value, dict):
                                        # JSON data
                                        json_str = json.dumps(value).replace("'", "''")
                                        values.append(f"'{json_str}'")
                                    else:
                                        values.append(str(value))
                                
                                columns_str = ", ".join(column_names)
                                values_str = ", ".join(values)
                                f.write(f"INSERT INTO {table_name} ({columns_str}) VALUES ({values_str});\n")
                    
                    f.write("\n")
                    
                f.write("\n-- Export completed successfully\n")
                
        finally:
            cursor.close()
            conn.close()

    def get_timestamp(self):
        """Get current timestamp for export file"""
        from datetime import datetime
        return datetime.now().strftime("%Y-%m-%d %H:%M:%S")

# CLI Interface
@click.group(invoke_without_command=True)
@click.pass_context
@click.option('--model', default='ecommerce_model.json', help='Path to JSON model file')
@click.option('--env', default='.env', help='Path to environment file')
def cli(ctx, model, env):
    """
    E-commerce Data Pipeline Automation System
    
    Main CLI interface for the complete data pipeline that handles:
    - Database schema creation
    - Realistic data generation 
    - Multi-format outputs (PostgreSQL, CSV, JSON, API)
    - Cross-format referential integrity
    - Database export functionality
    """
    ctx.ensure_object(dict)
    ctx.obj['model'] = model
    ctx.obj['env'] = env
    
    # If no subcommand provided, run the complete pipeline
    if ctx.invoked_subcommand is None:
        run_pipeline(model, env)

@cli.command()
@click.option('--model', default='ecommerce_model.json', help='Path to JSON model file')
@click.option('--env', default='.env', help='Path to environment file')
def run(model, env):
    """Run the complete data pipeline"""
    run_pipeline(model, env)

@cli.command('export-db')
@click.option('--env', default='.env', help='Path to environment file')
@click.option('--output', default='exports/database_dump.sql', help='Output SQL file path')
def export_database_cmd(env, output):
    """Export database to SQL dump file"""
    try:
        # We need a model file for initialization, use default
        pipeline = DataPipeline('ecommerce_model.json', env)
        success = pipeline.export_database(output)
        
        if success:
            print("\nSUCCESS: Database export completed successfully!")
            print(f"Export saved to: {output}")
        else:
            print("\nERROR: Database export failed!")
            sys.exit(1)
            
    except Exception as e:
        print(f"ERROR: Error during database export: {e}")
        sys.exit(1)

def run_pipeline(model, env):
    """Execute the complete data pipeline"""
    try:
        pipeline = DataPipeline(model, env)
        success = pipeline.run_complete_pipeline()
        
        if success:
            print(f"\nSUCCESS: Complete data pipeline execution finished successfully!")
            print(f"Ready to start API server: python api_server.py --model {model} --env {env}")
        else:
            print(f"\nERROR: Pipeline execution failed!")
            sys.exit(1)
            
    except Exception as e:
        print(f"ERROR: Error during pipeline execution: {e}")
        sys.exit(1)

if __name__ == "__main__":
    cli()
