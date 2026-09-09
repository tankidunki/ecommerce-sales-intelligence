-- =====================================================
-- E-Commerce Sales Intelligence
-- SQL Analysis 02: Customer Performance
-- =====================================================

-- Top 20 Customers by Sales and Profitability

SELECT
    "Customer ID" AS customer_id,
    "Customer Name" AS customer_name,
    COUNT(DISTINCT "Order ID") AS total_orders,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,

    ROUND(
        SUM(Profit) / SUM(Sales) * 100,
        2
    ) AS profit_margin_pct

FROM orders

GROUP BY
    "Customer ID",
    "Customer Name"

ORDER BY total_sales DESC

LIMIT 20;

-- Customers with Negative Profit

SELECT
    "Customer ID" AS customer_id,
    "Customer Name" AS customer_name,
    COUNT(DISTINCT "Order ID") AS total_orders,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,

    ROUND(
        SUM(Profit) / SUM(Sales) * 100,
        2
    ) AS profit_margin_pct

FROM orders

GROUP BY
    "Customer ID",
    "Customer Name"

HAVING SUM(Profit) < 0

ORDER BY total_profit ASC;

-- High-Revenue Customers with Negative Profit

SELECT
    "Customer ID" AS customer_id,
    "Customer Name" AS customer_name,
    COUNT(DISTINCT "Order ID") AS total_orders,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,

    ROUND(
        SUM(Profit) / SUM(Sales) * 100,
        2
    ) AS profit_margin_pct

FROM orders

GROUP BY
    "Customer ID",
    "Customer Name"

HAVING
    SUM(Profit) < 0
    AND SUM(Sales) >= 5000

ORDER BY total_sales DESC;

-- Average Order Value by Customer

SELECT
    "Customer ID" AS customer_id,
    "Customer Name" AS customer_name,
    COUNT(DISTINCT "Order ID") AS total_orders,
    ROUND(SUM(Sales), 2) AS total_sales,

    ROUND(
        SUM(Sales) / COUNT(DISTINCT "Order ID"),
        2
    ) AS average_order_value

FROM orders

GROUP BY
    "Customer ID",
    "Customer Name"

ORDER BY average_order_value DESC

LIMIT 20;

-- Recency Analysis

SELECT
    "Customer ID" AS customer_id,
    "Customer Name" AS customer_name,
    MAX("Order Date") AS last_order_date,

    CAST(
        julianday((SELECT MAX("Order Date") FROM orders))
        - julianday(MAX("Order Date"))
        AS INTEGER
    ) AS recency_days

FROM orders

GROUP BY
    "Customer ID",
    "Customer Name"

ORDER BY recency_days ASC;

-- Frequency Analysis

SELECT
    "Customer ID" AS customer_id,
    "Customer Name" AS customer_name,

    COUNT(DISTINCT "Order ID") AS frequency

FROM orders

GROUP BY
    "Customer ID",
    "Customer Name"

ORDER BY frequency DESC;

-- Monetary Analysis

SELECT
    "Customer ID" AS customer_id,
    "Customer Name" AS customer_name,

    ROUND(
        SUM(Sales),
        2
    ) AS monetary_value

FROM orders

GROUP BY
    "Customer ID",
    "Customer Name"

ORDER BY monetary_value DESC;

-- =====================================================
-- RFM Scoring
-- =====================================================

WITH rfm_base AS (

    SELECT
        "Customer ID" AS customer_id,
        "Customer Name" AS customer_name,

        -- Recency
        CAST(
            julianday((SELECT MAX("Order Date") FROM orders))
            - julianday(MAX("Order Date"))
            AS INTEGER
        ) AS recency,

        -- Frequency
        COUNT(DISTINCT "Order ID") AS frequency,

        -- Monetary
        SUM(Sales) AS monetary

    FROM orders

    GROUP BY
        "Customer ID",
        "Customer Name"
),

rfm_scores AS (

    SELECT
        customer_id,
        customer_name,
        recency,
        frequency,
        ROUND(monetary, 2) AS monetary,

        -- Lower recency is better
        NTILE(5) OVER (
            ORDER BY recency DESC
        ) AS recency_score,

        -- Higher frequency is better
        NTILE(5) OVER (
            ORDER BY frequency ASC
        ) AS frequency_score,

        -- Higher monetary value is better
        NTILE(5) OVER (
            ORDER BY monetary ASC
        ) AS monetary_score

    FROM rfm_base
)

SELECT
    customer_id,
    customer_name,
    recency,
    frequency,
    monetary,
    recency_score,
    frequency_score,
    monetary_score

FROM rfm_scores

