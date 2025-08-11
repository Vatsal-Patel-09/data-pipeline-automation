import json
import random
import logging
from datetime import datetime, timedelta
from decimal import Decimal
from typing import Dict, List, Any, Union
from faker import Faker
import os

class DataGenerator:
    def __init__(self, model_file: str):
        """Initialize data generator with JSON model"""
        self.fake = Faker()
        Faker.seed(42)  # For reproducible data
        random.seed(42)
        
        with open(model_file, 'r') as f:
            self.model = json.load(f)
        
        # Storage for generated data to maintain relationships
        self.generated_data = {}
        self.primary_key_counters = {}
        self.used_unique_values = {}  # Track unique values to avoid duplicates
        
        # Set up logging
        logging.basicConfig(level=logging.INFO)
        self.logger = logging.getLogger(__name__)
    
    def get_sample_size(self, table_config: Dict) -> int:
        """Get number of records to generate for a table"""
        return table_config.get('sample_size', 100)
    
    def get_output_format(self, table_config: Dict) -> str:
        """Get output format for a table"""
        format_mapping = {
            'postgres': 'postgresql',
            'postgresql': 'postgresql',
            'csv': 'csv',
            'json': 'json',
            'api': 'api'
        }
        return format_mapping.get(table_config.get('output_format', 'postgresql'), 'postgresql')
    
    def get_unique_value(self, generator_func, field_key: str, max_attempts: int = 100):
        """Generate unique value for fields with unique constraints"""
        if field_key not in self.used_unique_values:
            self.used_unique_values[field_key] = set()
        
        for attempt in range(max_attempts):
            value = generator_func()
            if value not in self.used_unique_values[field_key]:
                self.used_unique_values[field_key].add(value)
                return value
        
        # If we can't generate unique value, append a number
        base_value = generator_func()
        counter = 1
        while f"{base_value}_{counter}" in self.used_unique_values[field_key]:
            counter += 1
        
        unique_value = f"{base_value}_{counter}"
        self.used_unique_values[field_key].add(unique_value)
        return unique_value
    
    def generate_field_value(self, field_config: Dict, table_name: str, record_index: int, existing_records: List[Dict] = None) -> Any:
        """Generate realistic value for a field based on its configuration"""
        field_name = field_config['name']
        field_type = field_config['type']
        
        # Handle primary key
        if field_config.get('primary_key'):
            if field_config.get('auto_increment'):
                counter_key = f"{table_name}_{field_name}"
                if counter_key not in self.primary_key_counters:
                    self.primary_key_counters[counter_key] = 0
                self.primary_key_counters[counter_key] += 1
                return self.primary_key_counters[counter_key]
            else:
                return record_index + 1
        
        # Handle foreign keys
        if 'foreign_key' in field_config:
            return self.generate_foreign_key_value(
                field_config['foreign_key'], 
                field_config.get('nullable', False),
                table_name,
                existing_records,
                field_config
            )
        
        # Handle unique fields
        is_unique = field_config.get('unique', False)
        field_key = f"{table_name}.{field_name}"
        
        # Generate based on field type
        if field_type == 'string':
            if is_unique:
                return self.get_unique_value(
                    lambda: self.generate_string_value(field_config, field_name),
                    field_key
                )
            else:
                return self.generate_string_value(field_config, field_name)
        elif field_type == 'integer':
            return self.generate_integer_value(field_config)
        elif field_type == 'decimal':
            return self.generate_decimal_value(field_config)
        elif field_type == 'boolean':
            return self.fake.boolean()
        elif field_type == 'date':
            return self.fake.date_between(start_date='-2y', end_date='today')
        elif field_type == 'timestamp':
            return self.fake.date_time_between(start_date='-1y', end_date='now')
        elif field_type == 'text':
            return self.fake.text(max_nb_chars=500)
        elif field_type == 'json':
            return self.generate_json_value(field_name)
        elif field_type == 'enum':
            return random.choice(field_config['values'])
        else:
            return f"sample_{field_type}"
    
    def generate_string_value(self, field_config: Dict, field_name: str) -> str:
        """Generate realistic string values based on field name"""
        max_length = field_config.get('max_length', 255)
        
        # Generate context-appropriate strings based on field name
        if 'name' in field_name.lower():
            # if 'full' in field_name.lower():
            #     value = self.fake.name()
            # elif 'user' in field_name.lower():
            #     value = self.fake.user_name()
            # elif 'company' in field_name.lower():
            #     value = self.fake.company()
            if 'product_type' in field_name.lower():
                loan_types = ['personal', 'business', 'vehicle', 'mortgage', 'salaried', 'overdraft']
                value = random.choice(loan_types)
            elif 'employment_type' in field_name.lower():
                employment_types = ['salaried', 'self_employed', 'business', 'unemployed', 'other']
                value = random.choice(employment_types)
            elif 'payment_mode' in field_name.lower():
                payment_modes = ['UPI', 'NEFT', 'RTGS', 'IMPS', 'CARD', 'AUTO_DEBIT', 'CHEQUE', 'CASH']
                value = random.choice(payment_modes)
            elif 'account_number' in field_name.lower():
                value = f"LA-{self.fake.random_number(digits=12)}"
            elif 'pan_number' in field_name.lower():
                value = f"{self.fake.random_letters(5).upper()}{self.fake.random_number(digits=4)}{self.fake.random_letter().upper()}"
