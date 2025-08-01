#!/usr/bin/env python3
"""
Final Integration Test for Complete Data Pipeline System
Tests all CLI commands and verifies full system functionality
"""

import os
import subprocess
import time
import requests
import json
from pathlib import Path

def run_command(command, timeout=300):
    """Run a command and return success/failure"""
    print(f"🔄 Running: {command}")
    try:
        result = subprocess.run(
            command, 
            shell=True, 
            capture_output=True, 
            text=True, 
            timeout=timeout
        )
        
        if result.returncode == 0:
            print("✅ Command executed successfully")
            return True, result.stdout, result.stderr
        else:
            print(f"❌ Command failed with return code: {result.returncode}")
            print(f"Error: {result.stderr}")
            return False, result.stdout, result.stderr
            
    except subprocess.TimeoutExpired:
        print(f"❌ Command timed out after {timeout} seconds")
        return False, "", "Command timed out"
    except Exception as e:
        print(f"❌ Error running command: {e}")
        return False, "", str(e)

def test_file_exists(filepath, expected_min_size=100):
    """Test if a file exists and has content"""
    if os.path.exists(filepath):
        size = os.path.getsize(filepath)
        if size >= expected_min_size:
            print(f"✅ File exists: {filepath} ({size:,} bytes)")
            return True
        else:
            print(f"❌ File too small: {filepath} ({size} bytes)")
            return False
    else:
        print(f"❌ File missing: {filepath}")
        return False

def test_api_server():
    """Test if API server is responsive"""
    try:
        response = requests.get("http://localhost:8000/health", timeout=5)
        if response.status_code == 200:
            print("✅ API server is responsive")
            return True
        else:
            print(f"❌ API server returned status {response.status_code}")
            return False
    except requests.exceptions.RequestException as e:
        print(f"❌ API server not accessible: {e}")
        return False

