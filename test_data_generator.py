from src.data_generator import DataGenerator
from src.output_handlers import OutputHandler
import logging

# Enable detailed logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def main():
    print("="*60)
    print("TESTING DATA GENERATOR")
    print("="*60)
    
    try:
        # Initialize data generator
        generator = DataGenerator('ecommerce_model.json')
        print("✅ Data generator initialized")
        
        # Generate all data
        print("\n" + "="*60)
        print("GENERATING DATA FOR ALL TABLES")
        print("="*60)
        
        all_data = generator.generate_all_data()
        
        # Show summary
        print("\n" + "="*60)
        print("DATA GENERATION SUMMARY")
        print("="*60)
        
        for table_name, table_info in all_data.items():
            data_count = len(table_info['data'])
            output_format = table_info['output_format']
            print(f"📊 {table_name}: {data_count} records → {output_format}")
        
        # Process outputs
        print("\n" + "="*60)
        print("PROCESSING DATA OUTPUTS")
        print("="*60)
        
        output_handler = OutputHandler()
        output_handler.process_all_outputs(all_data)
        
        print("\n" + "="*60)
        print("🎉 DATA GENERATION COMPLETED SUCCESSFULLY!")
        print("="*60)
        
        # Show what was created
        print("\n📁 Check these locations:")
        print("   🐘 PostgreSQL tables: categories, order_items")
        print("   📄 CSV files: exports/csv/users.csv, exports/csv/reviews.csv")
        print("   📄 JSON files: exports/json/products.json")
        print("   🌐 API data: orders table (in PostgreSQL)")
        
    except Exception as e:
        print(f"\n❌ Error during data generation: {e}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    main()
