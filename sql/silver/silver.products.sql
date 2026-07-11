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
SHOW COLUMNS IN TABLE BRONZE.PRODUCTS;

-- ===========
-- PRODUCT_ID
-- ===========
--1: Check for unqiueness
SELECT
        COUNT(*) AS total_rows,
        COUNT(DISTINCT PRODUCT_Id) AS unique_product_id_rows
FROM bronze.products
--Result: No duplicates
--2: Check for Nulls
SELECT 
        COUNT(*) AS total_null_values
FROM bronze.products
WHERE product_id IS NULL;
--Result: None 
--3: Inspect Column 
SELECT product_ID
FROM bronze.products
LIMIT 40;

-- =====================
-- PRODUCT_CATEGORY_NAME
-- =====================
--1: Inspect Column
SELECT DISTINCT PRODUCT_CATEGORY_NAME
FROM BRONZE.PRODUCTS;
--Check For Nulls
=====================================
SELECT COUNT(*) AS Total_Null_ROWS 
FROM BRONZE.PRODUCTS
WHERE PRODUCT_CATEGORY_NAME IS NULL;
--Result: 610 ROWS 
======================================
--2: Check duplicates 
SELECT 
        COUNT(*) AS TOTAL_ROWS,
        COUNT(DISTINCT PRODUCT_CATEGORY_NAME) as unique_PRODUCT_CATEGORY_NAME
FROM BRONZE.PRODUCTS

--Result: Total_rows = 32951 | UNIQUE_PRODUCT_CATEGORY_NAME = 73
=========================================
-- =====================
-- PRODUCT_NAME_LENGHT
-- =====================
--1: Inspect column
SELECT DISTINCT 
                PRODUCT_NAME_LENGHT
FROM BRONZE.Products
--2: Check for negative values
SELECT 
        COUNT(*) AS TOTAL_NEGATIVE_VALUES
FROM BRONZE.PRODUCTS
WHERE PRODUCT_NAME_LENGHT < 0;
--Result: None.
--================================
--3: Check for Nulls
SELECT 
        Count(*) AS total_nulls
FROM BRONZE.PRODUCTS
WHERE PRODUCT_NAME_LENGHT IS NULL;
--Result:610 Null Values Found
--================================
-- ==========================
-- PRODUCT_DESCRIPTION_LENGTH
-- ==========================
--1: Inspect column
SELECT DISTINCT 
                PRODUCT_DESCRIPTION_LENGTH
FROM BRONZE.Products
--2: Check for negative values
SELECT 
        COUNT(*) AS TOTAL_NEGATIVE_VALUES
FROM BRONZE.PRODUCTS
WHERE PRODUCT_DESCRIPTION_LENGTH < 0;
--Result: None.
--========================================
--3: Check for Nulls
SELECT 
        Count(*) AS total_nulls
FROM BRONZE.PRODUCTS
WHERE PRODUCT_DESCRIPTION_LENGTH IS NULL;
--Result:610 Null Values Found
--=========================================
-- ===================
-- PRODUCT_PHOTOS_QTY
-- ===================
--1: Check for negative values
SELECT 
        COUNT(*) AS TOTAL_NEGATIVE_VALUES
FROM BRONZE.PRODUCTS
WHERE PRODUCT_PHOTOS_QTY < 0;
--================================
--2: Check for Nulls
SELECT 
        Count(*) AS total_nulls
FROM BRONZE.PRODUCTS
WHERE PRODUCT_PHOTOS_QTY IS NULL;
--Result:610 Null Values Found
--=================================

-- ===================
-- PRODUCT_WEIGHT_G
-- ===================
--1:inspect column
SELECT DISTINCT 
                PRODUCT_WEIGHT_G
FROM bronze.products
--2: Check for negative values
SELECT 
        COUNT(*) AS TOTAL_NEGATIVE_VALUES
FROM BRONZE.PRODUCTS
WHERE PRODUCT_WEIGHT_G < 0;
--Result:None

--=====================================
--3: Check for Nulls                        
SELECT                                      
        Count(*) AS total_nulls
FROM BRONZE.PRODUCTS
WHERE PRODUCT_PHOTOS_QTY IS NULL;
--Result:610 Null Values Found
--======================================
-- ===================
-- PRODUCT_LENGTH_CM
-- ===================
--1:Inspect column
SELECT DISTINCT 
                PRODUCT_LENGTH_CM
FROM bronze.products
--2: Check for negative values
SELECT 
        COUNT(*) AS TOTAL_NEGATIVE_VALUES
FROM BRONZE.PRODUCTS
WHERE PRODUCT_LENGTH_CM < 0;
--Result:None
--======================================
--3: Check for Nulls                        
SELECT                                      
        Count(*) AS total_nulls
FROM BRONZE.PRODUCTS
WHERE PRODUCT_LENGTH_CM IS NULL;
--Result:2 Null Values Found
--=======================================

-- ===================
-- PRODUCT_HEIGHT_CM
-- ===================
--1:Inspect column
SELECT DISTINCT 
                PRODUCT_HEIGHT_CM
FROM bronze.products
--2: Check for negative values
SELECT 
        COUNT(*) AS TOTAL_NEGATIVE_VALUES
FROM BRONZE.PRODUCTS
WHERE PRODUCT_HEIGHT_CM < 0;
--Result:None
--======================================
--3: Check for Nulls                        
SELECT                                      
        Count(*) AS total_nulls
FROM BRONZE.PRODUCTS
WHERE PRODUCT_HEIGHT_CM IS NULL;
--Result:2 Null Values Found
--======================================

-- ===================
-- PRODUCT_WIDTH_CM
-- ===================
--1:Inspect column
SELECT DISTINCT 
                PRODUCT_WIDTH_CM
FROM bronze.products;
--2: Check for negative values
SELECT 
        COUNT(*) AS TOTAL_NEGATIVE_VALUES
FROM BRONZE.PRODUCTS
WHERE PRODUCT_WIDTH_CM < 0;
--Result:None
--======================================
--3: Check for Nulls                        
SELECT                                      
        Count(*) AS total_nulls
FROM BRONZE.PRODUCTS
WHERE PRODUCT_WIDTH_CM IS NULL;
--Result:2 Null Values Found
--================================================================================================
