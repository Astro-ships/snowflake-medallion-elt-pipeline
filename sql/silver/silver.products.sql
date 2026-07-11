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
------------------------
-- Check for columns 
------------------------
SHOW COLUMNS IN TABLE BRONZE.PRODUCTS;

-- ===========
-- PRODUCT_ID
-- ===========
-- 1:Check for unqiueness
---------------------------
SELECT
        COUNT(*) AS total_rows,
        COUNT(DISTINCT PRODUCT_Id) AS unique_product_id_rows
FROM bronze.products
-- Result: No duplicates
------------------------
-- 2:Check for Nulls
------------------------
SELECT 
        COUNT(*) AS total_null_values
FROM bronze.products
WHERE product_id IS NULL;
-- Result: None 
-------------------
-- 3:Inspect Column
------------------- 
SELECT product_ID
FROM bronze.products
LIMIT 40;

-- =====================
-- PRODUCT_CATEGORY_NAME
-- =====================
-------------------
-- 1:Inspect Column
--------------------
SELECT DISTINCT PRODUCT_CATEGORY_NAME
FROM BRONZE.PRODUCTS;
---------------------
-- Check For Nulls
-------------------
=====================================
SELECT COUNT(*) AS Total_Null_ROWS 
FROM BRONZE.PRODUCTS
WHERE PRODUCT_CATEGORY_NAME IS NULL;
-- Result: 610 ROWS 
-------------------
======================================
-- 2:Check duplicates 
----------------------
SELECT 
        COUNT(*) AS TOTAL_ROWS,
        COUNT(DISTINCT PRODUCT_CATEGORY_NAME) as unique_PRODUCT_CATEGORY_NAME
FROM BRONZE.PRODUCTS

-- Result: Total_rows = 32951 | UNIQUE_PRODUCT_CATEGORY_NAME = 73
=========================================
-- =====================
-- PRODUCT_NAME_LENGHT
-- =====================
-- 1:Inspect column
------------------
SELECT DISTINCT 
                PRODUCT_NAME_LENGHT
FROM BRONZE.Products
-- 2:Check for negative values
-------------------------------
SELECT 
        COUNT(*) AS TOTAL_NEGATIVE_VALUES
FROM BRONZE.PRODUCTS
WHERE PRODUCT_NAME_LENGHT < 0;
-----------------
-- Result: None.
-----------------
--================================
-- 3:Check for Nulls
SELECT 
        Count(*) AS total_nulls
FROM BRONZE.PRODUCTS
WHERE PRODUCT_NAME_LENGHT IS NULL;
-- Result:610 Null Values Found
--================================
-- ==========================
-- PRODUCT_DESCRIPTION_LENGTH
-- ==========================
-- 1:Inspect column
----------------------
SELECT DISTINCT 
                PRODUCT_DESCRIPTION_LENGTH
FROM BRONZE.Products
------------------------------
-- 2:Check for negative values
------------------------------
SELECT 
        COUNT(*) AS TOTAL_NEGATIVE_VALUES
FROM BRONZE.PRODUCTS
WHERE PRODUCT_DESCRIPTION_LENGTH < 0;
--------------------
-- Result: None.
--========================================
-- 3:Check for Nulls
--------------------
SELECT 
        Count(*) AS total_nulls
FROM BRONZE.PRODUCTS
WHERE PRODUCT_DESCRIPTION_LENGTH IS NULL;
-----------------------------------
-- Result:610 Null Values Found
--=========================================
-- ===================
-- PRODUCT_PHOTOS_QTY
-- ===================
-- 1:Check for negative values
-------------------------------
SELECT 
        COUNT(*) AS TOTAL_NEGATIVE_VALUES
FROM BRONZE.PRODUCTS
WHERE PRODUCT_PHOTOS_QTY < 0;
------------------------------------
-- 2:Check for "0" PRODUCT_PHOTOS_QTY
-------------------------------------
SELECT 
        COUNT(*) AS TOTAL_NEGATIVE_VALUES
