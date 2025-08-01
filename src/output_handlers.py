import json
import csv
import pandas as pd
import psycopg2
import os
import logging
from typing import Dict, List, Any, Set
from dotenv import load_dotenv
from decimal import Decimal
import datetime

load_dotenv()

class OutputHandler:
    def __init__(self):
        """Initialize output handler"""
        self.logger = logging.getLogger(__name__)
        
        # Database connection parameters
        self.db_params = {
            'host': os.getenv('DB_HOST'),
            'port': os.getenv('DB_PORT', 5432),
            'database': os.getenv('DB_NAME'),
            'user': os.getenv('DB_USER'),
            'password': os.getenv('DB_PASSWORD')
        }
        
        # Try DATABASE_URL if individual params not available
        self.database_url = os.getenv('DATABASE_URL')
    
    def connect_db(self):
        """Establish database connection"""
        try:
            if self.database_url:
                conn = psycopg2.connect(self.database_url)
            else:
                conn = psycopg2.connect(**self.db_params)
            return conn
        except Exception as e:
            self.logger.error(f"Database connection failed: {e}")
            raise
    
    def serialize_value_for_db(self, value):
        """Convert Python values to database-compatible format"""
        if isinstance(value, dict):
            # Convert dict to JSON string for PostgreSQL JSONB fields
            return json.dumps(value)
        elif isinstance(value, list):
            # Convert list to JSON string
            return json.dumps(value)
        elif isinstance(value, Decimal):
            # Convert Decimal to float for database
            return float(value)
        elif isinstance(value, datetime.datetime):
            # Ensure datetime is in proper format
            return value
        elif isinstance(value, datetime.date):
            # Ensure date is in proper format
            return value
        elif value is None:
            return None
        else:
            return value
    
    def serialize_record_for_db(self, record: Dict) -> Dict:
        """Serialize all values in a record for database insertion"""
        serialized_record = {}
        for key, value in record.items():
            serialized_record[key] = self.serialize_value_for_db(value)
        return serialized_record
    
    def serialize_record_for_file(self, record: Dict) -> Dict:
        """Serialize record for file output (CSV/JSON)"""
        serialized_record = {}
        for key, value in record.items():
            if isinstance(value, (datetime.datetime, datetime.date)):
                # Convert datetime/date to string for file output
                serialized_record[key] = value.isoformat()
            elif isinstance(value, Decimal):
                # Convert Decimal to float for file output
                serialized_record[key] = float(value)
            elif isinstance(value, dict) or isinstance(value, list):
                # Keep JSON as-is for JSON files, but serialize for CSV
                serialized_record[key] = value
            else:
                serialized_record[key] = value
        return serialized_record
    
    def find_postgresql_dependencies(self, generated_data: Dict[str, Dict]) -> Set[str]:
        """Find which tables need to be in PostgreSQL for foreign key integrity"""
        postgresql_tables = set()
        referenced_tables = set()
        
        # First, identify tables that are going to PostgreSQL
        for table_name, table_info in generated_data.items():
            if table_info['output_format'] in ['postgresql', 'api']:
                postgresql_tables.add(table_name)
        
        # Find all foreign key references from PostgreSQL tables
        for table_name in postgresql_tables:
            table_info = generated_data[table_name]
            config = table_info['config']
            
            for field in config['fields']:
                if 'foreign_key' in field:
                    fk_string = field['foreign_key']
                    if '.' in fk_string:
                        ref_table = fk_string.split('.')[0]
                        referenced_tables.add(ref_table)
        
        # All referenced tables must also be available in PostgreSQL
        return postgresql_tables.union(referenced_tables)
    
    def handle_postgresql_output(self, table_name: str, data: List[Dict], config: Dict):
        """Insert data into PostgreSQL table"""
        self.logger.info(f"Inserting {len(data)} records into PostgreSQL table: {table_name}")
        
        if not data:
            self.logger.warning(f"No data to insert for table: {table_name}")
            return
        
        conn = self.connect_db()
        cursor = conn.cursor()
        
        try:
            # Start transaction
            cursor.execute("BEGIN;")
            
            # Clear existing data
            cursor.execute(f"DELETE FROM {table_name};")
            self.logger.info(f"Cleared existing data from {table_name}")
            
            # Serialize data for database insertion
            serialized_data = [self.serialize_record_for_db(record) for record in data]
            
            # Prepare insert statement
            columns = list(serialized_data[0].keys())
            placeholders = ', '.join(['%s'] * len(columns))
            insert_sql = f"INSERT INTO {table_name} ({', '.join(columns)}) VALUES ({placeholders})"
            
            # Insert data
            for record in serialized_data:
                values = [record[col] for col in columns]
                cursor.execute(insert_sql, values)
            
            # Commit transaction
            conn.commit()
            self.logger.info(f"✅ Successfully inserted {len(data)} records into {table_name}")
            
        except Exception as e:
            conn.rollback()
            self.logger.error(f"❌ Failed to insert data into {table_name}: {e}")
            raise
        finally:
            cursor.close()
            conn.close()
    
    def handle_csv_output(self, table_name: str, data: List[Dict], config: Dict):
        """Export data to CSV file"""
        filename = f"exports/csv/{table_name}.csv"
        self.logger.info(f"Exporting {len(data)} records to CSV: {filename}")
        
        if not data:
            self.logger.warning(f"No data to export for CSV: {table_name}")
            return
        
        try:
            # Serialize data for file output
            serialized_data = [self.serialize_record_for_file(record) for record in data]
            
            # Handle JSON fields in CSV - convert to string
            csv_data = []
            for record in serialized_data:
                csv_record = {}
                for key, value in record.items():
                    if isinstance(value, (dict, list)):
                        # Convert JSON objects to strings for CSV
                        csv_record[key] = json.dumps(value)
                    else:
                        csv_record[key] = value
                csv_data.append(csv_record)
            
            # Create DataFrame and export to CSV
            df = pd.DataFrame(csv_data)
            df.to_csv(filename, index=False)
            self.logger.info(f"✅ Successfully exported {len(data)} records to {filename}")
            
        except Exception as e:
            self.logger.error(f"❌ Failed to export CSV for {table_name}: {e}")
            raise
    
    def handle_json_output(self, table_name: str, data: List[Dict], config: Dict):
        """Export data to JSON file"""
        filename = f"exports/json/{table_name}.json"
        self.logger.info(f"Exporting {len(data)} records to JSON: {filename}")
        
        if not data:
            self.logger.warning(f"No data to export for JSON: {table_name}")
            return
        
        try:
            # Serialize data for file output
            serialized_data = [self.serialize_record_for_file(record) for record in data]
            
            # Custom JSON encoder to handle additional types
            class CustomJSONEncoder(json.JSONEncoder):
                def default(self, obj):
                    if isinstance(obj, Decimal):
                        return float(obj)
                    elif isinstance(obj, (datetime.datetime, datetime.date)):
                        return obj.isoformat()
                    return super().default(obj)
            
            with open(filename, 'w') as f:
                json.dump(serialized_data, f, indent=2, cls=CustomJSONEncoder)
            self.logger.info(f"✅ Successfully exported {len(data)} records to {filename}")
            
        except Exception as e:
            self.logger.error(f"❌ Failed to export JSON for {table_name}: {e}")
            raise
    
    def handle_api_output(self, table_name: str, data: List[Dict], config: Dict):
        """Store data for API access (in this case, also insert to PostgreSQL)"""
        self.logger.info(f"Preparing {len(data)} records for API access: {table_name}")
        
        # For API data, we'll store it in PostgreSQL so the API can serve it
        self.handle_postgresql_output(table_name, data, config)
    
    def process_all_outputs(self, generated_data: Dict[str, Dict]):
        """Process all generated data to their respective outputs with dependency handling"""
        self.logger.info("Processing all data outputs...")
        
        # First, determine which tables need to be in PostgreSQL for foreign key integrity
        required_postgresql_tables = self.find_postgresql_dependencies(generated_data)
        
        self.logger.info("🔗 Foreign Key Dependency Analysis:")
        for table_name in required_postgresql_tables:
            primary_destination = generated_data[table_name]['output_format']
            if primary_destination != 'postgresql' and primary_destination != 'api':
                self.logger.info(f"   📋 {table_name}: {primary_destination} + PostgreSQL (for FK integrity)")
            else:
                self.logger.info(f"   📋 {table_name}: {primary_destination}")
        
        # Process PostgreSQL tables first (to satisfy foreign key dependencies)
        self.logger.info("\n🐘 PHASE 1: PostgreSQL Tables (Dependencies First)")
        
        # Create a dependency order for PostgreSQL insertion
        postgresql_order = self.get_postgresql_insertion_order(generated_data, required_postgresql_tables)
        
        for table_name in postgresql_order:
            if table_name in required_postgresql_tables:
                table_info = generated_data[table_name]
                data = table_info['data']
                config = table_info['config']
                
                try:
                    self.logger.info(f"🔄 Processing {table_name} for PostgreSQL...")
                    self.handle_postgresql_output(table_name, data, config)
                except Exception as e:
                    self.logger.error(f"❌ Failed to process PostgreSQL for {table_name}: {e}")
                    # Don't continue - this will break dependent tables
                    raise
        
        # Now process primary destinations (files, etc.)
        self.logger.info("\n📁 PHASE 2: Primary Destinations (Files & Others)")
        
        for table_name, table_info in generated_data.items():
            data = table_info['data']
            output_format = table_info['output_format']
            config = table_info['config']
            
            self.logger.info(f"🔄 Processing {table_name} -> {output_format} format")
            
            try:
                if output_format == 'csv':
                    self.handle_csv_output(table_name, data, config)
                elif output_format == 'json':
                    self.handle_json_output(table_name, data, config)
                # Skip postgresql and api since they were handled in Phase 1
                elif output_format not in ['postgresql', 'api']:
                    self.logger.warning(f"Unknown output format: {output_format} for table: {table_name}")
            except Exception as e:
                self.logger.error(f"❌ Failed to process {table_name}: {e}")
                # Continue with other tables
                continue
        
        self.logger.info("\n✅ All data outputs processed successfully!")
    
    def get_postgresql_insertion_order(self, generated_data: Dict[str, Dict], required_tables: Set[str]) -> List[str]:
        """Get the correct order to insert tables into PostgreSQL based on dependencies"""
        dependency_graph = {}
        
        # Build dependency graph for required PostgreSQL tables
        for table_name in required_tables:
            dependencies = []
            table_info = generated_data[table_name]
            config = table_info['config']
            
            for field in config['fields']:
                if 'foreign_key' in field:
                    fk_string = field['foreign_key']
                    if '.' in fk_string:
                        ref_table = fk_string.split('.')[0]
                        if ref_table != table_name and ref_table in required_tables:
                            dependencies.append(ref_table)
            
            dependency_graph[table_name] = dependencies
        
        # Topological sort
        ordered_tables = []
        remaining_tables = set(required_tables)
        
        while remaining_tables:
            # Find tables with no dependencies in remaining set
            ready_tables = []
            for table_name in remaining_tables:
                if not any(dep in remaining_tables for dep in dependency_graph[table_name]):
                    ready_tables.append(table_name)
            
            if not ready_tables:
                # Handle circular dependencies
                ready_tables = [next(iter(remaining_tables))]
                self.logger.warning(f"Circular dependency detected, processing {ready_tables[0]} first")
            
            # Sort for consistent ordering
            ready_tables.sort()
            
            for table_name in ready_tables:
                ordered_tables.append(table_name)
                remaining_tables.remove(table_name)
        
        return ordered_tables
