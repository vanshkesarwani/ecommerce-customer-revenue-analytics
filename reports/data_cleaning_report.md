# Phase 2: Data Cleaning, Quality Audit & Feature Engineering Report

## Project: E-Commerce Customer & Revenue Intelligence Analytics
**Analyst:** Vansh Kesarwani  
**Dataset:** Olist Brazilian E-Commerce Public Dataset (Kaggle)  
**Deliverable:** Technical Data Audit, Imputation Log & Transformation Documentation  

---

## 1. Executive Summary

This report documents the end-to-end data preparation, cleaning, quality assurance, and feature engineering pipeline implemented in **Phase 2**. 

Raw e-commerce datasets are messy: they contain inconsistent text encodings, missing category mappings, null timestamps for non-delivered orders, and payment anomalies. The primary mandate of this phase was to transform **~100,000 raw operational records** into a clean, normalized, analysis-ready data warehouse stored in [`dataset/cleaned/`](file:///Users/vanshkesarwanii/project/dataset/cleaned/) without altering or corrupting the original raw source files.

---

## 2. Table-by-Table Data Audit & Quality Scorecard

| Table Name | Raw Rows | Clean Rows | Raw Columns | Clean Columns | Missing Values Handled | Key Cleaning Action |
|---|---|---|---|---|---|---|
| **`orders`** | 99,441 | 99,441 | 8 | 18 | Null delivery dates on non-delivered orders | Converted 5 timestamp strings to datetimes; engineered 10 delivery lead time & time intelligence columns. |
| **`order_items`** | 112,650 | 112,650 | 7 | 9 | 0 nulls | Parsed shipping limit date; calculated `total_item_value` and `freight_ratio`. |
| **`order_payments`** | 103,886 | 103,883 | 5 | 8 | 3 `not_defined` records | Filtered 3 zero-value undefined artifacts; categorized `installment_bracket` and `is_installment`. |
| **`products`** | 32,951 | 32,951 | 9 | 11 | 610 missing categories, 2 missing dimensions | Mapped Portuguese categories to English; resolved 2 unmapped categories; imputed dimension nulls with medians. |
| **`customers`** | 99,441 | 99,441 | 5 | 5 | 0 nulls | Standardized city text to Title Case; validated state codes; preserved `customer_unique_id`. |
| **`sellers`** | 3,095 | 3,095 | 4 | 4 | 0 nulls | Standardized city names to Title Case; validated 2-letter state codes. |
| **`order_reviews`** | 99,224 | 99,224 | 7 | 9 | 87,656 null titles, 58,247 null comments | Imputed null comments with empty strings; engineered `has_comment` flag and `sentiment_group`. |

---

## 3. Data Anomalies Identified & Business Justifications

### Anomaly 1: The Dual Customer Identifier Nuance (`customer_id` vs `customer_unique_id`)
- **Discovery:** In `olist_customers_dataset.csv`, there are 99,441 rows of `customer_id`, but only 96,096 distinct `customer_unique_id` values.
- **Root Cause:** Olist issues a new `customer_id` as an order-level proxy token every time a buyer places an order. The underlying human buyer is identified by `customer_unique_id`.
- **Business Resolution:** Preserved both columns. In SQL and Python modeling, all customer retention, repeat purchase rates, and lifetime spend calculations group strictly by `customer_unique_id`.

### Anomaly 2: Null Delivery Dates in Orders Table
- **Discovery:** 2,965 orders lacked `order_delivered_customer_date`.
- **Root Cause Audit:** Cross-referencing against `order_status` revealed that 2,957 of these orders were legitimately undelivered (`shipped`, `canceled`, `unavailable`, `processing`, or `invoiced`). Only 8 orders with status `delivered` lacked a delivery timestamp.
- **Business Resolution:** Rather than blindly dropping 2,965 rows (which would corrupt order status tracking and operational fulfillment funnels), rows were retained and classified into a derived `delivery_performance` category:
  - `On-Time` (88,644 orders)
  - `Late` (7,826 orders)
  - `Not Delivered` (2,963 orders)
  - `Delivered (Missing Date)` (8 orders)

### Anomaly 3: Missing Categories in Product Translation Table
- **Discovery:** Two product categories present in `olist_products_dataset.csv` were completely missing from Kaggle’s `product_category_name_translation.csv`:
  1. `portateis_cozinha_e_preparadores_de_alimentos` (15 products)
  2. `pc_gamer` (9 products)
- **Business Resolution:** Rather than allowing these products to become `NaN` in English reporting, custom translation overrides were engineered:
  - `portateis_cozinha_e_preparadores_de_alimentos` $\rightarrow$ `kitchen_and_food_preparers`
  - `pc_gamer` $\rightarrow$ `pc_gamer`
  - 610 products with missing Portuguese categories were labeled `other_unknown`.
  - All category strings were transformed into clean Title Case (`category_clean`) for executive presentation.

### Anomaly 4: Zero-Value Undefined Payment Records
- **Discovery:** In `olist_order_payments_dataset.csv`, 3 records had `payment_type = 'not_defined'` with `payment_value = 0.0`.
- **Root Cause:** Failed checkout sessions or test tokens recorded by the gateway.
- **Business Resolution:** Filtered out the 3 records (0.002% of data), reducing payment rows from 103,886 to 103,883.

### Anomaly 5: Null Review Comments
- **Discovery:** 87,656 reviews had null comment titles, and 58,247 had null comment messages.
- **Root Cause:** Providing written feedback is optional; most customers submit only a 1-to-5 star rating.
- **Business Resolution:** Replaced null strings with empty text strings `""` and created a boolean feature `has_comment` (1 if comment present, 0 if star rating only).

---

## 4. Derived Feature Engineering Dictionary

| Feature Name | Target Table | Data Type | Formula / Logic | Business Analytical Role |
|---|---|---|---|---|
| `delivery_lead_time_days` | `orders` | Float | `(order_delivered_customer_date - order_purchase_timestamp) / 86400` | Measures actual customer delivery wait time. |
| `estimated_lead_time_days`| `orders` | Float | `(order_estimated_delivery_date - order_purchase_timestamp) / 86400` | Measures promised delivery turnaround. |
| `delivery_delay_days` | `orders` | Float | `(order_delivered_customer_date - order_estimated_delivery_date) / 86400` | $>0$ means late delivery; $\le 0$ means on-time delivery. |
| `delivery_performance` | `orders` | String | `CASE WHEN actual <= promised THEN 'On-Time' ELSE 'Late'` | Categorizes logistics SLA fulfillment. |
| `is_late` | `orders` | Integer | `1 if delivery_performance == 'Late' else 0` | Binary indicator for late delivery modeling. |
| `purchase_year_month` | `orders` | String | `strftime('%Y-%m', order_purchase_timestamp)` | Month-over-Month time intelligence slicing. |
| `purchase_day_name` | `orders` | String | Day name (Monday, Tuesday, etc.) | Day-of-week purchasing pattern analysis. |
| `purchase_hour` | `orders` | Integer | Hour of day (0–23) | Peak shopping hours optimization. |
| `total_item_value` | `order_items` | Float | `price + freight_value` | Gross checkout expenditure per item. |
| `freight_ratio` | `order_items` | Float | `freight_value / price` | Measures freight cost burden on merchandise. |
| `category_clean` | `products` | String | English category in Title Case without underscores | Clean dimension for BI charts and executive slicers. |
| `installment_bracket` | `order_payments`| String | `1x`, `2x-3x`, `4x-6x`, `7x-10x`, `11x-24x` | Consumer financing depth segmentation. |
| `sentiment_group` | `order_reviews` | String | `Positive (4-5 Stars)`, `Neutral (3 Stars)`, `Negative (1-2 Stars)` | CSAT sentiment classification. |

---

## 5. Storage & Database Staging Verification

All cleaned datasets were exported into two distinct formats:
1. **Clean CSV Directory:** [`dataset/cleaned/`](file:///Users/vanshkesarwanii/project/dataset/cleaned/) for direct import into Power BI Desktop or external Python analytics.
2. **Centralized SQLite Database:** [`dataset/cleaned/olist_analytics.db`](file:///Users/vanshkesarwanii/project/dataset/cleaned/olist_analytics.db) with B-Tree indexes created on `order_id`, `customer_id`, `customer_unique_id`, `product_id`, and `seller_id` for instant query execution.

