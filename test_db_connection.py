from src.database_manager import DatabaseManager

def main():
    print("Testing Database Manager...")
    
    # Initialize database manager
    db_manager = DatabaseManager('.env')
    
    # Test connection
    if db_manager.test_connection():
        print("✅ Database connection successful!")
    else:
        print("❌ Database connection failed!")
        return
    
    # Test schema creation
    try:
        print("Creating database schema...")
        db_manager.create_schema('ecommerce_model.json')
        print("✅ Database schema created successfully!")
    except Exception as e:
        print(f"❌ Schema creation failed: {e}")

if __name__ == "__main__":
    main()
