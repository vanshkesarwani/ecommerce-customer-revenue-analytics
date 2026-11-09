# Phase 3: Customer & Revenue Intelligence Analysis Report

## Project: E-Commerce Customer & Revenue Intelligence Analytics
**Analyst:** Vansh Kesarwani  
**Dataset:** Olist Brazilian E-Commerce Dataset (Kaggle)  
**Deliverable:** Comprehensive Commercial Insights & Strategic Recommendations Report  

---

## Executive Summary

This report presents a thorough customer and revenue intelligence analysis of the Olist marketplace across **96,478 delivered orders** and **93,358 unique customers** from September 2016 through August 2018.

Over this analysis window, Olist generated **R$ 13.22 Million in Gross Merchandise Value (GMV)** and **R$ 2.20 Million in freight fees**, representing **R$ 15.42 Million in total customer cash inflow**. However, our behavioral and financial analysis reveals that Olist operates primarily as a **top-of-funnel customer acquisition engine with a severe retention deficit**:
- **97.0%** of all buyers purchased only once and never returned.
- Cohort retention drops to an average of **0.49% in Month 1** and **0.25% in Month 3**.
- A small cohort of high-value buyers (**Potential Loyalists** and **At-Risk customers**) accounts for **56.3% of total marketplace revenue**.

---

## 1. Core Financial & Customer Scorecard

| KPI Metric | Value (BRL / Units) | Benchmark / Analytical Meaning |
|---|---|---|
| **Gross Merchandise Value (GMV)** | **R$ 13,221,498.11** | Pure product revenue confirmed and fulfilled. |
| **Total Freight Inflow** | **R$ 2,198,275.64** | Delivery fees collected from consumers. |
| **Total Customer Spend** | **R$ 15,419,773.75** | Total gross checkout value processed (GMV + Shipping). |
| **Total Delivered Orders** | **96,478** | Confirmed delivered transactions (97.0% fulfillment rate). |
| **Total Unique Customers** | **93,358** | Distinct individual human buyers (`customer_unique_id`). |
| **Average Order Value (AOV)** | **R$ 137.04** | Average merchandise value per order. |
| **Average Revenue Per Customer (ARPC)** | **R$ 141.62** | Lifetime merchandise revenue per customer (ARPC $\approx$ AOV). |
| **Average Basket Depth** | **1.14 items** | Shallow basket size; minimal cross-seller multi-item checkout. |
| **Freight-to-Price Ratio** | **16.63%** | Shipping represents 16.63% of product purchase value. |
| **Repeat Purchase Rate** | **3.00%** | Only 2,801 out of 93,358 customers ordered 2 or more times. |

---

## 2. Monthly Revenue Trajectory & Seasonality