ORDER BY
    recency_score DESC,
    frequency_score DESC,
    monetary_score DESC;

-- =====================================================
-- RFM Customer Segmentation
-- =====================================================

WITH rfm_base AS (

    SELECT
        "Customer ID" AS customer_id,
        "Customer Name" AS customer_name,

        CAST(
            julianday((SELECT MAX("Order Date") FROM orders))
            - julianday(MAX("Order Date"))
            AS INTEGER
        ) AS recency,

        COUNT(DISTINCT "Order ID") AS frequency,

        SUM(Sales) AS monetary

    FROM orders

    GROUP BY
        "Customer ID",
        "Customer Name"
),

rfm_scores AS (

    SELECT
        customer_id,
        customer_name,
        recency,
        frequency,
        ROUND(monetary, 2) AS monetary,

        NTILE(5) OVER (
            ORDER BY recency DESC
        ) AS recency_score,

        NTILE(5) OVER (
            ORDER BY frequency ASC
        ) AS frequency_score,

        NTILE(5) OVER (
            ORDER BY monetary ASC
        ) AS monetary_score

    FROM rfm_base
)

SELECT
    customer_id,
    customer_name,
    recency,
    frequency,
    monetary,
    recency_score,
    frequency_score,
    monetary_score,

    CASE

        WHEN recency_score >= 4
             AND frequency_score >= 4
             AND monetary_score >= 4
            THEN 'Champions'

        WHEN recency_score >= 3
             AND frequency_score >= 4
            THEN 'Loyal Customers'

        WHEN monetary_score >= 4
            THEN 'Big Spenders'

        WHEN recency_score <= 2
             AND frequency_score >= 3
            THEN 'At Risk'

        WHEN recency_score <= 2
             AND frequency_score <= 2
            THEN 'Lost Customers'

        ELSE 'Regular Customers'

    END AS customer_segment

FROM rfm_scores

ORDER BY
    customer_segment,
    monetary DESC;

    -- =====================================================
-- Customer Segment Distribution
-- =====================================================

WITH rfm_base AS (

    SELECT
        "Customer ID" AS customer_id,
        "Customer Name" AS customer_name,

        CAST(
            julianday((SELECT MAX("Order Date") FROM orders))
            - julianday(MAX("Order Date"))
            AS INTEGER
        ) AS recency,

        COUNT(DISTINCT "Order ID") AS frequency,

        SUM(Sales) AS monetary

    FROM orders

    GROUP BY
        "Customer ID",
        "Customer Name"
),

rfm_scores AS (

    SELECT
        customer_id,
        customer_name,
        recency,
        frequency,
        monetary,

        NTILE(5) OVER (
            ORDER BY recency DESC
        ) AS recency_score,

        NTILE(5) OVER (
            ORDER BY frequency ASC
        ) AS frequency_score,

        NTILE(5) OVER (
            ORDER BY monetary ASC
        ) AS monetary_score

    FROM rfm_base
),

segmented_customers AS (

    SELECT
        customer_id,

        CASE

            WHEN recency_score >= 4
                 AND frequency_score >= 4
                 AND monetary_score >= 4
                THEN 'Champions'

            WHEN recency_score >= 3
                 AND frequency_score >= 4
                THEN 'Loyal Customers'

            WHEN monetary_score >= 4
                THEN 'Big Spenders'

            WHEN recency_score <= 2
                 AND frequency_score >= 3
                THEN 'At Risk'

            WHEN recency_score <= 2
                 AND frequency_score <= 2
                THEN 'Lost Customers'

            ELSE 'Regular Customers'

        END AS customer_segment

    FROM rfm_scores
)

SELECT
    customer_segment,
    COUNT(*) AS customer_count

FROM segmented_customers

GROUP BY customer_segment

ORDER BY customer_count DESC;

-- =====================================================
-- Repeat Purchase Analysis
-- =====================================================

WITH customer_orders AS (

    SELECT
        "Customer ID" AS customer_id,
        COUNT(DISTINCT "Order ID") AS total_orders

    FROM orders

    GROUP BY "Customer ID"
)

SELECT
    CASE
        WHEN total_orders = 1 THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END AS customer_type,

    COUNT(*) AS customer_count

FROM customer_orders

GROUP BY customer_type

ORDER BY customer_count DESC;

-- =====================================================
-- Customer Lifetime Value (Historical CLV)
-- =====================================================

SELECT
    "Customer ID" AS customer_id,
    "Customer Name" AS customer_name,

    COUNT(DISTINCT "Order ID") AS total_orders,

    ROUND(
        SUM(Sales),
        2
    ) AS historical_clv,

    ROUND(
        SUM(Profit),
        2
    ) AS total_profit,

    ROUND(
        SUM(Profit) / SUM(Sales) * 100,
        2
    ) AS profit_margin_pct

