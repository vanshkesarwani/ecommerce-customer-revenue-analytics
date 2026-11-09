# Power BI Data Model Architecture & Star Schema Specification

## Project: E-Commerce Customer & Revenue Intelligence Analytics
**Analyst:** Vansh Kesarwani  
**Tool:** Power BI Desktop / Power BI Service  
**Architecture:** Kimball Star Schema Modeling Standard  

---

## 1. Relational Star Schema Architecture

To deliver sub-second report query performance and clean DAX calculations in Power BI, the normalized operational database is denormalized into a classic **Star Schema**:

```
                                  +-----------------------+
                                  | Dim_Date              |
                                  +-----------+-----------+
                                              | Date (1:*)
                                              v
+-----------------------+ order_id  +-------------------+  order_id  +------------------------+
| Fact_Payments         | <-------> | Fact_Orders       | <--------> | Dim_Reviews            |
+-----------------------+           +---------+---------+            +------------------------+
                                              | customer_id (1:*)
                                              v
+-----------------------+           +-------------------+            +------------------------+
| Dim_Customers         |           | Fact_OrderItems   |            | Dim_RFMSegments        |
+-----------+-----------+           +----+---------+----+            +-----------+------------+
            | customer_unique_id         |         |                             | customer_unique_id
            +----------------------------|---------|-----------------------------+
                              product_id |         | seller_id
                                         v         v
                   +---------------------+         +-------------------+
                   | Dim_Products        |         | Dim_Sellers       |
                   +---------------------+         +-------------------+
```

---

## 2. Table Specifications & Granularity

### Fact Tables (Business Activity Measurements)

| Table Name | Source File | Granularity (1 Row) | Primary / Composite Key | Key Business Metrics Contained |
|---|---|---|---|---|
| **`Fact_OrderItems`** | `order_items_cleaned.csv` | 1 item line in an order | (`order_id`, `order_item_id`) | `price`, `freight_value`, `total_item_value`, `freight_ratio` |
| **`Fact_Orders`** | `orders_cleaned.csv` | 1 customer order | `order_id` | `order_purchase_timestamp`, `delivery_lead_time_days`, `delivery_delay_days`, `is_late` |
| **`Fact_Payments`** | `order_payments_cleaned.csv` | 1 payment transaction | (`order_id`, `payment_sequential`) | `payment_value`, `payment_installments`, `is_installment` |

### Dimension Tables (Business Context & Filters)

| Table Name | Source File | Granularity (1 Row) | Primary Key | Descriptive Attributes |
|---|---|---|---|---|
| **`Dim_Customers`** | `customers_cleaned.csv` | 1 customer profile | `customer_id` | `customer_unique_id`, `customer_city`, `customer_state`, `customer_zip_code_prefix` |
| **`Dim_Products`** | `products_cleaned.csv` | 1 catalog SKU | `product_id` | `category_clean`, `product_category_name_english`, `product_weight_g`, `product_photos_qty` |
| **`Dim_Sellers`** | `sellers_cleaned.csv` | 1 registered merchant | `seller_id` | `seller_city`, `seller_state`, `seller_zip_code_prefix` |
| **`Dim_Reviews`** | `order_reviews_cleaned.csv` | 1 customer survey | (`review_id`, `order_id`) | `review_score`, `sentiment_group`, `has_comment`, `review_creation_date` |
| **`Dim_RFMSegments`**| `rfm_customer_segments.csv`| 1 unique human buyer | `customer_unique_id` | `Customer_Segment`, `R_score`, `F_score`, `M_score`, `Recency`, `Frequency`, `Monetary` |
| **`Dim_Date`** | DAX Generated Calendar | 1 calendar day | `Date` | `Year`, `MonthName`, `MonthNumber`, `YearMonth`, `Quarter`, `DayOfWeek`, `IsWeekend` |

---

## 3. Relationship Matrix & Cardinality

