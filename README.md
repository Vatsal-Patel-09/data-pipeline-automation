# E-commerce Data Pipeline Automation System

A comprehensive data engineering solution that automates the generation, transformation, and distribution of realistic e-commerce data across multiple platforms while maintaining referential integrity.

## Demo video 
https://www.loom.com/share/d52908593c834a7a878a1c5d30a54eb3?sid=e54bf7d4-832c-4975-871a-fb75a55a7893

## 🎯 Project Overview

This system demonstrates advanced data pipeline capabilities by:
- **Parsing JSON data models** to dynamically create database schemas
- **Generating realistic test data** using context-aware algorithms
- **Maintaining referential integrity** across PostgreSQL, CSV, JSON, and API formats
- **Serving data via REST API** with pagination and filtering
- **Supporting cloud database integration** with automated deployment

**Key Achievement**: Successfully maintains foreign key relationships across different data destinations (e.g., CSV files reference PostgreSQL primary keys).

## 🏗️ System Architecture

```
┌─────────────────┐ ┌──────────────────┐ ┌─────────────────┐
│ JSON Model │───▶│ Schema Manager │───▶│ PostgreSQL │
│ Definition │ │ │ │ Database │
└─────────────────┘ └──────────────────┘ └─────────────────┘
│ │ │
▼ ▼ ▼
┌─────────────────┐ ┌──────────────────┐ ┌─────────────────┐
│ Data Generator │───▶│ Output Handlers │───▶│ Multi-Format │
│ (Faker) │ │ & Dependencies │ │ Outputs │
└─────────────────┘ └──────────────────┘ └─────────────────┘
│ │ │
▼ ▼ ▼
┌─────────────────┐ ┌──────────────────┐ ┌─────────────────┐
│ CLI Interface │ │ FastAPI Server │ │ CSV/JSON/API │
│ │ │ │ │ Files │
└─────────────────┘ └──────────────────┘ └─────────────────┘
```


### Core Components:
- **Database Manager**: Automated schema creation and transaction management
- **Data Generator**: Realistic data generation with business context awareness
- **Output Handlers**: Multi-format export with referential integrity
- **API Server**: Production-ready REST API with comprehensive endpoints

## 📊 Data Model

The system generates a complete e-commerce database with **6 interconnected tables**:

| Table | Records | Output Format | Description |
|-------|---------|---------------|-------------|
| `categories` | 25 | PostgreSQL | Product category hierarchy |
| `users` | 150 | CSV + PostgreSQL* | Customer information |
| `products` | 300 | JSON + PostgreSQL* | Product catalog |
| `orders` | 200 | API (PostgreSQL) | Customer orders |
| `order_items` | 500 | PostgreSQL | Order line items |
| `reviews` | 400 | CSV | Product reviews |

**Total Generated Records**: 1,575 across all formats

*Dual destination for foreign key integrity

## 🚀 Quick Start

### Prerequisites
- Python 3.8+
- Cloud PostgreSQL database (Supabase recommended)
- 4GB+ RAM for data generation

### Installation

1. **Clone Repository**
```
git clone https://github.com/your-username/ecommerce-data-pipeline.git
cd ecommerce-data-pipeline
```

2. **Create Virtual Environment**
```
python -m venv venv

Windows:
venv\Scripts\activate

macOS/Linux:
source venv/bin/activate
```

3. **Install Dependencies**
```pip install -r requirements.txt```

4. **Configure Environment**
```cp .env.example .env```

Edit .env with your database credentials

### Database Setup (Supabase)

