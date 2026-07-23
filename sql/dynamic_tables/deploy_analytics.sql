-- ==========================================================
-- Configure Snowflake Session
-- ==========================================================
-- USE ROLE GITHUB_ACTIONS_ROLE;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE ECOMMERCE_DB;

CREATE SCHEMA IF NOT EXISTS ANALYTICS;
USE SCHEMA ANALYTICS;
-- =====================
-- Monthly growth
-- ====================


CREATE  DYNAMIC TABLE MONTHLY_GROWTH
TARGET_LAG = '1 day'
WAREHOUSE = COMPUTE_WH
AS

WITH monthly_growth AS (


    SELECT
        DATE_TRUNC('MONTH', order_purchase_timestamp) AS monthly_sales,
        SUM(sales_amount) AS total_sales
    FROM GOLD.FACT_SALES
    GROUP BY 1

),

m_growth AS (


    SELECT
        monthly_sales,
        total_sales,
        LAG(total_sales, 1)
            OVER (ORDER BY monthly_sales) AS prev_month_sales
    FROM monthly_growth

)

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
-- ====================
-- monthly_sales
-- ====================

CREATE  DYNAMIC TABLE MONTHLY_SALES
TARGET_LAG = '1 day'
WAREHOUSE = COMPUTE_WH
AS

SELECT
    DATE_TRUNC('MONTH', ORDER_PURCHASE_TIMESTAMP) AS sales_month,
    SUM(sales_amount) AS total_sales
FROM GOLD.FACT_SALES
GROUP BY 1;
-- ========================
-- Top_monthly_product
-- ==========================

CREATE  DYNAMIC TABLE top_3_monthly_products
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
-- ===============
-- Top SEllERS 
-- ===============
CREATE OR REPLACE DYNAMIC TABLE top3_monthly_sellers
TARGET_LAG='1 day'
WAREHOUSE = compute_wh
AS 
WITH top_sellers AS (


    SELECT
        seller_key,
        DATE_TRUNC('MONTH', order_purchase_timestamp) AS month,
        SUM(sales_amount) AS total_sales
    FROM GOLD.FACT_SALES
    GROUP BY 1,2

),

ranked_sellers AS (


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

-- ======================
-- year over year growth
-- ======================

CREATE OR REPLACE DYNAMIC TABLE yoy_growth
TARGET_LAG= '1 day'
WAREHOUSE=compute_wh
AS 
WITH yoy_growth AS (


    SELECT
        EXTRACT(YEAR FROM order_purchase_timestamp) AS sales_year,
        SUM(sales_amount) AS total_sales
    FROM GOLD.FACT_SALES
    GROUP BY 1

),

yoy AS (

    SELECT
        sales_year,
        total_sales,
        LAG(total_sales, 1)
            OVER (ORDER BY sales_year) AS prev_year_sales
    FROM yoy_growth

)



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