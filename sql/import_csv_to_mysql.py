"""
=============================================================================
E-Commerce Customer & Revenue Intelligence Analytics
Phase 4: Bulk CSV Data Importer to MySQL
=============================================================================
Author: Vansh Kesarwani
Purpose: Loads cleaned CSV datasets into a local or cloud MySQL database
Usage:
  python sql/import_csv_to_mysql.py --host localhost --user root --password your_password
=============================================================================
"""

import os
import argparse
import pandas as pd
from sqlalchemy import create_engine

CLEAN_DIR = 'dataset/cleaned'

TABLES = [
    ('customers', 'customers_cleaned.csv'),
    ('products', 'products_cleaned.csv'),
    ('sellers', 'sellers_cleaned.csv'),
    ('orders', 'orders_cleaned.csv'),
    ('order_items', 'order_items_cleaned.csv'),
    ('order_payments', 'order_payments_cleaned.csv'),
    ('order_reviews', 'order_reviews_cleaned.csv'),
    ('rfm_segments', 'rfm_customer_segments.csv')
]

def load_to_mysql(host, port, user, password, database):
    conn_str = f"mysql+pymysql://{user}:{password}@{host}:{port}/{database}"
    print(f"Connecting to MySQL database: {database} at {host}:{port}...")
    try:
        engine = create_engine(conn_str)
        with engine.connect() as conn:
            print("Connected successfully!")
            
        for table_name, filename in TABLES:
            file_path = os.path.join(CLEAN_DIR, filename)
            if not os.path.exists(file_path):
                print(f"Warning: File {file_path} not found. Skipping.")
                continue
            
            print(f"Loading {table_name} from {filename}...")
            df = pd.read_csv(file_path)
            
            # Parse datetime columns if present
            for col in df.columns:
                if 'date' in col or 'timestamp' in col:
                    df[col] = pd.to_datetime(df[col], errors='coerce')
                    
            df.to_sql(table_name, engine, if_exists='append', index=False, chunksize=5000)
            print(f"  -> Successfully imported {len(df):,} rows into [{table_name}].")
            
        print("\nAll tables imported successfully into MySQL!")
    except Exception as e:
        print(f"Error loading to MySQL: {e}")
        print("\nTip: Ensure MySQL server is running and database 'olist_ecommerce' is created using sql/schema_setup_mysql.sql.")

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Import cleaned e-commerce CSVs into MySQL")
    parser.add_argument('--host', default='localhost', help='MySQL host')
    parser.add_argument('--port', default=3306, type=int, help='MySQL port')
    parser.add_argument('--user', default='root', help='MySQL username')
    parser.add_argument('--password', default='', help='MySQL password')
    parser.add_argument('--database', default='olist_ecommerce', help='Database name')
    args = parser.parse_args()
    
    load_to_mysql(args.host, args.port, args.user, args.password, args.database)

