"""
=============================================================================
E-Commerce Customer & Revenue Intelligence Analytics
Phase 2: Data Cleaning, Transformation & Staging Pipeline
=============================================================================
Author: Vansh Kesarwani
Standard: Production ETL & Analytics Warehouse Pipeline
Dataset: Olist Brazilian E-Commerce Dataset (Kaggle)

Objectives:
1. Load raw datasets without modifying original files.
2. Standardize column data types (datetimes, strings, numerics).
3. Audit and handle missing values, duplicates, and business anomalies.
4. Translate and standardize product categories from Portuguese to English.
5. Engineer business-critical features (lead time, delivery variance, order timing).
6. Export analysis-ready datasets to CSV and a centralized SQLite database.
=============================================================================
"""

import os
import sqlite3
import pandas as pd
import numpy as np

# Configure display
pd.set_option('display.max_columns', None)

RAW_DIR = 'dataset'
CLEAN_DIR = os.path.join(RAW_DIR, 'cleaned')
os.makedirs(CLEAN_DIR, exist_ok=True)

print("=" * 70)
print("STARTING PHASE 2: DATA CLEANING & TRANSFORMATION PIPELINE")
print("=" * 70)


def clean_orders():
    """
    Cleans and enriches olist_orders_dataset:
    - Parses all 5 timestamp columns into proper pandas datetimes.
    - Computes delivery duration, promised delivery duration, and delay days.
    - Creates time intelligence attributes (year, month, year_month, day, hour).
    - Categorizes delivery performance (On-Time, Late, Undelivered).
    """
    print("\n[1/7] Cleaning Orders Table...")
    df = pd.read_csv(os.path.join(RAW_DIR, 'olist_orders_dataset.csv'))
    raw_rows = len(df)

    # 1. Parse timestamps
    timestamp_cols = [
        'order_purchase_timestamp',
        'order_approved_at',
        'order_delivered_carrier_date',
        'order_delivered_customer_date',
        'order_estimated_delivery_date'
    ]
    for col in timestamp_cols:
        df[col] = pd.to_datetime(df[col], errors='coerce')

    # 2. Time intelligence features
    df['purchase_year'] = df['order_purchase_timestamp'].dt.year
    df['purchase_month'] = df['order_purchase_timestamp'].dt.month
    df['purchase_year_month'] = df['order_purchase_timestamp'].dt.to_period('M').astype(str)
    df['purchase_day_name'] = df['order_purchase_timestamp'].dt.day_name()
    df['purchase_hour'] = df['order_purchase_timestamp'].dt.hour

    # 3. Delivery duration calculations (in days)
    # Lead time: purchase to delivery
    df['delivery_lead_time_days'] = (
        df['order_delivered_customer_date'] - df['order_purchase_timestamp']
    ).dt.total_seconds() / 86400.0

    # Promised lead time: purchase to estimated delivery
    df['estimated_lead_time_days'] = (
        df['order_estimated_delivery_date'] - df['order_purchase_timestamp']
    ).dt.total_seconds() / 86400.0

    # Delivery delay: positive = late, negative/zero = on-time
    df['delivery_delay_days'] = (
        df['order_delivered_customer_date'] - df['order_estimated_delivery_date']
    ).dt.total_seconds() / 86400.0

    # 4. Delivery performance category
    def categorize_delivery(row):
        if row['order_status'] != 'delivered':
            return 'Not Delivered'
        if pd.isnull(row['order_delivered_customer_date']):
            return 'Delivered (Missing Date)'
        if row['order_delivered_customer_date'] <= row['order_estimated_delivery_date']:
            return 'On-Time'
        else:
            return 'Late'

    df['delivery_performance'] = df.apply(categorize_delivery, axis=1)
    df['is_late'] = (df['delivery_performance'] == 'Late').astype(int)

    # Round floating days to 2 decimals for clean reporting
    df['delivery_lead_time_days'] = df['delivery_lead_time_days'].round(2)
    df['estimated_lead_time_days'] = df['estimated_lead_time_days'].round(2)
    df['delivery_delay_days'] = df['delivery_delay_days'].round(2)

    out_path = os.path.join(CLEAN_DIR, 'orders_cleaned.csv')
    df.to_csv(out_path, index=False)
    print(f"  -> Processed {raw_rows:,} rows. Saved to: {out_path}")
    print(f"  -> Delivery Performance Breakdown:\n{df['delivery_performance'].value_counts().to_string()}")
    return df