FROM orders

GROUP BY
    "Customer ID",
    "Customer Name"

ORDER BY
    historical_clv DESC

LIMIT 20;

-- =====================================================
-- Category Performance
-- =====================================================

SELECT
    Category AS category,

    COUNT(DISTINCT "Order ID") AS total_orders,

    SUM(Quantity) AS total_quantity,

    ROUND(
        SUM(Sales),
        2
    ) AS total_sales,

    ROUND(
        SUM(Profit),
        2
    ) AS total_profit,

    ROUND(
        SUM(Profit) / SUM(Sales) * 100,
        2
    ) AS profit_margin_pct

FROM orders

GROUP BY Category

ORDER BY total_sales DESC;

-- =====================================================
-- Sub-Category Performance
-- =====================================================

SELECT
    "Sub-Category" AS sub_category,

    COUNT(DISTINCT "Order ID") AS total_orders,

    SUM(Quantity) AS total_quantity,

    ROUND(
        SUM(Sales),
        2
    ) AS total_sales,

    ROUND(
        SUM(Profit),
        2
    ) AS total_profit,

    ROUND(
        SUM(Profit) / SUM(Sales) * 100,
        2
    ) AS profit_margin_pct

FROM orders

GROUP BY "Sub-Category"

ORDER BY total_profit DESC;

-- =====================================================
-- Product-Level Profitability
-- =====================================================

SELECT
    "Product ID" AS product_id,
    "Product Name" AS product_name,
    Category AS category,
    "Sub-Category" AS sub_category,

    COUNT(DISTINCT "Order ID") AS total_orders,

    SUM(Quantity) AS total_quantity,

    ROUND(
        SUM(Sales),
        2
    ) AS total_sales,

    ROUND(
        SUM(Profit),
        2
    ) AS total_profit,

    ROUND(
        SUM(Profit) / SUM(Sales) * 100,
        2
    ) AS profit_margin_pct

FROM orders

GROUP BY
    "Product ID",
    "Product Name",
    Category,
    "Sub-Category"

ORDER BY
    total_profit ASC

LIMIT 20;

-- =====================================================
-- Discount vs. Profitability
-- =====================================================

SELECT
    ROUND(Discount * 100, 0) AS discount_pct,

    COUNT(*) AS total_rows,

    ROUND(
        SUM(Sales),
        2
    ) AS total_sales,

    ROUND(
        SUM(Profit),
        2
    ) AS total_profit,

    ROUND(
        SUM(Profit) / SUM(Sales) * 100,
        2
    ) AS profit_margin_pct

FROM orders

GROUP BY Discount

ORDER BY Discount;

-- =====================================================
-- Discount Impact by Category
-- =====================================================

SELECT
    Category AS category,

    ROUND(AVG(Discount) * 100, 2) AS avg_discount_pct,

    ROUND(SUM(Sales), 2) AS total_sales,

    ROUND(SUM(Profit), 2) AS total_profit,

    ROUND(
        SUM(Profit) / SUM(Sales) * 100,
        2
    ) AS profit_margin_pct

FROM orders

GROUP BY Category

ORDER BY profit_margin_pct ASC;

-- =====================================================
-- Regional Sales and Profitability
-- =====================================================

SELECT
    Region AS region,

    COUNT(DISTINCT "Order ID") AS total_orders,

    ROUND(SUM(Sales), 2) AS total_sales,

    ROUND(SUM(Profit), 2) AS total_profit,

    ROUND(
        SUM(Profit) / SUM(Sales) * 100,
        2
    ) AS profit_margin_pct

FROM orders

GROUP BY Region

ORDER BY total_profit DESC;

-- =====================================================
-- Overall Return Rate
-- =====================================================

SELECT
    COUNT(DISTINCT o."Order ID") AS total_orders,

    COUNT(DISTINCT r."Order ID") AS returned_orders,

    ROUND(
        COUNT(DISTINCT r."Order ID") * 100.0
        / COUNT(DISTINCT o."Order ID"),
        2
    ) AS return_rate_pct

FROM orders o

LEFT JOIN returns r
    ON o."Order ID" = r."Order ID";

-- =====================================================
-- Return Rate by Category
-- =====================================================

SELECT
    o.Category AS category,

    COUNT(DISTINCT o."Order ID") AS total_orders,

    COUNT(DISTINCT r."Order ID") AS returned_orders,

    ROUND(
        COUNT(DISTINCT r."Order ID") * 100.0
        / COUNT(DISTINCT o."Order ID"),
        2
    ) AS return_rate_pct,

    ROUND(
        SUM(o.Sales),
        2
    ) AS total_sales,

    ROUND(
        SUM(o.Profit),
        2
    ) AS total_profit

