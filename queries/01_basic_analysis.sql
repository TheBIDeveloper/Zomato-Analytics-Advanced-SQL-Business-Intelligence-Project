USE ZomatoAnalytics;
GO

/* =====================================================
   BASIC BUSINESS ANALYSIS
   ===================================================== */

-- 1. Total number of customers
SELECT COUNT(*) AS total_customers
FROM customers;

-- 2. Total number of orders
SELECT COUNT(*) AS total_orders
FROM orders;

-- 3. Total revenue generated
SELECT SUM(total_amount) AS total_revenue
FROM orders;

-- 4. Total customers per city
SELECT city, COUNT(*) AS customer_count
FROM customers
GROUP BY city;

-- 5. Total revenue per city
SELECT c.city, SUM(o.total_amount) AS total_revenue
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY c.city;

-- 6. Average order value (AOV)
SELECT 
    CAST(SUM(total_amount) / COUNT(order_id) AS DECIMAL(10,2)) AS average_order_value
FROM orders;

-- 7. Orders count per restaurant
SELECT r.restaurant_name, COUNT(o.order_id) AS total_orders
FROM orders o
JOIN restaurants r
    ON o.restaurant_id = r.restaurant_id
GROUP BY r.restaurant_name;

-- 8. Revenue per restaurant
SELECT r.restaurant_name, SUM(o.total_amount) AS restaurant_revenue
FROM orders o
JOIN restaurants r
    ON o.restaurant_id = r.restaurant_id
GROUP BY r.restaurant_name;

-- 9. Customers who placed more than one order
SELECT customer_id, COUNT(order_id) AS order_count
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id) > 1;

-- 10. Latest order date
SELECT MAX(order_date) AS latest_order_date
FROM orders;
