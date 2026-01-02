USE ZomatoAnalytics;
GO

/* =====================================================
   CTE & SUBQUERY BASED ANALYSIS
   ===================================================== */

-- 1. Customers who spent more than average customer spend
WITH customer_spending AS (
    SELECT 
        customer_id,
        SUM(total_amount) AS total_spent
    FROM orders
    GROUP BY customer_id
)
SELECT 
    customer_id,
    total_spent
FROM customer_spending
WHERE total_spent >
      (SELECT AVG(total_spent) FROM customer_spending);

-- 2. Restaurants with revenue greater than average restaurant revenue
WITH restaurant_revenue AS (
    SELECT 
        restaurant_id,
        SUM(total_amount) AS revenue
    FROM orders
    GROUP BY restaurant_id
)
SELECT 
    r.restaurant_name,
    rr.revenue
FROM restaurant_revenue rr
JOIN restaurants r
    ON rr.restaurant_id = r.restaurant_id
WHERE rr.revenue >
      (SELECT AVG(revenue) FROM restaurant_revenue);

-- 3. Customers who ordered from more than one restaurant
SELECT 
    customer_id,
    COUNT(DISTINCT restaurant_id) AS restaurant_count
FROM orders
GROUP BY customer_id
HAVING COUNT(DISTINCT restaurant_id) > 1;

-- 4. Monthly revenue using CTE
WITH monthly_revenue AS (
    SELECT 
        FORMAT(order_date, 'yyyy-MM') AS order_month,
        SUM(total_amount) AS revenue
    FROM orders
    GROUP BY FORMAT(order_date, 'yyyy-MM')
)
SELECT *
FROM monthly_revenue
ORDER BY order_month;

-- 5. Restaurants contributing to top 30% revenue
WITH restaurant_revenue AS (
    SELECT 
        restaurant_id,
        SUM(total_amount) AS revenue
    FROM orders
    GROUP BY restaurant_id
),
ranked_restaurants AS (
    SELECT 
        restaurant_id,
        revenue,
        NTILE(10) OVER (ORDER BY revenue DESC) AS revenue_bucket
    FROM restaurant_revenue
)
SELECT 
    r.restaurant_name,
    rr.revenue
FROM ranked_restaurants rr
JOIN restaurants r
    ON rr.restaurant_id = r.restaurant_id
WHERE revenue_bucket <= 3;
