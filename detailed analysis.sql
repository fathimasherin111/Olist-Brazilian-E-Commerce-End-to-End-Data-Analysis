USE olist_db;
-- (1)Total revenue overview
USE olist_db;

SELECT
    COUNT(DISTINCT order_id)         AS total_orders,
    COUNT(DISTINCT customer_id)      AS total_customers,
    COUNT(DISTINCT product_id)       AS total_products,
    COUNT(DISTINCT seller_id)        AS total_sellers,
    ROUND(SUM(total_payment), 2)     AS total_revenue_brl,
    ROUND(AVG(total_payment), 2)     AS avg_order_value,
    ROUND(MAX(total_payment), 2)     AS max_order_value,
    ROUND(AVG(review_score), 2)      AS avg_review_score
FROM olist;

-- (2) Monthly revenue trend

USE olist_db;

SELECT
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m')  AS month,
    DATE_FORMAT(order_purchase_timestamp, '%b %Y')  AS month_label,
    COUNT(DISTINCT order_id)                         AS total_orders,
    ROUND(SUM(total_payment), 2)                     AS monthly_revenue,
    ROUND(AVG(total_payment), 2)                     AS avg_order_value
FROM olist
WHERE order_purchase_timestamp IS NOT NULL
GROUP BY month, month_label
ORDER BY month;

-- (3)Revenue by payment type

USE olist_db;

SELECT
    payment_type,
    COUNT(DISTINCT order_id)                         AS total_orders,
    ROUND(SUM(total_payment), 2)                     AS total_revenue,
    ROUND(AVG(total_payment), 2)                     AS avg_order_value,
    ROUND(100.0 * COUNT(DISTINCT order_id) /
        (SELECT COUNT(DISTINCT order_id) FROM olist), 1)
                                                     AS pct_of_orders
FROM olist
GROUP BY payment_type
ORDER BY total_revenue DESC;

-- (4)Top 15 categories by revenue

USE olist_db;
SELECT
    IFNULL(category_english, 'unknown')              AS category,
    COUNT(DISTINCT order_id)                         AS total_orders,
    COUNT(DISTINCT product_id)                       AS unique_products,
    ROUND(SUM(total_payment), 2)                     AS total_revenue,
    ROUND(AVG(total_payment), 2)                     AS avg_order_value,
    ROUND(AVG(review_score), 2)                      AS avg_rating
FROM olist
WHERE category_english IS NOT NULL
GROUP BY category
ORDER BY total_revenue DESC
LIMIT 15;

-- (5) Top 10 sellers by revenue

USE olist_db;
SELECT
    seller_id,
    seller_city,
    seller_state,
    COUNT(DISTINCT order_id)                         AS orders_handled,
    COUNT(DISTINCT product_id)                       AS products_sold,
    ROUND(SUM(total_payment), 2)                     AS total_revenue,
    ROUND(AVG(total_payment), 2)                     AS avg_order_value,
    ROUND(AVG(review_score), 2)                      AS avg_rating
FROM olist
GROUP BY seller_id, seller_city, seller_state
ORDER BY total_revenue DESC
LIMIT 10;

-- (6) Revenue share of top 5 categories

USE olist_db;
WITH category_revenue AS (
    SELECT
        IFNULL(category_english, 'unknown')          AS category,
        SUM(total_payment)                           AS revenue
    FROM olist
    GROUP BY category
),
total AS (
    SELECT SUM(total_payment) AS grand_total FROM olist
)
SELECT
    c.category,
    ROUND(c.revenue, 2)                              AS revenue,
    ROUND(100.0 * c.revenue / t.grand_total, 1)      AS pct_of_total_revenue
FROM category_revenue c, total t
ORDER BY c.revenue DESC
LIMIT 5;

-- (7) Orders and revenue by state

USE olist_db;
SELECT
    customer_state                                   AS state,
    COUNT(DISTINCT customer_id)                      AS unique_customers,
    COUNT(DISTINCT order_id)                         AS total_orders,
    ROUND(SUM(total_payment), 2)                     AS total_revenue,
    ROUND(AVG(total_payment), 2)                     AS avg_spend_per_order
FROM olist
GROUP BY customer_state
ORDER BY total_orders DESC
LIMIT 10;

-- (8)Repeat vs one-time buyers

USE olist_db;
WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id)                     AS order_count
    FROM olist
    GROUP BY customer_id
)
SELECT
    CASE
        WHEN order_count = 1 THEN '1. One-time buyer'
        WHEN order_count = 2 THEN '2. Returning buyer'
        ELSE '3. Loyal buyer (3+ orders)'
    END                                              AS customer_type,
    COUNT(*)                                         AS customers,
    ROUND(100.0 * COUNT(*) /
        (SELECT COUNT(*) FROM customer_orders), 1)   AS pct_of_customers
FROM customer_orders
GROUP BY customer_type
ORDER BY customer_type;

-- (9) New customers acquired per month

USE olist_db;
SELECT
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m')  AS month,
    DATE_FORMAT(order_purchase_timestamp, '%b %Y')  AS month_label,
    COUNT(DISTINCT customer_id)                      AS new_customers,
    COUNT(DISTINCT order_id)                         AS total_orders
FROM olist
WHERE order_purchase_timestamp IS NOT NULL
GROUP BY month, month_label
ORDER BY month;

