# Power BI Dashboard Wireframes, Design Blueprint & Build Guide

## Project: E-Commerce Customer & Revenue Intelligence Analytics
**Analyst:** Vansh Kesarwani  
**Canvas Standard:** 16:9 Widescreen (1280 × 720 px)  
**Corporate Theme Palette:**
- Primary Brand Navy: `#1B365D`
- Secondary Steel Blue: `#2B5C8F`
- KPI Accent Green: `#10B981` / `#27AE60`
- Alert / Detractor Red: `#EF4444` / `#E74C3C`
- Warning / Installment Amber: `#D97706` / `#F59E0B`
- Canvas Background: `#F8F9FA`
- Visual Card Background: `#FFFFFF` (Border: 1px `#E5E7EB`, Shadow: Soft Bottom)

---

## Page 1: Executive Overview Dashboard

**Target Audience:** Chief Executive Officer (CEO), Chief Commercial Officer (CCO), VP of Sales  
**Objective:** High-level operational pulse monitoring revenue growth, order volume, average basket spend, and geographic density.

```
+----------------------------------------------------------------------------------------------------+
|  HEADER: E-Commerce Executive Overview & Revenue Intelligence                [Slicers: Year | State]|
+-------------------+--------------------+--------------------+--------------------------------------+
| TOTAL REVENUE     | DELIVERED ORDERS   | TOTAL BUYERS       | AVERAGE ORDER VALUE                  |
| R$ 13.22M         | 96,478             | 93,358             | R$ 137.04                            |
| +52.4% Nov Peak   | 97.0% Fulfilled    | 3.0% Repeat Rate   | Basket Depth: 1.14 items             |
+-------------------+--------------------+--------------------+--------------------------------------+
|                                                             |                                      |
|  VISUAL 1: Line & Clustered Column Chart                    |  VISUAL 2: Clustered Bar Chart       |
|  Monthly GMV Trajectory & Order Volume                      |  Top 5 Product Categories            |
|  (Jan 2017 - Aug 2018 with Black Friday Annotation)         |  (Health/Beauty, Watches, Bed/Bath)  |
|                                                             |                                      |
+-------------------------------------------------------------+--------------------------------------+
|                                                             |                                      |
|  VISUAL 3: Clustered Horizontal Bar / Filled Map            |  VISUAL 4: Executive Takeaway Card   |
|  Geographic Revenue Share by State                          |  Key Commercial Insights             |
|  (SP 38.3%, RJ 13.3%, MG 11.7%, RS 5.5%, PR 5.0%)           |  (Concentration, Churn & Logistics)  |
|                                                             |                                      |
+-------------------------------------------------------------+--------------------------------------+
```

### Visual-by-Visual Configuration Guide:

1. **Header & Slicers (Top Bar):**
   - **Text Box:** Title: `E-Commerce Executive Overview & Revenue Intelligence` (20pt Bold `#1B365D`).
   - **Slicer 1:** Field: `Dim_Date[Year]`. Style: Tile / Buttons or Dropdown.
   - **Slicer 2:** Field: `Dim_Customers[customer_state]`. Style: Dropdown (Multi-select enabled).
2. **KPI Card 1: Total Revenue (GMV):**
   - Visual Type: **Card (New)**
   - Measure: `_Measures_Financial[Total GMV]`
   - Display Units: Auto (shows `R$ 13.22M`). Subtitle: `+52.4% Nov Peak`. Accent border left: 4px `#1B365D`.
3. **KPI Card 2: Delivered Orders:**
   - Measure: `_Measures_Financial[Total Delivered Orders]`
   - Value: `96,478`. Subtitle: `97.0% Fulfilled`. Accent border left: 4px `#2B5C8F`.
4. **KPI Card 3: Total Customers:**
   - Measure: `_Measures_Customer[Total Unique Customers]`
   - Value: `93,358`. Subtitle: `3.00% Repeat Rate`. Accent border left: 4px `#27AE60`.
5. **KPI Card 4: Average Order Value (AOV):**
   - Measure: `_Measures_Financial[Average Order Value (AOV)]`
   - Value: `R$ 137.04`. Subtitle: `Basket Depth: 1.14 items`. Accent border left: 4px `#D97706`.
6. **Visual 1: Monthly Revenue Trajectory & Order Volume:**
   - Visual Type: **Line and Clustered Column Chart**
   - X-axis: `Dim_Date[YearMonth]`
   - Column Y-axis: `_Measures_Financial[Total GMV]` (Bar Color: `#2B5C8F`)
   - Line Y-axis: `_Measures_Financial[Total Delivered Orders]` (Line Color: `#E67E22`, Marker size: 5)
