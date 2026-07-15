-- ==========================================================
-- Configure Snowflake session
-- ==========================================================
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE compute_wh;
USE DATABASE ecommerce_db;
USE SCHEMA GOLD;

/*
==========================================================
Surrogate Key Generation
==========================================================

This file demonstrates two approaches for generating
surrogate keys in Snowflake.

1. ROW_NUMBER()
   - Simple and suitable for static datasets.
   - Used in this project for demonstration purposes.

2. Snowflake SEQUENCE
   - Recommended for production data warehouses.
   - Produces stable surrogate keys that do not change
     during incremental loads.

==========================================================
*/
--========================================================
-- 1. ROW_NUMBER()
--========================================================
-------------------------------------------
-- Grain:
-- One row represents one unique customer.

-- Primary Key:
-- customer_key
-------------------------------------------
CREATE OR REPLACE TABLE customer_keys AS 

SELECT DISTINCT 
                customer_id,
                ROW_NUMBER() OVER (ORDER BY customer_id) AS customer_key
FROM GOLD.DIM_CUSTOMERS;

--==============================
-- Validate keys
--=============================
SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT(customer_key)) AS unique_keys,
       COUNT(DISTINCT(customer_id)) AS  unique_primary_id
FROM DIM_CUSTOMER_SK;

--------------------------------------------------
SELECT *
FROM customer_keys
ORDER BY customer_id
LIMIT 500;

--==========================================================
-- Method 2: Snowflake SEQUENCE (Production Approach)
--==========================================================

-- Grain:
-- One row represents one unique customer.

-- Primary Key:
-- customer_key
-------------------------------------------
CREATE OR REPLACE SEQUENCE customer_seq
START = 1
INCREMENT = 1;

CREATE OR REPLACE TABLE customer_keys AS

SELECT
    customer_seq.NEXTVAL AS customer_key,
    customer_id
FROM GOLD.DIM_CUSTOMERS;

--==============================
-- Validate keys
--=============================
-- Check for 1-1 mapping
-------------------------------
SELECT 
      COUNT(*) AS total_rows,
      COUNT(DISTINCT(customer_key)) AS unique_customer_key,
      COUNT(DISTINCT(customer_id)) AS unique_customer_id
FROM customer_keys
---------------------------------------------------------
SELECT *
FROM customer_keys 
ORDER BY customer_key
LIMIT 50;
-------------------------------------------------------