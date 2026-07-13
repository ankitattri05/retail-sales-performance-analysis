-- Data Validation and Quality Checks
-- =====================================================

-- Dataset overview
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_name) AS total_customers,
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date
FROM store;


-- Missing value check 
SELECT
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS missing_order_id,
    SUM(CASE WHEN customer_name IS NULL THEN 1 ELSE 0 END) AS missing_customer,
    SUM(CASE WHEN sales IS NULL THEN 1 ELSE 0 END) AS missing_sales,
    SUM(CASE WHEN profit IS NULL THEN 1 ELSE 0 END) AS missing_profit,
    SUM(CASE WHEN category IS NULL THEN 1 ELSE 0 END) AS missing_category
FROM store;


-- Duplicate order check
SELECT
    order_id,
    COUNT(*) AS duplicate_records
FROM store
GROUP BY order_id
HAVING COUNT(*) > 1;


-- Verify yearly coverage
SELECT
    year,
    COUNT(*) AS total_transactions
FROM store
GROUP BY year
ORDER BY year;


-- Verify category distribution
SELECT
    category,
    COUNT(*) AS total_records
FROM store
GROUP BY category
ORDER BY total_records DESC;