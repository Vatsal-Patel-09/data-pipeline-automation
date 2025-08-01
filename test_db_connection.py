from src.database_manager import DatabaseManager
import logging

# Enable debug logging
logging.basicConfig(level=logging.DEBUG, format='%(asctime)s - %(levelname)s - %(message)s')

def main():
    print("Testing Database Manager...")
    
    # Initialize database manager
    db_manager = DatabaseManager('.env')
    
    # Test connection first
    if db_manager.test_connection():
        print("✅ Database connection successful!")
    else:
        print("❌ Database connection failed!")
        return
    
    # Test schema creation with detailed logging
    try:
        print("\n" + "="*50)
        print("CREATING DATABASE SCHEMA...")
        print("="*50)
        
        db_manager.create_schema('ecommerce_model.json')
        print("\n✅ Database schema created successfully!")
        
        # Verify tables were created
        print("\n" + "="*50)
        print("VERIFYING TABLES IN DATABASE...")
        print("="*50)
        
        if db_manager.connect():
            db_manager.cursor.execute("""
                SELECT table_name 
                FROM information_schema.tables 
                WHERE table_schema = 'public'
                ORDER BY table_name;
            """)
            tables = db_manager.cursor.fetchall()
            
            if tables:
                print(f"✅ Found {len(tables)} tables:")
                for table in tables:
                    print(f"  - {table[0]}")
            else:
                print("❌ No tables found in database!")
            
            db_manager.disconnect()
        
    except Exception as e:
        print(f"❌ Schema creation failed: {e}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    main()
