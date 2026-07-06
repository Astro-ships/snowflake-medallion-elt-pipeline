-- ==========================================================
-- Configure Snowflake session
-- ==========================================================
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE compute_wh;
USE DATABASE ecommerce_db;
USE SCHEMA BRONZE;
-- ==========================================================
-- CREATE PRODUCTS TABLE FROM RAW DATA
-- ==========================================================
CREATE OR REPLACE TABLE BRONZE.products AS 
SELECT 
        "product_id" AS product_id,
        "product_category_name" AS product_category_name,
        "product_name_lenght" AS product_name_lenght,
        "product_description_lenght" AS product_description_length,
        "product_photos_qty" AS product_photos_qty,
        "product_weight_g" AS product_weight_g,
        "product_length_cm" AS product_length_cm,
        "product_height_cm" AS product_height_cm,
        "product_width_cm" AS product_width_cm 
FROM RAW.products
-- ==========================================================
-- Validate Table
-- ==========================================================
SELECT * FROM bronze.products
LIMIT 10;