#For E-commerce model
            # elif 'category' in field_name.lower() or field_name.lower() == 'name':
            #     # Generate category names for categories table
            #     categories = [
            #         'Electronics', 'Clothing', 'Books', 'Home & Garden', 'Sports',
            #         'Toys', 'Beauty', 'Automotive', 'Health', 'Food & Beverage',
            #         'Smartphones', 'Laptops', 'Tablets', 'Gaming', 'Audio',
            #         'Men\'s Clothing', 'Women\'s Clothing', 'Kids\' Clothing', 'Shoes', 'Accessories',
            #         'Fiction', 'Non-Fiction', 'Educational', 'Comics', 'Magazines',
            #         'Furniture', 'Kitchen', 'Bathroom', 'Garden Tools', 'Decor'
            #     ]
            #     value = random.choice(categories)
            else:
                value = self.fake.word().title()
        elif 'email' in field_name.lower():
            value = self.fake.email()
        elif 'phone' in field_name.lower():
            value = self.fake.phone_number()
        elif 'address' in field_name.lower():
            value = self.fake.address()
        elif 'description' in field_name.lower():
            value = self.fake.text(max_nb_chars=min(200, max_length))
        elif 'sku' in field_name.lower():
            value = f"SKU-{self.fake.random_number(digits=8)}"
        elif 'order_number' in field_name.lower():
            value = f"ORD-{self.fake.random_number(digits=10)}"
        elif 'payment' in field_name.lower():
            value = random.choice(['credit_card', 'debit_card', 'paypal', 'bank_transfer'])
        else:
            value = self.fake.word()
        
        # Truncate to max_length if necessary
        if len(value) > max_length:
            value = value[:max_length]
        
        return value
    
    def generate_integer_value(self, field_config: Dict) -> int:
        """Generate realistic integer values"""
        if 'rating' in field_config['name'].lower():
            return random.randint(1, 5)
        elif 'quantity' in field_config['name'].lower():
            return random.randint(1, 10)
        elif 'stock' in field_config['name'].lower():
            return random.randint(0, 1000)
        else:
            return self.fake.random_int(min=1, max=10000)
    
    def generate_decimal_value(self, field_config: Dict) -> Decimal:
        """Generate realistic decimal values"""
        field_name = field_config['name'].lower()
        precision = field_config.get('precision', 10)
        scale = field_config.get('scale', 2)
        
        if 'loan_amount' in field_name:
            value = random.uniform(50000.0, 10000000.0)  # ₹50K to ₹1Cr
        elif 'annual_income' in field_name:
            value = random.uniform(300000.0, 5000000.0)   # ₹3L to ₹50L
        elif 'interest_rate' in field_name:
            value = random.uniform(8.5, 24.0)             # 8.5% to 24%
        elif 'cibil_score' in field_name:
            value = random.randint(300, 900)              # CIBIL range
        elif 'processing_fee' in field_name:
            value = random.uniform(0.5, 3.0)              # 0.5% to 3%

