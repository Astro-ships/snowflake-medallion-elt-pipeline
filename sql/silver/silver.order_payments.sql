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
---------------------
-- Check for columns 
---------------------
SHOW COLUMNS IN TABLE BRONZE.ORDER_PAYMENTS;
--======================================
-- Check ORDER_ID / PAYMENT_SEQUENTIAL
--======================================
------------------------------------------
-- Check PAYMENT_SEQUENTIAL uniqueness.
------------------------------------------
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT payment_sequential) AS unique_payment_sequential
FROM BRONZE.ORDER_PAYMENTS;
---------------------------------------------------------------
-- Result:
-- Duplicate values exist because PAYMENT_SEQUENTIAL
-- restarts for each order.
---------------------------------------------------------------
-- Check ORDER_ID uniqueness.
----------------------------
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS unique_order_id
FROM BRONZE.ORDER_PAYMENTS;
---------------------------------------------------------------
-- Result:
-- Duplicate values exist because an order can contain
-- multiple payment records.
---------------------------------------------------------------
-- Investigation:
-- Validate the composite key (ORDER_ID, PAYMENT_SEQUENTIAL),
-- which uniquely identifies each payment record.
---------------------------------------------------------------
WITH unique_payments AS (
    SELECT DISTINCT
        order_id,
        payment_sequential
    FROM BRONZE.ORDER_PAYMENTS
)
SELECT
    (SELECT COUNT(*) FROM BRONZE.ORDER_PAYMENTS) AS total_rows,
    COUNT(*) AS unique_combinations
FROM unique_payments;
---------------------------------------------------------------
-- Result:
-- All (ORDER_ID, PAYMENT_SEQUENTIAL) combinations are unique.
---------------------------------------------------------------
--======================================
-- Check PAYMENT_TYPE
--======================================
--Check for NULLS
------------------------------------------
SELECT 
        COUNT(*)
FROM BRONZE.ORDER_PAYMENTS
WHERE payment_type IS NULL;
------------------------------------------
-- Result:None 
-- Inspect for values
------------------------------------------
SELECT DISTINCT 
                payment_type
FROM BRONZE.ORDER_PAYMENTS;
--------------------------------------------
--Result: Data looks standardized and valid.
------------------------------------------

--======================================
-- PAYMENT_INSTALLMENTS
--======================================
---------------------
-- Check for NULLS.
---------------------
SELECT 
        COUNT(*)
FROM BRONZE.ORDER_PAYMENTS
WHERE payment_installments IS NULL;

--======================================
-- PAYMENT_VALUE
--======================================
---------------------
-- Check for Nulls.
---------------------

SELECT 
        COUNT(*)
FROM BRONZE.ORDER_PAYMENTS
WHERE PAYMENT_VALUE IS NULL;
------------------------------------------
-- Result:None. 
-- Check for negative payment value
------------------------------------------
SELECT *
FROM BRONZE.ORDER_PAYMENTS
WHERE PAYMENT_VALUE < 0;

-- ==========================================================
-- Data Transformation
-- ==========================================================
-- No transformations required.
-- Data quality validation confirmed that the table contains
-- consistent values and valid business relationships.
---------------------------------------------------------------
CREATE OR REPLACE TABLE SILVER.ORDER_PAYMENTS
AS
SELECT * 
FROM BRONZE.ORDER_PAYMENTS;