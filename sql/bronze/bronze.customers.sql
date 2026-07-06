-- ==========================================================
-- Configure Snowflake session
-- ==========================================================
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE compute_wh;
USE DATABASE ecommerce_db;
USE SCHEMA BRONZE;
-- ==========================================================
-- CREATE CUSTOMER TABLE FROM RAW DATA
-- ==========================================================

CREATE OR REPLACE TABLE bronze.customers AS
SELECT 
        "customer_id" AS customer_id, 
        "customer_unique_id" AS customer_unique_id,
        "customer_zip_code_prefix" AS customer_zip_code_prefix,
        UPPER("customer_city") as customer_city,
        "customer_state" AS customer_state
FROM RAW.CUSTOMERS;
-- ==========================================================
-- Validate Table
-- ==========================================================
SELECT * FROM bronze.customers
LIMIT 10;