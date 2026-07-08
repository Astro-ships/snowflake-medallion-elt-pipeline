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

-- ===========================================================
-- Data Transformation 
-- ===========================================================
-- Investigation:
-- ZIP code prefixes are stored as NUMBER, so leading zeros are removed.
-- ZIP codes should be standardized to a fixed 5-character format.
-- Transforming and validating
SELECT  
        COUNT(*) AS total_rows,
        LENGTH(LPAD(SELLER_ZIP_CODE_PREFIX,5,'0')) AS SELLER_ZIP_CODE_PREFIX_LENGTH
FROM BRONZE.SELLERS
GROUP BY SELLER_ZIP_CODE_PREFIX_LENGTH;
--Length transformed to standard 5 prefix length
-----------------------------------------------\
--Transform lower case values of SELLER_CITY to a standardized values.
--Transform and Validate
SELECT
        DISTINCT SELLER_CITY AS Original_seller_city,
        INITCAP(SELLER_CITY) AS standard_seller_city
FROM BRONZE.SELLERS

-- ===========================================================
-- Create table Silver.Sellers
-- ===========================================================
--Now that we have everything, creating silver layer table

CREATE OR REPLACE TABLE SILVER.SELLERS AS
SELECT
       seller_id,
       LPAD(SELLER_ZIP_CODE_PREFIX,5,'0') AS SELLER_ZIP_CODE_PREFIX,
       INITCAP(SELLER_CITY) AS seller_city,
       SELLER_STATE
FROM BRONZE.SELLERS
-- ===========================================================
-- VALIDATE TABLE
-- ===========================================================
SELECT * 
FROM SILVER.SELLERS
LIMIT 50;