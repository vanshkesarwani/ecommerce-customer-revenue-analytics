# Dataset Directory & Data Architecture

## Brazilian E-Commerce Public Dataset by Olist

This directory houses the raw and cleaned transaction datasets supporting the **E-Commerce Customer & Revenue Intelligence Analytics** project.

- **Primary Source:** [Kaggle - Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
- **Scope:** ~100,000 real marketplace orders placed between September 2016 and October 2018 across Brazil.
- **Currency:** Brazilian Real (BRL / R$)

---

## 1. Raw Dataset Breakdown (`dataset/`)

The raw dataset comprises 9 relational CSV files reflecting Olist's multi-sided marketplace operations:

| File Name | Approx Rows | Description |
|---|---|---|
| `olist_orders_dataset.csv` | 99,441 | Core order transactional log with order statuses and milestone timestamps. |
| `olist_order_items_dataset.csv` | 112,650 | Line-item level details including product IDs, seller IDs, item prices, and freight fees. |
| `olist_order_payments_dataset.csv` | 103,886 | Payment transaction records including payment types, installments, and payment values. |
| `olist_order_reviews_dataset.csv` | 99,224 | Customer satisfaction surveys with rating scores (1–5) and optional text reviews. |
| `olist_customers_dataset.csv` | 99,441 | Customer geographic metadata with distinct order-level `customer_id` and unique human `customer_unique_id`. |
| `olist_products_dataset.csv` | 32,951 | Product catalog attributes, category names (in Portuguese), physical dimensions, and photos count. |
| `olist_sellers_dataset.csv` | 3,095 | Merchant master data including seller IDs, cities, and states. |
| `olist_geolocation_dataset.csv` | 1,000,163 | Brazilian zip code prefixes, latitude/longitude coordinates, and city mappings. |
| `product_category_name_translation.csv` | 71 | Translation crosswalk mapping Portuguese category names to English. |

---

## 2. Cleaned & Feature-Engineered Datasets (`dataset/cleaned/`)

The cleaned datasets are produced deterministically by running [`notebooks/01_data_cleaning.py`](../notebooks/01_data_cleaning.py). All raw anomalies, null values, and string timestamps are resolved without modifying raw source files.

| Cleaned File | Row Count | Key Enhancements & Engineered Features |
|---|---|---|
| `orders_cleaned.csv` | 99,441 | Parsed 5 datetime columns; engineered 10 lead-time and calendar metrics (`delivery_days`, `is_delayed`, `delay_days`, `order_year_month`, etc.). |
| `order_items_cleaned.csv` | 112,650 | Engineered `total_item_value` (`price` + `freight_value`) and `freight_ratio`. |
| `order_payments_cleaned.csv` | 103,883 | Filtered 3 zero-value `not_defined` records; engineered `installment_bracket` (1x, 2-3x, 4-6x, 7-10x, 11-24x) and `is_installment` flag. |
| `products_cleaned.csv` | 32,951 | Translated Portuguese categories to clean English; mapped missing categories; imputed missing physical dimensions with category medians. |
| `customers_cleaned.csv` | 99,441 | Standardized city names, capitalized text strings, and preserved 96,096 distinct `customer_unique_id` values. |
| `sellers_cleaned.csv` | 3,095 | Standardized merchant locations and cleaned zip prefixes. |
| `order_reviews_cleaned.csv` | 99,224 | Imputed null review comments with standard placeholders; categorized scores into `sentiment` bins (Positive, Neutral, Negative). |
| `rfm_customer_segments.csv` | 93,358 | Calculated Recency, Frequency, and Monetary metrics for all delivered customers; assigned 1–5 quantile scores and 9 behavioral segment labels. |
| `olist_analytics.db` | -- | Single-file embedded SQLite relational database with primary keys and indexes. *(Gitignored due to GitHub's 100 MB limit; generated via cleaning script).* |

---

## 3. How to Re-generate Cleaned Datasets

To re-run the end-to-end cleaning and feature engineering pipeline from source:

```bash
python notebooks/01_data_cleaning.py
```
This script reads the raw CSVs, performs all transformations, writes the clean CSVs to `dataset/cleaned/`, and rebuilds the SQLite database `olist_analytics.db`.

