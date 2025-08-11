import requests
import json


def test_api_server():
    """Test the FastAPI server endpoints for Loan Management API"""
    base_url = "http://localhost:8000"
    
    print("="*60)
    print("🧪 TESTING LOAN MANAGEMENT FASTAPI SERVER")
    print("="*60)
    
    try:
        # Test root endpoint
        print("\n1. Testing root endpoint...")
        response = requests.get(f"{base_url}/")
        if response.status_code == 200:
            print("✅ Root endpoint working")
            print(f"   Response: {response.json()}")
        else:
            print(f"❌ Root endpoint failed: {response.status_code}")
        
        # Test health check
        print("\n2. Testing health check...")
        response = requests.get(f"{base_url}/health")
        if response.status_code == 200:
            print("✅ Health check passed")
            print(f"   Response: {response.json()}")
        else:
            print(f"❌ Health check failed: {response.status_code}")
        
        # Test transactions endpoint (basic)
        print("\n3. Testing transactions endpoint (basic)...")
        response = requests.get(f"{base_url}/transactions")
        if response.status_code == 200:
            data = response.json()
            print("✅ Transactions endpoint working")
            print(f"   Total transactions: {data['total_count']}")
            print(f"   Returned transactions: {len(data['transactions'])}")
            print(f"   Has more: {data['has_more']}")
            
            # Show first transaction
            if data['transactions']:
                first_transaction = data['transactions'][0]
                print(f"   First transaction ID: {first_transaction['id']}")
                print(f"   Loan account ID: {first_transaction['loan_account_id']}")
                print(f"   Amount: ${first_transaction['amount']}")
                print(f"   Payment mode: {first_transaction['payment_mode']}")
                print(f"   Status: {first_transaction['transaction_status']}")
        else:
            print(f"❌ Transactions endpoint failed: {response.status_code}")
        
        # Test pagination
        print("\n4. Testing pagination...")
        response = requests.get(f"{base_url}/transactions?skip=10&limit=5")
        if response.status_code == 200:
            data = response.json()
            print("✅ Pagination working")
            print(f"   Skip: {data['skip']}, Limit: {data['limit']}")
            print(f"   Returned: {len(data['transactions'])} transactions")
        else:
            print(f"❌ Pagination failed: {response.status_code}")
        
        # Test loan account ID filtering
        print("\n5. Testing loan account ID filtering...")
        response = requests.get(f"{base_url}/transactions?loan_account_id=1")
        if response.status_code == 200:
            data = response.json()
            print("✅ Loan account filtering working")
            print(f"   Transactions for account ID 1: {data['total_count']}")
        else:
            print(f"❌ Loan account filtering failed: {response.status_code}")
        
        # Test payment mode filtering
        print("\n6. Testing payment mode filtering...")
        response = requests.get(f"{base_url}/transactions?payment_mode=UPI")
        if response.status_code == 200:
            data = response.json()
            print("✅ Payment mode filtering working")
            print(f"   UPI transactions: {data['total_count']}")
        else:
            print(f"❌ Payment mode filtering failed: {response.status_code}")
        
        # Test transaction status filtering
        print("\n7. Testing transaction status filtering...")
        response = requests.get(f"{base_url}/transactions?transaction_status=success")
        if response.status_code == 200:
            data = response.json()
            print("✅ Transaction status filtering working")
            print(f"   Successful transactions: {data['total_count']}")
        else:
            print(f"❌ Transaction status filtering failed: {response.status_code}")
        
        # Test single loan account retrieval
        print("\n8. Testing single loan account retrieval...")
        response = requests.get(f"{base_url}/loan-accounts/1")
        if response.status_code == 200:
            loan_account = response.json()
            print("✅ Single loan account retrieval working")
            print(f"   Loan Account ID: {loan_account['id']}")
            print(f"   Account Number: {loan_account['account_number']}")
            print(f"   Customer ID: {loan_account['customer_id']}")
            print(f"   Sanctioned Amount: ${loan_account['loan_amount_sanctioned']}")
            print(f"   Outstanding Principal: ${loan_account['outstanding_principal']}")
            print(f"   Status: {loan_account['status']}")
        else:
            print(f"❌ Single loan account retrieval failed: {response.status_code}")
        
        # Test transaction summary statistics
        print("\n9. Testing transaction summary...")
        response = requests.get(f"{base_url}/transactions/stats/summary")
        if response.status_code == 200:
            stats = response.json()
            print("✅ Transaction summary working")
            print(f"   Total transactions: {stats['total_transactions']}")
            print(f"   Unique loan accounts: {stats['unique_loan_accounts']}")
            print(f"   Average transaction amount: ${stats['average_transaction_amount']}")
            print(f"   Total transaction amount: ${stats['total_transaction_amount']}")
            print(f"   Min transaction amount: ${stats['min_transaction_amount']}")
            print(f"   Max transaction amount: ${stats['max_transaction_amount']}")
            
            # Show payment mode breakdown
            if 'payment_mode_breakdown' in stats:
                print(f"   Payment Mode Breakdown:")
                for mode, count in stats['payment_mode_breakdown'].items():
                    print(f"     {mode}: {count}")
            
            # Show status breakdown  
            if 'status_breakdown' in stats:
                print(f"   Status Breakdown:")
                for status, count in stats['status_breakdown'].items():
                    print(f"     {status}: {count}")
                    
        else:
            print(f"❌ Transaction summary failed: {response.status_code}")
        
        # Test combined filters
        print("\n10. Testing combined filters...")
        response = requests.get(f"{base_url}/transactions?loan_account_id=1&payment_mode=NEFT&limit=3")
        if response.status_code == 200:
            data = response.json()
            print("✅ Combined filtering working")
            print(f"   NEFT transactions for account 1: {data['total_count']}")
            print(f"   Returned: {len(data['transactions'])} transactions")
        else:
            print(f"❌ Combined filtering failed: {response.status_code}")
        
        print("\n" + "="*60)
        print("🎉 LOAN MANAGEMENT API SERVER TESTING COMPLETED!")
        print("="*60)
        
    except requests.ConnectionError:
        print("❌ Could not connect to API server. Make sure it's running on http://localhost:8000")
        print("   Start server with: python api_server.py --model loan_mgmt_model.json --env .env --port 8000")
    except Exception as e:
        print(f"❌ Test failed: {e}")


if __name__ == "__main__":
    test_api_server()
