-- ==========================================================
-- Configure Snowflake session
-- ==========================================================
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE compute_wh;
USE DATABASE ecommerce_db;
USE SCHEMA SILVER;

-- ==========================================================
-- Data Profiling
-- ==========================================================
---------------------
-- Check for columns 
---------------------
SHOW COLUMNS IN TABLE BRONZE.ORDER_REVIEWS;
--========================================


-- ==========================
-- REVIEW_ID
-- ==========================
-----------------------
-- Check for duplicates
-----------------------
SELECT 
COUNT(*) AS TOTAL_ROWS,
COUNT(DISTINCT REVIEW_ID) AS unique_review_id
FROM BRONZE.ORDER_REVIEWS
------------------------------------------
-- Result: Duplicates found.
-- Check which rows are duplicates.
------------------------------------------
SELECT
    review_id
    COUNT(*) AS occurrences
FROM BRONZE.ORDER_REVIEWS
GROUP BY review_id,order_id
HAVING COUNT(*) > 1;

-- ==========================
-- Order_id
-- ==========================
-- Check for uniqueness
------------------------
SELECT COUNT(*) as total_rows,
COUNT(DISTINCT ORDER_ID) total_unique_ids
FROM BRONZE.ORDER_REVIEWS;
------------------------------------------
-- Result: Duplicates Found
------------------------------------------
SELECT
    order_id,
    COUNT(*) AS occurrences
FROM BRONZE.ORDER_REVIEWS
GROUP BY order_id
HAVING COUNT(*) > 1;
---------------------------------------
-- Validate both columns for duplicates
---------------------------------------
SELECT
    review_id,
    order_id,
    COUNT(*) AS occurrences
FROM BRONZE.ORDER_REVIEWS
GROUP BY
    review_id,
    order_id
HAVING COUNT(*) > 1;
---------------------------------------------------------------
-- Investigation:
-- Neither REVIEW_ID nor ORDER_ID is unique individually.
-- REVIEW_ID may be associated with multiple orders, and an
-- ORDER_ID may have multiple review records in the source data.
--
-- Validation confirmed that the combination
-- (REVIEW_ID, ORDER_ID) is unique and can be used to
-- uniquely identify each review record.
--=============================================================
------------------------------------------
-- Check both records for nulls.
------------------------------------------
SELECT 
COUNT(*) AS Total_NULLS
FROM BRONZE.ORDER_REVIEWS
WHERE review_id IS NULL OR order_id IS NULL;
---------------------
-- No Nulls Found
---------------------

-- ====================
-- REVIEW_SCORE
-- ====================
---------------------
-- 1:Check for Nulls
---------------------
SELECT 
        COUNT(*) AS total_null_rows
FROM BRONZE.ORDER_REVIEWS
WHERE review_score IS NULL;
---------------------
-- Result:None
---------------------
------------------------------------------------------------------------------------
-- 2:Check for a negative review score or greater than 5 to ensure data quality
------------------------------------------------------------------------------------
SELECT 
    COUNT(review_score) as Negative_score
FROM bronze.order_reviews
WHERE review_score < 0 OR review_score > 5 ;
--------------------------------------
--Result: None
--====================================

-- ====================
-- REVIEW_COMMENT_TITLE
-- ====================
---------------------------------------------------------------
-- Investigation:
-- NULL values are expected in REVIEW_COMMENT_TITLE.
-- Review titles are optional and many customers submit
-- only a review score without a title.
-- No transformation required.
---------------------------------------------------------------
-- ======================
-- REVIEW_COMMENT_MESSAGE
-- ======================
-- Investigation:
-- NULL values are expected in REVIEW_COMMENT_MESSAGE.
-- Customers are not required to provide written feedback.
-- No transformation required.
---------------------------------------------------------------
-- ===========================================
-- REVIEW_CREATION_DATE/REVIEW_ANSWER_TIMESTAMP
-- ============================================
---------------------
-- 1:Check for Nulls
---------------------
SELECT COUNT(*) AS Total_Nulls
FROM BRONZE.ORDER_REVIEWS
WHERE REVIEW_CREATION_DATE IS NULL;
---------------------
-- 2:Inspect Column|
---------------------
SELECT 
        REVIEW_CREATION_DATE
FROM BRONZE.ORDER_REVIEWS
LIMIT 50;
-------------------------
-- 3:Check for Null rows.
-------------------------
SELECT COUNT(*) AS TOTAL_NULLS
FROM BRONZE.ORDER_REVIEWS
WHERE REVIEW_ANSWER_TIMESTAMP IS NULL;
-------------------------------------------------------------
-- Result: No NULL values found.
-- ==========================================================
-- Data Transformation
-- ==========================================================
-- No transformations required.
-- Data profiling confirmed that:
-- • Composite key (REVIEW_ID, ORDER_ID) is unique.
-- • Timestamp columns are complete and correctly typed.
-- • NULL values in review comment fields are expected because
--   review titles and messages are optional.
-------------------------------------------------------------

-- ==========================================================
-- Table Creation
-- ==========================================================

CREATE OR REPLACE TABLE SILVER.ORDER_REVIEWS AS 
SELECT 
        *
FROM BRONZE.ORDER_REVIEWS

---------------------------------------------------------------