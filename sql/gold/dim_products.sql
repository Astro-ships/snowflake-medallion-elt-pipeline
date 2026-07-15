-- ==========================================================
-- Configure Snowflake session
-- ==========================================================
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE compute_wh;
USE DATABASE ecommerce_db;
USE SCHEMA GOLD;

-- ==========================================================
-- Create DIM_PRODUCT
-- ==========================================================
-- Dimension:
-- Product
--
-- Grain:
-- One row represents one unique product.
--
-- Primary Key:
-- product_id
--
-- Source Table:
-- • SILVER.PRODUCTS
--
-- Purpose:
-- Stores descriptive product attributes used to analyze
-- sales by product category, size, weight, and dimensions.
-- ==========================================================

CREATE OR REPLACE TABLE GOLD.DIM_PRODUCTS AS

SELECT DISTINCT
    product_id,
    product_category_name,
    product_name_length,
    product_description_length,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
FROM SILVER.PRODUCTS;
-- ==========================================================
-- Validation: Compare row counts
-- ==========================================================
-- DIM_PRODUCT is created directly from SILVER.PRODUCTS.
-- Since no business filtering is applied, both tables are
-- expected to contain the same number of product records.
-- ==========================================================

SELECT
    (SELECT COUNT(*) FROM SILVER.PRODUCTS) AS total_silver_products,
    (SELECT COUNT(*) FROM GOLD.DIM_PRODUCTS) AS total_gold_products;

-- ==========================================================
-- Validation: Check for NULL primary keys
-- ==========================================================

SELECT
    COUNT(*) AS total_null_product_ids
FROM GOLD.DIM_PRODUCTS
WHERE product_id IS NULL;
---------------------------
-- Expected Result:
-- 0 NULL values.
---------------------------
-- ==========================================================
-- Prerequisite: Surrogate Key Generation
-- ==========================================================
-- Execute sql/surrogate_keys/product_keys.sql before
-- joining surrogate keys into this dimension table.
CREATE OR REPLACE TABLE GOLD.DIM_PRODUCTS AS

SELECT DISTINCT
                pk.product_key,
                sp.product_id,
                sp.product_category_name,
                sp.product_name_length,
                sp.product_description_length,
                sp.product_photos_qty,
                sp.product_weight_g,
                sp.product_length_cm,
                sp.product_height_cm,
                sp.product_width_cm
FROM SILVER.PRODUCTS AS sp 
INNER JOIN product_keys as pk 
ON
pk.product_id = sp.product_id;
----------------------------------
-- Inspect table
-----------------------------------
SELECT *
FROM dim_products
ORDER BY product_key
LIMIT 50;