7. **Visual 2: Top Categories by GMV:**
   - Visual Type: **Clustered Bar Chart**
   - Y-axis: `Dim_Products[category_clean]` (Filter top 5)
   - X-axis: `_Measures_Financial[Total GMV]` (Bar Color: `#10B981`)
8. **Visual 3: Geographic Revenue Share:**
   - Visual Type: **Clustered Horizontal Bar Chart (or Filled Map)**
   - Y-axis: `Dim_Customers[customer_state]` (Filter top 5)
   - X-axis: `_Measures_Customer[Customer Revenue Share %]`
9. **Visual 4: Executive Insights Callout:**
   - Visual Type: **Card or Text Panel** summarizing key takeaways.

---

## Page 2: Revenue Analysis Dashboard

**Target Audience:** Chief Financial Officer (CFO), Head of Growth, Pricing Strategy Team  
**Objective:** Deconstruct revenue channels, evaluate Month-over-Month growth volatility, and analyze consumer payment financing.

```
+----------------------------------------------------------------------------------------------------+
|  HEADER: Revenue Dynamics & Payment Intelligence                    [Slicers: Category | Payment]  |
+-------------------+--------------------+--------------------+--------------------------------------+
| GROSS CASH INFLOW | FREIGHT FEES       | CREDIT CARD SHARE  | AVG INSTALLMENTS                     |
| R$ 15.42M         | R$ 2.20M           | 75.6%              | 3.5x                                 |
| GMV + Shipping    | 16.63% of GMV      | R$ 12.1M Volume    | 66.1% Multi-Month                    |
+-------------------+--------------------+--------------------+--------------------------------------+
|                                                             |                                      |
|  VISUAL 1: Clustered Column Chart                           |  VISUAL 2: Donut Chart               |
|  MoM GMV Growth % Trajectory                                |  Payment Method Market Share         |
|  (Green = Positive, Red = Negative Cooldown)                |  (Credit Card 75.6%, Boleto 17.3%)   |
|                                                             |                                      |
+-------------------------------------------------------------+--------------------------------------+
|                                                             |                                      |
|  VISUAL 3: Clustered Horizontal Bar Chart                   |  VISUAL 4: Matrix Grid               |
|  Credit Card Financing Depth                                |  Quarterly Financial Breakdown       |
|  (1x: 33.9%, 2x-3x: 26.5%, 4x-6x: 20%, 7x-10x: 17.5%)       |  (Quarter, Orders, GMV, Freight, AOV)|
|                                                             |                                      |
+-------------------------------------------------------------+--------------------------------------+
```

### Visual Configuration Details:
1. **Visual 1 (MoM Growth Bar Chart):**
   - X-axis: `Dim_Date[YearMonth]`
   - Y-axis: `_Measures_TimeIntelligence[MoM GMV Growth %]`
   - Conditional Formatting: Color green (`#10B981`) if $>0$, red (`#EF4444`) if $<0$.
2. **Visual 2 (Payment Method Share Donut):**
   - Legend: `Fact_Payments[payment_type_clean]`
   - Values: `SUM(Fact_Payments[payment_value])`
3. **Visual 3 (Installment Depth Bar Chart):**
   - Y-axis: `Fact_Payments[installment_bracket]`
   - X-axis: `DISTINCTCOUNT(Fact_Payments[order_id])`
   - Data labels enabled.
4. **Visual 4 (Financial Matrix):**
   - Rows: `Dim_Date[QuarterYear]`
   - Values: `[Total Delivered Orders]`, `[Total GMV]`, `[Total Freight]`, `[Average Order Value (AOV)]`.

---

## Page 3: Customer Intelligence Dashboard

**Target Audience:** Chief Marketing Officer (CMO), Retention / CRM Manager, Growth Lead  
**Objective:** Understand customer lifetime behavior, evaluate RFM behavioral segments, and quantify the churn crisis.

```
+----------------------------------------------------------------------------------------------------+
|  HEADER: Customer Intelligence & RFM Behavioral Segmentation         [Slicers: RFM Segment | State]|
+-------------------+--------------------+--------------------+--------------------------------------+
| TOTAL BUYERS      | REPEAT BUYERS      | POTENTIAL LOYALIST | AT-RISK GMV                          |
| 93,358            | 2,801              | 33.9%              | R$ 2.96M                             |
| Distinct Humans   | 3.00% Retention    | R$ 4.48M Revenue   | 7,412 Churned VIPs                   |
+-------------------+--------------------+--------------------+--------------------------------------+
|                                                             |                                      |
|  VISUAL 1: Clustered Bar Chart                              |  VISUAL 2: Clustered Bar Chart       |
|  Revenue Contribution by RFM Segment (%)                    |  Customer Base Share by Segment (%)  |
|  (Potential Loyalists 33.9%, At Risk 22.4%)                 |  (Lost 24%, Potential Loyalists 23%) |
|                                                             |                                      |
+-------------------------------------------------------------+--------------------------------------+
|                                                             |                                      |
|  VISUAL 3: Donut Chart                                      |  VISUAL 4: Callout Strategy Card     |
|  Repeat vs One-Time Revenue Split                           |  Customer Retention Diagnostics      |
|  (One-Time: 94.5% vs Repeat: 5.5%)                          |  (30-Day Nurture & Win-Back ROI)     |
|                                                             |                                      |
+-------------------------------------------------------------+--------------------------------------+
```

