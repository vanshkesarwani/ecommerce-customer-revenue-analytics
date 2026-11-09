-- =============================================================================
-- E-Commerce Customer & Revenue Intelligence Analytics
-- Phase 4: Production Business SQL Analysis
-- Author: Vansh Kesarwani
-- Database Target: MySQL 8.0+ / Standard ANSI SQL
-- Database: olist_ecommerce
-- =============================================================================

USE olist_ecommerce;

-- =============================================================================
-- SECTION A: BASIC SQL ANALYSIS (Exploratory Queries & Filtering)
-- =============================================================================

-- A1. Distinct Order Statuses & Order Volume Breakdown
-- Business Purpose: Verify the fulfillment funnel and understand valid revenue states.
SELECT 
    order_status,
    COUNT(order_id) AS total_orders,
    ROUND(COUNT(order_id) * 100.0 / (SELECT COUNT(*) FROM orders), 2) AS status_share_pct
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

-- A2. Distinct Geographic Coverage
-- Business Purpose: Count states and unique cities serviced across Brazil.
SELECT 
    COUNT(DISTINCT customer_state) AS total_states_served,
    COUNT(DISTINCT customer_city) AS total_cities_served,
    COUNT(DISTINCT customer_unique_id) AS total_unique_customers
FROM customers;

-- A3. Active Product Catalog Breadth
-- Business Purpose: Measure the variety of active product categories.
SELECT 
    COUNT(DISTINCT product_id) AS total_unique_products,
    COUNT(DISTINCT category_clean) AS total_categories
FROM products;

-- A4. High-Volume Sellers (HAVING Clause)
-- Business Purpose: Identify merchants that have fulfilled more than 500 items.
SELECT 
    oi.seller_id,
    s.seller_city,
    s.seller_state,
    COUNT(oi.order_item_id) AS items_fulfilled,
    ROUND(SUM(oi.price), 2) AS total_sales_volume
FROM order_items oi
JOIN sellers s ON oi.seller_id = s.seller_id
GROUP BY oi.seller_id, s.seller_city, s.seller_state
HAVING COUNT(oi.order_item_id) >= 500
ORDER BY items_fulfilled DESC;


-- =============================================================================
-- SECTION B: REVENUE ANALYSIS (Financial Performance & Basket Economics)
-- =============================================================================

-- B1. Marketplace Financial Top-Line Overview
-- Business Purpose: Gross Merchandise Value (GMV), Freight, and Customer Cash Inflows.
SELECT 
    COUNT(DISTINCT o.order_id) AS total_delivered_orders,
    ROUND(SUM(oi.price), 2) AS total_merchandise_revenue_gmv,
    ROUND(SUM(oi.freight_value), 2) AS total_freight_revenue,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_customer_cash_inflow,
    ROUND(SUM(oi.price) / COUNT(DISTINCT o.order_id), 2) AS average_order_value_aov
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered';

-- B2. Monthly Revenue Trajectory & Month-over-Month (MoM) Growth
-- Business Purpose: Track monthly sales trajectory and seasonal spikes (e.g. Black Friday).
WITH monthly_metrics AS (
    SELECT 
        DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS year_month,
        COUNT(DISTINCT o.order_id) AS total_orders,
        ROUND(SUM(oi.price), 2) AS monthly_gmv
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
)
SELECT 
    year_month,
    total_orders,
    monthly_gmv,
    LAG(monthly_gmv, 1) OVER (ORDER BY year_month) AS prev_month_gmv,
    ROUND(
        (monthly_gmv - LAG(monthly_gmv, 1) OVER (ORDER BY year_month)) * 100.0 / 
        LAG(monthly_gmv, 1) OVER (ORDER BY year_month), 
        2
    ) AS mom_revenue_growth_pct
FROM monthly_metrics
WHERE year_month BETWEEN '2017-01' AND '2018-08'
ORDER BY year_month;

-- B3. Top 10 Product Categories by Revenue Contribution (Pareto Analysis)
-- Business Purpose: Identify the primary commercial category pillars driving sales.
SELECT 
    p.category_clean AS product_category,
    COUNT(oi.order_item_id) AS units_sold,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    ROUND(AVG(oi.price), 2) AS average_item_price,
    ROUND(SUM(oi.price) * 100.0 / (
        SELECT SUM(oi_all.price) 
        FROM order_items oi_all 
        JOIN orders o_all ON oi_all.order_id = o_all.order_id 
        WHERE o_all.order_status = 'delivered'
    ), 2) AS revenue_share_pct
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status = 'delivered'
GROUP BY p.category_clean
ORDER BY total_revenue DESC
LIMIT 10;