-- (10)Overall delivery performance
USE olist_db;
SELECT
    COUNT(*)                                         AS total_orders,
    ROUND(AVG(delivery_days), 1)                     AS avg_delivery_days,
    ROUND(MIN(delivery_days), 0)                     AS fastest_delivery_days,
    ROUND(MAX(delivery_days), 0)                     AS slowest_delivery_days,
    COUNT(CASE WHEN delivery_days <= 7  THEN 1 END)  AS delivered_within_1_week,
    COUNT(CASE WHEN delivery_days <= 14 THEN 1 END)  AS delivered_within_2_weeks,
    COUNT(CASE WHEN delivery_days > 30  THEN 1 END)  AS took_over_30_days
FROM olist
WHERE delivery_days IS NOT NULL;

-- (11)On-time vs late delivery rate

USE olist_db;
SELECT
    CASE
        WHEN order_delivered_customer_date <=
             order_estimated_delivery_date
        THEN 'On time'
        ELSE 'Late'
    END                                              AS delivery_status,
    COUNT(*)                                         AS orders,
    ROUND(100.0 * COUNT(*) /
        SUM(COUNT(*)) OVER (), 1)                    AS pct
FROM olist
WHERE order_delivered_customer_date IS NOT NULL
  AND order_delivered_customer_date != 'not_delivered'
  AND order_estimated_delivery_date IS NOT NULL
GROUP BY delivery_status
ORDER BY orders DESC;
-- (12)Worst states for delivery time


SELECT
    customer_state                                   AS state,
    COUNT(*)                                         AS total_orders,
    ROUND(AVG(delivery_days), 1)                     AS avg_delivery_days,
    ROUND(MIN(delivery_days), 0)                     AS fastest_days,
    ROUND(MAX(delivery_days), 0)                     AS slowest_days,
    COUNT(CASE WHEN delivery_days > 20 THEN 1 END)   AS orders_over_20_days
FROM olist
WHERE delivery_days IS NOT NULL
GROUP BY customer_state
ORDER BY avg_delivery_days DESC
LIMIT 10;

-- (13)Rating distribution

USE olist_db;
SELECT
    review_score                                     AS rating,
    COUNT(*)                                         AS total_reviews,
    ROUND(100.0 * COUNT(*) /
        SUM(COUNT(*)) OVER (), 1)                    AS pct_of_reviews
FROM olist
WHERE review_score IS NOT NULL
GROUP BY review_score
ORDER BY review_score DESC;
-- (14) Lowest rated product categories

USE olist_db;
SELECT
    IFNULL(category_english, 'unknown')              AS category,
    COUNT(*)                                         AS total_reviews,
    ROUND(AVG(review_score), 2)                      AS avg_rating,
    COUNT(CASE WHEN review_score <= 2 THEN 1 END)    AS bad_reviews,
    ROUND(100.0 *
        COUNT(CASE WHEN review_score <= 2 THEN 1 END)
        / COUNT(*), 1)                               AS pct_bad_reviews
FROM olist
WHERE category_english IS NOT NULL
  AND review_score IS NOT NULL
GROUP BY category
HAVING COUNT(*) > 100
ORDER BY avg_rating ASC
LIMIT 10;

-- (15)Delivery speed vs review rating

USE olist_db;
SELECT
    CASE
        WHEN delivery_days <= 7  THEN '1. Fast — under 7 days'
        WHEN delivery_days <= 14 THEN '2. Normal — 8 to 14 days'
        WHEN delivery_days <= 30 THEN '3. Slow — 15 to 30 days'
        ELSE '4. Very slow — over 30 days'
    END                                              AS delivery_speed,
    COUNT(*)                                         AS total_orders,
    ROUND(AVG(review_score), 2)                      AS avg_rating,
    COUNT(CASE WHEN review_score >= 4 THEN 1 END)    AS good_reviews,
    COUNT(CASE WHEN review_score <= 2 THEN 1 END)    AS bad_reviews
FROM olist
WHERE delivery_days IS NOT NULL
  AND review_score IS NOT NULL
GROUP BY delivery_speed
ORDER BY delivery_speed;

-- (16)Running total revenue by month

USE olist_db;
SELECT
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m')   AS month,
    ROUND(SUM(total_payment), 2)                     AS monthly_revenue,
    ROUND(SUM(SUM(total_payment)) OVER (
        ORDER BY DATE_FORMAT(order_purchase_timestamp, '%Y-%m')
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ), 2)                                            AS running_total_revenue
FROM olist
WHERE order_purchase_timestamp IS NOT NULL
GROUP BY month
ORDER BY month;

-- (17)Month-over-month revenue growth %

USE olist_db;
WITH monthly AS (
    SELECT
        DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS month,
        ROUND(SUM(total_payment), 2)                   AS revenue
    FROM olist
    WHERE order_purchase_timestamp IS NOT NULL
    GROUP BY month
)
SELECT
    month,
    revenue                                            AS monthly_revenue,
    LAG(revenue) OVER (ORDER BY month)                 AS prev_month_revenue,
    ROUND(
        100.0 * (revenue - LAG(revenue) OVER (ORDER BY month))
        / LAG(revenue) OVER (ORDER BY month)
    , 1)                                               AS mom_growth_pct
FROM monthly
ORDER BY month;

-- (18)Category revenue rank

USE olist_db;
SELECT
    IFNULL(category_english, 'unknown')              AS category,
    ROUND(SUM(total_payment), 2)                     AS total_revenue,
    COUNT(DISTINCT order_id)                         AS total_orders,
    ROUND(AVG(review_score), 2)                      AS avg_rating,
    RANK() OVER (
        ORDER BY SUM(total_payment) DESC
    )                                                AS revenue_rank
FROM olist
WHERE category_english IS NOT NULL
GROUP BY category
ORDER BY revenue_rank
LIMIT 15;