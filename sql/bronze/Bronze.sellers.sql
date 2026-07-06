-- ==========================================================
-- Configure Snowflake session
-- ==========================================================
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE compute_wh;
USE DATABASE ecommerce_db;
USE SCHEMA BRONZE;

-- ==========================================================
-- CREATE SELLERS TABLE FROM RAW DATA
-- ==========================================================
CREATE OR REPLACE TABLE BRONZE.SELLERS AS 
SELECT 
        "seller_id" AS seller_id,
        "seller_zip_code_prefix" AS seller_zip_code_prefix,
        "seller_city" AS  seller_city,
        "seller_state" AS seller_state 
FROM RAW.SELLERS

-- ==========================================================
-- Validate Table
-- ==========================================================
SELECT * 
FROM bronze.sellers
LIMIT 10;