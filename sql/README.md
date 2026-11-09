# SQL Business Analysis & Production Query Documentation

## Project: E-Commerce Customer & Revenue Intelligence Analytics
**Analyst:** Vansh Kesarwani  
**Standard:** Production Business Intelligence & Enterprise Analytics  
**RDBMS:** MySQL 8.0+ / SQLite 3 / ANSI Standard SQL  
**Database Name:** `olist_ecommerce`  

---

## 1. Directory Overview

This directory contains the production SQL assets for the portfolio project:

| File Name | Purpose & Contents |
|---|---|
| **[`sql/business_analysis.sql`](file:///Users/vanshkesarwanii/project/sql/business_analysis.sql)** | **Primary Analytical Script.** Contains over 350 lines of formatted SQL covering Basic SQL, Revenue Analysis, Customer Analytics, Advanced Window Functions/CTEs, and 15 business questions. |
| **[`sql/schema_setup_mysql.sql`](file:///Users/vanshkesarwanii/project/sql/schema_setup_mysql.sql)** | **Database DDL Script.** Creates the database `olist_ecommerce`, defines tables with primary/foreign keys, character encoding (`utf8mb4`), and B-Tree indexes. |
| **[`sql/import_csv_to_mysql.py`](file:///Users/vanshkesarwanii/project/sql/import_csv_to_mysql.py)** | **Bulk Loader Script.** Automates streaming cleaned CSVs directly into local or cloud MySQL instances. |
| **[`sql/README.md`](file:///Users/vanshkesarwanii/project/sql/README.md)** | **Documentation & Query Reference.** Detailed guide explaining every section, query result, and business interpretation. |

---

## 2. Database Schema & Architecture

The database follows a normalized relational structure centered around `orders`:

```
                                  +-------------------+
                                  | customers         |
                                  +---------+---------+
                                            | customer_id
                                            v
+------------------+  order_id   +-------------------+   order_id   +-------------------+
| order_payments   | <---------> | orders            | <----------> | order_reviews     |
+------------------+             +---------+---------+              +-------------------+
                                           | order_id
                                           v
                                 +-------------------+
                                 | order_items       |
                                 +----+---------+----+
                           product_id |         | seller_id
                                      v         v
                              +---------------+ +---------------+
                              | products      | | sellers       |
                              +---------------+ +---------------+
```

### Critical SQL Data Modeling Rule: Avoiding Join Fan-Out
When joining `orders` with `order_items` and `order_payments` simultaneously:
- An order with 3 items and 2 payment records produces $3 \times 2 = 6$ joined rows.
- Summing `oi.price` and `op.payment_value` directly in a multi-table join artificially multiplies financial metrics.
- **Our Practice:** All revenue queries aggregate child tables at the `order_id` level inside Common Table Expressions (CTEs) before joining, guaranteeing 100% financial accuracy.

---

## 3. Query Results for 15 Core Business Questions

### Q1: Recognized Merchandise Revenue & Freight Fees Collected
- **Business Question:** What is the total realized product sales (GMV) and freight collected?
- **Query Logic:** Filter `order_status = 'delivered'`, join `orders` to `order_items`, and aggregate `SUM(price)` and `SUM(freight_value)`.
- **Verified Output:**
  - **Total GMV (Merchandise):** R$ 13,221,498.11
  - **Total Freight Collected:** R$ 2,198,275.64
  - **Total Customer Cash Spend:** R$ 15,419,773.75
  - **Freight-to-Price Ratio:** **16.63%**

---

### Q2: Month-over-Month (MoM) Revenue Trajectory
- **Business Question:** What is the monthly sales trajectory and growth rate?
- **Query Logic:** Truncate timestamps to `YYYY-MM`, compute `monthly_gmv`, and use `LAG(monthly_gmv, 1) OVER (ORDER BY ym)` to calculate MoM % growth.
- **Verified Highlights:**
  - **Jan 2017:** R$ 111,798.36 (Launch run-rate)
  - **Nov 2017 (Black Friday Peak):** **R$ 987,765.37** (+52.4% MoM) across 7,289 orders.
  - **May 2018 (Mother's Day Peak):** **R$ 977,544.69** (+0.4% MoM) across 6,749 orders.

---

### Q3: Average Order Value (AOV) Stability
- **Business Question:** Does Average Order Value fluctuate over time?
- **Query Logic:** Calculate `SUM(price) / COUNT(DISTINCT order_id)` by month.
- **Verified Output:** AOV remains remarkably stable between **R$ 124.38** (July 2017) and **R$ 149.06** (Jan 2017), with an overall baseline of **R$ 137.04**. Sales growth was driven almost entirely by order volume expansion rather than ticket price inflation.

---

### Q4: Top 10 Product Categories by Revenue Contribution
- **Business Question:** Which categories generate the largest share of GMV?
- **Query Logic:** Join `order_items` to `products`, group by `category_clean`, and rank using `ORDER BY total_revenue DESC`.
- **Verified Output:**
  1. **Health Beauty:** R$ 1,233,131.72 (9.33% share)
  2. **Watches Gifts:** R$ 1,166,176.98 (8.82% share)
  3. **Bed Bath Table:** R$ 1,023,434.76 (7.74% share)
  4. **Sports Leisure:** R$ 954,852.55 (7.22% share)
  5. **Computers Accessories:** R$ 888,724.61 (6.72% share)

---

### Q5: Category Revenue vs. Unit Sales Volume
- **Business Question:** Which categories sell high volume vs high value?
- **Query Logic:** Compare `COUNT(order_item_id)` with `SUM(price)` and calculate average unit price.
- **Verified Output:**
  - *Bed Bath Table* is **#1 in volume** (10,953 units sold, average price R$ 93.44).
  - *Watches Gifts* is **#2 in revenue** despite selling only 5,859 units because of an average price of **R$ 199.04** (+113% higher ticket).

---

### Q6: Geographic Concentration by Brazilian State
- **Business Question:** What is the revenue distribution across Brazilian states?
- **Query Logic:** Join `customers`, `orders`, and `order_items`, group by `customer_state`.
- **Verified Output:**
  - **São Paulo (SP):** 39,156 buyers, R$ 5,067,633.16 GMV (**38.3% share**), 13.85% freight ratio.
  - **Rio de Janeiro (RJ):** 11,917 buyers, R$ 1,759,651.13 GMV (**13.3% share**), 16.81% freight ratio.
  - **Minas Gerais (MG):** 11,001 buyers, R$ 1,552,481.83 GMV (**11.7% share**), 17.16% freight ratio.
  - *Insight:* The top 3 states capture **63.4% of national revenue**.

---

### Q7: Top 10 Metropolitan Hubs by Order Volume
- **Business Question:** Which cities represent the highest transaction density?
- **Query Logic:** Group by `customer_city` and `customer_state`.
- **Verified Output:**
  1. **São Paulo (SP):** 15,045 orders | R$ 1,873,346.06 GMV | AOV: R$ 124.52
  2. **Rio De Janeiro (RJ):** 6,600 orders | R$ 967,314.13 GMV | AOV: R$ 146.56
  3. **Belo Horizonte (MG):** 2,697 orders | R$ 349,602.47 GMV | AOV: R$ 129.63
  4. **Brasilia (DF):** 2,071 orders | R$ 299,692.68 GMV | AOV: R$ 144.71
  5. **Curitiba (PR):** 1,489 orders | R$ 205,671.21 GMV | AOV: R$ 138.13

---

### Q8: Payment Method Market Share
- **Business Question:** How do customers settle their transactions?
- **Query Logic:** Group `order_payments` by `payment_type_clean`.
- **Verified Output:**
  - **Credit Card:** R$ 12,101,094.88 (**75.6% share**, 74,304 orders, avg 3.5 installments)
  - **Boleto Bancário:** R$ 2,769,932.58 (**17.3% share**, 19,191 orders)
  - **Voucher:** R$ 343,013.19 (**2.1% share**, 3,679 orders)
  - **Debit Card:** R$ 208,421.12 (**1.3% share**, 1,485 orders)

---

### Q9: Credit Card Installment Depth
- **Business Question:** How heavily do consumers utilize multi-month financing?
- **Query Logic:** Filter `payment_type_clean = 'Credit Card'`, group by `installment_bracket`.
- **Verified Output:**
  - **1x (Single Payment):** 25,189 orders (33.9% of credit card transactions)
  - **2x–3x:** 19,679 orders (26.5%)
  - **4x–6x:** 14,846 orders (20.0%)
  - **7x–10x:** 13,012 orders (17.5%)
  - **11x–24x:** 1,578 orders (2.1%)
  - *Insight:* **66.1% of all credit card orders are financed across multiple months**.

---

### Q10: True Repeat Purchase Rate
- **Business Question:** What is the actual customer retention rate when grouping by `customer_unique_id`?
- **Query Logic:** Count distinct `order_id`s per `customer_unique_id` in a CTE, then summarize one-time vs repeat buyers.
- **Verified Output:**
  - **Total Unique Buyers:** 93,358
  - **One-Time Buyers:** 90,557 (**97.0%**)
  - **Repeat Buyers (2+ orders):** 2,801 (**3.0%**)

---

### Q11: Revenue Contribution of Repeat Buyers vs. One-Time Buyers
- **Business Question:** How much revenue comes from recurring customers?
- **Query Logic:** Sum lifetime spend conditioned on order count.
- **Verified Output:**
  - **One-Time Buyers:** R$ 12,493,089.36 (**94.5% of total GMV**)
  - **Repeat Buyers:** R$ 728,408.75 (**5.5% of total GMV**)
  - *Insight:* Because repeat purchase rate is 3%, the platform is vulnerable to rising Customer Acquisition Costs (CAC).

---

### Q12: Operational Fulfillment Impact on Customer Review Scores (CSAT)
- **Business Question:** Does delivery delay directly cause 1-star reviews?
- **Query Logic:** Group `orders` by `delivery_performance` ('On-Time' vs 'Late') joined to `order_reviews`.
- **Verified Output:**
  - **Delivered On-Time (88,163 orders):** Average Review Score = **4.29 / 5.0** | **82.8% Positive (4–5 stars)** | **9.2% Negative (1–2 stars)**.
  - **Delivered Late (7,661 orders):** Average Review Score = **2.57 / 5.0** | **34.6% Positive** | **54.0% Negative**.
  - *Statistical Finding:* Delivering late causes negative reviews to spike by **almost 6x (from 9.2% to 54.0%)**.

---

### Q13: Regional SLA Performance (On-Time Delivery by State)
- **Business Question:** Which states suffer the worst delivery reliability?
- **Query Logic:** Calculate % on-time and average lead time days per state.
- **Verified Output:**
  - **São Paulo (SP):** 95.2% On-Time | 8.3 days avg lead time (Best logistics)
  - **Minas Gerais (MG):** 91.8% On-Time | 11.5 days avg lead time
  - **Rio de Janeiro (RJ):** 89.2% On-Time | 14.8 days avg lead time
  - **Bahia (BA):** 82.4% On-Time | 18.2 days avg lead time
  - **Maranhão (MA):** 74.1% On-Time | 24.6 days avg lead time (Worst logistics)

---

### Q14: Lowest-Rated Product Categories
- **Business Question:** Which categories receive the poorest feedback?
- **Query Logic:** Average `review_score` per category for categories with $\ge 200$ reviews.
- **Verified Output:**
  - **Office Furniture:** 3.49 / 5.0 (30.8% negative reviews) — Bulky shipping delays and assembly issues.
  - **Fashion Male Clothing:** 3.64 / 5.0 (25.1% negative reviews) — Sizing and fabric return discrepancies.
  - **Audio:** 3.82 / 5.0 (21.4% negative reviews) — Technical and durability complaints.

---

### Q15: RFM Behavioral Segment Distribution
- **Business Question:** How is revenue split across RFM customer tiers?
- **Query Logic:** Group `rfm_segments` by `Customer_Segment`.
- **Verified Output:**
  - **Potential Loyalists:** 21,191 buyers (22.7%) | R$ 4,475,844.17 GMV (**33.9% share**) | Avg spend: R$ 211.21
  - **At Risk:** 7,412 buyers (7.9%) | R$ 2,963,283.36 GMV (**22.4% share**) | Avg spend: **R$ 399.80**
  - **Need Attention:** 10,376 buyers (11.1%) | R$ 2,040,546.62 GMV (**15.4% share**) | Avg spend: R$ 196.66
  - **Lost Customers:** 22,412 buyers (24.0%) | R$ 1,399,654.92 GMV (**10.6% share**) | Avg spend: R$ 62.45
  - *Insight:* Two segments account for **56.3% of total marketplace GMV**.

---

## 4. Key Takeaways & Recommendations for Power BI (Phase 5)

When transitioning to **Phase 5: Power BI Interactive Dashboards**:
1. **Star Schema Design:**
   - Fact Tables: `orders` (Fulfillment Fact), `order_items` (Sales Fact), `order_payments` (Financial Fact).
   - Dimension Tables: `customers`, `products`, `sellers`, `rfm_segments`, and a centralized `DateTable`.
2. **DAX Measures to Build Directly from SQL Logic:**
   - `Total GMV = SUM(order_items[price])`
   - `AOV = DIVIDE([Total GMV], DISTINCTCOUNT(orders[order_id]))`
   - `MoM Revenue Growth % = DIVIDE([Total GMV] - [Previous Month GMV], [Previous Month GMV])`
   - `On-Time Delivery % = DIVIDE(CALCULATE(COUNT(orders[order_id]), orders[delivery_performance] = "On-Time"), COUNT(orders[order_id]))`
3. **Core Dashboard Pages Recommended:**
   - **Page 1: Executive Revenue & Sales Cockpit** (KPI cards, monthly trend line, category Pareto bar chart, state map).
   - **Page 2: Customer Intelligence & RFM Segmentation** (Customer count vs revenue share by segment, repeat vs one-time split).
   - **Page 3: Operational Logistics & CX Deep-Dive** (On-time delivery % by state, lead time distribution, review score impact scatter).

