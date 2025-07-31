import json
import psycopg2
import logging
from typing import Dict, List, Any
import os
from dotenv import load_dotenv

load_dotenv()

class DatabaseManager:
    def __init__(self, config_path: str = None):
        """Initialize database manager with connection details"""
        if config_path:
            load_dotenv(config_path)
        
        self.connection_params = {
            'host': os.getenv('DB_HOST'),
            'port': os.getenv('DB_PORT', 5432),
            'database': os.getenv('DB_NAME'),
            'user': os.getenv('DB_USER'),
            'password': os.getenv('DB_PASSWORD')
        }
        
        self.connection = None
        self.cursor = None
        
        # Set up logging
        logging.basicConfig(level=logging.INFO)
        self.logger = logging.getLogger(__name__)

    def connect(self):
        """Establish database connection"""
        try:
            self.connection = psycopg2.connect(**self.connection_params)
            self.cursor = self.connection.cursor()
            self.logger.info("Database connection established successfully")
            return True
        except Exception as e:
            self.logger.error(f"Database connection failed: {e}")
            return False

    def disconnect(self):
        """Close database connection"""
        if self.cursor:
            self.cursor.close()
        if self.connection:
            self.connection.close()
        self.logger.info("Database connection closed")

    def load_model(self, model_file: str) -> Dict:
        """Load JSON data model"""
        try:
            with open(model_file, 'r') as f:
                model = json.load(f)
            self.logger.info(f"Loaded data model from {model_file}")
            return model
        except Exception as e:
            self.logger.error(f"Failed to load model file: {e}")
            raise

    def get_postgres_type(self, field_type: str, field_config: Dict) -> str:
        """Convert JSON model field types to PostgreSQL types"""
        type_mapping = {
            'string': 'VARCHAR',
            'integer': 'INTEGER',
            'decimal': 'DECIMAL',
            'timestamp': 'TIMESTAMP',
            'json': 'JSONB',
            'enum': 'VARCHAR'
        }
        
        base_type = type_mapping.get(field_type, 'TEXT')
        
        # Handle specific constraints
        if field_type == 'string' and 'max_length' in field_config:
            base_type = f"VARCHAR({field_config['max_length']})"
        elif field_type == 'decimal' and 'precision' in field_config:
            precision = field_config['precision']
            scale = field_config.get('scale', 2)
            base_type = f"DECIMAL({precision},{scale})"
        
        return base_type

    def generate_create_table_sql(self, table_name: str, table_config: Dict) -> str:
        """Generate CREATE TABLE SQL statement"""
        fields = table_config['fields']
        sql_parts = [f"CREATE TABLE IF NOT EXISTS {table_name} ("]
        
        field_definitions = []
        
        for field_name, field_config in fields.items():
            field_type = self.get_postgres_type(field_config['type'], field_config)
            
            # Build field definition
            field_def = f"    {field_name} {field_type}"
            
            # Add constraints
            if field_config.get('primary_key'):
                field_def += " PRIMARY KEY"
            elif field_config.get('unique'):
                field_def += " UNIQUE"
            
            if not field_config.get('nullable', True):
                field_def += " NOT NULL"
            
            if field_config.get('auto_increment'):
                field_def = f"    {field_name} SERIAL PRIMARY KEY"
            
            field_definitions.append(field_def)
        
        sql_parts.append(',\n'.join(field_definitions))
        sql_parts.append(");")
        
        return '\n'.join(sql_parts)

    def generate_foreign_key_constraints(self, model: Dict) -> List[str]:
        """Generate foreign key constraint SQL statements"""
        constraints = []
        
        for table_name, table_config in model['tables'].items():
            fields = table_config['fields']
            
            for field_name, field_config in fields.items():
                if field_config.get('foreign_key'):
                    fk_config = field_config['foreign_key']
                    ref_table = fk_config['table']
                    ref_field = fk_config['field']
                    
                    constraint_name = f"fk_{table_name}_{field_name}"
                    constraint_sql = f"""
ALTER TABLE {table_name} 
ADD CONSTRAINT {constraint_name} 
FOREIGN KEY ({field_name}) 
REFERENCES {ref_table}({ref_field}) 
ON DELETE CASCADE;"""
                    
                    constraints.append(constraint_sql)
        
        return constraints

    def create_schema(self, model_file: str):
        """Create complete database schema from JSON model"""
        if not self.connect():
            raise Exception("Cannot connect to database")
        
        try:
            model = self.load_model(model_file)
            
            # Start transaction
            self.cursor.execute("BEGIN;")
            
            # Drop existing tables in reverse dependency order to handle foreign keys
            table_names = list(model['tables'].keys())
            for table_name in reversed(table_names):
                drop_sql = f"DROP TABLE IF EXISTS {table_name} CASCADE;"
                self.cursor.execute(drop_sql)
                self.logger.info(f"Dropped table: {table_name}")
            
            # Create tables in dependency order
            dependency_order = self.get_table_dependency_order(model)
            
            for table_name in dependency_order:
                table_config = model['tables'][table_name]
                create_sql = self.generate_create_table_sql(table_name, table_config)
                
                self.cursor.execute(create_sql)
                self.logger.info(f"Created table: {table_name}")
            
            # Add foreign key constraints
            constraints = self.generate_foreign_key_constraints(model)
            for constraint in constraints:
                self.cursor.execute(constraint)
                self.logger.info("Added foreign key constraint")
            
            # Commit transaction
            self.connection.commit()
            self.logger.info("Database schema created successfully")
            
        except Exception as e:
            # Rollback on error
            self.connection.rollback()
            self.logger.error(f"Schema creation failed: {e}")
            raise
        finally:
            self.disconnect()

    def get_table_dependency_order(self, model: Dict) -> List[str]:
        """Determine correct order to create tables based on dependencies"""
        tables = model['tables']
        dependency_graph = {}
        
        # Build dependency graph
        for table_name, table_config in tables.items():
            dependencies = []
            
            for field_name, field_config in table_config['fields'].items():
                if field_config.get('foreign_key'):
                    ref_table = field_config['foreign_key']['table']
                    if ref_table != table_name:  # Avoid self-references for now
                        dependencies.append(ref_table)
            
            dependency_graph[table_name] = dependencies
        
        # Topological sort
        ordered_tables = []
        remaining_tables = set(tables.keys())
        
        while remaining_tables:
            # Find tables with no dependencies
            ready_tables = []
            for table in remaining_tables:
                if not any(dep in remaining_tables for dep in dependency_graph[table]):
                    ready_tables.append(table)
            
            if not ready_tables:
                # Handle circular dependencies or self-references
                ready_tables = [next(iter(remaining_tables))]
            
            for table in ready_tables:
                ordered_tables.append(table)
                remaining_tables.remove(table)
        
        return ordered_tables

    def test_connection(self) -> bool:
        """Test database connection"""
        if self.connect():
            try:
                self.cursor.execute("SELECT 1;")
                result = self.cursor.fetchone()
                self.logger.info("Database connection test successful")
                return True
            except Exception as e:
                self.logger.error(f"Connection test failed: {e}")
                return False
            finally:
                self.disconnect()
        return False
