# Executive Business Insights & Strategic Recommendations Report

## Project: E-Commerce Customer & Revenue Intelligence Analytics
**Lead Analyst:** Vansh Kesarwani  
**Dataset:** Olist Brazilian E-Commerce Public Dataset (Kaggle)  
**Deliverable:** Comprehensive Commercial Insights, Operational Findings & Executive Strategy  
**Standard:** Enterprise Business Intelligence & Commercial Analytics Strategy  

---

## 1. Executive Summary

This report synthesizes the commercial, behavioral, operational, and financial findings from our end-to-end data analytics project on the **Olist Brazilian E-Commerce Marketplace** across **96,478 delivered transactions** and **93,358 unique human buyers** between September 2016 and August 2018.

Over this analysis window, Olist achieved:
- **R$ 13.22 Million in Gross Merchandise Value (GMV)**
- **R$ 2.20 Million in freight charges collected**
- **R$ 15.42 Million in total customer cash processed**
- An **Average Order Value (AOV) of R$ 137.04**

### The Core Strategic Paradox
While top-line GMV experienced rapid expansion (scaling from R$ 111k/month in early 2017 to a Black Friday peak of R$ 988k in November 2017), the underlying marketplace business model faces a severe structural vulnerability: **Olist functions as a top-of-funnel customer acquisition utility rather than a customer retention engine**:
- **97.0%** of all customers purchased only once and never transacted again.
- Customer cohort retention drops from **100% in Month 0 to 0.49% in Month 1** and flattens to **0.25% by Month 3**.
- A small cohort of buyers (**Potential Loyalists** at 33.9% and **At-Risk customers** at 22.4%) accounts for **56.3% (~R$ 7.44 Million)** of total platform revenue.
- Shipping freight represents **16.63% of product purchase prices**, creating friction that restricts basket depth to **1.14 items per order**.

This report articulates **10 data-backed business insights**—each structured by data evidence, commercial significance, recommended business actions, and expected ROI—followed by an actionable strategic roadmap.

---

## 2. Revenue Performance Insights

### Insight 1: Sales Growth is Driven by Customer Volume Acquisition, Not Basket Size Expansion
- **What the Data Shows:**
  Monthly GMV expanded from **R$ 111,798.36 in January 2017** to a record **R$ 987,765.37 in November 2017 (+52.4% MoM)**, before settling at a steady 2018 run-rate of ~R$ 880,000/month. Concurrently, Average Order Value (AOV) remained flat throughout the entire timeline, oscillating narrowly between **R$ 124.38 and R$ 149.06**, with an overall average of **R$ 137.04**.
- **Why It Matters to the Business:**
  Revenue growth has been fueled almost exclusively by acquiring a higher volume of new buyers rather than increasing the value extracted from each transaction. If digital advertising costs (Customer Acquisition Cost - CAC) rise, top-line growth will immediately decelerate because basket depth remains stagnant at **1.14 items per order**.
- **Recommended Business Action:**
  Implement cross-selling bundles, minimum spend thresholds for discounted shipping (e.g. "Spend R$ 180 to save 50% on freight"), and post-order add-on suggestions before final shipment dispatch.
- **Expected Business Benefit:**
  Increasing average basket depth from **1.14 to 1.30 items** will lift AOV from R$ 137.04 to ~R$ 156.00, generating an estimated **~R$ 1.83 Million in incremental GMV** at zero additional advertising cost.

---

### Insight 2: Heavy Regional Revenue Concentration in Southeast Brazil
- **What the Data Shows:**
  Three contiguous states in the Southeast region account for **63.38% of total marketplace GMV**:
  - **São Paulo (SP):** R$ 5,067,633.16 (38.33% of national GMV | 39,156 buyers)
  - **Rio de Janeiro (RJ):** R$ 1,759,651.13 (13.31% of national GMV | 11,917 buyers)
  - **Minas Gerais (MG):** R$ 1,552,481.83 (11.74% of national GMV | 11,001 buyers)
  Conversely, northern and northeastern states (e.g. Maranhão, Pará, Amazonas) represent less than 5% of national sales combined.
- **Why It Matters to the Business:**
  Revenue is over-indexed on a single geographic economic zone. Furthermore, customers in remote states face high freight-to-price ratios (>25%) and prolonged delivery lead times (averaging 24.6 days in Maranhão vs 8.3 days in São Paulo), creating a barrier that suppresses geographic expansion.