FROM BRONZE.PRODUCTS
WHERE PRODUCT_PHOTOS_QTY = 0;
----------------------------------
-- Result: None.
----------------
--================================
-- 2:Check for Nulls
--------------------
SELECT 
        Count(*) AS total_nulls
FROM BRONZE.PRODUCTS
WHERE PRODUCT_PHOTOS_QTY IS NULL;

---------------------------------
-- Result:610 Null Values Found
--=================================

-- ===================
-- PRODUCT_WEIGHT_G
-- ===================
-- 1:inspect column
---------------------
SELECT DISTINCT 
                PRODUCT_WEIGHT_G
FROM bronze.products
-- 2:Check for negative values
------------------------------
SELECT 
        COUNT(*) AS TOTAL_NEGATIVE_VALUES
FROM BRONZE.PRODUCTS
WHERE PRODUCT_WEIGHT_G < 0;
--------------
-- Result:None
--------------
-- 2:Check for "0" PRODUCT_WEIGHT_G
-----------------------------------
SELECT 
        COUNT(*) AS TOTAL_NEGATIVE_VALUES
FROM BRONZE.PRODUCTS
WHERE PRODUCT_WEIGHT_G = 0;
------------------------
-- Result: None.
--=====================================
-- 3:Check for Nulls  
--------------------                      
SELECT                                      
        Count(*) AS total_nulls
FROM BRONZE.PRODUCTS
WHERE PRODUCT_PHOTOS_QTY IS NULL;
---------------------------------------
-- Result:610 Null Values Found
-- =====================================
-- ===================
-- PRODUCT_LENGTH_CM
-- ===================
-- 1:Inspect column
--------------------
SELECT DISTINCT 
                PRODUCT_LENGTH_CM
FROM bronze.products
-- 2: Check for negative values
SELECT 
        COUNT(*) AS TOTAL_NEGATIVE_VALUES
FROM BRONZE.PRODUCTS
WHERE PRODUCT_LENGTH_CM < 0;
----------------
-- Result:None
----------------

-- 2:Check for "0" PRODUCT_LENGTH_CM
-------------------------------------
SELECT 
        COUNT(*) AS TOTAL_NEGATIVE_VALUES
FROM BRONZE.PRODUCTS
WHERE PRODUCT_LENGTH_CM = 0;
----------------------------------------
-- Result: None.
--======================================
-- 3:Check for Nulls 
---------------------                       
SELECT                                      
        Count(*) AS total_nulls
FROM BRONZE.PRODUCTS
WHERE PRODUCT_LENGTH_CM IS NULL;
----------------------------------------
-- Result:2 Null Values Found
--=======================================

-- ===================
-- PRODUCT_HEIGHT_CM
-- ===================
-- 1:Inspect column
--------------------
SELECT DISTINCT 
                PRODUCT_HEIGHT_CM
FROM bronze.products
-- 2:Check for negative values
SELECT 
        COUNT(*) AS TOTAL_NEGATIVE_VALUES
FROM BRONZE.PRODUCTS
WHERE PRODUCT_HEIGHT_CM < 0;
--------------
-- Result:None
--------------

-- 2:Check for "0" PRODUCT_HEIGHT_CM
-------------------------------------
SELECT 
        COUNT(*) AS TOTAL_NEGATIVE_VALUES
FROM BRONZE.PRODUCTS
WHERE PRODUCT_HEIGHT_CM = 0;
------------------|
--Result: None.     
--======================================|
--3: Check for Nulls  
-------------------- |              
SELECT                                      
        Count(*) AS total_nulls
FROM BRONZE.PRODUCTS
WHERE PRODUCT_HEIGHT_CM IS NULL;
------------------------------------
--Result:2 Null Values Found
--======================================

