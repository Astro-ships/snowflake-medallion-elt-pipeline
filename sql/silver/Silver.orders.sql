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
SHOW COLUMNS IN TABLE BRONZE.ORDERS;

-- Check order_id uniqueness
SELECT 
COUNT(*) as total_rows,
COUNT(DISTINCT order_id) as unique_order_id
FROM BRONZE.ORDERS 

-- Check order_id NULLS

SELECT COUNT(*)
FROM BRONZE.ORDERS
WHERE order_id IS NULL;

--Check for customer_id uniqueness
SELECT 
COUNT(*) as total_rows,
count(DISTINCT customer_id) as unique_customer_id
FROM BRONZE.orders


--Check for customer_id Nulls
SELECT COUNT(*)
FROM BRONZE.ORDERS
WHERE customer_id IS NULL;

--Check order_status for Nulls

SELECT 
        COUNT(*) 
FROM BRONZE.ORDERS 
WHERE order_status IS NULL;

-- check order status for values

SELECT
DISTINCT order_status
FROM bronze.orders;

--check order_purchase_timestamp NULLS 
SELECT COUNT(*)
FROM BRONZE.ORDERS
WHERE order_purchase_timestamp IS NULL;

--check ORDER_APPROVED_AT for NULLS 
SELECT 
        COUNT(*)
FROM bronze.orders
WHERE ORDER_APPROVED_AT IS NULL;

-- Result: 160 NULL values found.
-- Further investigation required to determine whether NULLs are expected
-- based on order_status or represent missing data.
SELECT
        order_status , 
        order_approved_at
FROM BRONZE.ORDERS 
WHERE ORDER_APPROVED_AT IS NULL;

-- Investigate NULL approval timestamps by order status

SELECT
order_status , order_approved_at
FROM BRONZE.ORDERS 
WHERE ORDER_APPROVED_AT IS NULL
AND (order_status='delivered');
-- Investigation:
-- NULL order_approved_at values were analyzed by order_status.
-- Most NULL values belong to cancelled and created orders, which are valid scenarios.
-- A small number of delivered orders have NULL approval timestamps and require further
-- investigation as they may represent source data quality issues.
--=====================================================================================

--Check ORDER_DELIVERED_CARRIER_DATE Null;
SELECT 
        COUNT(*)
FROM bronze.orders
WHERE ORDER_DELIVERED_CARRIER_DATE IS NULL;

--Result returned 1783 Nulls 
-- Investigate NULL ORDER_DELIVERED_CARRIER_DATE

SELECT order_status 
FROM BRONZE.orders 
WHERE ORDER_DELIVERED_CARRIER_DATE IS NULL;

-- Investigation:
-- NULL order_delivered_carrier_date values were analyzed by order_status.
-- Most NULL values belong to orders that did not reach the shipping stage
-- (created, processing, invoiced, canceled, unavailable).
-- These NULL values are considered valid and will be retained.
-- Delivered orders with missing carrier delivery dates require further validation.
--==================================================================================
--Check ORDER_DELIVERED_CUSTOMER_DATE for Nulls
SELECT 
        COUNT(*)
FROM BRONZE.ORDERS
WHERE ORDER_DELIVERED_CUSTOMER_DATE IS NULL;

--Result returned 1783 Nulls 
SELECT
         order_status 
FROM BRONZE.ORDERS
WHERE ORDER_DELIVERED_CUSTOMER_DATE IS NULL;
-- Note:
-- NULL timestamp values are retained because they represent valid business states
-- (e.g., canceled, created, processing, or unavailable orders). Replacing them
-- with default values would misrepresent the original source data.

--================================================================================
--inspect ORDER_ESTIMATED_DELIVERY_DATE

SELECT ORDER_ESTIMATED_DELIVERY_DATE
FROM BRONZE.ORDERS 
LIMIT 30;
----Check ORDER_ESTIMATED_DELIVERY_DATE  Nulls
SELECT 
        order_status
FROM BRONZE.ORDERS 
WHERE ORDER_ESTIMATED_DELIVERY_DATE IS NULL;

--NO NULLS FOUND

-- =====================================================================
-- Data Profiling Summary
-- =====================================================================
-- Tables were created using Snowflake INFER_SCHEMA, and the inferred
-- data types were validated. Timestamp columns are correctly stored as
-- TIMESTAMP_NTZ, therefore no additional datatype conversion is required.
--
-- NULL timestamp values are retained because they represent valid
-- business states.
-- ======================================================================

-- ==========================================================
-- Data Transformation 
-- ==========================================================
-- No transformations required.
-- Data types were validated, and NULL timestamp values represent
-- valid business states. Data is promoted from Bronze to Silver
-- without modification.

CREATE OR REPLACE TABLE SILVER.ORDERS AS
SELECT 
        ORDER_ID,
        CUSTOMER_ID,
        ORDER_STATUS,
        ORDER_PURCHASE_TIMESTAMP,
        ORDER_APPROVED_AT,
        ORDER_DELIVERED_CARRIER_DATE,
        ORDER_DELIVERED_CUSTOMER_DATE,
        ORDER_ESTIMATED_DELIVERY_DATE
FROM BRONZE.ORDERS