- **Recommended Business Action:**
  Establish regional 3PL logistics partnerships and localized fulfillment hubs outside of São Paulo (e.g. in Salvador or Recife) to lower inter-state freight rates and cut delivery transit times to northern states.
- **Expected Business Benefit:**
  Compressing shipping transit times in the North and Northeast by 5–7 days will improve checkout conversion and elevate regional review ratings from 3.7 to 4.2 stars.

---

### Insight 3: Consumer Financing is Dominated by Multi-Month Credit Card Installments
- **What the Data Shows:**
  Credit cards represent **75.59% of total transaction value (R$ 12,101,094.88)** across 74,304 orders, followed by *Boleto Bancário* (cash slips) at 17.30% (R$ 2.77M), vouchers at 2.14%, and debit cards at 1.30%. Furthermore, **66.1% of all credit card orders are financed across multiple installments**, with an average installment depth of **3.5 monthly payments** (and 19.6% split across 7 to 10 months).
- **Why It Matters to the Business:**
  Brazilian consumers depend heavily on installment credit to finance household, electronics, and lifestyle goods. Restricting installment options or passing high gateway financing fees onto consumers will immediately depress conversion rates on items priced above R$ 150.
- **Recommended Business Action:**
  Negotiate lower credit card interchange fees with Brazilian payment acquirers (e.g. Cielo, Stone, PagSeguro) by leveraging high transaction volume, and strategically offer 10x-to-12x interest-free installment promotions on high-margin categories (*Watches Gifts* and *Computers Accessories*).
- **Expected Business Benefit:**
  Reducing payment gateway processing fees by 0.35% will yield direct annual cost savings of **~R$ 42,000**, while installment promotions will protect conversion on high-ticket catalog items.

---

## 3. Customer Behavior Insights

### Insight 4: Severe RFM Revenue Skew: 56% of Revenue Controlled by Two Segments
- **What the Data Shows:**
  Behavioral RFM modeling across all 93,358 unique buyers reveals an extreme revenue concentration:
  - **Potential Loyalists (22.7% of buyers | 21,191 customers):** Generated **R$ 4,475,844.17 (33.85% of total GMV)** with an average spend of R$ 211.21.
  - **At-Risk Customers (7.9% of buyers | 7,412 customers):** Generated **R$ 2,963,283.36 (22.41% of total GMV)** with an average spend of **R$ 399.80** (the highest spend of any group).
  - *Combined:* These two segments alone account for **56.26% (~R$ 7.44 Million)** of all marketplace sales.
- **Why It Matters to the Business:**
  The business is exposed to high-value customer churn. The *At-Risk* group comprises high-ticket spenders who have had zero purchase activity for over 400 days. If this group permanently attrites, Olist loses its most profitable buyer cohort.
- **Recommended Business Action:**
  Deploy targeted VIP reactivation email and SMS campaigns for the *At-Risk* cohort featuring personalized re-engagement incentives (e.g., "We miss you: R$ 50 off your next order over R$ 250"). For *Potential Loyalists*, trigger complementary category discounts within 30 days of their initial order.
- **Expected Business Benefit:**
  Reactivating just 8% of the *At-Risk* segment (593 buyers) will recover **~R$ 237,000 in high-margin merchandise revenue**.

---

### Insight 5: Shallow Basket Sizes Caused by Multi-Seller Shipping Compound
- **What the Data Shows:**
  The average order contains only **1.14 items**, and over 85% of completed transactions consist of a single product line item.
- **Why It Matters to the Business:**
  In a multi-merchant marketplace, if a consumer adds two products from two different merchants to their cart, each merchant ships independently, resulting in stacked delivery fees. Consumers respond rationally by abandoning multi-item baskets and purchasing only single essential items.
- **Recommended Business Action:**
  Develop an algorithmic "Same Merchant Cross-Sell" widget at checkout: when a buyer adds an item from Merchant A to their basket, dynamically recommend popular complementary accessories sold by Merchant A with guaranteed combined flat-rate freight.
- **Expected Business Benefit:**
  Increases average units per order by 15%, raising Average Order Value without incurring additional logistics friction.

---

## 4. Customer Retention Insights

