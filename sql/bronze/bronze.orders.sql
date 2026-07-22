-- ==========================================================
-- Configure Snowflake session
-- ==========================================================
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE compute_wh;
USE DATABASE ecommerce_db;
USE SCHEMA BRONZE;
-- ==========================================================
-- CREATE ORDERS TABLE FROM RAW DATA
-- ==========================================================

CREATE OR REPLACE TABLE bronze.orders AS 
SELECT 
        "order_id" AS order_id,
        "customer_id" AS customer_id,
        "order_status" AS order_status,
        "order_purchase_timestamp" AS order_purchase_timestamp,
        "order_approved_at" AS order_approved_at,
        "order_delivered_carrier_date" AS order_delivered_carrier_date,
        "order_delivered_customer_date" AS order_delivered_customer_date,
        "order_estimated_delivery_date" AS order_estimated_delivery_date

FROM RAW.ORDERS;

-- ==========================================================
-- Validate Table
-- ==========================================================
SELECT *
FROM bronze.orders
LIMIT 10;