1. Create account at [supabase.com](https://supabase.com/)
2. Create new project
3. Go to Settings > Database
4. Copy connection details to `.env` file

## 💻 Usage

### 1. Complete Pipeline Execution
```python data_pipeline.py --model ecommerce_model.json --env .env```

**Output**: Creates database schema, generates 1,575 records, exports to all formats

### 2. Database Export
```python data_pipeline.py export-db --env .env --output exports/database_dump.sql```

**Output**: Complete SQL dump with schema and data

### 3. API Server
```python api_server.py --model ecommerce_model.json --env .env --port 8000```

**Access**: http://localhost:8000/docs for interactive API documentation

## 📡 API Endpoints

| Endpoint | Method | Description | Example |
|----------|--------|-------------|---------|
| `/` | GET | API information | `curl http://localhost:8000/` |
| `/health` | GET | Health check | `curl http://localhost:8000/health` |
| `/orders` | GET | Paginated orders | `curl http://localhost:8000/orders?limit=10` |
| `/orders/{id}` | GET | Single order | `curl http://localhost:8000/orders/123` |
| `/orders/stats/summary` | GET | Order analytics | `curl http://localhost:8000/orders/stats/summary` |

### API Features
- **Pagination**: `?skip=0&limit=50`
- **Filtering**: `?status=pending&user_id=123`
- **Statistics**: Revenue, customer metrics, status breakdown
- **Error Handling**: Proper HTTP status codes and error messages

## 🔗 Cross-Format Referential Integrity

### The Challenge
Maintaining foreign key relationships when data spans multiple formats:
- `orders.user_id` (PostgreSQL) must reference `users.id` (CSV file)
- `reviews.product_id` (CSV file) must reference `products.id` (JSON file)

### Our Solution: Dual-Destination Strategy
1. **Dependency Analysis**: Automatically detect which tables need PostgreSQL presence
2. **Dual Insertion**: Referenced tables inserted into both PostgreSQL AND primary destination
3. **Topological Ordering**: Generate parent tables before child tables
4. **Transaction Safety**: Rollback on errors, commit on success

**Example**:
- `users` table → Primary: CSV file, Secondary: PostgreSQL (for `orders.user_id`)
- `products` table → Primary: JSON file, Secondary: PostgreSQL (for `order_items.product_id`)

## 📁 Project Structure

```
ecommerce-data-pipeline/
├── README.md # This file
├── requirements.txt # Python dependencies
├── .env.example # Environment template
├── data_pipeline.py # Main CLI script
├── api_server.py # FastAPI server
├── ecommerce_model.json # Data model definition
├── src/ # Core modules
│ ├── database_manager.py # Database operations
│ ├── data_generator.py # Data generation logic
│ └── output_handlers.py # Multi-format output
├── exports/ # Generated outputs
│ ├── csv/ # CSV exports
│ ├── json/ # JSON exports
│ └── database_dump.sql # Database backup
└── logs/ # Application logs
```

## 🧪 Testing & Verification

### Verify Complete Pipeline
```1. Run complete pipeline
python data_pipeline.py --model ecommerce_model.json --env .env

2. Check generated files
ls -la exports/csv/ # Should contain users.csv, reviews.csv
ls -la exports/json/ # Should contain products.json

3. Verify database content (using your database client)
SELECT COUNT() FROM categories; # Should return 25
SELECT COUNT() FROM order_items; # Should return 500

4. Test API endpoints
curl http://localhost:8000/orders?limit=5
curl http://localhost:8000/orders/stats/summary
```

### Verify Referential Integrity
```
Check cross-format relationships
1. Get a product category_id from products.json
2. Verify it exists in PostgreSQL categories table
3. Confirm reviews.csv user_id values exist in PostgreSQL users table
```

## 🔧 Technical Implementation

### Data Generation Strategy
- **Context-Aware Generation**: Products have realistic names for their categories
- **Business Logic**: Order totals mathematically consistent with line items  
- **Self-Referencing Relationships**: Categories can have parent-child hierarchies
- **Realistic Constraints**: Unique emails, valid phone formats, proper date sequences

### Dependency Resolution
Uses **topological sorting** algorithm to determine table creation/population order:
```
Example dependency chain
categories → products → users → orders → order_items → reviews
```

### Performance Optimizations
- **Batch Processing**: Database insertions in configurable batches
- **Connection Pooling**: Reused database connections
- **Memory Management**: Streaming data processing for large datasets
- **Transaction Management**: Atomic operations with rollback capability

## 🚨 Error Handling

The system includes comprehensive error handling:
- **Database Connection**: Automatic retry with exponential backoff
- **Data Validation**: Field-level validation before insertion
- **Transaction Safety**: Complete rollback on any failure
- **Resource Cleanup**: Proper connection and file handle management

## 📈 Performance Metrics

**Typical Performance** (on 4GB RAM system):
- **Schema Creation**: < 30 seconds
- **Data Generation**: 2-3 minutes for 1,575 records
- **Multi-Format Export**: < 1 minute
- **API Response Time**: < 200ms for paginated queries

## 🔐 Security Considerations

- **Environment Variables**: Sensitive credentials stored in `.env`
- **SQL Injection Prevention**: Parameterized queries throughout
- **Input Validation**: Comprehensive validation on all user inputs
- **Connection Security**: SSL-enabled database connections

## 🎯 Submission Deliverables

This project demonstrates:

✅ **End-to-End Functionality**: Complete workflow from JSON model to all outputs  
✅ **Data Integrity**: Foreign key relationships maintained across all formats  
✅ **Cloud Database Integration**: Supabase PostgreSQL setup and population  
✅ **Code Quality**: Clean, readable, well-structured codebase  
✅ **Output Accuracy**: All formats generated with realistic, consistent data  
✅ **Error Handling**: Robust database connections and edge case management  

## 📞 Support & Contact

For questions about this implementation:
- Review the comprehensive logging output for debugging
- Check the `/health` endpoint for system status
- Verify `.env` configuration matches your database setup

---

**Built with**: Python, FastAPI, PostgreSQL, Faker, Pandas, Click  
**Architecture**: Cloud-native, microservices-ready, production-scalable