def clean_order_items():
    """
    Cleans and enriches olist_order_items_dataset:
    - Parses shipping limit date.
    - Calculates total item expenditure (price + freight).
    - Audits positive pricing boundaries.
    """
    print("\n[2/7] Cleaning Order Items Table...")
    df = pd.read_csv(os.path.join(RAW_DIR, 'olist_order_items_dataset.csv'))
    raw_rows = len(df)

    # 1. Parse shipping deadline
    df['shipping_limit_date'] = pd.to_datetime(df['shipping_limit_date'], errors='coerce')

    # 2. Total item transaction value
    df['total_item_value'] = (df['price'] + df['freight_value']).round(2)

    # 3. Freight-to-Price ratio per item
    # Handle division by zero safely if price is zero (none in dataset, but best practice)
    df['freight_ratio'] = np.where(df['price'] > 0, (df['freight_value'] / df['price']).round(4), 0.0)

    out_path = os.path.join(CLEAN_DIR, 'order_items_cleaned.csv')
    df.to_csv(out_path, index=False)
    print(f"  -> Processed {raw_rows:,} rows. Saved to: {out_path}")
    print(f"  -> Total Merchandise Volume: R$ {df['price'].sum():,.2f}")
    print(f"  -> Total Freight Volume:     R$ {df['freight_value'].sum():,.2f}")
    return df


def clean_products():
    """
    Cleans and enriches olist_products_dataset:
    - Joins Portuguese category names with English translations.
    - Solves unmapped categories discovered during Phase 1 profiling.
    - Imputes missing categories with 'other_unknown'.
    - Formats category names cleanly (Title Case, no underscores).
    - Fills minor missing dimensional values with category medians.
    """
    print("\n[3/7] Cleaning Products Table...")
    df_prod = pd.read_csv(os.path.join(RAW_DIR, 'olist_products_dataset.csv'))
    df_trans = pd.read_csv(os.path.join(RAW_DIR, 'product_category_name_translation.csv'))
    raw_rows = len(df_prod)

    # Explicit mapping for categories missing from Kaggle translation file:
    custom_translations = {
        'portateis_cozinha_e_preparadores_de_alimentos': 'kitchen_and_food_preparers',
        'pc_gamer': 'pc_gamer'
    }

    # Merge translations
    df = df_prod.merge(df_trans, on='product_category_name', how='left')

    # Apply custom overrides for unmapped categories
    for pt_name, en_name in custom_translations.items():
        mask = df['product_category_name'] == pt_name
        df.loc[mask, 'product_category_name_english'] = en_name

    # Handle remaining nulls in category
    df['product_category_name_english'] = df['product_category_name_english'].fillna('other_unknown')
    df['product_category_name'] = df['product_category_name'].fillna('outros_desconhecido')

    # Format English category name for executive dashboards (e.g., 'bed_bath_table' -> 'Bed Bath Table')
    df['category_clean'] = (
        df['product_category_name_english']
        .str.replace('_', ' ')
        .str.title()
    )

    # Impute the 2 rows with missing physical specs using median values
    for col in ['product_weight_g', 'product_length_cm', 'product_height_cm', 'product_width_cm', 'product_photos_qty']:
        median_val = df[col].median()
        df[col] = df[col].fillna(median_val)

    out_path = os.path.join(CLEAN_DIR, 'products_cleaned.csv')
    df.to_csv(out_path, index=False)
    print(f"  -> Processed {raw_rows:,} products. Saved to: {out_path}")
    print(f"  -> Unique Clean Categories: {df['category_clean'].nunique()}")
    return df


