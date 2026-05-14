CREATE DATABASE IF NOT EXISTS olist_db;

-- Set it as active database
USE olist_db;

-- Confirm it worked
SELECT DATABASE();
SELECT
    COUNT(DISTINCT order_id)      AS total_orders,
    COUNT(DISTINCT customer_id)   AS total_customers,
    ROUND(SUM(total_payment), 2)  AS total_revenue_brl,
    ROUND(AVG(total_payment), 2)  AS avg_order_value,
    ROUND(AVG(review_score), 2)   AS avg_review_score
FROM olist;
USE olist_db;

-- 1. NULL handling

SELECT IFNULL(category_english, 'unknown') AS category
FROM olist LIMIT 5;


-- 2. Date formatting
SELECT
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS month,
    COUNT(*) AS orders
FROM olist
GROUP BY month
ORDER BY month;


-- 3. String concat

SELECT CONCAT(seller_city, ', ', seller_state) AS location
FROM olist LIMIT 5;


-- 4. Window functions (same in both!)
SELECT
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS month,
    ROUND(SUM(total_payment), 2) AS revenue,
    ROUND(SUM(SUM(total_payment)) OVER (
        ORDER BY DATE_FORMAT(order_purchase_timestamp, '%Y-%m')
    ), 2) AS running_total
FROM olist
GROUP BY month
ORDER BY month;