-- ==========================================================
-- Configure Snowflake session
-- ==========================================================
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE compute_wh;
USE DATABASE ecommerce_db;
USE SCHEMA GOLD;

-- ===============
--  Customer_key
-- ===============

CREATE OR REPLACE SEQUENCE customer_key_seq
START = 1
INCREMENT = 1;

CREATE TABLE IF NOT EXISTS customer_keys AS

SELECT
    customer_key_seq.NEXTVAL AS customer_key,
    customer_id
FROM GOLD.DIM_CUSTOMERS;

CREATE TABLE IF NOT EXISTS GOLD.dim_customers 
AS 
SELECT 
DISTINCT 
    ck.customer_key,
    sc.customer_id,
    sc.customer_unique_id,
    sc.customer_zip_code_prefix,
    sc.customer_city,
    sc.customer_state
FROM silver.customers AS sc
INNER JOIN customer_keys as ck 
ON 
sc.customer_id = ck.customer_id ;

-- =================
-- Produt_key
-- =================

CREATE OR REPLACE SEQUENCE product_key_seq
START = 1
INCREMENT = 1;

CREATE TABLE IF NOT EXISTS product_keys AS

SELECT
    product_key_seq.NEXTVAL AS product_key,
    product_id
FROM GOLD.DIM_PRODUCTS;

-- ------------------------------
CREATE TABLE IF NOT EXISTS GOLD.DIM_PRODUCTS AS

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

-- =============
-- Seller Key
-- =============
CREATE OR REPLACE SEQUENCE seller_key_seq
START = 1
INCREMENT = 1;

CREATE TABLE IF NOT EXISTS seller_keys AS

SELECT
    seller_key_seq.NEXTVAL AS seller_key,
    seller_id
FROM GOLD.DIM_SELLERS;

CREATE TABLE IF NOT EXISTS GOLD.dim_sellers AS 
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