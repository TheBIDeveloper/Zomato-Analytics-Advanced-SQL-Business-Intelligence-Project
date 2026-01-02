USE ZomatoAnalytics;
GO

/* =====================================================
   WINDOW FUNCTION ANALYSIS
   ===================================================== */

-- 1. Rank restaurants by revenue (overall)
SELECT 
    r.restaurant_name,
    SUM(o.total_amount) AS revenue,
    RANK() OVER (ORDER BY SUM(o.total_amount) DESC) AS revenue_rank
FROM orders o
JOIN restaurants r
    ON o.restaurant_id = r.restaurant_id
GROUP BY r.restaurant_name;

-- 2. Rank restaurants by revenue within each city
SELECT 
    r.city,
    r.restaurant_name,
    SUM(o.total_amount) AS revenue,
    RANK() OVER (
        PARTITION BY r.city
        ORDER BY SUM(o.total_amount) DESC
    ) AS city_rank
FROM orders o
JOIN restaurants r
    ON o.restaurant_id = r.restaurant_id
GROUP BY r.city, r.restaurant_name;

-- 3. Running total of revenue by order date
SELECT 
    order_date,
    total_amount,
    SUM(total_amount) OVER (
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_revenue
FROM orders;

-- 4. First order date for each customer
SELECT DISTINCT
    customer_id,
    FIRST_VALUE(order_date) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS first_order_date
FROM orders;

-- 5. Identify repeat orders using LAG
SELECT 
    customer_id,
    order_date,
    LAG(order_date) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS previous_order_date
FROM orders;

-- 6. Days between consecutive orders
SELECT 
    customer_id,
    order_date,
    DATEDIFF(
        DAY,
        LAG(order_date) OVER (
            PARTITION BY customer_id
            ORDER BY order_date
        ),
        order_date
    ) AS days_since_last_order
FROM orders;
