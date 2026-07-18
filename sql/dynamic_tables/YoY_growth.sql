-- ==========================================================
-- Configure Snowflake Session
-- ==========================================================
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE ECOMMERCE_DB;

CREATE SCHEMA IF NOT EXISTS ANALYTICS;
USE SCHEMA ANALYTICS;

-- ==========================================================
-- Dynamic Table: Year-over-Year (YoY) Sales Growth
-- ==========================================================
-- Purpose:
-- Automatically calculates yearly sales revenue and
-- Year-over-Year (YoY) growth percentage from the Gold layer.
--
-- Refresh Strategy:
-- Snowflake automatically refreshes the Dynamic Table
-- within a maximum lag of one day whenever FACT_SALES
-- receives new data.
-- ==========================================================

WITH yoy_growth AS (

    -- ------------------------------------------------------
    -- Aggregate total sales for each calendar year.
    -- One row represents one year of sales.
    -- ------------------------------------------------------

    SELECT
        EXTRACT(YEAR FROM order_purchase_timestamp) AS sales_year,
        SUM(sales_amount) AS total_sales
    FROM GOLD.FACT_SALES
    GROUP BY 1

),

yoy AS (

    -- ------------------------------------------------------
    -- Retrieve the previous year's sales using the
    -- LAG() window function.
    -- This allows calculation of YoY growth.
    -- ------------------------------------------------------

    SELECT
        sales_year,
        total_sales,
        LAG(total_sales, 1)
            OVER (ORDER BY sales_year) AS prev_year_sales
    FROM yoy_growth

)

-- ----------------------------------------------------------
-- Calculate Year-over-Year Growth Percentage
--
-- Formula:
--
-- ((Current Year Sales - Previous Year Sales)
--        / Previous Year Sales) × 100
--
-- The first year returns NULL because no previous year
-- exists for comparison.
-- ----------------------------------------------------------

SELECT
    sales_year,
    total_sales,
    prev_year_sales,

    CASE
        WHEN prev_year_sales IS NULL THEN NULL
        ELSE ROUND(
                ((total_sales - prev_year_sales)
                / prev_year_sales) * 100,
                2)
    END AS yoy_growth_percentage

FROM yoy;
-- =====================
-- Validate
-- =====================
SELECT * from yoy_growth;