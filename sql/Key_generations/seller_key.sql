-- ==========================================================
-- Configure Snowflake session
-- ==========================================================
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE compute_wh;
USE DATABASE ecommerce_db;
USE SCHEMA GOLD;

/*
==========================================================
Seller Surrogate Key Generation
==========================================================

Business Entity : Seller

Grain           : One row represents one unique seller.

Primary Key     : seller_key

Natural Key     : seller_id

NOTE:
This script demonstrates two approaches for generating
surrogate keys.

• Method 1: ROW_NUMBER() (Demonstration)
• Method 2: Snowflake SEQUENCE (Production)

Execute only ONE method at a time because both methods
create the SELLER_KEYS table.

For a detailed explanation of each approach, refer to
the README in the surrogate_keys folder.
==========================================================
*/

--==========================================================
-- Method 1 : ROW_NUMBER()
--==========================================================

CREATE OR REPLACE TABLE seller_keys AS

SELECT
    ROW_NUMBER() OVER (ORDER BY seller_id) AS seller_key,
    seller_id
FROM GOLD.DIM_SELLERS;

--==========================================================
-- Validation
--==========================================================

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT seller_key) AS unique_seller_keys,
    COUNT(DISTINCT seller_id) AS unique_seller_ids
FROM seller_keys;

SELECT *
FROM seller_keys
ORDER BY seller_key
LIMIT 50;

--==========================================================
-- Method 2 : Snowflake SEQUENCE (Recommended)
--==========================================================

CREATE OR REPLACE SEQUENCE seller_key_seq
START = 1
INCREMENT = 1;

CREATE OR REPLACE TABLE seller_keys AS

SELECT
    seller_key_seq.NEXTVAL AS seller_key,
    seller_id
FROM GOLD.DIM_SELLERS;

--==========================================================
-- Validation
--==========================================================

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT seller_key) AS unique_seller_keys,
    COUNT(DISTINCT seller_id) AS unique_seller_ids
FROM seller_keys;

SELECT *
FROM seller_keys
ORDER BY seller_key
LIMIT 50;

-- ==========================================================
-- Prerequisite: Surrogate Key Generation
-- ==========================================================
-- Gold layer and Silver layer must exist.
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