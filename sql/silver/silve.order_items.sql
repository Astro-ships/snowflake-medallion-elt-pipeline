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
SHOW COLUMNS IN TABLE BRONZE.ORDER_ITEMS;
--======================================
-- Check ORDER_ID, ORDER_ITEM_ID
--======================================
-- Check for ORDER_ID for Nulls
------------------------------------------

SELECT 
        COUNT(*)
FROM BRONZE.ORDER_ITEMS
WHERE ORDER_ID IS NULL;
---------------------
-- Result:None.
---------------------
-- Check for ORDER_ITEM_ID for Nulls
------------------------------------------
SELECT 
        COUNT(*)
FROM BRONZE.ORDER_ITEMS
WHERE ORDER_ITEM_ID IS NULL;
---------------------
-- Result: None
-- Validate both order_ID and order_ITEM_ID for Duplication
---------------------------------------------------------------
WITH unique_order_items AS (
                    SELECT DISTINCT 
                                    ORDER_ID,
                                    ORDER_ITEM_ID
                    FROM BRONZE.ORDER_ITEMS
)
SELECT 
        (SELECT COUNT(*) AS TOTAL_ROWS FROM BRONZE.ORDER_ITEMS) as total_rows,
        COUNT(*) AS unique_combinations
FROM unique_order_items;
---------------------------------------------------------------
--Result: None
--- Investigation:
-- order_id is not unique in ORDER_ITEMS because a single order
-- can contain multiple order items.
-- Validate the uniqueness of (order_id, order_item_id) instead.
---------------------------------------------------------------
--======================================
-- Check PRODUCT_ID
--======================================
-- Investigation:
-- product_id is a foreign key and is not expected to be unique.
-- The same product can appear in multiple order items.
---------------------------------------------------------------
SELECT
        COUNT(*) AS total_rows,
        COUNT(DISTINCT PRODUCT_ID) AS unique_product_id_rows
FROM BRONZE.ORDER_ITEMS;
---------------------
-- Check for NULLS
---------------------
SELECT 
        COUNT(*)
FROM BRONZE.ORDER_ITEMS
WHERE product_id IS NULL;
---------------------
-- Result: None
---------------------
--======================================
-- SELLER_ID
--======================================
-- CHECK FOR NULLS
---------------------
SELECT 
        COUNT(*)
FROM BRONZE.ORDER_ITEMS
WHERE SELLER_ID IS NULL;
---------------------
-- Result:None
-- Inspect columns
---------------------
SELECT 
       DISTINCT seller_id
FROM BRONZE.ORDER_ITEMS;
--======================================
-- SHIPPING_LIMIT_DATE
--======================================
------------------------------------------
-- Inspect for column data type 
------------------------------------------
DESC TABLE BRONZE.ORDER_ITEMS;
---------------------
-- Check for Nulls
---------------------
SELECT 
        COUNT(*)
FROM BRONZE.ORDER_ITEMS
WHERE SHIPPING_LIMIT_DATE IS NULL;
---------------------
-- Result:None.
---------------------
--======================================
-- PRICE
--======================================
---------------------
-- Check for NULLS
---------------------
SELECT 
        COUNT(*)
FROM BRONZE.ORDER_ITEMS
WHERE PRICE IS NULL;
-----------------------------
-- Check for negative prices
-----------------------------
SELECT 
        *
FROM BRONZE.ORDER_ITEMS
WHERE PRICE < 0;

--======================================
-- FREIGHT_VALUE
--======================================
---------------------
-- Check for Nulls
---------------------
SELECT 
        COUNT(*)
FROM BRONZE.ORDER_ITEMS
WHERE FREIGHT_VALUE IS NULL;
------------------------------------------
-- Check for negative FREIGHT_VALUE
------------------------------------------

SELECT 
        *
FROM BRONZE.ORDER_ITEMS
WHERE FREIGHT_VALUE < 0;

-- ==========================================================
-- Profiling Summary
-- ==========================================================
-- No data quality issues requiring transformation were identified.
-- ORDER_ITEMS Will be loaded into the Silver layer without modification.

-- ==========================================================
-- Create Table
-- ==========================================================
CREATE OR REPLACE TABLE SILVER.ORDER_ITEMS
AS 
SELECT
        ORDER_ID,
        ORDER_ITEM_ID,
        PRODUCT_ID,
        SELLER_ID,
        SHIPPING_LIMIT_DATE,
        PRICE,
        FREIGHT_VALUE
FROM BRONZE.ORDER_ITEMS;