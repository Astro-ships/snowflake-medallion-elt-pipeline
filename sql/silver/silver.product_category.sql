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

-- Check for columns 
SHOW COLUMNS IN TABLE BRONZE.PRODUCT_CATEGORY;

-- =====================
-- PRODUCT_CATEGORY_NAME
-- =====================
--1: Inspect column
SELECT DISTINCT 
                PRODUCT_CATEGORY_NAME
FROM BRONZE.PRODUCT_CATEGORY
--2:Check for NULLS
SELECT 
        COUNT(*) AS total_Null_rows
FROM BRONZE.PRODUCT_CATEGORY
WHERE PRODUCT_CATEGORY_NAME IS NULL;
--Result:None
--Check duplicates
SELECT  PRODUCT_CATEGORY_NAME
FROM BRONZE.PRODUCT_CATEGORY
GROUP BY PRODUCT_CATEGORY_NAME
HAVING COUNT(*) > 1;
--Result:None

-- =============================
-- PRODUCT_CATEGORY_NAME_ENGLISH
-- =============================
--1: Inspect column
SELECT 
        DISTINCT PRODUCT_CATEGORY_NAME_ENGLISH
FROM BRONZE.PRODUCT_CATEGORY
--2:Check Null
SELECT 
        COUNT(*) AS total_null_values
FROM  BRONZE.PRODUCT_CATEGORY
WHERE  PRODUCT_CATEGORY_NAME_ENGLISH IS NULL;
--Result: NONE
--CHECK for duplicates 
SELECT  PRODUCT_CATEGORY_NAME_ENGLISH
FROM BRONZE.PRODUCT_CATEGORY
GROUP BY PRODUCT_CATEGORY_NAME_ENGLISH
HAVING COUNT(*) > 1;
--Result:None
-- =============================
-- Validate
-- =============================
--Since this is a mapping table, verify that it's a 1-to-1 mapping.
SELECT 
        PRODUCT_CATEGORY_NAME,
        PRODUCT_CATEGORY_NAME_ENGLISH,
        COUNT(*)
FROM BRONZE.PRODUCT_CATEGORY
GROUP BY 
        PRODUCT_CATEGORY_NAME,
        PRODUCT_CATEGORY_NAME_ENGLISH
HAVING COUNT(*) > 1;
--Result: 1-1 mapping confirmed
-- ==========================================================
-- Data Transformation
-- ==========================================================
-- No transformations required.
-- Data profiling confirmed that the lookup table contains
-- unique category mappings with no NULL values.
-- ==========================================================
-- Create silver layer table
-- ==========================================================

CREATE OR REPLACE TABLE SILVER.product_category
AS 
SELECT *
FROM BRONZE.PRODUCT_CATEGORY
