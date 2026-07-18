-- ==========================================================
-- Configure Snowflake Session
-- ==========================================================
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE ECOMMERCE_DB;

CREATE SCHEMA IF NOT EXISTS ANALYTICS;
USE SCHEMA ANALYTICS;

-- ==========================================================
-- Dynamic Table: Top 3 Products by Monthly Revenue
-- ==========================================================
-- Purpose:
-- Identifies the three highest-selling products for each
-- calendar month based on total sales revenue.
--
-- Ranking Method:
-- Uses DENSE_RANK() to preserve ties while ensuring
-- consecutive ranking values.
--
-- Refresh Strategy:
-- Automatically refreshed within one day whenever
-- FACT_SALES receives new records.
-- ==========================================================

CREATE OR REPLACE DYNAMIC TABLE top_3_monthly_products
TARGET_LAG = '1 day'
WAREHOUSE =compute_wh
AS 
WITH top_monthly_product AS (

            SELECT product_key,DATE_TRUNC('MONTH',order_purchase_timestamp) AS curr_month,
                    SUM(sales_amount) as total_sales 
                    FROM GOLD.FACT_sales
                    GROUP BY 1,2
                   
),
top_product AS (
        SELECT curr_month,
                product_key,
                total_sales,
                DENSE_RANK() OVER (PARTITION BY curr_month ORDER BY total_sales DESC ) AS top_rank 
        FROM top_monthly_product 
)

SELECT 
        tp.curr_month,
        tp.product_key,
        dp.product_category_name,
        tp.total_sales,
        tp.top_rank
FROM top_product AS tp
JOIN GOLD.DIM_PRODUCTS AS dp
ON 
tp.product_key = dp.product_key
WHERE top_rank <=3;
-- ==========================================================
-- Validation
-- ==========================================================
SELECT *
FROM TOP_3_MONTHLY_PRODUCTS
ORDER BY curr_month, top_rank;