# for ecommers
        # elif 'total' in field_name or 'amount' in field_name:
        #     # Generate amounts between $10.00 and $5000.00
        #     value = random.uniform(10.0, 5000.0)
        # elif 'tax' in field_name:
        #     # Generate tax amounts between $0.50 and $500.00
        #     value = random.uniform(0.5, 500.0)
        # elif 'shipping' in field_name:
        #     # Generate shipping costs between $0.00 and $50.00
        #     value = random.uniform(0.0, 50.0)
        # elif 'discount' in field_name:
        #     # Generate discount amounts between $0.00 and $100.00
        #     value = random.uniform(0.0, 100.0)
        # elif 'weight' in field_name:
        #     # Generate weights between 0.1 and 50.0 kg
        #     value = random.uniform(0.1, 50.0)
        else:
            value = random.uniform(1.0, 1000.0)
        
        # Round to specified scale
        return round(Decimal(str(value)), scale)
    
    def generate_json_value(self, field_name: str) -> Dict:
        """Generate realistic JSON values based on field name"""
        if 'address' in field_name.lower():
            return {
                'street': self.fake.street_address(),
                'city': self.fake.city(),
                'state': self.fake.state(),
                'zip_code': self.fake.zipcode(),
                'country': self.fake.country()
            }
        else:
            return {'field': self.fake.word(), 'value': self.fake.sentence()}
    
    def parse_foreign_key(self, fk_string: str) -> Dict:
        """Parse foreign key string like 'categories.id' into table and field"""
        if '.' in fk_string:
            table, field = fk_string.split('.', 1)
            return {'table': table, 'field': field}
        return {'table': fk_string, 'field': 'id'}
    
    def generate_foreign_key_value(self, foreign_key: str, nullable: bool = False, current_table: str = None, existing_records: List[Dict] = None, field_config: Dict = None) -> Union[int, None]:
        fk_info = self.parse_foreign_key(foreign_key)
        ref_table = fk_info['table']
        ref_field = fk_info['field']
        
        # Handle self-referencing foreign keys
        if ref_table == current_table and existing_records:
            if random.random() < 0.3 or len(existing_records) == 0:
                return None
            else:
                existing_ids = [record[ref_field] for record in existing_records if ref_field in record]
                if existing_ids:
                    return random.choice(existing_ids)
                else:
                    return None
        
        # Handle nullable foreign keys
        if nullable and random.random() < 0.1:
            return None
        
        # Get available IDs from referenced table
        if ref_table in self.generated_data and self.generated_data[ref_table]:
            available_ids = [record[ref_field] for record in self.generated_data[ref_table] if ref_field in record]
            
            # ← ADD THIS SECTION FOR UNIQUE CONSTRAINT HANDLING
            if field_config and field_config.get('unique'):
                # For unique foreign keys, track already used values
                field_name = field_config['name']
                used_key = f"{current_table}.{field_name}"
                
                if used_key not in self.used_unique_values:
                    self.used_unique_values[used_key] = set()
                
                # Get unused IDs
                unused_ids = [id_val for id_val in available_ids if id_val not in self.used_unique_values[used_key]]
                
                if unused_ids:
                    selected_id = random.choice(unused_ids)
                    self.used_unique_values[used_key].add(selected_id)
                    return selected_id
                elif nullable:
                    return None
                else:
                    self.logger.warning(f"No unused unique foreign key values available for {current_table}.{field_name}")
                    return None
            # ← END OF NEW SECTION
            
            if available_ids:
                return random.choice(available_ids)
        
        # Fallback
        if nullable:
            return None
        else:
            self.logger.warning(f"No data available for foreign key reference to {ref_table}.{ref_field}, using fallback value 1")
            return 1

    
    def get_table_generation_order(self) -> List[Dict]:
        """Determine correct order to generate data based on dependencies"""
        tables = {table['name']: table for table in self.model['tables']}
        dependency_graph = {}
        
        # Build dependency graph (excluding self-references)
        for table_config in self.model['tables']:
            table_name = table_config['name']
            dependencies = []
            
            for field in table_config['fields']:
                if 'foreign_key' in field:
                    fk_info = self.parse_foreign_key(field['foreign_key'])
                    ref_table = fk_info['table']
                    if ref_table != table_name:  # Exclude self-references for ordering
                        dependencies.append(ref_table)
            
            dependency_graph[table_name] = list(set(dependencies))  # Remove duplicates
        
        # Topological sort
        ordered_tables = []
        remaining_tables = set(tables.keys())
        
        while remaining_tables:
            # Find tables with no dependencies in remaining set
            ready_tables = []
            for table_name in remaining_tables:
                if not any(dep in remaining_tables for dep in dependency_graph[table_name]):
                    ready_tables.append(table_name)
            
            if not ready_tables:
                # Handle circular dependencies - just pick one
                ready_tables = [next(iter(remaining_tables))]
                self.logger.warning(f"Circular dependency detected, processing {ready_tables[0]} first")
            
            # Sort ready tables for consistent ordering
            ready_tables.sort()
            
            for table_name in ready_tables:
                ordered_tables.append(tables[table_name])
                remaining_tables.remove(table_name)
        
        return ordered_tables
    
    def generate_table_data(self, table_config: Dict) -> List[Dict]:
        """Generate all records for a table"""
        table_name = table_config['name']
        sample_size = self.get_sample_size(table_config)
        
        self.logger.info(f"Generating {sample_size} records for table: {table_name}")
        
        records = []
        for i in range(sample_size):
            record = {}
            
            for field_config in table_config['fields']:
                field_name = field_config['name']
                
                # For self-referencing tables, pass existing records to handle parent_id
                field_value = self.generate_field_value(
                    field_config, 
                    table_name, 
                    i, 
                    records  # Pass existing records for self-referencing
                )
                record[field_name] = field_value
            
            records.append(record)
        
        # Store generated data for foreign key references
        self.generated_data[table_name] = records
        
        self.logger.info(f"✅ Generated {len(records)} records for {table_name}")
        return records
    
    def generate_all_data(self) -> Dict[str, List[Dict]]:
        """Generate data for all tables in correct dependency order"""
        self.logger.info("Starting data generation for all tables...")
        
        ordered_tables = self.get_table_generation_order()
        all_data = {}
        
        for table_config in ordered_tables:
            table_name = table_config['name']
            table_data = self.generate_table_data(table_config)
            all_data[table_name] = {
                'data': table_data,
                'output_format': self.get_output_format(table_config),
                'config': table_config
            }
        
        self.logger.info("✅ Data generation completed for all tables!")
        return all_data
