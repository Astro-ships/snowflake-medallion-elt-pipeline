-- ==========================================================
-- Configure Snowflake session
-- ==========================================================
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE compute_wh;
USE DATABASE ecommerce_db;
USE SCHEMA GOLD;
-- ==========================================================
-- Create DIM_SELLER
-- ==========================================================
-- Dimension:
-- Seller
--
-- Grain:
-- One row represents one unique seller.
--
-- Primary Key:
-- seller_id
--
-- Source Table:
-- • SILVER.SELLERS
-- ==========================================================
CREATE OR REPLACE TABLE GOLD.dim_sellers AS 
SELECT 
      DISTINCT 
              seller_id,
              seller_zip_code_prefix,
              seller_city,
              seller_state
FROM SILVER.SELLERS;
-- ==========================================================
-- Validation: Compare row counts
-- ==========================================================
-- DIM_SELLERS is created directly from SILVER.SELLERS.
-- Since no business filtering is applied, both tables are
-- expected to contain the same number of seller records.
-- ==========================================================
SELECT 
    (SELECT COUNT(*) FROM SILVER.SELLERS) AS silver_layer_rows,
    (SELECT COUNT(*) FROM GOLD.dim_Sellers) AS Gold_layer_rows;

-- ==========================================================
-- Validation: Check for NULL primary keys
-- ==========================================================
-- Verify that the primary key (seller_id) contains no NULL
-- values, ensuring every dimension record can be uniquely
-- identified.
-- ==========================================================

SELECT 
        COUNT(*) AS total_null_values 
FROM GOLD.DIM_SELLERS
WHERE seller_id IS NULL;
-----------------
-- Result: 
-- 0 Null values
-----------------
-- ==========================================================
-- Prerequisite: Surrogate Key Generation
-- ==========================================================
-- Execute sql/surrogate_keys/seller_key.sql before
-- joining surrogate keys into this dimension table.
CREATE OR REPLACE TABLE GOLD.dim_sellers AS 
SELECT 
      DISTINCT 
              sk.seller_key,
              ss.seller_id,
              ss.seller_zip_code_prefix,
              ss.seller_city,
              ss.seller_state
FROM SILVER.SELLERS AS ss
INNER JOIN seller_keys AS sk 
ON 
sk.seller_id = ss.seller_id;
--==============================
-- Inspect table 
--==============================
SELECT *
FROM gold.dim_sellers
ORDER BY seller_key
LIMIT 50;