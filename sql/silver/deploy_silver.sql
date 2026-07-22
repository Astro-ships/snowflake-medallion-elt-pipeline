-- ==========================================================
-- Configure Snowflake session
-- ==========================================================
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE compute_wh;
USE DATABASE ecommerce_db;
USE SCHEMA SILVER;
-- ==========================================================
-- Create Table SILVER.ORDER_ITEMS
-- ==========================================================
CREATE TABLE IF NOT EXISTS SILVER.ORDER_ITEMS
AS 
SELECT
        ORDER_ID,
        ORDER_ITEM_ID,
        PRODUCT_ID,
        SELLER_ID,
        SHIPPING_LIMIT_DATE,
        PRICE,
        FREIGHT_VALUE
FROM BRONZE.ORDER_ITEMS;
-- ==========================================================
-- CREATE  SILVER LAYER CUSTOMER TABLE
-- ==========================================================
CREATE TABLE IF NOT EXISTS SILVER.CUSTOMERS
AS
SELECT
        customer_id,
        customer_unique_id,
        LPAD(CUSTOMER_ZIP_CODE_PREFIX,5,'0') as customer_zip_code_prefix,
        LOWER(customer_city) AS customer_city,
        customer_state
FROM BRONZE.CUSTOMERS;

-- ===========================================================
-- Create table SILVER.GEOLOCATION
-- ===========================================================
CREATE TABLE IF NOT EXISTS SILVER.GEOLOCATION
AS
   SELECT 
         LPAD(GEOLOCATION_ZIP_CODE_PREFIX,5,'0') AS geolocation_zip_code_prefix,
         geolocation_lat,
         geolocation_lng,
         (TRANSLATE(INITCAP(LOWER(REPLACE(geolocation_city, 'Sa£o', 'São'))),'áàâãéêíóôõúç',
        'aaaaeeiooouc') ) as geolocation_city,
         geolocation_state
FROM BRONZE.geolocation;

-- =============================
-- Create SILVER.ORDER_PAYMENTS
-- =============================
CREATE TABLE IF NOT EXISTS SILVER.ORDER_PAYMENTS
AS
SELECT * 
FROM BRONZE.ORDER_PAYMENTS;

-- ==========================================================
-- Create Silver.order_reviews table
-- ==========================================================

CREATE TABLE IF NOT EXISTS SILVER.ORDER_REVIEWS AS 
SELECT 
        *
FROM BRONZE.ORDER_REVIEWS;
-- =================================================
-- CREATE SILVER.ORDERS TABLE 
-- =================================================

CREATE TABLE IF NOT EXISTS SILVER.ORDERS AS
SELECT 
        ORDER_ID,
        CUSTOMER_ID,
        ORDER_STATUS,
        ORDER_PURCHASE_TIMESTAMP,
        ORDER_APPROVED_AT,
        ORDER_DELIVERED_CARRIER_DATE,
        ORDER_DELIVERED_CUSTOMER_DATE,
        ORDER_ESTIMATED_DELIVERY_DATE
FROM BRONZE.ORDERS;

-- ==========================================================
-- Create silver.product_cateogory table
-- ==========================================================

CREATE TABLE IF NOT EXISTS SILVER.product_category
AS 
SELECT *
FROM BRONZE.PRODUCT_CATEGORY;
-- ===============================================
-- CREATE SILVER.PRODUCTS TABLE
-- ================================================
CREATE TABLE IF NOT EXISTS SILVER.PRODUCTS AS 
SELECT 
        PRODUCT_ID,
        PRODUCT_CATEGORY_NAME,
        PRODUCT_NAME_LENGHT AS PRODUCT_NAME_LENGTH,
        PRODUCT_DESCRIPTION_LENGTH,
        PRODUCT_PHOTOS_QTY,
        PRODUCT_WEIGHT_G,
        PRODUCT_LENGTH_CM,
        PRODUCT_HEIGHT_CM,
        PRODUCT_WIDTH_CM
FROM BRONZE.products;

-- =============================
--  CREATE SILVER.SEllERS table
-- =============================

CREATE TABLE IF NOT EXISTS SILVER.SELLERS AS
SELECT
       seller_id,
       LPAD(SELLER_ZIP_CODE_PREFIX,5,'0') AS SELLER_ZIP_CODE_PREFIX,
       INITCAP(SELLER_CITY) AS seller_city,
       SELLER_STATE
FROM BRONZE.SELLERS;