-- =====================================================
-- E-Commerce Sales Intelligence
-- SQL Analysis 01: Overall Sales Performance
-- =====================================================

-- 1. Total Sales
SELECT
    SUM(Sales) AS total_sales
FROM orders;


-- 2. Total Profit
SELECT
    SUM(Profit) AS total_profit
FROM orders;


-- 3. Total Quantity Sold
SELECT
    SUM(Quantity) AS total_quantity
FROM orders;


-- 4. Number of Orders
SELECT
    COUNT(DISTINCT "Order ID") AS total_orders
FROM orders;


-- 5. Number of Customers
SELECT
    COUNT(DISTINCT "Customer ID") AS total_customers
FROM orders;

-- 6. Monthly Sales and Profit Trend
SELECT
    strftime('%Y-%m', "Order Date") AS order_month,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    COUNT(DISTINCT "Order ID") AS total_orders
FROM orders
GROUP BY order_month
ORDER BY order_month;

-- 7. Yearly Sales and Profit Performance
SELECT
    strftime('%Y', "Order Date") AS order_year,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    COUNT(DISTINCT "Order ID") AS total_orders,
    COUNT(DISTINCT "Customer ID") AS total_customers
FROM orders
GROUP BY order_year
ORDER BY order_year;

-- 8. Year-over-Year Sales and Profit Growth

WITH yearly AS (
    SELECT
        strftime('%Y', "Order Date") AS order_year,
        SUM(Sales) AS total_sales,
        SUM(Profit) AS total_profit
    FROM orders
    GROUP BY order_year
)

SELECT
    order_year,
    ROUND(total_sales, 2) AS total_sales,
    ROUND(total_profit, 2) AS total_profit,

    ROUND(
        (total_sales - LAG(total_sales) OVER (ORDER BY order_year))
        / LAG(total_sales) OVER (ORDER BY order_year) * 100,
        2
    ) AS sales_yoy_growth_pct,

    ROUND(
        (total_profit - LAG(total_profit) OVER (ORDER BY order_year))
        / LAG(total_profit) OVER (ORDER BY order_year) * 100,
        2
    ) AS profit_yoy_growth_pct

FROM yearly
ORDER BY order_year;