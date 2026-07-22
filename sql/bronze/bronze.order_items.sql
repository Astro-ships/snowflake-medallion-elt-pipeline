-- ==========================================================
-- Configure Snowflake session
-- ==========================================================
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE compute_wh;
USE DATABASE ecommerce_db;
USE SCHEMA BRONZE;

-- ==========================================================
-- CREATE ORDER_ITEMS TABLE FROM RAW DATA
-- ==========================================================

CREATE OR REPLACE TABLE BRONZE.ORDER_ITEMS AS 
SELECT 
    "order_id" AS order_id,
    "order_item_id" AS order_item_id,
    "product_id" AS product_id,   
    "seller_id" AS seller_id,
    "shipping_limit_date" AS shipping_limit_date,
    "price" AS price,
    "freight_value" AS freight_value
FROM RAW.ORDER_ITEMS;
-- ==========================================================
-- Validate Table
-- ==========================================================
SELECT *
FROM bronze.order_items
LIMIT 10;
