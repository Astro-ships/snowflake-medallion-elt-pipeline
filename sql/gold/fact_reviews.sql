-- ==========================================================
-- Configure Snowflake session
-- ==========================================================
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE compute_wh;
USE DATABASE ecommerce_db;
USE SCHEMA GOLD;

-- ==========================================================
-- Create FACT_REVIEWS
-- ==========================================================
-- Business Process:
-- Customer reviews
--
-- Grain:
-- One row represents one review submitted for one order.
--
-- Primary Key:
-- review_id
--
-- Measure:
-- review_score
-- ==========================================================

CREATE OR REPLACE TABLE GOLD.FACT_REVIEWS AS

SELECT DISTINCT

-- ==========================================================
-- Primary Key
-- ==========================================================
    sr.review_id,

-- ==========================================================
-- Foreign Keys
-- ==========================================================
    sr.order_id,
    so.customer_id,

-- ==========================================================
-- Review Attributes
-- ==========================================================
    sr.review_creation_date,
    sr.review_answer_timestamp,

-- ==========================================================
-- Measure
-- ==========================================================
    sr.review_score

FROM SILVER.ORDER_REVIEWS AS sr

INNER JOIN SILVER.ORDERS AS so
    ON sr.order_id = so.order_id;

------------------------------------
-- Check the primary key
------------------------------------

SELECT 
        COUNT(*) AS total_rows,
        COUNT(DISTINCT(review_id)) AS unique_Rows
FROM GOLD.FACT_reviews;
-------------------------------------------------
-- Result: Duplicates Found
------------------------------------------------

---------------------------------------------
-- Check the row count of silver.order_reviews
-- and compare if the resuls produced were 
-- because of the join queries
------------------------------------------------
SELECT 
        (SELECT COUNT(*) FROM SILVER.ORDER_REVIEWS) AS TOTAL_ROWS_IN_SILVER_LAYER,
        (SELECT COUNT(*) FROM GOLD.FACT_REVIEWS) AS TOTAL_ROWS_IN_GOLD_LAYER 

-- -----------------------------------------------------
-- Results:  Both tables have same row_count
--------------------------------------------------
-- Further investigating
-------------------------
SELECT
    review_id,order_id,
    COUNT(*) AS occurrences
FROM GOLD.FACT_REVIEWS
GROUP BY review_id,order_id
HAVING COUNT(*) > 1
ORDER BY occurrences DESC;
-----------------------------------------------------------------------
-- This means review_id is not a primary key as originaly
-- declared but a composite key(review_id + order_id )