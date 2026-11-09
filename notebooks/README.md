# Jupyter Notebooks & Data Analytics Workflows

## E-Commerce Customer & Revenue Intelligence Analytics

This directory contains the core Python scripts, exploratory data analysis (EDA) notebooks, and generated visual artifacts for the project.

---

## 1. Notebook Workflow & File Structure

```
notebooks/
├── 01_data_cleaning.py              # Standalone production ETL & cleaning script
├── 01_data_cleaning.ipynb           # Interactive cleaning, quality audit & SQLite build
├── 02_customer_revenue_analysis.ipynb # Core EDA, Cohort Retention Heatmap & RFM Segmentation
└── figures/                         # High-resolution charts exported directly from analysis
    ├── 01_monthly_revenue_trend.png
    ├── 02_top_categories_performance.png
    ├── 03_rfm_customer_segments.png
    ├── 04_cohort_retention_heatmap.png
    ├── powerbi_page1_executive_overview.png
    ├── powerbi_page2_revenue_analysis.png
    ├── powerbi_page3_customer_intelligence.png
    └── powerbi_page4_product_performance.png
```

---

## 2. Notebook Descriptions

### `01_data_cleaning.py` / `01_data_cleaning.ipynb`
- **Purpose:** End-to-end data preparation, missing value imputation, text standardization, and feature engineering.
- **Key Pipeline Steps:**
  1. Converted 5 timestamp strings in `orders` to proper datetime types.
  2. Engineered 10 operational and time intelligence metrics (lead times, delay flags, seasonal indicators).
  3. Mapped Portuguese product categories to English using crosswalk dictionary and resolved unmapped records.
  4. Imputed product physical dimension nulls with category-specific medians.
  5. Binned review scores into structured sentiment tiers (Positive: 4–5, Neutral: 3, Negative: 1–2).
  6. Created credit card installment brackets and payment type indicators.
  7. Exported cleaned CSVs to `dataset/cleaned/` and built an indexed SQLite relational database (`olist_analytics.db`).

### `02_customer_revenue_analysis.ipynb`
- **Purpose:** In-depth exploratory data analysis, behavioral modeling, cohort retention decay, and RFM customer segmentation.
- **Key Analytical Modules:**
  1. **Macro Revenue & Growth Trajectory:** Monthly GMV, order volume, Average Order Value (AOV), and seasonality trends (scaling from R$ 111k/month to R$ 988k/month during Black Friday).
  2. **Product Category Pareto Analysis:** Top 10 categories by GMV vs physical units sold, highlighting value vs volume trade-offs.
  3. **Customer Cohort Retention Analysis:** Constructed a multi-month cohort retention matrix revealing the rapid decay from 100% in Month 0 to 0.49% in Month 1 and 0.25% in Month 3.
  4. **RFM Customer Segmentation:** Calculated Recency, Frequency, and Monetary scores across 93,358 delivered customers; mapped buyers into 9 behavioral tiers.
  5. **Operational Logistics & SLA vs CSAT:** Quantified the direct relationship between delivery delays and customer review ratings (CSAT dropping from 4.29 on-time to 2.57 late).

---

## 3. How to Run Notebooks

### Option A: Run via Terminal (Quick Execution)
```bash
# Run data cleaning script to generate cleaned data & SQLite database
python notebooks/01_data_cleaning.py
```

### Option B: Interactive Execution via Jupyter Lab / Notebook
```bash
# Launch Jupyter Notebook
jupyter notebook

# Navigate to notebooks/ and run 01_data_cleaning.ipynb or 02_customer_revenue_analysis.ipynb
```

