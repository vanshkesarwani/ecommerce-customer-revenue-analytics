# Power BI Dashboard Architecture & Business Intelligence Suite

## E-Commerce Customer & Revenue Intelligence Analytics

This directory contains the data model specifications, DAX measure calculations, visual layout blueprints, and pixel-perfect screenshots for the **4-Page Power BI Executive Dashboard Suite**.

---

## 1. Directory Structure

```
powerbi/
├── data_model_specification.md      # Kimball Star Schema architecture, table relationships & cardinality
├── dax_measures.dax                 # Master library of 25+ production DAX measures
├── dashboard_wireframes_and_guide.md # Layout grid, color palette & step-by-step visual build instructions
├── screenshots/                     # Pixel-perfect 16:9 widescreen exports of all 4 dashboard pages
│   ├── 01_executive_overview.png
│   ├── 02_revenue_analysis.png
│   ├── 03_customer_intelligence.png
│   └── 04_product_performance.png
└── README.md                        # Power BI module overview & quick reference
```

---

## 2. Power BI Reporting Pages Overview

| Page # | Title | Target Audience | Primary Focus |
|---|---|---|---|
| **Page 1** | **Executive Overview** | CEO, CCO, VP of Sales | High-level GMV pulse, orders, AOV, top categories, and state geographic concentration. |
| **Page 2** | **Revenue Analysis & Payments** | CFO, Finance, Category Leads | MoM growth rate (%), payment method split (75.6% Credit Card), installment depth (avg 3.5x). |
| **Page 3** | **Customer Intelligence & RFM** | CMO, Retention & CRM Leads | RFM segment breakdown, repeat purchase rate (3.0%), 30-day repurchase window, cohort decay. |
| **Page 4** | **Product Performance & Logistics** | COO, Supply Chain & Logistics | Category GMV vs volume, bulky shipping delays, delivery SLA vs CSAT rating impact. |

---

## 3. Data Model Architecture (Kimball Star Schema)

The model is built on an enterprise Kimball Star Schema with **1-to-Many single-directional filter propagation**:

- **Fact Tables:**
  - `Fact_Orders` (Central order grain)
  - `Fact_OrderItems` (Line-item sales & freight grain)
  - `Fact_Payments` (Payment method & installment grain)
- **Dimension Tables:**
  - `Dim_Customers` (`customer_id`, `customer_unique_id`, state, city)
  - `Dim_Products` (`product_id`, category in English, dimensions, weight)
  - `Dim_Sellers` (`seller_id`, state, city)
  - `Dim_Reviews` (`order_id`, review score, sentiment)
  - `Dim_RFMSegments` (`customer_unique_id`, segment name, R/F/M scores)
  - `Dim_Date` (Calendar hierarchy: Year, Quarter, Month, Weekday)

Refer to [`data_model_specification.md`](data_model_specification.md) for full relationship definitions and [`dax_measures.dax`](dax_measures.dax) for formulas.

