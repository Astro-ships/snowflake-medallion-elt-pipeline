-- ==========================================================
-- Configure Snowflake session
-- ==========================================================
USE ROLE GITHUB_ACTIONS_ROLE;
USE WAREHOUSE compute_wh;
USE DATABASE ecommerce_db;
USE SCHEMA GOLD;

-- ===============
--  Customer_key
-- ===============

CREATE OR REPLACE SEQUENCE customer_key_seq
START = 1
INCREMENT = 1;
-- ===================
-- GOLD dim_customers
-- ===================
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
-- =================================
--  FACT PAYMENTS
-- ================================


CREATE OR REPLACE TABLE GOLD.FACT_PAYMENTS AS

SELECT

-- ==========================================================
-- Composite Key (Degenerate Dimension)
-- ==========================================================
    sp.order_id,
    sp.payment_sequential,

-- ==========================================================
-- Foreign Key (Surrogate Key)
-- ==========================================================
    ck.customer_key,

-- ==========================================================
-- Transaction Attributes
-- ==========================================================
    so.order_status,
    sp.payment_type,
    sp.payment_installments,
    so.order_purchase_timestamp,

-- ==========================================================
-- Measure
-- ==========================================================
    sp.payment_value

FROM SILVER.ORDER_PAYMENTS AS sp

INNER JOIN SILVER.ORDERS AS so
    ON sp.order_id = so.order_id

INNER JOIN CUSTOMER_KEYS AS ck
    ON so.customer_id = ck.customer_id;

-- ======================
-- FACT_SALES
-- ======================

CREATE OR REPLACE TABLE GOLD.FACT_SALES AS

SELECT

-- ==========================================================
-- Degnerate Dimension
-- ==========================================================
    oi.order_id,
    oi.order_item_id,

-- ==========================================================
-- Foreign Keys
-- ==========================================================
    ck.customer_id,
    pk.product_id,
    sk.seller_id,

-- ==========================================================
-- Transaction Attributes
-- ==========================================================
    o.order_status,
    o.order_purchase_timestamp,
    oi.shipping_limit_date,

-- ==========================================================
-- Delivery Information
-- ==========================================================
    o.order_estimated_delivery_date,
    o.order_delivered_carrier_date,
    o.order_delivered_customer_date,

-- ==========================================================
-- Measures
-- ==========================================================
    oi.price AS sales_amount,
    oi.freight_value AS shipping_cost

FROM SILVER.ORDER_ITEMS AS oi
-- ================================================
-- Joins: Order is being joined with keys 
-- ==============================================
INNER JOIN SILVER.ORDERS AS o
ON 
oi.order_id = o.order_id
INNER JOIN CUSTOMER_KEYS AS ck
ON
o.customer_id = ck.customer_id
INNER JOIN product_keys AS pk 
ON 
oi.product_id = pk.product_id 
INNER JOIN  seller_keys  AS sk 
ON 
oi.seller_id = sk.seller_id;

-- ==================
--  fact_reviews
-- ===================


CREATE OR REPLACE TABLE GOLD.FACT_REVIEWS AS

SELECT

-- ==========================================================
-- Composite Key (Degenerate Dimensions)
-- ==========================================================
    sr.review_id,
    sr.order_id,

-- ==========================================================
-- Foreign Key (Surrogate Key)
-- ==========================================================
    ck.customer_key,

-- ==========================================================
-- Review Attributes
-- ==========================================================
    sr.review_creation_date,
    sr.review_answer_timestamp,

-- ==========================================================
-- Measure
-- ==========================================================
    sr.review_score

FROM SILVER.ORDER_REVIEWS AS sr

INNER JOIN SILVER.ORDERS AS so
    ON sr.order_id = so.order_id

INNER JOIN CUSTOMER_KEYS AS ck
    ON so.customer_id = ck.customer_id;