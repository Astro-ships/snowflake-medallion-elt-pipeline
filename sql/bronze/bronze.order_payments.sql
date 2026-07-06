-- ==========================================================
-- Configure Snowflake session
-- ==========================================================
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE compute_wh;
USE DATABASE ecommerce_db;
USE SCHEMA BRONZE;

-- ==========================================================
-- CREATE ORDER_PAYMENTS TABLE FROM RAW DATA
-- ==========================================================
SELECT * FROM RAW.ORDER_PAYMENTS LIMIT 10;

CREATE OR REPLACE TABLE BRONZE.ORDER_PAYMENTS AS 
SELECT 
     "order_id" AS order_id,
     "payment_sequential" AS payment_sequential,
     "payment_type" AS payment_type,
     "payment_installments" AS payment_installments,
     "payment_value" AS payment_value,
FROM RAW.ORDER_PAYMENTS;