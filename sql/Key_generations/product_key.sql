-- ==========================================================
-- Configure Snowflake session
-- ==========================================================
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE compute_wh;
USE DATABASE ecommerce_db;
USE SCHEMA GOLD;

/*
==========================================================
Product Surrogate Key Generation
==========================================================

Business Entity : Product

Grain           : One row represents one unique product.

Primary Key     : product_key

Natural Key     : product_id

NOTE:
This script demonstrates two approaches for generating
surrogate keys.

• Method 1: ROW_NUMBER() (Demonstration)
• Method 2: Snowflake SEQUENCE (Production)

Execute only ONE method at a time because both methods
create the PRODUCT_KEYS table.

For a detailed explanation of each approach, refer to
the README in the surrogate_keys folder.
==========================================================
*/

--==========================================================
-- Method 1 : ROW_NUMBER()
--==========================================================

CREATE OR REPLACE TABLE product_keys AS

SELECT
    ROW_NUMBER() OVER (ORDER BY product_id) AS product_key,
    product_id
FROM GOLD.DIM_PRODUCTS;

--==========================================================
-- Validation
--==========================================================

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT product_key) AS unique_product_keys,
    COUNT(DISTINCT product_id) AS unique_product_ids
FROM product_keys;

SELECT *
FROM product_keys
ORDER BY product_key
LIMIT 50;

--==========================================================
-- Method 2 : Snowflake SEQUENCE (Recommended)
--==========================================================

CREATE OR REPLACE SEQUENCE product_key_seq
START = 1
INCREMENT = 1;

CREATE OR REPLACE TABLE product_keys AS

SELECT
    product_key_seq.NEXTVAL AS product_key,
    product_id
FROM GOLD.DIM_PRODUCTS;

--==========================================================
-- Validation
--==========================================================

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT product_key) AS unique_product_keys,
    COUNT(DISTINCT product_id) AS unique_product_ids
FROM product_keys;

SELECT *
FROM product_keys
ORDER BY product_key
LIMIT 50;