Olist experienced rapid commercial expansion between January 2017 and November 2017, followed by a stabilized high-volume run-rate through 2018:
- **Launch to Growth (Q1–Q3 2017):** Monthly GMV grew from **R$ 111.8k in Jan 2017** to **R$ 648.2k in Oct 2017** (+479% expansion).
- **The Black Friday Record Peak (Nov 2017):** Revenue surged by **+52.4% MoM** to **R$ 987,765.37** across **7,289 completed orders**, marking the single highest-grossing month in company history.
- **2018 Maturity Plateau:** From January 2018 through August 2018, revenue stabilized at an average of **~R$ 880,000 / month** (peak in May 2018 for Mother's Day at **R$ 977,544.69**).

---

## 3. Product Category Concentration (The Pareto Principle)

Revenue is heavily concentrated within a few core product pillars:
- The **Top 5 categories** generate **39.8% (~R$ 5.27M)** of total revenue.
- The **Top 10 categories** account for **62.5% (~R$ 8.25M)** of total revenue.

| Category Name (English) | Total GMV (BRL) | Units Sold | Share of GMV (%) | Average Unit Price (BRL) |
|---|---|---|---|---|
| **Health Beauty** | R$ 1,233,131.72 | 9,465 | 9.33% | R$ 130.28 |
| **Watches Gifts** | R$ 1,166,176.98 | 5,859 | 8.82% | R$ 199.04 |
| **Bed Bath Table** | R$ 1,023,434.76 | 10,953 | 7.74% | R$ 93.44 |
| **Sports Leisure** | R$ 954,852.55 | 8,431 | 7.22% | R$ 113.25 |
| **Computers Accessories** | R$ 888,724.61 | 7,644 | 6.72% | R$ 116.26 |
| **Furniture Decor** | R$ 711,927.69 | 8,160 | 5.38% | R$ 87.25 |
| **Housewares** | R$ 615,628.69 | 6,795 | 4.66% | R$ 90.60 |
| **Cool Stuff** | R$ 610,204.10 | 3,718 | 4.62% | R$ 164.12 |
| **Auto** | R$ 578,966.65 | 4,140 | 4.38% | R$ 139.85 |
| **Toys** | R$ 471,286.48 | 4,030 | 3.56% | R$ 116.94 |

---

## 4. RFM Customer Segmentation Analysis

Using **Recency (R)**, **Frequency (F)**, and **Monetary (M)** modeling, we segmented Olist's 93,358 customers into 9 distinct commercial segments:

| Customer Segment | Customer Count | Customer Share (%) | Avg Recency (Days) | Avg Spend (BRL) | Total GMV Contributed (BRL) | Revenue Share (%) |
|---|---|---|---|---|---|---|
| **Potential Loyalists** | 21,191 | 22.7% | 91 | R$ 211.21 | R$ 4,475,844.17 | **33.9%** |
| **At Risk** | 7,412 | 7.9% | 401 | R$ 399.80 | R$ 2,963,283.36 | **22.4%** |
| **Need Attention** | 10,376 | 11.1% | 221 | R$ 196.66 | R$ 2,040,546.62 | 15.4% |
| **Lost Customers** | 22,412 | 24.0% | 386 | R$ 62.45 | R$ 1,399,654.92 | 10.6% |
| **Hibernating** | 14,568 | 15.6% | 316 | R$ 76.30 | R$ 1,111,588.13 | 8.4% |
| **Loyal Customers** | 1,429 | 1.5% | 232 | R$ 221.82 | R$ 316,977.97 | 2.4% |
| **Champions** | 937 | 1.0% | 89 | R$ 327.09 | R$ 306,481.81 | 2.3% |
| **New Customers** | 7,601 | 8.1% | 44 | R$ 40.22 | R$ 305,689.89 | 2.3% |
| **Promising** | 7,432 | 8.0% | 136 | R$ 40.56 | R$ 301,431.24 | 2.3% |

### Critical RFM Takeaway:
The **Potential Loyalists (33.9%)** and **At-Risk (22.4%)** segments together drive **56.3% of all marketplace revenue**. Meanwhile, *Champions* and *Loyal Customers* represent less than **5% of revenue**, showing that Olist lacks an established VIP retention flywheel.

---

## 5. Cohort Retention Decay & Repeat Buyer Behavior

### Cohort Retention Matrix (2017 Acquisition Cohorts)

| Cohort Month | Cohort Size (M0) | Month 1 Retention | Month 2 Retention | Month 3 Retention | Month 6 Retention | Month 12 Retention |
|---|---|---|---|---|---|---|
| **2017-01** | 717 | 0.28% | 0.28% | 0.14% | 0.42% | 0.70% |
| **2017-02** | 1,628 | 0.18% | 0.31% | 0.12% | 0.25% | 0.12% |
| **2017-03** | 2,503 | 0.44% | 0.36% | 0.40% | 0.16% | 0.20% |
| **2017-04** | 2,256 | 0.62% | 0.22% | 0.18% | 0.35% | 0.04% |
| **2017-05** | 3,451 | 0.46% | 0.46% | 0.29% | 0.41% | 0.23% |
| **2017-06** | 3,037 | 0.49% | 0.40% | 0.43% | 0.36% | 0.16% |
| **2017-07** | 3,752 | 0.53% | 0.35% | 0.24% | 0.32% | 0.13% |
| **2017-08** | 4,057 | 0.69% | 0.35% | 0.27% | 0.30% | 0.12% |
| **2017-09** | 4,004 | 0.70% | 0.55% | 0.27% | 0.22% | — |
| **2017-10** | 4,329 | 0.72% | 0.25% | 0.09% | 0.21% | — |
| **2017-11** | 7,076 | 0.57% | 0.37% | 0.17% | 0.11% | — |
| **2017-12** | 5,338 | 0.21% | 0.28% | 0.34% | 0.17% | — |
| **Average** | — | **0.49%** | **0.35%** | **0.25%** | **0.26%** | **0.19%** |

### Repurchase Time-Lag Findings:
- For the 2,801 customers who made repeat purchases:
  - **Median Repurchase Lag:** **29.5 days (~1 month)**.
  - **Mean Repurchase Lag:** **79.2 days (~2.5 months)**.
  - **75th Percentile:** **121.5 days (~4 months)**.
- **The Golden Window:** If a buyer does not place a second order within **30 to 60 days**, the likelihood of repeat purchase drops below **0.3%**.

---

## 6. Ten Key Data-Driven Business Insights

1. **The Leaky Bucket Problem (97% Churn):** Only 3.0% of buyers ever place a second order. Olist relies almost entirely on expensive paid acquisition and marketplace discovery rather than customer lifetime loyalty.
2. **The Post-Purchase Churn Cliff:** Average Month-1 cohort retention is just **0.49%**, and drops to **0.25% by Month 3**, confirming that customers treat Olist as a one-time transactional utility.
3. **High-Value Churn Exposure (R$ 2.96M At Risk):** The *At-Risk* segment comprises 7,412 buyers with an average historical spend of **R$ 399.80** (nearly 3x the platform average) who have had zero activity for 400+ days.
4. **Shallow Baskets Limit Growth (1.14 items/order):** Over 85% of orders contain only a single item. Because different merchants fulfill separate items, customers avoid multi-item baskets to prevent paying stacked shipping fees.
5. **Significant Freight Friction (16.63% Freight-to-Price Ratio):** Customers pay an average of R$ 16.63 in shipping for every R$ 100 in merchandise. In remote regions, freight ratios exceed 30%, suppressing conversion and repeat orders.
6. **Heavy Geographic Concentration (66% Revenue in 3 States):** São Paulo (37.4%), Rio de Janeiro (13.2%), and Minas Gerais (11.9%) generate two-thirds of all marketplace revenue.
7. **Flagship Category Dependency (Top 5 = 40% GMV):** *Health Beauty*, *Watches Gifts*, *Bed Bath Table*, *Sports Leisure*, and *Computers Accessories* generate R$ 5.27M of the platform's R$ 13.2M GMV.
8. **High-Ticket Power of Watches & Gifts:** Despite selling 46% fewer units than *Bed Bath Table*, *Watches Gifts* generated 14% more revenue due to an average price of **R$ 199.04** vs. R$ 93.44.
9. **Credit Card Installment Reliance (74% GMV Share):** Over 74% of revenue is financed via credit cards, with more than half utilizing multi-month installments (up to 10x-12x without interest).
10. **The 30-Day Nurture Window:** Repeat purchases peak at **29.5 days**. Marketing campaigns executed after 90 days yield minimal customer re-engagement.

---

## 7. Actionable Business Recommendations & Implementation Roadmap

```
+-------------------------------------------------------------------------------+
|                       STRATEGIC ACTION MATRIX                                 |
+--------------------------------+----------------------------------------------+
| HIGH IMPACT / IMMEDIATE EFFORT | 1. Automated 30-Day Post-Delivery Nurture    |
|                                | 2. "At-Risk" High-Value Win-Back Campaign    |
+--------------------------------+----------------------------------------------+
| HIGH IMPACT / MEDIUM EFFORT    | 3. Smart Cross-Merchant Cart Bundling        |
|                                | 4. Free Shipping Subscriptions (Olist Prime) |
+--------------------------------+----------------------------------------------+
| STRATEGIC EXPANSION            | 5. Geographic Fulfillment Hubs (North/NE)    |
|                                | 6. Premium Category Spotlight (Health/Watch) |
+--------------------------------+----------------------------------------------+
```

### Recommendation 1: Launch an Automated 30-Day Post-Delivery Win-Back Flow
- **Target Audience:** All new buyers in the *Potential Loyalists* and *New Customers* segments.
- **Action:** Deliver an automated email/SMS sequence triggered 14 days and 28 days post-delivery (aligned with the 29.5-day median repurchase cycle) offering a time-limited 10% discount on complementary categories.
- **Expected Financial Impact:** Increasing Month-1 retention from **0.49% to 2.0%** would generate an estimated **~R$ 450,000 in incremental annual GMV**.

### Recommendation 2: High-Value "At-Risk" Reactivation Initiative
- **Target Audience:** The 7,412 buyers in the *At-Risk* segment (R$ 2.96M historical GMV, average ticket R$ 399.80).
- **Action:** Deploy targeted VIP reactivation campaigns featuring exclusive credits (e.g., "R$ 50 off your next order over R$ 250").
- **Expected Financial Impact:** Reactivating just 8% of this cohort would recover **~R$ 237,000 in high-margin merchandise revenue**.

### Recommendation 3: Solve the "Shallow Basket" Problem with Cross-Seller Cart Consolidation
- **Target Audience:** All checkout consumers.
- **Action:** Implement algorithms that recommend related items from the *same seller* at checkout (e.g., "Add matching pillowcases from this merchant for free combined shipping").
- **Expected Financial Impact:** Lifting average basket depth from **1.14 to 1.30 items** would increase Average Order Value (AOV) by **~14%**, generating over **R$ 1.8 Million in additional GMV** without increasing customer acquisition costs.

### Recommendation 4: Regional Shipping Subsidies & Fulfillment Expansion
- **Target Audience:** Underserved buyers in Northeast and North states.
- **Action:** Partner with regional 3PL carriers and establish micro-fulfillment hubs outside of São Paulo to reduce delivery lead times and lower freight-to-price ratios below 15%.
- **Expected Financial Impact:** Reduces cart abandonment and improves review scores by an estimated 0.3 to 0.5 stars in peripheral states.

### Recommendation 5: Category Focus on High-Margin, High-Ticket Leaders
- **Target Audience:** Merchant Acquisition & Marketplace Placement Teams.
- **Action:** Expand seller recruitment and homepage promotional placement for *Health & Beauty* (top revenue driver) and *Watches & Gifts* (highest unit ticket at R$ 199).
- **Expected Financial Impact:** Strengthens marketplace unit economics and increases average revenue per transaction.

---

## 8. Summary of Phase 3 Artifacts

- **Executive Report:** [`reports/customer_revenue_insights.md`](file:///Users/vanshkesarwanii/project/reports/customer_revenue_insights.md)
- **RFM Customer Segments Data:** [`dataset/cleaned/rfm_customer_segments.csv`](file:///Users/vanshkesarwanii/project/dataset/cleaned/rfm_customer_segments.csv)
- **High-Resolution Figures:**
  1. [`reports/figures/01_monthly_revenue_trend.png`](file:///Users/vanshkesarwanii/project/reports/figures/01_monthly_revenue_trend.png) (Monthly GMV & Order Volume)
  2. [`reports/figures/02_top_categories_performance.png`](file:///Users/vanshkesarwanii/project/reports/figures/02_top_categories_performance.png) (Top 10 Category Revenue vs Units)
  3. [`reports/figures/03_rfm_customer_segments.png`](file:///Users/vanshkesarwanii/project/reports/figures/03_rfm_customer_segments.png) (Customer Share vs Revenue Share by Segment)
  4. [`reports/figures/04_cohort_retention_heatmap.png`](file:///Users/vanshkesarwanii/project/reports/figures/04_cohort_retention_heatmap.png) (2017 Cohort Retention Heatmap)