def clean_order_payments():
    """
    Cleans and enriches olist_order_payments_dataset:
    - Filters out the 3 zero-value 'not_defined' payment artifacts.
    - Creates installment bracket categories.
    - Formats payment types cleanly.
    """
    print("\n[4/7] Cleaning Order Payments Table...")
    df = pd.read_csv(os.path.join(RAW_DIR, 'olist_order_payments_dataset.csv'))
    raw_rows = len(df)

    # Audit 'not_defined' records
    df = df[df['payment_type'] != 'not_defined'].copy()
    dropped_rows = raw_rows - len(df)

    # Format payment type
    df['payment_type_clean'] = df['payment_type'].str.replace('_', ' ').str.title()

    # Installment bracket categorization
    def installment_bracket(val):
        if val == 1:
            return '1x (Single Payment)'
        elif 2 <= val <= 3:
            return '2x - 3x'
        elif 4 <= val <= 6:
            return '4x - 6x'
        elif 7 <= val <= 10:
            return '7x - 10x'
        else:
            return '11x - 24x'

    df['installment_bracket'] = df['payment_installments'].apply(installment_bracket)
    df['is_installment'] = (df['payment_installments'] > 1).astype(int)

    out_path = os.path.join(CLEAN_DIR, 'order_payments_cleaned.csv')
    df.to_csv(out_path, index=False)
    print(f"  -> Processed {len(df):,} payments (dropped {dropped_rows} undefined zero rows). Saved to: {out_path}")
    print(f"  -> Payment Breakdown:\n{df['payment_type_clean'].value_counts().to_string()}")
    return df


def clean_order_reviews():
    """
    Cleans and enriches olist_order_reviews_dataset:
    - Parses review dates and timestamps.
    - Imputes null review titles and comments with empty strings.
    - Flags whether a customer provided written commentary.
    - Classifies review sentiments (Positive, Neutral, Negative).
    """
    print("\n[5/7] Cleaning Order Reviews Table...")
    df = pd.read_csv(os.path.join(RAW_DIR, 'olist_order_reviews_dataset.csv'))
    raw_rows = len(df)

    # 1. Parse timestamps
    df['review_creation_date'] = pd.to_datetime(df['review_creation_date'], errors='coerce')
    df['review_answer_timestamp'] = pd.to_datetime(df['review_answer_timestamp'], errors='coerce')

    # 2. Impute text nulls
    df['review_comment_title'] = df['review_comment_title'].fillna('')
    df['review_comment_message'] = df['review_comment_message'].fillna('')
    df['has_comment'] = (df['review_comment_message'] != '').astype(int)

    # 3. Sentiment tier
    def review_sentiment(score):
        if score >= 4:
            return 'Positive (4-5 Stars)'
        elif score == 3:
            return 'Neutral (3 Stars)'
        else:
            return 'Negative (1-2 Stars)'

    df['sentiment_group'] = df['review_score'].apply(review_sentiment)

    out_path = os.path.join(CLEAN_DIR, 'order_reviews_cleaned.csv')
    df.to_csv(out_path, index=False)
    print(f"  -> Processed {raw_rows:,} reviews. Saved to: {out_path}")
    print(f"  -> Sentiment Breakdown:\n{df['sentiment_group'].value_counts().to_string()}")
    return df


def clean_customers():
    """
    Cleans and standardizes olist_customers_dataset:
    - Standardizes city strings to clean Title Case.
    - Validates state codes.
    - Calculates customer order frequency profile.
    """
    print("\n[6/7] Cleaning Customers Table...")
    df = pd.read_csv(os.path.join(RAW_DIR, 'olist_customers_dataset.csv'))
    raw_rows = len(df)

    # Standardize text
    df['customer_city'] = df['customer_city'].str.strip().str.title()
    df['customer_state'] = df['customer_state'].str.strip().str.upper()

    out_path = os.path.join(CLEAN_DIR, 'customers_cleaned.csv')
    df.to_csv(out_path, index=False)
    print(f"  -> Processed {raw_rows:,} customer rows. Saved to: {out_path}")
    print(f"  -> Distinct Human Buyers (customer_unique_id): {df['customer_unique_id'].nunique():,}")
    return df