FROM orders o

LEFT JOIN returns r
    ON o."Order ID" = r."Order ID"

GROUP BY o.Category

ORDER BY return_rate_pct DESC;

-- =====================================================
-- Query 21: Return Rate by Region
-- =====================================================

SELECT
    o.Region AS region,

    COUNT(DISTINCT o."Order ID") AS total_orders,

    COUNT(DISTINCT r."Order ID") AS returned_orders,

    ROUND(
        COUNT(DISTINCT r."Order ID") * 100.0
        / COUNT(DISTINCT o."Order ID"),
        2
    ) AS return_rate_pct,

    ROUND(SUM(o.Sales), 2) AS total_sales,

    ROUND(SUM(o.Profit), 2) AS total_profit,

    ROUND(
        SUM(o.Profit) / SUM(o.Sales) * 100,
        2
    ) AS profit_margin_pct

FROM orders o

LEFT JOIN returns r
    ON o."Order ID" = r."Order ID"

GROUP BY o.Region

ORDER BY return_rate_pct DESC;


-- =====================================================
-- Query 22: Return Rate by Sub-Category
-- =====================================================

SELECT
    o."Sub-Category" AS sub_category,

    COUNT(DISTINCT o."Order ID") AS total_orders,

    COUNT(DISTINCT r."Order ID") AS returned_orders,

    ROUND(
        COUNT(DISTINCT r."Order ID") * 100.0
        / COUNT(DISTINCT o."Order ID"),
        2
    ) AS return_rate_pct,

    ROUND(SUM(o.Sales), 2) AS total_sales,

    ROUND(SUM(o.Profit), 2) AS total_profit,

    ROUND(
        SUM(o.Profit) / SUM(o.Sales) * 100,
        2
    ) AS profit_margin_pct

FROM orders o

LEFT JOIN returns r
    ON o."Order ID" = r."Order ID"

GROUP BY o."Sub-Category"

ORDER BY return_rate_pct DESC;


-- =====================================================
-- Query 23: Profitability by Discount Level
-- =====================================================

SELECT
    ROUND(Discount * 100, 0) AS discount_pct,

    COUNT(*) AS total_rows,

    ROUND(SUM(Sales), 2) AS total_sales,

    ROUND(SUM(Profit), 2) AS total_profit,

    ROUND(
        SUM(Profit) / SUM(Sales) * 100,
        2
    ) AS profit_margin_pct

FROM orders

GROUP BY Discount

ORDER BY profit_margin_pct ASC;


-- =====================================================
-- Query 24: Regional Category Performance
-- =====================================================

SELECT
    Region AS region,

    Category AS category,

    ROUND(SUM(Sales), 2) AS total_sales,

    ROUND(SUM(Profit), 2) AS total_profit,

    ROUND(
        SUM(Profit) / SUM(Sales) * 100,
        2
    ) AS profit_margin_pct,

    ROUND(AVG(Discount) * 100, 2) AS avg_discount_pct

FROM orders

GROUP BY Region, Category

ORDER BY region, profit_margin_pct ASC;


-- =====================================================
-- Query 25: Top 20 Most Profitable Products
-- =====================================================

SELECT
    "Product ID" AS product_id,

    "Product Name" AS product_name,

    Category AS category,

    "Sub-Category" AS sub_category,

    ROUND(SUM(Sales), 2) AS total_sales,

    ROUND(SUM(Profit), 2) AS total_profit,

    ROUND(
        SUM(Profit) / SUM(Sales) * 100,
        2
    ) AS profit_margin_pct

FROM orders

GROUP BY
    "Product ID",
    "Product Name",
    Category,
    "Sub-Category"

ORDER BY total_profit DESC

LIMIT 20;


-- =====================================================
-- Query 26: Top 20 Products by Sales with Negative Profit
-- =====================================================

SELECT
    "Product ID" AS product_id,

    "Product Name" AS product_name,

    Category AS category,

    "Sub-Category" AS sub_category,

    ROUND(SUM(Sales), 2) AS total_sales,

    ROUND(SUM(Profit), 2) AS total_profit,

    ROUND(
        SUM(Profit) / SUM(Sales) * 100,
        2
    ) AS profit_margin_pct,

    ROUND(AVG(Discount) * 100, 2) AS avg_discount_pct

FROM orders

GROUP BY
    "Product ID",
    "Product Name",
    Category,
    "Sub-Category"

HAVING SUM(Profit) < 0

ORDER BY total_sales DESC

LIMIT 20;