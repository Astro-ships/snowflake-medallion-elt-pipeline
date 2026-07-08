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

---- Check for columns 
SHOW COLUMNS IN TABLE BRONZE.sellers;
-- Check for column values 

DESCRIBE TABLE BRONZE.SELLERS;
--======================================
-- SELLER_ID
--======================================
--Check for NULL
SELECT 
        COUNT(*)
FROM BRONZE.SELLERS
WHERE seller_id IS NULL;
--Result:None
-------------------------
--Check for duplicates
SELECT 
        COUNT(*) as total_rows,
        COUNT(DISTINCT seller_id) as unique_ids
FROM BRONZE.sellers
--Result: All identifiers unique.
--======================================
-- SELLER_ZIP_CODE_PREFIX
--======================================
--Check for Nulls
SELECT 
        COUNT(*)
FROM bronze.sellers
WHERE SELLER_ZIP_CODE_PREFIX IS NULL;
--Result: None.
-----------------------------------
--Inspect length of the prefix
SELECT 
        COUNT(*) AS total_rows,
        LENGTH(SELLER_ZIP_CODE_PREFIX) as Prefix_Length
FROM bronze.sellers
GROUP BY Prefix_Length
ORDER BY Prefix_Length
-- Result:
-- Some ZIP code prefixes contain fewer than 5 digits.
-- Transformation Pending
--======================================
-- SELLER_CITY
--======================================
--Check NULLS
SELECT 
        COUNT(*)
FROM bronze.sellers
WHERE SELLER_CITY IS NULL;
--Result:None.
-----------------------------------------
--Inspect data:SELLER_CITY
SELECT 
        DISTINCT SELLER_CITY
FROM bronze.sellers

--Lower case values found, will standardize in transfromation
--======================================
-- SELLER_STATE
--======================================
--Check NULLS
SELECT 
        COUNT(*)
FROM bronze.sellers
WHERE SELLER_STATE IS NULL;
--Result:None.
---------------------------------
--Inspect data: SELLER_STATE
SELECT 
       DISTINCT SELLER_STATE
FROM bronze.sellers
--Values are standardized

