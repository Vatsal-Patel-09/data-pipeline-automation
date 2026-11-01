import json
import random
import logging
import time
from datetime import date, datetime, timedelta
from decimal import Decimal
from typing import Dict, List, Any, Optional, Union
from faker import Faker

try:
    from src.metrics import NullMetrics
    from src.model_graph import (
        ModelGraph,
        normalize_output_format,
        parse_foreign_key as _parse_foreign_key,
    )
except ImportError:  # pragma: no cover - supports direct module execution
    from metrics import NullMetrics
    from model_graph import (
        ModelGraph,
        normalize_output_format,
        parse_foreign_key as _parse_foreign_key,
    )

class DataGenerator:
    DEFAULT_SEED = 42

    # Fixed anchor for every generated date and timestamp.
    #
    # The generator previously anchored temporal fields to the wall clock
    # ('today' / 'now'), which silently broke the reproducibility the project
    # documented: a seeded run picked the same offset but from a different
    # origin, so every table carrying a date or timestamp produced different
    # data on every run. Measured before this change: five of the six tables in
    # ecommerce_model.json were nonreproducible across processes, and the one
    # stable table (order_items) was precisely the one with no temporal field.
    #
    # Anchoring to a constant makes the whole dataset reproducible. Pass
    # reference_date='today' to opt back into wall-clock behaviour.
    DEFAULT_REFERENCE_DATE = '2026-01-01'

    def __init__(self, model_file: str, seed: int = DEFAULT_SEED,
                 scale: float = 1.0, metrics=None,
                 reference_date: Optional[str] = None):
        """
        Initialize data generator with JSON model.

        seed and scale default to the historical values (42 and 1.0), so the
        default construction matches the pre-overhaul generator on every
        non-temporal field. scale multiplies every table's sample_size, which
        turns a 90-minute feedback loop into a seconds-long one during
        development.
        """
        self.seed = seed
        self.scale = scale
        self.reference_datetime = self._resolve_reference(reference_date)
        self.reference_date = self.reference_datetime.date()
        self.metrics = metrics if metrics is not None else NullMetrics()
        self.engine_name = 'legacy'

        self.fake = Faker()
        Faker.seed(seed)  # For reproducible data
        random.seed(seed)

        with open(model_file, 'r', encoding='utf-8') as f:
            self.model = json.load(f)

        # Storage for generated data to maintain relationships
        self.generated_data = {}
        self.primary_key_counters = {}
        self.used_unique_values = {}  # Track unique values to avoid duplicates

        # Memoized parent-id lists for foreign-key resolution, keyed by
        # (ref_table, ref_field). See _parent_ids for why this is safe.
        self._parent_id_cache = {}

        # Built lazily by the `graph` property.
        self._graph = None

        self.logger = logging.getLogger(__name__)

    @classmethod
    def _resolve_reference(cls, reference_date: Optional[str]) -> datetime:
        """
        Resolve the temporal anchor.

        None uses the fixed default, which is what makes runs reproducible.
        'today' or 'now' explicitly opts into wall-clock anchoring and therefore
        out of reproducibility.
        """
        if reference_date is None:
            reference_date = cls.DEFAULT_REFERENCE_DATE
        if reference_date.lower() in ('today', 'now'):
            return datetime.now()
        try:
            return datetime.fromisoformat(reference_date)
        except ValueError:
            raise ValueError(
                f"Invalid reference_date {reference_date!r}: expected an ISO "
                "date such as 2026-01-01, or 'today' for wall-clock anchoring."
            ) from None

    def get_sample_size(self, table_config: Dict) -> int:
        """
        Get number of records to generate for a table.

        The declared sample_size is multiplied by self.scale and floored at 1,
        so --scale 0.01 still produces at least one row per table and the
        dependency structure stays exercised.
        """
        declared = table_config.get('sample_size', 100)
        if self.scale == 1.0:
            return declared
        return max(1, int(round(declared * self.scale)))
    
    def get_output_format(self, table_config: Dict) -> str:
        """
        Get the normalized output format for a table.

        Delegates to the shared normalizer. The previous local copy carried its
        own format map and fell back to 'postgresql' for anything it did not
        recognise, so a format it had not been taught about -- 'parquet', or a
        typo -- was silently routed to the database instead of being reported.
        """
        return normalize_output_format(table_config)
    
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
                existing_records
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
            return self.fake.date_between_dates(
                date_start=self.reference_date - timedelta(days=730),
                date_end=self.reference_date,
            )
        elif field_type == 'timestamp':
            return self.fake.date_time_between_dates(
                datetime_start=self.reference_datetime - timedelta(days=365),
                datetime_end=self.reference_datetime,
            )
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
            if 'full' in field_name.lower():
                value = self.fake.name()
            elif 'user' in field_name.lower():
                value = self.fake.user_name()
            elif 'company' in field_name.lower():
                value = self.fake.company()
            elif 'category' in field_name.lower() or field_name.lower() == 'name':
                # Generate category names for categories table
                categories = [
                    'Electronics', 'Clothing', 'Books', 'Home & Garden', 'Sports',
                    'Toys', 'Beauty', 'Automotive', 'Health', 'Food & Beverage',
                    'Smartphones', 'Laptops', 'Tablets', 'Gaming', 'Audio',
                    'Men\'s Clothing', 'Women\'s Clothing', 'Kids\' Clothing', 'Shoes', 'Accessories',
                    'Fiction', 'Non-Fiction', 'Educational', 'Comics', 'Magazines',
                    'Furniture', 'Kitchen', 'Bathroom', 'Garden Tools', 'Decor'
                ]
                value = random.choice(categories)
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
        
        if 'price' in field_name or 'cost' in field_name:
            # Generate prices between $1.00 and $999.99
            value = random.uniform(1.0, 999.99)
        elif 'total' in field_name or 'amount' in field_name:
            # Generate amounts between $10.00 and $5000.00
            value = random.uniform(10.0, 5000.0)
        elif 'tax' in field_name:
            # Generate tax amounts between $0.50 and $500.00
            value = random.uniform(0.5, 500.0)
        elif 'shipping' in field_name:
            # Generate shipping costs between $0.00 and $50.00
            value = random.uniform(0.0, 50.0)
        elif 'discount' in field_name:
            # Generate discount amounts between $0.00 and $100.00
            value = random.uniform(0.0, 100.0)
        elif 'weight' in field_name:
            # Generate weights between 0.1 and 50.0 kg
            value = random.uniform(0.1, 50.0)
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
        """
        Parse a foreign key string like 'categories.id' into table and field.

        Kept as a method, and still returning a dict, so existing callers and
        the root-level demo scripts keep working. The parsing itself now comes
        from the shared module, which was previously duplicated byte-for-byte
        here and in database_manager, and implemented a third incompatible way
        inline in output_handlers.
        """
        table, field = _parse_foreign_key(fk_string)
        return {'table': table, 'field': field}
    
    def _parent_ids(self, ref_table: str, ref_field: str) -> List[Any]:
        """
        The list of candidate parent ids for a foreign key, built once.

        This replaces a list comprehension that previously ran on every single
        field call, rebuilding the entire parent-id list each time. For
        ecommerce_model.json that was roughly 2.0 billion dict probes per run
        (order_items alone contributed 40,000 x 35,000), to produce a result
        that is invariant for a given (ref_table, ref_field).

        Memoizing is behaviour-preserving rather than merely equivalent: tables
        are generated in topological order, so generated_data[ref_table] is
        complete and never mutated again before any child table reads it. The
        cached list is therefore the identical list in the identical order, and
        random.choice consumes the identical RNG draw. The cache is still
        invalidated whenever a table's data is (re)assigned, so the invariant
        does not depend on callers preserving the order.
        """
        key = (ref_table, ref_field)
        cached = self._parent_id_cache.get(key)
        if cached is not None:
            return cached

        records = self.generated_data.get(ref_table)
        if not records:
            return []
        ids = [record[ref_field] for record in records if ref_field in record]
        self._parent_id_cache[key] = ids
        return ids

    def _invalidate_parent_ids(self, table_name: str) -> None:
        """Drop cached parent-id lists for a table whose data just changed."""
        stale = [key for key in self._parent_id_cache if key[0] == table_name]
        for key in stale:
            del self._parent_id_cache[key]

    def generate_foreign_key_value(self, foreign_key: str, nullable: bool = False, current_table: str = None, existing_records: List[Dict] = None) -> Union[int, None]:
        """Generate foreign key value that references existing record"""
        fk_info = self.parse_foreign_key(foreign_key)
        ref_table = fk_info['table']
        ref_field = fk_info['field']
        
        # Handle self-referencing foreign keys (like categories.parent_id)
        if ref_table == current_table and existing_records:
            # For self-referencing tables, 30% chance of NULL (root categories)
            # 70% chance of referencing an existing record in the same table
            if random.random() < 0.3 or len(existing_records) == 0:
                return None
            else:
                # Reference an existing record from the current generation batch
                existing_ids = [record[ref_field] for record in existing_records if ref_field in record]
                if existing_ids:
                    return random.choice(existing_ids)
                else:
                    return None
        
        # Handle nullable foreign keys
        if nullable and random.random() < 0.1:  # 10% chance of NULL
            return None
        
        # Get available IDs from referenced table
        available_ids = self._parent_ids(ref_table, ref_field)
        if available_ids:
            return random.choice(available_ids)

        # Fallback: return None for nullable fields, 1 for non-nullable
        if nullable:
            return None
        else:
            self.logger.warning(f"No data available for foreign key reference to {ref_table}.{ref_field}, using fallback value 1")
            return 1
    
    @property
    def graph(self) -> ModelGraph:
        """The model's table graph, built once."""
        if self._graph is None:
            self._graph = ModelGraph(self.model)
        return self._graph

    def get_table_generation_order(self) -> List[Dict]:
        """
        Determine the correct order to generate data based on dependencies.

        Delegates to the shared topological sort, which breaks ties by name and
        therefore never depends on set iteration order. Returns table configs
        rather than names, as before, so callers are unaffected.
        """
        graph = self.graph
        for cycle in graph.cycles():
            self.logger.warning(
                "Circular foreign-key dependency among %s; breaking it at %s",
                ", ".join(cycle), cycle[0],
            )
        return [graph.config(name) for name in graph.topological_order()]
    
    def generate_table_data(self, table_config: Dict) -> List[Dict]:
        """Generate all records for a table"""
        table_name = table_config['name']
        sample_size = self.get_sample_size(table_config)
        
        self.logger.info(f"Generating {sample_size} records for table: {table_name}")

        started = time.perf_counter()
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
        self._invalidate_parent_ids(table_name)
        elapsed = time.perf_counter() - started

        table_metric = self.metrics.table(table_name)
        table_metric.rows = len(records)
        table_metric.fields = len(table_config['fields'])
        table_metric.declared_format = self.get_output_format(table_config)
        table_metric.generate_s = round(elapsed, 6)
        table_metric.engine = self.engine_name

        self.logger.info(
            f"Generated {len(records)} records for {table_name} "
            f"in {elapsed:.2f}s"
        )
        return records
    
    def generate_all_data(self) -> Dict[str, Dict[str, Any]]:
        """
        Generate data for all tables in correct dependency order.

        Returns a mapping of table name to {'data', 'output_format', 'config'}.
        The previous annotation claimed Dict[str, List[Dict]], which every
        consumer already contradicted.
        """
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
        
        self.metrics.set_graph(
            generation_order=[t['name'] for t in ordered_tables]
        )
        self.logger.info("Data generation completed for all tables")
        return all_data
