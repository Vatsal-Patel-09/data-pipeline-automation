import requests
import json

def test_api_server():
    """Test the FastAPI server endpoints"""
    base_url = "http://localhost:8000"
    
    print("="*60)
    print("🧪 TESTING FASTAPI SERVER")
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
        
        # Test orders endpoint (basic)
        print("\n3. Testing orders endpoint (basic)...")
        response = requests.get(f"{base_url}/orders")
        if response.status_code == 200:
            data = response.json()
            print("✅ Orders endpoint working")
            print(f"   Total orders: {data['total_count']}")
            print(f"   Returned orders: {len(data['orders'])}")
            print(f"   Has more: {data['has_more']}")
            
            # Show first order
            if data['orders']:
                first_order = data['orders'][0]
                print(f"   First order ID: {first_order['id']}")
                print(f"   Order number: {first_order['order_number']}")
                print(f"   Total amount: ${first_order['total_amount']}")
        else:
            print(f"❌ Orders endpoint failed: {response.status_code}")
        
        # Test pagination
        print("\n4. Testing pagination...")
        response = requests.get(f"{base_url}/orders?skip=10&limit=5")
        if response.status_code == 200:
            data = response.json()
            print("✅ Pagination working")
            print(f"   Skip: {data['skip']}, Limit: {data['limit']}")
            print(f"   Returned: {len(data['orders'])} orders")
        else:
            print(f"❌ Pagination failed: {response.status_code}")
        
        # Test filtering
        print("\n5. Testing status filtering...")
        response = requests.get(f"{base_url}/orders?status=pending")
        if response.status_code == 200:
            data = response.json()
            print("✅ Filtering working")
            print(f"   Pending orders: {data['total_count']}")
        else:
            print(f"❌ Filtering failed: {response.status_code}")
        
        # Test single order
        print("\n6. Testing single order retrieval...")
        response = requests.get(f"{base_url}/orders/1")
        if response.status_code == 200:
            order = response.json()
            print("✅ Single order retrieval working")
            print(f"   Order ID: {order['id']}")
            print(f"   Customer ID: {order['user_id']}")
            print(f"   Status: {order['status']}")
        else:
            print(f"❌ Single order retrieval failed: {response.status_code}")
        
        # Test summary statistics
        print("\n7. Testing order summary...")
        response = requests.get(f"{base_url}/orders/stats/summary")
        if response.status_code == 200:
            stats = response.json()
            print("✅ Order summary working")
            print(f"   Total orders: {stats['total_orders']}")
            print(f"   Unique customers: {stats['unique_customers']}")
            print(f"   Average order value: ${stats['average_order_value']}")
            print(f"   Total revenue: ${stats['total_revenue']}")
        else:
            print(f"❌ Order summary failed: {response.status_code}")
        
        print("\n" + "="*60)
        print("🎉 API SERVER TESTING COMPLETED!")
        print("="*60)
        
    except requests.ConnectionError:
        print("❌ Could not connect to API server. Make sure it's running on http://localhost:8000")
    except Exception as e:
        print(f"❌ Test failed: {e}")

if __name__ == "__main__":
    test_api_server()
