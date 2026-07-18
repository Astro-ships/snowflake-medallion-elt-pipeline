-- ==========================================================
-- Configure Snowflake Session
-- ==========================================================
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE ECOMMERCE_DB;

CREATE SCHEMA IF NOT EXISTS ANALYTICS;
USE SCHEMA ANALYTICS;


-- ==========================================================
-- Dynamic Table: Month-over-Month (MoM) Sales Growth
-- ==========================================================
-- Purpose:
-- Automatically calculates monthly sales revenue and
-- Month-over-Month (MoM) growth percentage from the
-- FACT_SALES table in the Gold layer.
--
-- Refresh Strategy:
-- Snowflake refreshes the Dynamic Table automatically
-- within a maximum lag of one day whenever FACT_SALES
-- receives new data.
-- ==========================================================

CREATE OR REPLACE DYNAMIC TABLE MONTHLY_GROWTH
TARGET_LAG = '1 day'
WAREHOUSE = COMPUTE_WH
AS

WITH monthly_growth AS (

    -- ------------------------------------------------------
    -- Aggregate total sales for each calendar month.
    -- One row represents one month of sales.
    -- ------------------------------------------------------

    SELECT
        DATE_TRUNC('MONTH', order_purchase_timestamp) AS monthly_sales,
        SUM(sales_amount) AS total_sales
    FROM GOLD.FACT_SALES
    GROUP BY 1

),

m_growth AS (

    -- ------------------------------------------------------
    -- Retrieve the previous month's sales using the
    -- LAG() window function.
    -- This enables Month-over-Month (MoM) comparison.
    -- ------------------------------------------------------

    SELECT
        monthly_sales,
        total_sales,
        LAG(total_sales, 1)
            OVER (ORDER BY monthly_sales) AS prev_month_sales
    FROM monthly_growth

)

-- ----------------------------------------------------------
-- Calculate Month-over-Month (MoM) Growth Percentage
--
-- Formula:
--
-- ((Current Month Sales - Previous Month Sales)
--          / Previous Month Sales) × 100
--
-- The first month returns NULL because no previous
-- month exists for comparison.
-- ----------------------------------------------------------

SELECT
    monthly_sales,
    total_sales,
    prev_month_sales,

    CASE
        WHEN prev_month_sales IS NULL THEN NULL
        ELSE ROUND(
                ((total_sales - prev_month_sales)
                / prev_month_sales) * 100,
                2)
    END AS monthly_growth_percentage

FROM m_growth;

-- ==========================================================
-- Validation
-- ==========================================================
-- Query the Dynamic Table to verify the calculated
-- monthly sales and Month-over-Month growth metrics.
-- ==========================================================

SELECT *
FROM ANALYTICS.MONTHLY_GROWTH;

