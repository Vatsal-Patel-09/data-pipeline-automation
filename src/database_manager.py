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
        
        # Try DATABASE_URL if individual params not available
        if not all(self.connection_params.values()):
            database_url = os.getenv('DATABASE_URL')
            if database_url:
                self.connection_params = database_url
        
        self.connection = None
        self.cursor = None
        
        # Set up logging
        logging.basicConfig(level=logging.INFO)
        self.logger = logging.getLogger(__name__)

    def connect(self):
        """Establish database connection"""
        try:
            if isinstance(self.connection_params, str):
                # Use DATABASE_URL
                self.connection = psycopg2.connect(self.connection_params)
            else:
                # Use individual parameters
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
            'date': 'DATE',
            'boolean': 'BOOLEAN',
            'json': 'JSONB',
            'text': 'TEXT',
            'enum': 'VARCHAR'
        }
        
        base_type = type_mapping.get(field_type, 'TEXT')
        
        # Handle specific constraints
        if field_type == 'string' and 'max_length' in field_config:
            base_type = f"VARCHAR({field_config['max_length']})"
        elif field_type == 'decimal':
            precision = field_config.get('precision', 10)
            scale = field_config.get('scale', 2)
            base_type = f"DECIMAL({precision},{scale})"
        elif field_type == 'enum' and 'values' in field_config:
            # For enum, we'll use VARCHAR and add a CHECK constraint later
            max_len = max(len(v) for v in field_config['values'])
            base_type = f"VARCHAR({max_len})"
        
        return base_type

    def parse_foreign_key(self, fk_string: str) -> Dict:
        """Parse foreign key string like 'categories.id' into table and field"""
        if '.' in fk_string:
            table, field = fk_string.split('.', 1)
            return {'table': table, 'field': field}
        return {'table': fk_string, 'field': 'id'}

    def generate_create_table_sql(self, table_config: Dict) -> str:
        """Generate CREATE TABLE SQL statement"""
        table_name = table_config['name']
        fields = table_config['fields']
        
        sql_parts = [f"CREATE TABLE IF NOT EXISTS {table_name} ("]
        field_definitions = []
        enum_constraints = []
        
        for field in fields:
            field_name = field['name']
            field_type = self.get_postgres_type(field['type'], field)
            
            # Build field definition
            field_def = f"    {field_name} {field_type}"
            
            # Add constraints
            if field.get('primary_key'):
                if field.get('auto_increment'):
                    field_def = f"    {field_name} SERIAL PRIMARY KEY"
                else:
                    field_def += " PRIMARY KEY"
            elif field.get('unique'):
                field_def += " UNIQUE"
            
            if not field.get('nullable', True) and not field.get('primary_key'):
                field_def += " NOT NULL"
            
            if 'default' in field:
                default_val = field['default']
                if isinstance(default_val, str) and default_val != 'CURRENT_TIMESTAMP':
                    default_val = f"'{default_val}'"
                field_def += f" DEFAULT {default_val}"
            
            field_definitions.append(field_def)
            
            # Handle enum constraints
            if field['type'] == 'enum' and 'values' in field:
                enum_values = "', '".join(field['values'])
                constraint_name = f"chk_{table_name}_{field_name}"
                enum_constraints.append(f"    CONSTRAINT {constraint_name} CHECK ({field_name} IN ('{enum_values}'))")
        
        # Add enum constraints
        if enum_constraints:
            field_definitions.extend(enum_constraints)
        
        sql_parts.append(',\n'.join(field_definitions))
        sql_parts.append(");")
        
        return '\n'.join(sql_parts)

    def generate_foreign_key_constraints(self, model: Dict) -> List[str]:
        """Generate foreign key constraint SQL statements"""
        constraints = []
        
        for table_config in model['tables']:
            table_name = table_config['name']
            
            for field in table_config['fields']:
                if 'foreign_key' in field:
                    field_name = field['name']
                    fk_info = self.parse_foreign_key(field['foreign_key'])
                    ref_table = fk_info['table']
                    ref_field = fk_info['field']
                    
                    constraint_name = f"fk_{table_name}_{field_name}"
                    constraint_sql = f"""
ALTER TABLE {table_name} 
ADD CONSTRAINT {constraint_name} 
FOREIGN KEY ({field_name}) 
REFERENCES {ref_table}({ref_field}) 
ON DELETE CASCADE;"""
                    
                    constraints.append(constraint_sql)
        
        return constraints

    def get_table_dependency_order(self, model: Dict) -> List[Dict]:
        """Determine correct order to create tables based on dependencies"""
        tables = {table['name']: table for table in model['tables']}
        dependency_graph = {}
        
        # Build dependency graph
        for table_config in model['tables']:
            table_name = table_config['name']
            dependencies = []
            
            for field in table_config['fields']:
                if 'foreign_key' in field:
                    fk_info = self.parse_foreign_key(field['foreign_key'])
                    ref_table = fk_info['table']
                    if ref_table != table_name:  # Avoid self-references for now
                        dependencies.append(ref_table)
            
            dependency_graph[table_name] = dependencies
        
        # Topological sort
        ordered_tables = []
        remaining_tables = set(tables.keys())
        
        while remaining_tables:
            # Find tables with no dependencies
            ready_tables = []
            for table_name in remaining_tables:
                if not any(dep in remaining_tables for dep in dependency_graph[table_name]):
                    ready_tables.append(table_name)
            
            if not ready_tables:
                # Handle circular dependencies or self-references
                ready_tables = [next(iter(remaining_tables))]
            
            for table_name in ready_tables:
                ordered_tables.append(tables[table_name])
                remaining_tables.remove(table_name)
        
        return ordered_tables

    def create_schema(self, model_file: str):
        """Create complete database schema from JSON model"""
        if not self.connect():
            raise Exception("Cannot connect to database")
        
        try:
            model = self.load_model(model_file)
            
            # Start transaction
            self.cursor.execute("BEGIN;")
            self.logger.info("Started database transaction")
            
            # Drop existing tables in reverse dependency order to handle foreign keys
            table_names = [table['name'] for table in model['tables']]
            for table_name in reversed(table_names):
                drop_sql = f"DROP TABLE IF EXISTS {table_name} CASCADE;"
                self.cursor.execute(drop_sql)
                self.logger.info(f"Dropped table: {table_name}")
            
            # Create tables in dependency order
            ordered_tables = self.get_table_dependency_order(model)
            
            for table_config in ordered_tables:
                table_name = table_config['name']
                create_sql = self.generate_create_table_sql(table_config)
                
                self.logger.info(f"Creating table: {table_name}")
                self.logger.debug(f"SQL: {create_sql}")
                
                self.cursor.execute(create_sql)
                self.logger.info(f"✅ Created table: {table_name}")
            
            # Add foreign key constraints
            constraints = self.generate_foreign_key_constraints(model)
            for constraint in constraints:
                self.logger.info("Adding foreign key constraint")
                self.cursor.execute(constraint)
                self.logger.info("✅ Added foreign key constraint")
            
            # Commit transaction
            self.connection.commit()
            self.logger.info("✅ Database schema created successfully!")
            
        except Exception as e:
            # Rollback on error
            self.connection.rollback()
            self.logger.error(f"❌ Schema creation failed: {e}")
            raise
        finally:
            self.disconnect()

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