-- B4. Top 10 Revenue-Generating Individual Products
-- Business Purpose: Find the flagship individual SKUs generating top sales.
SELECT 
    oi.product_id,
    p.category_clean AS category,
    COUNT(oi.order_item_id) AS units_sold,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    ROUND(AVG(oi.price), 2) AS unit_price
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status = 'delivered'
GROUP BY oi.product_id, p.category_clean
ORDER BY total_revenue DESC
LIMIT 10;

-- B5. Payment Method Distribution & Revenue Share
-- Business Purpose: Measure customer payment preferences and installment depth.
SELECT 
    op.payment_type_clean AS payment_method,
    COUNT(DISTINCT op.order_id) AS total_orders,
    ROUND(SUM(op.payment_value), 2) AS total_payment_value,
    ROUND(SUM(op.payment_value) * 100.0 / (SELECT SUM(payment_value) FROM order_payments), 2) AS payment_share_pct,
    ROUND(AVG(op.payment_installments), 1) AS average_installments
FROM order_payments op
JOIN orders o ON op.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY op.payment_type_clean
ORDER BY total_payment_value DESC;


-- =============================================================================
-- SECTION C: CUSTOMER ANALYSIS (Retention, Loyalty & CLV)
-- =============================================================================

-- C1. True Customer Count & Repeat vs One-Time Buyer Breakdown
-- Business Purpose: Quantify customer retention rate using customer_unique_id.
WITH customer_order_summary AS (
    SELECT 
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.price) AS lifetime_spend
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT 
    COUNT(*) AS total_unique_customers,
    SUM(CASE WHEN total_orders = 1 THEN 1 ELSE 0 END) AS one_time_buyers,
    SUM(CASE WHEN total_orders > 1 THEN 1 ELSE 0 END) AS repeat_buyers,
    ROUND(SUM(CASE WHEN total_orders > 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS repeat_buyer_pct,
    ROUND(SUM(CASE WHEN total_orders = 1 THEN lifetime_spend ELSE 0 END), 2) AS one_time_spend_gmv,
    ROUND(SUM(CASE WHEN total_orders > 1 THEN lifetime_spend ELSE 0 END), 2) AS repeat_spend_gmv,
    ROUND(SUM(CASE WHEN total_orders > 1 THEN lifetime_spend ELSE 0 END) * 100.0 / SUM(lifetime_spend), 2) AS repeat_revenue_share_pct
FROM customer_order_summary;

-- C2. Customer Order Frequency Distribution
-- Business Purpose: Breakdown of customer volume across exact purchase counts.
WITH frequency_tiers AS (
    SELECT 
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT 
    order_count AS purchases_made,
    COUNT(customer_unique_id) AS number_of_customers,
    ROUND(COUNT(customer_unique_id) * 100.0 / (SELECT COUNT(*) FROM frequency_tiers), 3) AS customer_share_pct
FROM frequency_tiers
GROUP BY order_count
ORDER BY order_count;

-- C3. Top 10 Highest-Spending Customers (VIP Buyers)
-- Business Purpose: Identify the most valuable individual shoppers on the platform.
SELECT 
    c.customer_unique_id,
    c.customer_city,
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS total_orders_placed,
    COUNT(oi.order_item_id) AS total_items_bought,
    ROUND(SUM(oi.price), 2) AS total_monetary_spend,
    ROUND(AVG(oi.price), 2) AS avg_item_price
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id, c.customer_city, c.customer_state
ORDER BY total_monetary_spend DESC
LIMIT 10;

-- C4. RFM Customer Segment Revenue Performance
-- Business Purpose: Measure customer distribution and GMV across behavioral segments.
SELECT 
    Customer_Segment,
    COUNT(customer_unique_id) AS total_customers,
    ROUND(COUNT(customer_unique_id) * 100.0 / (SELECT COUNT(*) FROM rfm_segments), 2) AS customer_share_pct,
    ROUND(AVG(Recency), 1) AS avg_recency_days,
    ROUND(AVG(Frequency), 2) AS avg_frequency,
    ROUND(AVG(Monetary), 2) AS avg_monetary_val,
    ROUND(SUM(Monetary), 2) AS total_revenue_contributed,
    ROUND(SUM(Monetary) * 100.0 / (SELECT SUM(Monetary) FROM rfm_segments), 2) AS revenue_share_pct
FROM rfm_segments
GROUP BY Customer_Segment
ORDER BY total_revenue_contributed DESC;


-- =============================================================================
-- SECTION D: ADVANCED SQL (Window Functions, CTEs & Cumulative Analytics)
-- =============================================================================

-- D1. Running Total of Revenue (Cumulative GMV Over Time)
-- Business Purpose: Measure cumulative GMV growth milestone progress.
WITH monthly_data AS (
    SELECT 
        DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS ym,
        ROUND(SUM(oi.price), 2) AS monthly_revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
)
SELECT 
    ym AS purchase_month,
    monthly_revenue,
    SUM(monthly_revenue) OVER (ORDER BY ym) AS cumulative_running_revenue
FROM monthly_data
WHERE ym BETWEEN '2017-01' AND '2018-08'
ORDER BY ym;

-- D2. Product Ranking Within Category (DENSE_RANK Window Function)
-- Business Purpose: Find the Top 3 best-selling products within each top category.
WITH product_ranks AS (
    SELECT 
        p.category_clean,
        oi.product_id,
        ROUND(SUM(oi.price), 2) AS product_revenue,
        COUNT(oi.order_item_id) AS units_sold,
        DENSE_RANK() OVER (PARTITION BY p.category_clean ORDER BY SUM(oi.price) DESC) AS rank_in_category
    FROM order_items oi
    JOIN orders o ON oi.order_id = o.order_id
    JOIN products p ON oi.product_id = p.product_id
    WHERE o.order_status = 'delivered'
      AND p.category_clean IN ('Health Beauty', 'Watches Gifts', 'Bed Bath Table')
    GROUP BY p.category_clean, oi.product_id
)
SELECT 
    category_clean,
    rank_in_category,
    product_id,
    product_revenue,
    units_sold
FROM product_ranks
WHERE rank_in_category <= 3
ORDER BY category_clean, rank_in_category;

-- D3. Repurchase Time Lag (Days Between 1st and 2nd Purchase via LAG)
-- Business Purpose: Calculate the exact days elapsed between initial purchase and repeat order.
WITH ordered_customer_purchases AS (
    SELECT 
        c.customer_unique_id,
        o.order_id,
        o.order_purchase_timestamp,
        ROW_NUMBER() OVER (
            PARTITION BY c.customer_unique_id 
            ORDER BY o.order_purchase_timestamp
        ) AS purchase_seq,
        LAG(o.order_purchase_timestamp, 1) OVER (
            PARTITION BY c.customer_unique_id 
            ORDER BY o.order_purchase_timestamp
        ) AS previous_purchase_timestamp
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
)
SELECT 
    COUNT(*) AS total_second_orders,
    ROUND(AVG(DATEDIFF(order_purchase_timestamp, previous_purchase_timestamp)), 1) AS avg_days_to_repurchase,
    ROUND(MIN(DATEDIFF(order_purchase_timestamp, previous_purchase_timestamp)), 1) AS min_days,
    ROUND(MAX(DATEDIFF(order_purchase_timestamp, previous_purchase_timestamp)), 1) AS max_days
FROM ordered_customer_purchases
WHERE purchase_seq = 2;


-- =============================================================================
-- SECTION E: 15 HIGH-IMPACT BUSINESS QUESTIONS ANSWERED IN SQL
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Q1: What is the total recognized merchandise revenue and freight fees collected?
-- -----------------------------------------------------------------------------
SELECT 
    ROUND(SUM(oi.price), 2) AS total_gmv_merchandise,
    ROUND(SUM(oi.freight_value), 2) AS total_freight_collected,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_customer_cash_spend,
    ROUND((SUM(oi.freight_value) * 100.0) / SUM(oi.price), 2) AS freight_to_price_ratio_pct
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered';

-- -----------------------------------------------------------------------------
-- Q2: What is the month-over-month (MoM) revenue growth across the platform?
-- -----------------------------------------------------------------------------
WITH monthly_rev AS (
    SELECT 
        DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS ym,
        ROUND(SUM(oi.price), 2) AS gmv
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
)
SELECT 
    ym,
    gmv,
    LAG(gmv, 1) OVER (ORDER BY ym) AS previous_month_gmv,
    ROUND((gmv - LAG(gmv, 1) OVER (ORDER BY ym)) * 100.0 / LAG(gmv, 1) OVER (ORDER BY ym), 2) AS mom_growth_pct
FROM monthly_rev
WHERE ym BETWEEN '2017-01' AND '2018-08';

-- -----------------------------------------------------------------------------
-- Q3: How does the Average Order Value (AOV) fluctuate across months?
-- -----------------------------------------------------------------------------
SELECT 
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS ym,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS total_gmv,
    ROUND(SUM(oi.price) / COUNT(DISTINCT o.order_id), 2) AS aov
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
  AND DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') BETWEEN '2017-01' AND '2018-08'
GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
ORDER BY ym;

-- -----------------------------------------------------------------------------
-- Q4: What are the top 10 product categories by total merchandise sales (GMV)?
-- -----------------------------------------------------------------------------
SELECT 
    p.category_clean,
    ROUND(SUM(oi.price), 2) AS category_revenue,
    COUNT(oi.order_item_id) AS items_sold,
    ROUND(SUM(oi.price) * 100.0 / (
        SELECT SUM(oi2.price) FROM order_items oi2 JOIN orders o2 ON oi2.order_id = o2.order_id WHERE o2.order_status = 'delivered'
    ), 2) AS gmv_share_pct
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status = 'delivered'
GROUP BY p.category_clean
ORDER BY category_revenue DESC
LIMIT 10;

-- -----------------------------------------------------------------------------
-- Q5: Which categories sell the highest volume of items vs highest revenue?
-- -----------------------------------------------------------------------------
SELECT 
    p.category_clean,
    COUNT(oi.order_item_id) AS total_volume_sold,
    ROUND(SUM(oi.price), 2) AS total_revenue_gmv,
    ROUND(AVG(oi.price), 2) AS avg_item_price
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status = 'delivered'
GROUP BY p.category_clean
ORDER BY total_volume_sold DESC
LIMIT 10;

-- -----------------------------------------------------------------------------
-- Q6: Which Brazilian states generate the highest revenue and customer volume?
-- -----------------------------------------------------------------------------
SELECT 
    c.customer_state,
    COUNT(DISTINCT c.customer_unique_id) AS total_customers,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS total_state_revenue,
    ROUND(SUM(oi.price) * 100.0 / (
        SELECT SUM(price) FROM order_items oi2 JOIN orders o2 ON oi2.order_id = o2.order_id WHERE o2.order_status = 'delivered'
    ), 2) AS revenue_share_pct,
    ROUND(SUM(oi.freight_value) * 100.0 / SUM(oi.price), 2) AS freight_to_price_ratio
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY total_state_revenue DESC
LIMIT 10;

-- -----------------------------------------------------------------------------
-- Q7: What are the top 10 cities by total order volume and customer spend?
-- -----------------------------------------------------------------------------
SELECT 
    c.customer_city,
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS completed_orders,
    ROUND(SUM(oi.price), 2) AS total_city_spend,
    ROUND(SUM(oi.price) / COUNT(DISTINCT o.order_id), 2) AS city_aov
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_city, c.customer_state
ORDER BY completed_orders DESC
LIMIT 10;

-- -----------------------------------------------------------------------------
-- Q8: How is revenue distributed across payment methods?
-- -----------------------------------------------------------------------------
SELECT 
    payment_type_clean,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(payment_value), 2) AS total_payment_value,
    ROUND(SUM(payment_value) * 100.0 / (SELECT SUM(payment_value) FROM order_payments), 2) AS payment_share_pct
FROM order_payments
GROUP BY payment_type_clean
ORDER BY total_payment_value DESC;

-- -----------------------------------------------------------------------------
-- Q9: What percentage of credit card purchases utilize multi-month installments?
-- -----------------------------------------------------------------------------
SELECT 
    installment_bracket,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(payment_value), 2) AS total_financed_value,
    ROUND(COUNT(DISTINCT order_id) * 100.0 / (
        SELECT COUNT(DISTINCT order_id) FROM order_payments WHERE payment_type_clean = 'Credit Card'
    ), 2) AS share_of_credit_orders_pct
FROM order_payments
WHERE payment_type_clean = 'Credit Card'
GROUP BY installment_bracket
ORDER BY total_financed_value DESC;

-- -----------------------------------------------------------------------------
-- Q10: What is Olist's true repeat purchase rate when tracking customer_unique_id?
-- -----------------------------------------------------------------------------
WITH customer_order_counts AS (
    SELECT 
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS orders_count
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT 
    COUNT(*) AS total_unique_buyers,
    SUM(CASE WHEN orders_count = 1 THEN 1 ELSE 0 END) AS one_time_buyers,
    SUM(CASE WHEN orders_count > 1 THEN 1 ELSE 0 END) AS repeat_buyers,
    ROUND(SUM(CASE WHEN orders_count > 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS repeat_buyer_pct
FROM customer_order_counts;

-- -----------------------------------------------------------------------------
-- Q11: What proportion of total revenue is generated by repeat buyers vs one-time buyers?
-- -----------------------------------------------------------------------------
WITH customer_revenue_profile AS (
    SELECT 
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS orders_count,
        SUM(oi.price) AS total_spend
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT 
    CASE 
        WHEN orders_count = 1 THEN 'One-Time Buyer' 
        ELSE 'Repeat Buyer' 
    END AS customer_type,
    COUNT(customer_unique_id) AS customer_count,
    ROUND(SUM(total_spend), 2) AS total_revenue,
    ROUND(SUM(total_spend) * 100.0 / (SELECT SUM(total_spend) FROM customer_revenue_profile), 2) AS revenue_share_pct
FROM customer_revenue_profile
GROUP BY customer_type;

-- -----------------------------------------------------------------------------
-- Q12: How severely do late deliveries hurt customer review scores (CSAT)?
-- -----------------------------------------------------------------------------
SELECT 
    CASE 
        WHEN o.delivery_performance = 'On-Time' THEN 'Delivered On-Time'
        WHEN o.delivery_performance = 'Late' THEN 'Delivered Late'
        ELSE 'Other'
    END AS fulfillment_outcome,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(AVG(r.review_score), 2) AS avg_review_score,
    ROUND(SUM(CASE WHEN r.review_score <= 2 THEN 1 ELSE 0 END) * 100.0 / COUNT(r.review_score), 2) AS negative_reviews_pct,
    ROUND(SUM(CASE WHEN r.review_score >= 4 THEN 1 ELSE 0 END) * 100.0 / COUNT(r.review_score), 2) AS positive_reviews_pct
FROM orders o
JOIN order_reviews r ON o.order_id = r.order_id
WHERE o.order_status = 'delivered' 
  AND o.delivery_performance IN ('On-Time', 'Late')
GROUP BY fulfillment_outcome;

-- -----------------------------------------------------------------------------
-- Q13: What is the on-time delivery rate across the top 10 Brazilian states?
-- -----------------------------------------------------------------------------
SELECT 
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS delivered_orders,
    SUM(CASE WHEN o.delivery_performance = 'On-Time' THEN 1 ELSE 0 END) AS on_time_orders,
    SUM(CASE WHEN o.delivery_performance = 'Late' THEN 1 ELSE 0 END) AS late_orders,
    ROUND(SUM(CASE WHEN o.delivery_performance = 'On-Time' THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT o.order_id), 2) AS on_time_rate_pct,
    ROUND(AVG(o.delivery_lead_time_days), 1) AS avg_lead_time_days
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY delivered_orders DESC
LIMIT 10;

-- -----------------------------------------------------------------------------
-- Q14: Which product categories suffer from the lowest customer satisfaction?
-- -----------------------------------------------------------------------------
SELECT 
    p.category_clean,
    COUNT(DISTINCT o.order_id) AS total_orders_reviewed,
    ROUND(AVG(r.review_score), 2) AS avg_review_score,
    ROUND(SUM(CASE WHEN r.review_score <= 2 THEN 1 ELSE 0 END) * 100.0 / COUNT(r.review_score), 2) AS negative_review_pct
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN order_reviews r ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
GROUP BY p.category_clean
HAVING COUNT(DISTINCT o.order_id) >= 200
ORDER BY avg_review_score ASC
LIMIT 10;

-- -----------------------------------------------------------------------------
-- Q15: How does customer spend and volume distribute across RFM segments?
-- -----------------------------------------------------------------------------
SELECT 
    Customer_Segment,
    COUNT(customer_unique_id) AS total_customers,
    ROUND(COUNT(customer_unique_id) * 100.0 / (SELECT COUNT(*) FROM rfm_segments), 2) AS customer_share_pct,
    ROUND(SUM(Monetary), 2) AS total_revenue_contributed,
    ROUND(SUM(Monetary) * 100.0 / (SELECT SUM(Monetary) FROM rfm_segments), 2) AS revenue_share_pct,
    ROUND(AVG(Monetary), 2) AS avg_spend_per_customer
FROM rfm_segments
GROUP BY Customer_Segment
ORDER BY total_revenue_contributed DESC;

