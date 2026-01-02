USE ZomatoAnalytics;
GO

/* =====================================================
   ADVANCED BUSINESS ANALYSIS
   ===================================================== */

-- 1. New vs Repeat Customers
WITH customer_orders AS (
    SELECT 
        customer_id,
        COUNT(order_id) AS total_orders
    FROM orders
    GROUP BY customer_id
)
SELECT
    CASE 
        WHEN total_orders = 1 THEN 'New Customer'
        ELSE 'Repeat Customer'
    END AS customer_type,
    COUNT(*) AS customer_count
FROM customer_orders
GROUP BY 
    CASE 
        WHEN total_orders = 1 THEN 'New Customer'
        ELSE 'Repeat Customer'
    END;

-- 2. Monthly new customers
WITH first_order AS (
    SELECT 
        customer_id,
        MIN(order_date) AS first_order_date
    FROM orders
    GROUP BY customer_id
)
SELECT 
    FORMAT(first_order_date, 'yyyy-MM') AS order_month,
    COUNT(customer_id) AS new_customers
FROM first_order
GROUP BY FORMAT(first_order_date, 'yyyy-MM')
ORDER BY order_month;

-- 3. Top 10% customers by revenue
WITH customer_revenue AS (
    SELECT 
        customer_id,
        SUM(total_amount) AS total_spent
    FROM orders
    GROUP BY customer_id
),
ranked_customers AS (
    SELECT *,
           NTILE(10) OVER (ORDER BY total_spent DESC) AS revenue_bucket
    FROM customer_revenue
)
SELECT 
    customer_id,
    total_spent
FROM ranked_customers
WHERE revenue_bucket = 1;

-- 4. Average order value per city
SELECT 
    r.city,
    CAST(AVG(o.total_amount) AS DECIMAL(10,2)) AS avg_order_value
FROM orders o
JOIN restaurants r
    ON o.restaurant_id = r.restaurant_id
GROUP BY r.city;

-- 5. Peak ordering hour
SELECT 
    DATEPART(HOUR, order_date) AS order_hour,
    COUNT(*) AS total_orders
FROM orders
GROUP BY DATEPART(HOUR, order_date)
ORDER BY total_orders DESC;

-- 6. Customers inactive for last 60 days
SELECT DISTINCT
    c.customer_id,
    c.customer_name
FROM customers c
WHERE c.customer_id NOT IN (
    SELECT DISTINCT customer_id
    FROM orders
    WHERE order_date >= DATEADD(DAY, -60, GETDATE())
);

-- 7. Restaurant performance category
SELECT 
    r.restaurant_name,
    SUM(o.total_amount) AS revenue,
    CASE
        WHEN SUM(o.total_amount) >= 500 THEN 'High Performing'
        WHEN SUM(o.total_amount) BETWEEN 300 AND 499 THEN 'Medium Performing'
        ELSE 'Low Performing'
    END AS performance_category
FROM restaurants r
JOIN orders o
    ON r.restaurant_id = o.restaurant_id
GROUP BY r.restaurant_name;