### Insight 6: The 97% One-Time Purchase Cliff
- **What the Data Shows:**
  Out of 93,358 unique human buyers (`customer_unique_id`), **90,557 (97.00%) placed exactly one order**. Only **2,801 (3.00%) ever returned to place a second order**.
  - One-time buyers contributed **R$ 12,493,089.36 (94.49% of GMV)**.
  - Repeat buyers contributed only **R$ 728,408.75 (5.51% of GMV)**.
- **Why It Matters to the Business:**
  Healthy e-commerce marketplaces typically achieve repeat purchase rates between 15% and 30%. Operating with a 3.0% repeat rate means Olist constantly re-acquires its entire revenue base from scratch every month, leaving the business vulnerable to customer acquisition inflation and competitive discounting.
- **Recommended Business Action:**
  Launch a post-purchase CRM retention flywheel, including delivery tracking notifications, unboxing satisfaction surveys, and automated cross-sell sequences.
- **Expected Business Benefit:**
  Doubling the repeat purchase rate from 3.0% to 6.0% will generate an estimated **~R$ 728,000 in recurring annual merchandise revenue** at zero marginal advertising cost.

---

### Insight 7: The Critical 30-Day Repurchase Window
- **What the Data Shows:**
  For the 2,801 customers who placed repeat orders:
  - **Median time lag between 1st and 2nd purchase:** **29.5 days (~1 month)**.
  - **Mean time lag:** **79.2 days (~2.5 months)**.
  - **75th percentile:** **121.5 days (~4 months)**.
  - Beyond 120 days, the probability of repeat purchase drops to near zero.
- **Why It Matters to the Business:**
  Marketing teams frequently schedule re-engagement campaigns 90 or 180 days post-purchase, which is too late. The customer has already moved on.
- **Recommended Business Action:**
  Concentrate the retention budget within the **first 30 days post-delivery**. Schedule an automated lifecycle sequence:
  - *Day 3 post-delivery:* Satisfaction check & review invitation.
  - *Day 14 post-delivery:* Replenishment / complementary product recommendation.
  - *Day 28 post-delivery (The Golden Window):* Time-limited repurchase voucher expiring in 7 days.
- **Expected Business Benefit:**
  Maximizes repeat order conversion during the customer's peak brand recall window, capturing repeat sales before customer decay sets in.

---

### Insight 8: Cohort Retention Plummets to 0.49% in Month 1
- **What the Data Shows:**
  Tracking monthly acquisition cohorts across 2017 shows that average retention drops from **100% in Month 0 to 0.49% in Month 1**, declining further to **0.35% in Month 2** and **0.25% in Month 3**, before flatlining at ~0.19% at Month 12.
- **Why It Matters to the Business:**
  Customer lifetime decay is immediate and permanent. Olist is not building compounded cohort revenue over time; it is replacing lost cohorts with new traffic.
- **Recommended Business Action:**
  Introduce an "Olist Prime" or free shipping subscription membership program: customers pay a small annual fee in exchange for free shipping on qualifying items from verified top sellers.
- **Expected Business Benefit:**
  Subscription loyalty programs in e-commerce typically increase customer purchase frequency by 2.5x–3.5x and elevate 90-day retention above 8%.

---

## 5. Product Performance Insights

### Insight 9: Pareto Concentration: Top 5 Categories Generate 40% of All GMV
- **What the Data Shows:**
  Across 74 product categories in the catalog, revenue is heavily concentrated:
  - The **Top 5 categories** generate **39.84% (~R$ 5.27 Million)** of total GMV:
    1. *Health Beauty:* R$ 1,233,131.72 (9.33% share | 9,465 units | avg price R$ 130.28)
    2. *Watches Gifts:* R$ 1,166,176.98 (8.82% share | 5,859 units | avg price R$ 199.04)
    3. *Bed Bath Table:* R$ 1,023,434.76 (7.74% share | 10,953 units | avg price R$ 93.44)
    4. *Sports Leisure:* R$ 954,852.55 (7.22% share | 8,431 units | avg price R$ 113.25)
    5. *Computers Accessories:* R$ 888,724.61 (6.72% share | 7,644 units | avg price R$ 116.26)
  - The **Top 10 categories** account for **62.46% (~R$ 8.25 Million)** of GMV.