### Visual Configuration Details:
1. **Visual 1 & 2 (RFM Comparison Charts):**
   - Y-axis: `Dim_RFMSegments[Customer_Segment]`
   - Visual 1 X-axis: `SUM(Dim_RFMSegments[Monetary])` formatted as % of Total.
   - Visual 2 X-axis: `COUNT(Dim_RFMSegments[customer_unique_id])` formatted as % of Total.
2. **Visual 3 (Repeat vs One-Time Donut):**
   - Legend: One-Time Buyers vs Repeat Buyers.
   - Values: R$ 12.49M (94.5%) vs R$ 728k (5.5%).

---

## Page 4: Product Performance Dashboard

**Target Audience:** Category Managers, Merchandising Director, Merchant Acquisition Lead  
**Objective:** Evaluate product catalog breadth, volume vs value trade-offs, and customer feedback by category.

```
+----------------------------------------------------------------------------------------------------+
|  HEADER: Product Catalog & Category Performance Intelligence         [Slicers: Category | Score]   |
+-------------------+--------------------+--------------------+--------------------------------------+
| ACTIVE CATALOG    | PRODUCT CATEGORIES | TOP 5 SHARE        | CATALOG AVG PRICE                    |
| 32,951 SKUs       | 74 Categories      | 39.8%              | R$ 120.65                            |
| Unique Items      | English Mapped     | Pareto Dominance   | Average Item Price                   |
+-------------------+--------------------+--------------------+--------------------------------------+
|                                                             |                                      |
|  VISUAL 1: Clustered Horizontal Bar Chart                   |  VISUAL 2: Clustered Column Chart    |
|  Top 10 Product Categories by GMV                           |  Average Customer Review Score (CSAT)|
|  (Health/Beauty, Watches, Bed/Bath, Sports)                 |  (Office Furniture 3.49 vs Health 4.14)|
|                                                             |                                      |
+-------------------------------------------------------------+--------------------------------------+
|                                                                                                    |
|  VISUAL 3: Master Top Products Matrix Grid                                                         |
|  Flagship Revenue-Generating SKUs: Product ID, Category, Units Sold, Total GMV, Avg Unit Price     |
|                                                                                                    |
+----------------------------------------------------------------------------------------------------+
```

### Visual Configuration Details:
1. **Visual 1 (Top 10 Categories Bar):**
   - Y-axis: `Dim_Products[category_clean]`
   - X-axis: `_Measures_Financial[Total GMV]` (Descending order, Top 10 filter).
2. **Visual 2 (CSAT by Category):**
   - X-axis: `Dim_Products[category_clean]`
   - Y-axis: `_Measures_CX[Customer Satisfaction Score (CSAT)]` (Y-axis range: 3.0 to 4.5).
   - Data color: Green (`#10B981`) for $\ge 4.0$, Red (`#EF4444`) for $<4.0$.
3. **Visual 3 (Top Products Matrix):**
   - Rows: `Fact_OrderItems[product_id]`
   - Columns/Values: `Dim_Products[category_clean]`, `COUNT(Fact_OrderItems[order_item_id])`, `[Total GMV]`, `AVERAGE(Fact_OrderItems[price])`.

---

## 5. Instructions to Save, Document & Publish PBIX

1. In Power BI Desktop, click **File $\rightarrow$ Save As** $\rightarrow$ save as `powerbi/ecommerce_customer_revenue_analytics.pbix`.
2. Ensure all 4 pages are named cleanly:
   - `1. Executive Overview`
   - `2. Revenue Analysis`
   - `3. Customer Intelligence`
   - `4. Product Performance`
3. Export high-resolution PDF report: Click **File $\rightarrow$ Export $\rightarrow$ Export to PDF**.
4. Capture screenshots of each page and verify they match the generated assets in [`powerbi/screenshots/`](file:///Users/vanshkesarwanii/project/powerbi/screenshots/).