def main():
    """Run complete integration test suite"""
    print("="*80)
    print("🧪 FINAL INTEGRATION TEST - COMPLETE DATA PIPELINE SYSTEM")
    print("="*80)
    
    test_results = []
    
    # Test 1: Complete Pipeline Execution
    print(f"\n{'='*20} TEST 1: Complete Pipeline Execution {'='*20}")
    success, stdout, stderr = run_command(
        "python data_pipeline.py --model ecommerce_model.json --env .env"
    )
    test_results.append(("Complete Pipeline", success))
    
    if success:
        print("✅ Complete pipeline executed successfully")
    else:
        print("❌ Complete pipeline failed")
        print("Stdout:", stdout[-500:])  # Last 500 chars
        print("Stderr:", stderr[-500:])
    
    # Test 2: Verify Generated Files
    print(f"\n{'='*20} TEST 2: Verify Generated Files {'='*20}")
    
    file_tests = [
        ("exports/csv/users.csv", 1000),
        ("exports/csv/reviews.csv", 2000),
        ("exports/json/products.json", 5000)
    ]
    
    file_results = []
    for filepath, min_size in file_tests:
        result = test_file_exists(filepath, min_size)
        file_results.append(result)
    
    all_files_ok = all(file_results)
    test_results.append(("Generated Files", all_files_ok))
    
    # Test 3: Database Export
    print(f"\n{'='*20} TEST 3: Database Export {'='*20}")
    success, stdout, stderr = run_command(
        "python data_pipeline.py export-db --env .env --output exports/test_database_dump.sql"
    )
    
    if success:
        export_exists = test_file_exists("exports/test_database_dump.sql", 1000)
        test_results.append(("Database Export", export_exists))
    else:
        test_results.append(("Database Export", False))
        print("Export failed - stdout:", stdout[-500:])
        print("Export failed - stderr:", stderr[-500:])
    
    # Test 4: API Server (Background Process)
    print(f"\n{'='*20} TEST 4: API Server Testing {'='*20}")
    
    print("🔄 Starting API server in background...")
    api_process = subprocess.Popen([
        "python", "api_server.py", 
        "--model", "ecommerce_model.json", 
        "--env", ".env", 
        "--port", "8000"
    ])
    
    # Wait for server to start
    print("⏳ Waiting for API server to start...")
    time.sleep(10)
    
    # Test API endpoints
    api_working = test_api_server()
    test_results.append(("API Server", api_working))
    
    if api_working:
        # Additional API tests
        try:
            # Test orders endpoint
            response = requests.get("http://localhost:8000/orders?limit=5")
            if response.status_code == 200:
                data = response.json()
                orders_count = len(data.get('orders', []))
                total_count = data.get('total_count', 0)
                print(f"✅ Orders API working: {orders_count} orders returned, {total_count} total")
            else:
                print(f"❌ Orders API failed: {response.status_code}")
        except Exception as e:
            print(f"❌ Orders API test failed: {e}")
    
    # Clean up: Stop API server
    print("🔄 Stopping API server...")
    api_process.terminate()
    api_process.wait(timeout=10)
    
    # Test 5: Verify Database Content
    print(f"\n{'='*20} TEST 5: Database Content Verification {'='*20}")
    
    try:
        import psycopg2
        from dotenv import load_dotenv
        
        load_dotenv('.env')
        database_url = os.getenv('DATABASE_URL')
        
        if database_url:
            conn = psycopg2.connect(database_url)
            cursor = conn.cursor()
            
            # Test table counts
            expected_counts = {
                'categories': 25,
                'users': 150,
                'products': 300,
                'orders': 200,
                'order_items': 500
            }
            
            db_test_passed = True
            for table, expected_count in expected_counts.items():
                cursor.execute(f"SELECT COUNT(*) FROM {table};")
                actual_count = cursor.fetchone()[0]
                
                if actual_count == expected_count:
                    print(f"✅ {table}: {actual_count} records (expected {expected_count})")
                else:
                    print(f"❌ {table}: {actual_count} records (expected {expected_count})")
                    db_test_passed = False
            
            cursor.close()
            conn.close()
            
            test_results.append(("Database Content", db_test_passed))
        else:
            print("❌ Could not connect to database")
            test_results.append(("Database Content", False))
            
    except Exception as e:
        print(f"❌ Database verification failed: {e}")
        test_results.append(("Database Content", False))
    
    # Final Results
    print("\n" + "="*80)
    print("🏆 FINAL INTEGRATION TEST RESULTS")
    print("="*80)
    
    passed = sum(1 for _, result in test_results if result)
    total = len(test_results)
    
    print(f"\n📊 SUMMARY:")
    print(f"┌─{'─'*30}┬─{'─'*10}┐")
    print(f"│ {'Test Name':<30} │ {'Status':<10} │")
    print(f"├─{'─'*30}┼─{'─'*10}┤")
    
    for test_name, result in test_results:
        status = "✅ PASS" if result else "❌ FAIL"
        print(f"│ {test_name:<30} │ {status:<10} │")
    
    print(f"├─{'─'*30}┼─{'─'*10}┤")
    print(f"│ {'TOTAL':<30} │ {passed}/{total:<8} │")
    print(f"└─{'─'*30}┴─{'─'*10}┘")
    
    # Overall result
    if passed == total:
        print("\n🎉 ALL TESTS PASSED! 🎉")
        print("✅ Your data pipeline system is working perfectly!")
        print("\n🚀 SYSTEM READY FOR PRODUCTION!")
        
        # Final instructions
        print("\n" + "="*60)
        print("📋 FINAL USAGE INSTRUCTIONS:")
        print("="*60)
        print("1. Run complete pipeline:")
        print("   python data_pipeline.py --model ecommerce_model.json --env .env")
        print()
        print("2. Export database:")
        print("   python data_pipeline.py export-db --env .env --output exports/dump.sql")
        print()
        print("3. Start API server:")
        print("   python api_server.py --model ecommerce_model.json --env .env --port 8000")
        print("="*60)
        
        return True
    else:
        print(f"\n❌ TESTS FAILED: {total-passed}/{total} tests failed")
        print("❌ Please review the failed tests above")
        return False

if __name__ == "__main__":
    success = main()
    exit(0 if success else 1)
