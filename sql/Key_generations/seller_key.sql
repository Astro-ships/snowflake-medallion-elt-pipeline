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
-- One row represents one unique seller.

-- Primary Key:
-- seller_key
-------------------------------------------

CREATE OR REPLACE TABLE seller_keys AS 

SELECT DISTINCT 
                ROW_NUMBER() OVER (ORDER BY seller_id) AS seller_key,
                seller_id
                
FROM GOLD.DIM_SELLERS;

--==============================
-- Validate keys
--=============================
-- Check for 1-1 mapping
-------------------------------
SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT(seller_key)) AS unique_seller_key,
       COUNT(DISTINCT(seller_id)) AS  unique_seller_id
FROM seller_keys;
---------------------------------------------------------
SELECT *
FROM seller_keys 
ORDER BY seller_key 
LIMIT 50;
--=======================================================
--========================================================
-- Method 2: Snowflake SEQUENCE (Recommended)
--========================================================
-- This method is recommended for production environments
-- because generated surrogate keys remain stable across
-- incremental loads and data refreshes.
CREATE OR REPLACE SEQUENCE seller_sq
START = 1
INCREMENT = 1;

CREATE OR REPLACE TABLE seller_keys AS 
SELECT DISTINCT 
              seller_sq.NEXTVAL as seller_key,
              seller_id 
FROM GOLD.DIM_SELLERS;

--==============================
-- Validate keys
--=============================
-- Check for 1-1 mapping
-------------------------------
SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT(seller_key)) AS unique_seller_key,
       COUNT(DISTINCT( seller_id)) AS  unique_seller_id
FROM seller_keys
---------------------------------------------------
-- Inspect table 
-----------------
SELECT *
FROM seller_keys 
ORDER BY seller_key 
LIMIT 50;
