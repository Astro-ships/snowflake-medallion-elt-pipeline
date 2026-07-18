-- ==========================================================
-- Configure Snowflake Session
-- ==========================================================
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE ECOMMERCE_DB;

CREATE SCHEMA IF NOT EXISTS ANALYTICS;
USE SCHEMA ANALYTICS;

-- ==========================================================
-- Dynamic Table: Monthly Sales
-- Automatically refreshes aggregated monthly sales from the
-- Gold layer.
-- ==========================================================

CREATE OR REPLACE DYNAMIC TABLE MONTHLY_SALES
TARGET_LAG = '1 day'
WAREHOUSE = COMPUTE_WH
AS

SELECT
    DATE_TRUNC('MONTH', ORDER_PURCHASE_TIMESTAMP) AS sales_month,
    SUM(sales_amount) AS total_sales
FROM GOLD.FACT_SALES
GROUP BY 1;

-- =====================
-- Validate
-- =====================
SELECT * FROM MONTHLY_SALES;