def clean_sellers():
    """
    Cleans and standardizes olist_sellers_dataset:
    - Standardizes city names to Title Case.
    - Validates state codes.
    """
    print("\n[7/7] Cleaning Sellers Table...")
    df = pd.read_csv(os.path.join(RAW_DIR, 'olist_sellers_dataset.csv'))
    raw_rows = len(df)

    df['seller_city'] = df['seller_city'].str.strip().str.title()
    df['seller_state'] = df['seller_state'].str.strip().str.upper()

    out_path = os.path.join(CLEAN_DIR, 'sellers_cleaned.csv')
    df.to_csv(out_path, index=False)
    print(f"  -> Processed {raw_rows:,} sellers. Saved to: {out_path}")
    return df


def build_sqlite_database():
    """
    Loads all clean datasets into a centralized SQLite database:
    dataset/cleaned/olist_analytics.db
    Creates indexes on primary and foreign keys for high-performance SQL queries.
    """
    print("\n" + "=" * 70)
    print("BUILDING CENTRALIZED SQLITE ANALYTICS DATABASE")
    print("=" * 70)
    db_path = os.path.join(CLEAN_DIR, 'olist_analytics.db')

    # Remove existing DB if present to rebuild clean
    if os.path.exists(db_path):
        os.remove(db_path)

    conn = sqlite3.connect(db_path)

    tables = {
        'orders': 'orders_cleaned.csv',
        'order_items': 'order_items_cleaned.csv',
        'order_payments': 'order_payments_cleaned.csv',
        'order_reviews': 'order_reviews_cleaned.csv',
        'customers': 'customers_cleaned.csv',
        'products': 'products_cleaned.csv',
        'sellers': 'sellers_cleaned.csv'
    }

    for table_name, filename in tables.items():
        csv_file = os.path.join(CLEAN_DIR, filename)
        df = pd.read_csv(csv_file)
        df.to_sql(table_name, conn, if_exists='replace', index=False)
        print(f"  -> Created SQL Table: [{table_name}] ({len(df):,} rows)")

    # Build primary & foreign key index structures for optimal query execution
    print("\nCreating SQL Index Structures for Fast Joins...")
    cursor = conn.cursor()
    indexes = [
        "CREATE INDEX idx_orders_order_id ON orders(order_id);",
        "CREATE INDEX idx_orders_customer_id ON orders(customer_id);",
        "CREATE INDEX idx_orders_status ON orders(order_status);",
        "CREATE INDEX idx_items_order_id ON order_items(order_id);",
        "CREATE INDEX idx_items_product_id ON order_items(product_id);",
        "CREATE INDEX idx_items_seller_id ON order_items(seller_id);",
        "CREATE INDEX idx_payments_order_id ON order_payments(order_id);",
        "CREATE INDEX idx_reviews_order_id ON order_reviews(order_id);",
        "CREATE INDEX idx_customers_customer_id ON customers(customer_id);",
        "CREATE INDEX idx_customers_unique_id ON customers(customer_unique_id);",
        "CREATE INDEX idx_products_product_id ON products(product_id);",
        "CREATE INDEX idx_sellers_seller_id ON sellers(seller_id);"
    ]
    for idx_sql in indexes:
        cursor.execute(idx_sql)
    conn.commit()
    conn.close()
    print(f"  -> SQLite Database successfully generated: {db_path}")


if __name__ == '__main__':
    clean_orders()
    clean_order_items()
    clean_products()
    clean_order_payments()
    clean_order_reviews()
    clean_customers()
    clean_sellers()
    build_sqlite_database()
    print("\n" + "=" * 70)
    print("PHASE 2 DATA CLEANING & TRANSFORMATION PIPELINE COMPLETE!")
    print("=" * 70)

