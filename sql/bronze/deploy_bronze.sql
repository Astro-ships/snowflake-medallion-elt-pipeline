-- ==========================================================
-- Configure Snowflake session
-- ==========================================================
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE compute_wh;
USE DATABASE ecommerce_db;
USE SCHEMA BRONZE;

-- ==========================================================
-- CREATE CUSTOMER TABLE FROM RAW DATA
-- ==========================================================

CREATE OR REPLACE TABLE bronze.customers AS
SELECT 
        "customer_id" AS customer_id, 
        "customer_unique_id" AS customer_unique_id,
        "customer_zip_code_prefix" AS customer_zip_code_prefix,
        UPPER("customer_city") as customer_city,
        "customer_state" AS customer_state
FROM RAW.CUSTOMERS;

-- ==========================================================
-- CREATE Geolocation TABLE FROM RAW DATA
-- ==========================================================

CREATE OR REPLACE TABLE bronze.geolocation AS
SELECT 
        "geolocation_zip_code_prefix" AS geolocation_zip_code_prefix, 
        "geolocation_lat" AS geolocation_lat,
        "geolocation_lng" AS geolocation_lng,
        UPPER("geolocation_city") as geolocation_city,
        "geolocation_state" AS geolocation_state
FROM RAW.GEOLOCATION;

-- ==========================================================
-- CREATE ORDER_ITEMS TABLE FROM RAW DATA
-- ==========================================================

CREATE OR REPLACE TABLE BRONZE.ORDER_ITEMS AS 
SELECT 
    "order_id" AS order_id,
    "order_item_id" AS order_item_id,
    "product_id" AS product_id,   
    "seller_id" AS seller_id,
    "shipping_limit_date" AS shipping_limit_date,
    "price" AS price,
    "freight_value" AS freight_value
FROM RAW.ORDER_ITEMS;


-- ==========================================================
-- CREATE ORDER_PAYMENTS TABLE FROM RAW DATA
-- ==========================================================
SELECT * FROM RAW.ORDER_PAYMENTS LIMIT 10;

CREATE OR REPLACE TABLE BRONZE.ORDER_PAYMENTS AS 
SELECT 
     "order_id" AS order_id,
     "payment_sequential" AS payment_sequential,
     "payment_type" AS payment_type,
     "payment_installments" AS payment_installments,
     "payment_value" AS payment_value,
FROM RAW.ORDER_PAYMENTS;
-- ==========================================================
-- CREATE ORDER_REVIEWS TABLE FROM RAW DATA
-- ==========================================================
CREATE OR REPLACE TABLE BRONZE.ORDER_REVIEWS AS 
SELECT 
        "review_id" AS review_id,
        "order_id" AS order_id,
        "review_score" AS review_score,
        "review_comment_title" AS review_comment_title,
        "review_comment_message" AS review_comment_message,
        "review_creation_date" AS review_creation_date,
        "review_answer_timestamp" AS review_answer_timestamp
FROM RAW.ORDERS_REVIEWS;

-- ==========================================================
-- CREATE ORDERS TABLE FROM RAW DATA
-- ==========================================================

CREATE OR REPLACE TABLE bronze.orders AS 
SELECT 
        "order_id" AS order_id,
        "customer_id" AS customer_id,
        "order_status" AS order_status,
        "order_purchase_timestamp" AS order_purchase_timestamp,
        "order_approved_at" AS order_approved_at,
        "order_delivered_carrier_date" AS order_delivered_carrier_date,
        "order_delivered_customer_date" AS order_delivered_customer_date,
        "order_estimated_delivery_date" AS order_estimated_delivery_date

FROM RAW.ORDERS;

-- ==========================================================
-- CREATE PRODUCT_CATEGORY TABLE FROM RAW DATA
-- ==========================================================
CREATE OR REPLACE TABLE BRONZE.PRODUCT_CATEGORY AS 
SELECT 
        "product_category_name" AS product_category_name,
         "product_category_name_english" AS product_category_name_english
FROM RAW.PRODUCT_CATEGORY;

-- ==========================================================
-- CREATE PRODUCTS TABLE FROM RAW DATA
-- ==========================================================
CREATE OR REPLACE TABLE BRONZE.products AS 
SELECT 
        "product_id" AS product_id,
        "product_category_name" AS product_category_name,
        "product_name_lenght" AS product_name_lenght,
        "product_description_lenght" AS product_description_length,
        "product_photos_qty" AS product_photos_qty,
        "product_weight_g" AS product_weight_g,
        "product_length_cm" AS product_length_cm,
        "product_height_cm" AS product_height_cm,
        "product_width_cm" AS product_width_cm 
FROM RAW.products;


-- ==========================================================
-- CREATE SELLERS TABLE FROM RAW DATA
-- ==========================================================
CREATE OR REPLACE TABLE BRONZE.SELLERS AS 
SELECT 
        "seller_id" AS seller_id,
        "seller_zip_code_prefix" AS seller_zip_code_prefix,
        "seller_city" AS  seller_city,
        "seller_state" AS seller_state 
FROM RAW.SELLERS;