- **Why It Matters to the Business:**
  Marketplace revenue depends heavily on category health in just 5 sectors. Merchandising, seller recruitment, and homepage advertising should prioritize these categories.
- **Recommended Business Action:**
  Appoint dedicated Category Managers for Health/Beauty and Watches/Gifts. Expand seller recruitment in these areas and negotiate premium featured brand placements on marketplace homepages.
- **Expected Business Benefit:**
  Accelerating growth in top-performing categories by 10% will yield **~R$ 527,000 in additional marketplace GMV**.

---

### Insight 10: Operational Delivery Delays Cause a 6x Spike in Negative Reviews
- **What the Data Shows:**
  Correlating operational fulfillment with 99,224 customer reviews shows:
  - **Orders Delivered On-Time (88,163 orders):** Average Review Score = **4.29 / 5.0** | **82.8% Positive (4–5 stars)** | **9.2% Negative (1–2 stars)**.
  - **Orders Delivered Late (7,661 orders):** Average Review Score = **2.57 / 5.0** | **34.6% Positive** | **54.0% Negative**.
  - Negative reviews spike from **9.2% to 54.0% (an almost 6-fold increase)** when an order is delivered after the estimated delivery date.
- **Why It Matters to the Business:**
  Delivery delays are the single largest driver of customer dissatisfaction and brand damage. A 1-star review caused by shipping delay deters future buyers from that product listing and wastes customer service resources.
- **Recommended Business Action:**
  1. Revise delivery estimation algorithms: add a 2-day buffer to checkout estimated delivery dates in historically slow postal corridors (e.g. Rio de Janeiro and northeastern states) to under-promise and over-deliver.
  2. Implement strict carrier SLAs with performance penalties for delivery partners who miss dispatch deadlines.
- **Expected Business Benefit:**
  Converting just 3,000 late orders into on-time deliveries will prevent ~1,300 one-star reviews, elevating overall marketplace CSAT above 4.25 stars.

---

## 6. Business Challenges & Vulnerabilities

| Business Challenge | Root Cause Identified in Data | Severity | Commercial Impact |
|---|---|---|---|
| **1. Chronic Customer Churn** | 97.0% of buyers purchase only once; Month-1 cohort retention is 0.49%. | **Critical** | High customer acquisition spend cannot be amortized over customer lifetime value. |
| **2. At-Risk VIP Exposure** | 7,412 high-spending customers (R$ 2.96M historical GMV) have had zero activity for >400 days. | **High** | Loss of highest-margin buyer cohort to competing marketplaces. |
| **3. Shallow Basket Economics** | Multi-seller cart orders compound shipping freight fees, restricting orders to 1.14 items. | **High** | Caps Average Order Value at R$ 137.04; increases per-order handling costs. |
| **4. Freight Friction in Remote States** | Shipping fees average 16.63% nationally and exceed 25% in peripheral states (MA, PA, BA). | **Medium** | Causes checkout cart abandonment and depresses geographic expansion. |
| **5. Bulky Category Fulfillment Dissatisfaction** | Categories like *Office Furniture* score 3.49 / 5.0 stars with 30.8% negative reviews due to transit delays. | **Medium** | Increased return rates, customer support overhead, and negative seller feedback. |

---

## 7. Actionable Strategic Recommendations Roadmap

```
+-----------------------------------------------------------------------------------------------+
| STRATEGIC RECOMMENDATION ROADMAP                                                              |
+----------------------+--------------------+---------------------+-----------------------------+
| INITIATIVE           | PRIORITY / TIMELINE| TARGET AUDIENCE     | EXPECTED FINANCIAL IMPACT   |
+----------------------+--------------------+---------------------+-----------------------------+
| 1. Automated 30-Day  | Immediate (Q1)     | Potential Loyalists | +R$ 450k Incremental GMV    |
|    Nurture Sequence  |                    | & New Customers     | from repeat conversions     |
+----------------------+--------------------+---------------------+-----------------------------+
| 2. High-Value At-Risk| Immediate (Q1)     | 7,412 At-Risk VIPs  | +R$ 237k Recovered GMV      |
|    Win-Back Campaign |                    | (Avg spend R$ 400)  | (8% cohort reactivation)    |
+----------------------+--------------------+---------------------+-----------------------------+
| 3. Same-Merchant Cart| Medium-Term (Q2)   | All checkout buyers | +R$ 1.83M Incremental GMV   |
|    Cross-Sell Bundles|                    |                     | (AOV lifts from R$ 137->156)|
+----------------------+--------------------+---------------------+-----------------------------+
| 4. Delivery Promise  | Medium-Term (Q2)   | Carrier Logistics & | Prevents ~1,300 1-star      |
|    Buffer & SLA Rules|                    | Slow States (RJ, NE)| reviews; lifts CSAT to 4.25 |
+----------------------+--------------------+---------------------+-----------------------------+
| 5. Regional 3PL Hubs | Strategic (Q3–Q4)  | Buyers in North &   | Lowers freight ratio <15%;  |
|    & Fulfillment Hubs|                    | Northeast States    | cuts delivery time by 6 days|
+----------------------+--------------------+---------------------+-----------------------------+
```

