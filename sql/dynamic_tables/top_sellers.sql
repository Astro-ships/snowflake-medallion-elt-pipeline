-- ==========================================================
-- Configure Snowflake Session
-- ==========================================================
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE ECOMMERCE_DB;

CREATE SCHEMA IF NOT EXISTS ANALYTICS;
USE SCHEMA ANALYTICS;

-- ==========================================================
-- Dynamic Table: Top 3 Sellers by Monthly Revenue
-- ==========================================================
-- Purpose:
-- Identifies the top three performing sellers for each
-- calendar month based on total sales revenue.
--
-- Ranking Method:
-- Uses DENSE_RANK() to preserve ties while ensuring
-- consecutive ranking values.
--
-- Refresh Strategy:
-- Automatically refreshed within one day whenever
-- FACT_SALES receives new data.
-- ==========================================================
CREATE OR REPLACE DYNAMIC TABLE top3_monthly_sellers
TARGET_LAG='1 day'
WAREHOUSE = compute_wh
AS 
WITH top_sellers AS (

    -- ------------------------------------------------------
    -- Aggregate total sales for each seller by calendar month.
    -- One row represents one seller's monthly sales.
    -- ------------------------------------------------------

    SELECT
        seller_key,
        DATE_TRUNC('MONTH', order_purchase_timestamp) AS month,
        SUM(sales_amount) AS total_sales
    FROM GOLD.FACT_SALES
    GROUP BY 1,2

),

ranked_sellers AS (

    -- ------------------------------------------------------
    -- Rank sellers within each month based on total sales.
    -- DENSE_RANK() preserves ties without skipping rank values.
    -- ------------------------------------------------------

    SELECT
        seller_key,
        month,
        total_sales,
        DENSE_RANK() OVER (
            PARTITION BY month
            ORDER BY total_sales DESC
        ) AS top_rank
    FROM top_sellers

)

-- ----------------------------------------------------------
-- Retrieve the Top 3 Sellers for each month by joining
-- the ranked results with the Seller Dimension to expose
-- business-friendly seller attributes.
-- ----------------------------------------------------------

SELECT
    rs.month,
    rs.seller_key,
    ds.seller_state,
    ds.seller_city,
    rs.total_sales,
    rs.top_rank

FROM ranked_sellers AS rs
JOIN GOLD.DIM_SELLERS AS ds
    ON rs.seller_key = ds.seller_key

WHERE top_rank <= 3;

-- ==========================================================
-- Validation
-- ==========================================================
-- Verify the Dynamic Table contents by displaying the
-- Top 3 sellers for each month ordered by month and rank.
-- ==========================================================

SELECT *
FROM ANALYTICS.top3_monthly_sellers
ORDER BY month, top_rank;

