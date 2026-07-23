-- ==========================================================
-- Configure Snowflake session
-- ==========================================================
-- USE ROLE GITHUB_ACTIONS_ROLE;
 USE WAREHOUSE compute_wh;
USE DATABASE ecommerce_db;
CREATE SCHEMA IF NOT EXISTS GOLD;
USE SCHEMA GOLD;

-- ==========================================================
-- Create dim_customers
-- ==========================================================

CREATE OR REPLACE TABLE GOLD.dim_customers 
AS 
SELECT 
DISTINCT 
    sc.customer_id,
    sc.customer_unique_id,
    sc.customer_zip_code_prefix,
    sc.customer_city,
    sc.customer_state
FROM silver.customers AS sc;

-- ==========================================================
-- Create DIM_PRODUCT
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
-- =================
-- Gold dim_sellers
-- ================
CREATE OR REPLACE TABLE GOLD.dim_sellers AS 
SELECT 
      DISTINCT 
              seller_id,
              seller_zip_code_prefix,
              seller_city,
              seller_state
FROM SILVER.SELLERS;

-- ==================
-- Fact_payment
-- =================


CREATE OR REPLACE TABLE GOLD.FACT_PAYMENTS AS

SELECT

    sp.order_id,
    sp.payment_sequential,
    ck.customer_key,
    so.order_status,
    sp.payment_type,
    sp.payment_installments,
    so.order_purchase_timestamp,
    sp.payment_value

FROM SILVER.ORDER_PAYMENTS AS sp

INNER JOIN SILVER.ORDERS AS so
    ON sp.order_id = so.order_id

INNER JOIN CUSTOMER_KEYS AS ck
    ON so.customer_id = ck.customer_id;

-- =======================
-- Fact Review
-- =======================

CREATE OR REPLACE TABLE GOLD.FACT_REVIEWS AS

SELECT
    sr.review_id,
    sr.order_id,
    ck.customer_key,
    sr.review_creation_date,
    sr.review_answer_timestamp,
    sr.review_score

FROM SILVER.ORDER_REVIEWS AS sr

INNER JOIN SILVER.ORDERS AS so
    ON sr.order_id = so.order_id

INNER JOIN CUSTOMER_KEYS AS ck
    ON so.customer_id = ck.customer_id;

-- ================
-- FACT _Sales
-- ================
CREATE OR REPLACE TABLE GOLD.FACT_SALES AS

SELECT

    oi.order_id,
    oi.order_item_id,
    ck.customer_key,
    pk.product_key,
    sk.seller_key,
    o.order_status,
    o.order_purchase_timestamp,
    oi.shipping_limit_date,
    o.order_estimated_delivery_date,
    o.order_delivered_carrier_date,
    o.order_delivered_customer_date,
    oi.price AS sales_amount,
    oi.freight_value AS shipping_cost
FROM SILVER.ORDER_ITEMS AS oi
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