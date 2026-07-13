-- =====================================================
-- Retail Sales Performance Analysis
-- KPI and Business Analysis
-- =====================================================

-- Overall business KPIs

SELECT
    ROUND(SUM(sales),2) AS total_sales,
    ROUND(SUM(profit),2) AS total_profit,
    ROUND((SUM(profit)/SUM(sales))*100,2) AS profit_margin_pct,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(sales)/COUNT(DISTINCT order_id),2

-- Shipping cost contribution

SELECT
    ROUND(SUM(shipping_cost),2) AS total_shipping_cost,
    ROUND(SUM(sales),2) AS total_sales,
    ROUND((SUM(shipping_cost)/SUM(sales))*100,2) AS shipping_cost_ratio_pct
FROM store;

-- Discount Analysis

SELECT
    CONCAT(ROUND(discount * 100,0), '%') AS discount_percentage,
    ROUND(SUM(sales),2) AS total_sales,
    ROUND(SUM(profit),2) AS total_profit,
    ROUND((SUM(profit)/SUM(sales))*100,2) AS profit_margin_pct
FROM store
GROUP BY discount
ORDER BY discount;

-- Discount Bands

SELECT
    CASE
        WHEN discount = 0 THEN '0%'
        WHEN discount <= 0.10 THEN '1%-10%'
        WHEN discount <= 0.20 THEN '11%-20%'
        WHEN discount <= 0.30 THEN '21%-30%'
        ELSE '30%+'
    END AS discount_band,
    ROUND(SUM(sales),2) AS total_sales,
    ROUND(SUM(profit),2) AS total_profit,
    ROUND((SUM(profit)/SUM(sales))*100,2) AS profit_margin_pct
FROM store
GROUP BY discount_band
ORDER BY discount_band;

-- High Discount Orders

SELECT
    order_id,
    customer_name,
    sales,
    CONCAT(ROUND(discount * 100, 0), '%') AS discount_percentage,
    profit
FROM store
WHERE (discount * 100) >= 30
ORDER BY profit ASC
LIMIT 50;

-- High Discount Order Count

SELECT
    COUNT(DISTINCT order_id) AS total_high_discount_orders
FROM store
WHERE discount > 0.30;

-- Shipping Mode Economics

SELECT
    ship_mode,
    ROUND(AVG(shipping_cost),2) AS avg_shipping_cost,
    ROUND(AVG(time_for_shipping),2) AS avg_shipping_days,
    ROUND(SUM(sales),2) AS total_sales,
    ROUND(SUM(profit),2) AS total_profit,
    ROUND((SUM(profit)/SUM(sales))*100,2) AS profit_margin_pct
FROM store
GROUP BY ship_mode
ORDER BY total_profit DESC;

-- YoY Growth

WITH yearly_summary AS (
    SELECT
        year,
        SUM(sales) AS total_sales
    FROM store
    GROUP BY year
)

SELECT
    year,
    ROUND(total_sales, 2) AS total_sales,
    ROUND(
        ((total_sales - LAG(total_sales) OVER (ORDER BY year))
         / LAG(total_sales) OVER (ORDER BY year)) * 100,
        2
    ) AS yoy_growth_pct
FROM yearly_summary;

--Order Priority Economics

SELECT
    order_priority,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        (SUM(profit) / NULLIF(SUM(sales), 0)) * 100,
        2
    ) AS profit_margin_pct,
    ROUND(AVG(shipping_cost), 2) AS avg_shipping_cost,
    ROUND(AVG(time_for_shipping), 2) AS avg_shipping_time
FROM store
GROUP BY order_priority
ORDER BY total_sales DESC;