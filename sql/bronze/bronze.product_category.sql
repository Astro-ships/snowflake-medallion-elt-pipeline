-- ==========================================================
-- Configure Snowflake session
-- ==========================================================
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE compute_wh;
USE DATABASE ecommerce_db;
USE SCHEMA BRONZE;
-- ==========================================================
-- CREATE PRODUCT_CATEGORY TABLE FROM RAW DATA
-- ==========================================================
CREATE OR REPLACE TABLE BRONZE.PRODUCT_CATEGORY AS 
SELECT 
        "product_category_name" AS product_category_name,
         "product_category_name_english" AS product_category_name_english
FROM RAW.PRODUCT_CATEGORY;