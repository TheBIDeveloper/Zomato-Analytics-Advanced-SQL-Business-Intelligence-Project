USE ZomatoAnalytics;
GO

/* =====================================================
   JOIN BASED ANALYSIS
   ===================================================== */

-- 1. Customer name with total orders placed
SELECT 
    c.customer_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_name;

-- 2. Customers who never placed an order
SELECT 
    c.customer_name
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- 3. Restaurant name with total revenue
SELECT 
    r.restaurant_name,
    SUM(o.total_amount) AS total_revenue
FROM restaurants r
LEFT JOIN orders o
    ON r.restaurant_id = o.restaurant_id
GROUP BY r.restaurant_name;

-- 4. Restaurant revenue along with city
SELECT 
    r.restaurant_name,
    r.city,
    SUM(o.total_amount) AS revenue
FROM restaurants r
JOIN orders o
    ON r.restaurant_id = o.restaurant_id
GROUP BY r.restaurant_name, r.city;

-- 5. Customer-wise total spending
SELECT 
    c.customer_name,
    SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_name;

-- 6. City-wise total revenue
SELECT 
    r.city,
    SUM(o.total_amount) AS total_revenue
FROM restaurants r
JOIN orders o
    ON r.restaurant_id = o.restaurant_id
GROUP BY r.city;

-- 7. Restaurant with highest revenue
SELECT TOP 1
    r.restaurant_name,
    SUM(o.total_amount) AS total_revenue
FROM restaurants r
JOIN orders o
    ON r.restaurant_id = o.restaurant_id
GROUP BY r.restaurant_name
ORDER BY total_revenue DESC;

-- 8. Average rating of restaurants per city
SELECT 
    city,
    AVG(rating) AS avg_rating
FROM restaurants
GROUP BY city;