-- ===================
-- PRODUCT_WIDTH_CM
-- ===================
-- 1:Inspect column
--------------------

SELECT DISTINCT 
                PRODUCT_WIDTH_CM
FROM bronze.products;
------------------------------
--2: Check for negative values
-------------------------------
SELECT 
        COUNT(*) AS TOTAL_NEGATIVE_VALUES
FROM BRONZE.PRODUCTS
WHERE PRODUCT_WIDTH_CM < 0;
------------------------
--  Result:None
------------------------
------------------------------------
--3: Check for "0" product_witdth_cm
------------------------------------
SELECT 
        COUNT(*) AS TOTAL_NEGATIVE_VALUES
FROM BRONZE.PRODUCTS
WHERE PRODUCT_WIDTH_CM = 0;
----------------------------------------
-- Result:None
--======================================
------------------------
--3: Check for Nulls    
------------------------                    
SELECT                                      
        Count(*) AS total_nulls
FROM BRONZE.PRODUCTS
WHERE PRODUCT_WIDTH_CM IS NULL;
--------------------------------
--Result:2 Null Values Found
--================================================================================================
-- Investigation:
-- 610 products contain NULL values for product category,
-- product name length, product description length,
-- product photos quantity, and product weight.
-- These missing values appear to belong to the same set of
-- product records and likely represent incomplete source data.
-- No transformation will be applied in the Silver layer to
-- preserve source data integrity.
-- ===================================================================================================
-- Data Transformation
-- ===================================================================================================
-- Inspect the 610 Values

SELECT * 
FROM BRONZE.PRODUCTS 
WHERE 
    PRODUCT_CATEGORY_NAME IS NULL
    OR PRODUCT_NAME_LENGHT IS NULL
    OR PRODUCT_DESCRIPTION_LENGTH IS NULL
    OR PRODUCT_PHOTOS_QTY IS NULL
    OR PRODUCT_WEIGHT_G IS NULL
    OR PRODUCT_LENGTH_CM IS NULL
    OR PRODUCT_HEIGHT_CM IS NULL
    OR PRODUCT_WIDTH_CM IS NULL;
 -------------------------------------------------------
-- Investigation:
-- 610 products contain missing descriptive attributes,
-- including product category, product name length,
-- product description length, and product photos quantity.
--
-- These products still contain valid physical attributes
-- such as weight and dimensions.
--========================================================
-- Investigation:
-- Two products contain NULL values for product dimensions
-- (length, height, and width).
-- Comparing if the Null values are part of the 610 Nulls found 
-- in product category, product name length, product description
-- length, and product photos quantity.
SELECT
    PRODUCT_ID
FROM BRONZE.PRODUCTS
WHERE
    PRODUCT_CATEGORY_NAME IS NULL
    AND (
        PRODUCT_LENGTH_CM IS NULL
        OR PRODUCT_HEIGHT_CM IS NULL
        OR PRODUCT_WIDTH_CM IS NULL
    );
------------------------------------------------------------
-- One product is common to both groups, indicating it has
-- missing descriptive attributes as well as missing physical
-- dimensions.
--
-- These records are preserved in the Silver layer to maintain
-- source data integrity. No imputation or default values will
-- be applied.   
--------------------------------------------------------------
-- ===================================================================================================
-- Create Silver Table
-- ===================================================================================================

CREATE OR REPLACE TABLE SILVER.PRODUCTS AS 
SELECT 
        PRODUCT_ID,
        PRODUCT_CATEGORY_NAME,
        PRODUCT_NAME_LENGHT AS PRODUCT_NAME_LENGTH,
        PRODUCT_DESCRIPTION_LENGTH,
        PRODUCT_PHOTOS_QTY,
        PRODUCT_WEIGHT_G,
        PRODUCT_LENGTH_CM,
        PRODUCT_HEIGHT_CM,
        PRODUCT_WIDTH_CM
FROM BRONZE.products 