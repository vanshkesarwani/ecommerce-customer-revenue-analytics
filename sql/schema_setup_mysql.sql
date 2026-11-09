-- =============================================================================
-- E-Commerce Customer & Revenue Intelligence Analytics
-- Phase 4: MySQL Database Schema Setup (DDL)
-- Target: MySQL 8.0+ / MariaDB / Cloud Relational Database
-- =============================================================================

-- 1. Create Dedicated Project Database
CREATE DATABASE IF NOT EXISTS olist_ecommerce;
USE olist_ecommerce;

-- 2. Drop Tables if they exist (in reverse dependency order)
DROP TABLE IF EXISTS rfm_segments;
DROP TABLE IF EXISTS order_reviews;
DROP TABLE IF EXISTS order_payments;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS sellers;
DROP TABLE IF EXISTS customers;

-- -----------------------------------------------------------------------------
-- Table 1: Customers Dimension
-- -----------------------------------------------------------------------------
CREATE TABLE customers (
    customer_id VARCHAR(32) NOT NULL,
    customer_unique_id VARCHAR(32) NOT NULL,
    customer_zip_code_prefix INT NOT NULL,
    customer_city VARCHAR(100) NOT NULL,
    customer_state CHAR(2) NOT NULL,
    PRIMARY KEY (customer_id),
    INDEX idx_customer_unique (customer_unique_id),
    INDEX idx_customer_state (customer_state)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------------------------------
-- Table 2: Products Dimension
-- -----------------------------------------------------------------------------
CREATE TABLE products (
    product_id VARCHAR(32) NOT NULL,
    product_category_name VARCHAR(100),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g DECIMAL(10,2),
    product_length_cm DECIMAL(10,2),
    product_height_cm DECIMAL(10,2),
    product_width_cm DECIMAL(10,2),
    product_category_name_english VARCHAR(100),
    category_clean VARCHAR(100),
    PRIMARY KEY (product_id),
    INDEX idx_category_clean (category_clean)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------------------------------
-- Table 3: Sellers Dimension
-- -----------------------------------------------------------------------------
CREATE TABLE sellers (
    seller_id VARCHAR(32) NOT NULL,
    seller_zip_code_prefix INT NOT NULL,
    seller_city VARCHAR(100) NOT NULL,
    seller_state CHAR(2) NOT NULL,
    PRIMARY KEY (seller_id),
    INDEX idx_seller_state (seller_state)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------------------------------
-- Table 4: Orders Central Fact Table
-- -----------------------------------------------------------------------------
CREATE TABLE orders (
    order_id VARCHAR(32) NOT NULL,
    customer_id VARCHAR(32) NOT NULL,
    order_status VARCHAR(20) NOT NULL,
    order_purchase_timestamp DATETIME NOT NULL,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME NOT NULL,
    purchase_year INT NOT NULL,
    purchase_month INT NOT NULL,
    purchase_year_month CHAR(7) NOT NULL,
    purchase_day_name VARCHAR(15) NOT NULL,
    purchase_hour INT NOT NULL,
    delivery_lead_time_days DECIMAL(10,2),
    estimated_lead_time_days DECIMAL(10,2),
    delivery_delay_days DECIMAL(10,2),
    delivery_performance VARCHAR(30) NOT NULL,
    is_late TINYINT NOT NULL,
    PRIMARY KEY (order_id),
    INDEX idx_order_customer (customer_id),
    INDEX idx_order_status (order_status),
    INDEX idx_order_purchase_ts (order_purchase_timestamp),
    INDEX idx_order_ym (purchase_year_month),
    CONSTRAINT fk_orders_customers FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------------------------------
-- Table 5: Order Items Fact Table
-- -----------------------------------------------------------------------------
CREATE TABLE order_items (
    order_id VARCHAR(32) NOT NULL,
    order_item_id INT NOT NULL,
    product_id VARCHAR(32) NOT NULL,
    seller_id VARCHAR(32) NOT NULL,
    shipping_limit_date DATETIME NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    freight_value DECIMAL(10,2) NOT NULL,
    total_item_value DECIMAL(10,2) NOT NULL,
    freight_ratio DECIMAL(10,4) NOT NULL,
    PRIMARY KEY (order_id, order_item_id),
    INDEX idx_item_product (product_id),
    INDEX idx_item_seller (seller_id),
    CONSTRAINT fk_items_orders FOREIGN KEY (order_id) REFERENCES orders(order_id),
    CONSTRAINT fk_items_products FOREIGN KEY (product_id) REFERENCES products(product_id),
    CONSTRAINT fk_items_sellers FOREIGN KEY (seller_id) REFERENCES sellers(seller_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------------------------------
-- Table 6: Order Payments Fact Table
-- -----------------------------------------------------------------------------
CREATE TABLE order_payments (
    order_id VARCHAR(32) NOT NULL,
    payment_sequential INT NOT NULL,
    payment_type VARCHAR(20) NOT NULL,
    payment_installments INT NOT NULL,
    payment_value DECIMAL(10,2) NOT NULL,
    payment_type_clean VARCHAR(30) NOT NULL,
    installment_bracket VARCHAR(30) NOT NULL,
    is_installment TINYINT NOT NULL,
    PRIMARY KEY (order_id, payment_sequential),
    INDEX idx_payment_type (payment_type_clean),
    CONSTRAINT fk_payments_orders FOREIGN KEY (order_id) REFERENCES orders(order_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------------------------------
-- Table 7: Order Reviews Fact Table
-- -----------------------------------------------------------------------------
CREATE TABLE order_reviews (
    review_id VARCHAR(32) NOT NULL,
    order_id VARCHAR(32) NOT NULL,
    review_score INT NOT NULL,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date DATETIME NOT NULL,
    review_answer_timestamp DATETIME NOT NULL,
    has_comment TINYINT NOT NULL,
    sentiment_group VARCHAR(30) NOT NULL,
    PRIMARY KEY (review_id, order_id),
    INDEX idx_review_order (order_id),
    INDEX idx_review_score (review_score),
    CONSTRAINT fk_reviews_orders FOREIGN KEY (order_id) REFERENCES orders(order_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------------------------------
-- Table 8: RFM Customer Segments (Derived Dimension)
-- -----------------------------------------------------------------------------
CREATE TABLE rfm_segments (
    customer_unique_id VARCHAR(32) NOT NULL,
    Recency INT NOT NULL,
    Frequency INT NOT NULL,
    Monetary DECIMAL(10,2) NOT NULL,
    R_score INT NOT NULL,
    M_score INT NOT NULL,
    F_score INT NOT NULL,
    Customer_Segment VARCHAR(50) NOT NULL,
    PRIMARY KEY (customer_unique_id),
    INDEX idx_rfm_segment (Customer_Segment)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

