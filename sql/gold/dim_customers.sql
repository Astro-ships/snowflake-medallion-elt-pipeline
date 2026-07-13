-- ==========================================================
-- Configure Snowflake session
-- ==========================================================
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE compute_wh;
USE DATABASE ecommerce_db;
USE SCHEMA GOLD;
-- ==========================================================
-- Create dim_customers
-- ==========================================================

CREATE OR REPLACE TABLE GOLD.dim_customers 
AS 
SELECT 
DISTINCT 
    sc.customer_id,
    sc.customer_unique_id,
    sc.customer_zip_code_prefix,
    sc.customer_city,
    sc.customer_state
FROM silver.customers AS sc

-- ==========================================================
-- Validation: DIM_CUSTOMER
-- ==========================================================
-- Verify the dimension contains one record per customer and
-- that customer_id uniquely identifies each record.
-- ==========================================================
-- Check row count and uniqueness
---------------------------------
SELECT 
        COUNT(*) AS total_rows,
        COUNT(DISTINCT customer_id) as unique_customers
FROM gold.dim_customers
-- Result:
-- total_rows = unique_customers
-- Indicates customer_id is unique.
-- ==========================================================
-- Check for NULL primary keys
-- ==========================================================
SELECT 
        COUNT(*) AS total_null_values 
FROM GOLD.DIM_CUSTOMERS
WHERE customer_id IS NULL;
-----------------
-- Result: 
-- 0 Null values
-----------------
-- ==========================================================
-- Check for duplicate customer records
-- ==========================================================
SELECT 
        customer_id,
        COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_id
HAVING COUNT(*) > 1;
-----------------
-- Result: 
-- No duplicates
----------------

-- ==========================================================
-- Validation: Compare row counts
-- ==========================================================
-- Since DIM_CUSTOMER is created directly from
-- SILVER.CUSTOMERS without filtering, both tables are
-- expected to contain the same number of records.
-- ==========================================================
SELECT
    (SELECT COUNT(*) FROM SILVER.CUSTOMERS) AS total_silver_layer_table,
    (SELECT COUNT(*) FROM GOLD.DIM_CUSTOMERS) AS total_gold_dim_customers