| From Table (Dimension / Parent) | Key Column | To Table (Fact / Child) | Key Column | Cardinality | Cross Filter Direction |
|---|---|---|---|---|---|
| `Dim_Date` | `Date` | `Fact_Orders` | `order_purchase_timestamp` | **1 to Many (1:\*)** | Single (`Dim_Date` $\rightarrow$ `Fact_Orders`) |
| `Dim_Customers` | `customer_id` | `Fact_Orders` | `customer_id` | **1 to Many (1:\*)** | Single (`Dim_Customers` $\rightarrow$ `Fact_Orders`) |
| `Fact_Orders` | `order_id` | `Fact_OrderItems` | `order_id` | **1 to Many (1:\*)** | Single (`Fact_Orders` $\rightarrow$ `Fact_OrderItems`) |
| `Fact_Orders` | `order_id` | `Fact_Payments` | `order_id` | **1 to Many (1:\*)** | Single (`Fact_Orders` $\rightarrow$ `Fact_Payments`) |
| `Fact_Orders` | `order_id` | `Dim_Reviews` | `order_id` | **1 to Many (1:\*)** | Both (Bi-directional for CSAT filtering) |
| `Dim_Products` | `product_id` | `Fact_OrderItems` | `product_id` | **1 to Many (1:\*)** | Single (`Dim_Products` $\rightarrow$ `Fact_OrderItems`) |
| `Dim_Sellers` | `seller_id` | `Fact_OrderItems` | `seller_id` | **1 to Many (1:\*)** | Single (`Dim_Sellers` $\rightarrow$ `Fact_OrderItems`) |
| `Dim_RFMSegments` | `customer_unique_id` | `Dim_Customers` | `customer_unique_id` | **1 to Many (1:\*)** | Single (`Dim_RFMSegments` $\rightarrow$ `Dim_Customers`) |

---

## 4. DAX Calendar Dimension Implementation

In Power BI Desktop, click **Modeling $\rightarrow$ New Table** and paste this standard corporate calendar formula:

```dax
Dim_Date = 
VAR _MinYear = 2016
VAR _MaxYear = 2018
VAR _StartDate = DATE(_MinYear, 1, 1)
VAR _EndDate = DATE(_MaxYear, 12, 31)
RETURN
    ADDCOLUMNS(
        CALENDAR(_StartDate, _EndDate),
        "Year", YEAR([Date]),
        "YearMonth", FORMAT([Date], "YYYY-MM"),
        "MonthName", FORMAT([Date], "MMM"),
        "MonthNumber", MONTH([Date]),
        "Quarter", "Q" & FORMAT([Date], "Q"),
        "QuarterYear", "Q" & FORMAT([Date], "Q") & " " & YEAR([Date]),
        "DayOfWeek", FORMAT([Date], "dddd"),
        "DayOfWeekNumber", WEEKDAY([Date], 2),
        "IsWeekend", IF(WEEKDAY([Date], 2) >= 6, "Weekend", "Weekday")
    )
```

> **Mark as Date Table:** In Power BI, right-click `Dim_Date` and select **Mark as Date Table** $\rightarrow$ select column `Date`. This unlocks all standard DAX Time Intelligence functions (`DATEADD`, `SAMEPERIODLASTYEAR`, `TOTALYTD`).

---

## 5. Measure Tables Configuration

Create dedicated empty tables to house DAX measures cleanly instead of burying them inside fact tables:
1. `_Measures_Financial` (GMV, Freight, Inflow, AOV, Basket Depth, Freight Ratio)
2. `_Measures_TimeIntelligence` (MoM GMV Growth, MoM Orders Growth, Running GMV)
3. `_Measures_Customer` (Unique Customers, Repeat Buyers, Repeat Rate %, ARPC)
4. `_Measures_Operations` (Avg Delivery Days, On-Time Orders, On-Time Rate %, Late Rate %)
5. `_Measures_CX` (CSAT Score, Review Counts, Positive/Negative Review %)

