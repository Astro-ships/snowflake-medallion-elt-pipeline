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

-- Expected Result:
-- 0 NULL values.