### Recommendation 1: Launch an Automated 30-Day Post-Delivery Nurture Sequence
- **Tactical Execution:**
  Set up an automated email and push notification flow triggered in customer marketing software (e.g. Klaviyo / Braze):
  - *Trigger 1 (Day 3 post-delivery):* "How did your order arrive?" (Feedback collection & review generation).
  - *Trigger 2 (Day 14 post-delivery):* "Customers who bought [Product A] also loved these accessories" (Curated cross-sell).
  - *Trigger 3 (Day 28 post-delivery - The Golden Window):* "Here is an exclusive 10% credit towards your next order — expires in 7 days."
- **Expected Financial Return:**
  Lifting Month-1 cohort retention from 0.49% to 2.0% will generate **~R$ 450,000 in incremental annual merchandise revenue**.

### Recommendation 2: High-Value "At-Risk" Reactivation Initiative
- **Tactical Execution:**
  Segment the 7,412 buyers in `rfm_customer_segments.csv` labeled *At-Risk*. Deliver personalized VIP reactivation messaging via direct email, WhatsApp, and paid retargeting with high-value credits (e.g. "R$ 50 off your order of R$ 250 or more").
- **Expected Financial Return:**
  Reactivating 8% of this cohort (593 buyers spending an average of R$ 400) recovers **~R$ 237,000 in high-margin merchandise revenue**.

### Recommendation 3: Algorithmic Same-Merchant Cross-Sell Bundling
- **Tactical Execution:**
  When a user views their cart with an item from Merchant X, show a banner: *"Add matching items from this merchant for free combined shipping."*
- **Expected Financial Return:**
  Increasing average basket depth from **1.14 to 1.30 items** will lift Average Order Value by 14%, creating over **R$ 1.8 Million in new GMV** without increasing customer acquisition spend.

### Recommendation 4: Logistics SLA Buffer & Realistic Delivery Timelines
- **Tactical Execution:**
  Incorporate machine learning or historical lead-time buffers (+2 days) into delivery estimates quoted at checkout for carriers and routes with high delivery variance (especially in Rio de Janeiro and peripheral states).
- **Expected Financial Return:**
  Eliminates unexpected late deliveries, protecting customer review sentiment and reducing customer service refund inquiries by an estimated 20%.

---

## 8. Final Business Conclusion

The data confirms that Olist built a highly scalable marketplace acquisition engine that expanded Gross Merchandise Value to **R$ 13.22 Million** with disciplined order processing.

However, the company’s future profitability depends on shifting strategic focus from **pure acquisition to customer lifetime retention**:
1. **Closing the Leaky Bucket:** Transitioning repeat purchase rates from 3.0% toward the 10–15% industry benchmark will unlock recurring, high-margin revenue without expanding marketing acquisition budgets.
2. **Protecting High-Value Assets:** Actively engaging the *Potential Loyalists* and *At-Risk* cohorts (who control 56% of sales) secures the platform's core financial base.
3. **Optimizing Operational Delivery:** Ensuring orders arrive on or before the promised deadline protects customer review scores (averaging 4.29 stars on-time vs 2.57 late), safeguarding brand equity across Brazilian e-commerce.

By executing the automated 30-day retention flow, same-merchant cart bundling, and regional logistics improvements outlined in this report, Olist leadership can unlock an estimated **R$ 2.5+ Million in incremental high-margin revenue** while building a durable, loyal customer community.

