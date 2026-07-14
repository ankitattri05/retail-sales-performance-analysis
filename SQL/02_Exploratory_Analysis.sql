-- =====================================================
-- Retail Sales Performance Analysis
-- Exploratory Analysis
-- =====================================================

-- Market Performance

-- Sales by market

SELECT
    market,
    ROUND(SUM(sales),2) AS total_sales
FROM store
GROUP BY market
ORDER BY total_sales DESC;

-- Profitability by region

SELECT
    region,
    ROUND(SUM(sales),2) AS total_sales,
    ROUND(SUM(profit),2) AS total_profit,
    ROUND((SUM(profit)/SUM(sales))*100,2) AS profit_margin_pct
FROM store
GROUP BY region
ORDER BY total_profit DESC;

-- Product Performance

-- Category performance

SELECT
    category,
    ROUND(SUM(sales),2) AS total_sales,
    ROUND(SUM(profit),2) AS total_profit
FROM store
GROUP BY category
ORDER BY total_sales DESC;

-- Sub-category performance

SELECT
    sub_category,
    ROUND(SUM(sales),2) AS total_sales,
    ROUND(SUM(profit),2) AS total_profit,
    ROUND((SUM(profit)/SUM(sales))*100,2) AS profit_margin_pct
FROM store
GROUP BY sub_category
ORDER BY total_sales DESC;

-- Loss making products

SELECT
    product_name,
    ROUND(SUM(sales),2) AS total_sales,
    ROUND(SUM(profit),2) AS total_profit
FROM store
GROUP BY product_name
HAVING SUM(profit) < 0
ORDER BY total_profit ASC
LIMIT 50;

-- Customer Analysis

-- Top customers by sales

SELECT
    customer_name,
    ROUND(SUM(sales),2) AS total_sales,
    ROUND(SUM(profit),2) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders
FROM store
GROUP BY customer_name
ORDER BY total_sales DESC
LIMIT 20;

-- Segment performance

SELECT
    segment,
    ROUND(SUM(sales),2) AS total_sales,
    ROUND(SUM(profit),2) AS total_profit,
    ROUND((SUM(profit)/SUM(sales))*100,2) AS profit_margin_pct
FROM store
GROUP BY segment
ORDER BY total_sales DESC;

-- Time Analysis

-- Monthly sales trend

SELECT
    YEAR(STR_TO_DATE(order_date,'%d-%m-%Y')) AS year,
    MONTH(STR_TO_DATE(order_date,'%d-%m-%Y')) AS month,
    ROUND(SUM(sales),2) AS monthly_sales
FROM store
GROUP BY
    YEAR(STR_TO_DATE(order_date,'%d-%m-%Y')),
    MONTH(STR_TO_DATE(order_date,'%d-%m-%Y'))
ORDER BY
    year,
    month;

-- Yearly sales and profit trend

SELECT
    year,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS profit_margin_pct
FROM store
GROUP BY year
ORDER BY year;
-- Ranking Analysis

-- Product contribution ranking using CTE and window function

WITH product_sales AS (
    SELECT
        product_name,
        SUM(sales) AS total_sales
    FROM store
    GROUP BY product_name
)

SELECT
    product_name,
    total_sales,
    RANK() OVER(ORDER BY total_sales DESC) AS product_rank,
    ROUND(
        (total_sales /
         SUM(total_sales) OVER()) * 100,2
    ) AS revenue_contribution_pct
FROM product_sales
LIMIT 50;
