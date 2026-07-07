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
SHOW COLUMNS IN TABLE BRONZE.CUSTOMERS;
-- Check customer_id uniqueness
SELECT 
        COUNT(*) AS total_rows,
        COUNT(DISTINCT customer_id) AS Total_unique_ids
FROM BRONZE.CUSTOMERS

-- Check customer_id NULL values

SELECT 
        COUNT(*)
FROM bronze.customers
WHERE customer_id IS NULL;

-- Check customer_unique_id NULL values
SELECT 
        COUNT(*)
FROM bronze.customers
WHERE customer_unique_id IS NULL;

-- Check ZIP code prefix for NULLS
SELECT 
        COUNT(*)
FROM bronze.customers
WHERE CUSTOMER_ZIP_CODE_PREFIX IS NULL;

-- Check ZIP code prefix length
SELECT 
        COUNT(*) AS total_rows,
        LENGTH(CUSTOMER_ZIP_CODE_PREFIX) as prefix_length
FROM BRONZE.CUSTOMERS
GROUP BY prefix_length
ORDER BY prefix_length;
    
-- Check customer_city NULLS

SELECT  
        COUNT(*)
FROM BRONZE.CUSTOMERS 
WHERE customer_city IS NULL;

-- Check customer_city Values

SELECT 
        DISTINCT customer_city
FROM BRONZE.CUSTOMERS
LIMIT 300;

-- Check customer_state values
SELECT 
        DISTINCT customer_state
FROM BRONZE.CUSTOMERS
LIMIT 50;
-- Check customer_state for NULLS 
SELECT 
        COUNT(*) 
FROM BRONZE.CUSTOMERS
WHERE customer_State IS NULL;

-- ==========================================================
-- Data Transformation
-- ==========================================================

-- Fix ZIP code prefix length
SELECT
    customer_zip_code_prefix AS original_zip_prefix,
    LPAD(customer_zip_code_prefix, 5, '0') AS standardized_zip_prefix
FROM bronze.customers
LIMIT 50;

--standardize customer_city 
SELECT 
        customer_city AS original_city,
        LOWER(customer_city) AS standardized_city
FROM BRONZE.CUSTOMERS
LIMIT 20;

-- ==========================================================
-- CREATE STANDARDIZED SILVER LAYER CUSTOMER TABLE
-- ==========================================================
CREATE OR REPLACE TABLE SILVER.CUSTOMERS
AS
SELECT
        customer_id,
        customer_unique_id,
        LPAD(CUSTOMER_ZIP_CODE_PREFIX,5,'0') as customer_zip_code_prefix,
        LOWER(customer_city) AS customer_city,
        customer_state
FROM BRONZE.CUSTOMERS

