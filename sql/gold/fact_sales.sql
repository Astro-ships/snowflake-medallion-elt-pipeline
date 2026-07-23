-- ==========================================================
-- Configure Snowflake session
-- ==========================================================
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE compute_wh;
USE DATABASE ecommerce_db;
USE SCHEMA GOLD;

-- ==========================================================
-- Create FACT_SALES
-- ==========================================================
-- This table represents the sales business process.
-- Each row corresponds to a single product purchased within an order.
-- The table combines transactional data from multiple Silver tables
-- and serves as the central fact table for analytical reporting.
-- ---------------------------------------------------------------
-- Source Tables:
------------------------
-- Business Key:
-- Composite Key (order_id, order_item_id)
--
-- Source Tables & Columns:
--
-- SILVER.ORDER_ITEMS
-- • order_id---------|\
                        -- Composite Key.
-- • order_item_id----|/
-- • product_id
-- • seller_id
-----------------
-- SILVER.ORDERS
-- • customer_id
-- • order_status
-- • order_purchase_timestamp
-- • order_estimated_delivery_date
-- • order_purchase_timestamp
-- • order_delivered_customer_date
--
-- Measures:
-- • price
-- • freight_value
--
-- Purpose:
-- Combines transactional data from the Orders and Order_Items
-- tables to create the central sales fact table. Each record
-- represents a single purchased product within an order and
-- captures the customer, product, seller, purchase timestamp,
-- and financial measures required for analytical reporting.
-- ==========================================================
-- Create Gold.Fact table
--==========================================================
CREATE OR REPLACE TABLE GOLD.FACT_SALES AS

SELECT

-- ==========================================================
-- Degenerate Dimension
-- ==========================================================
    oi.order_id,
    oi.order_item_id,

-- ==========================================================
-- Natural Foreign Keys
-- ==========================================================
    o.customer_id,
    oi.product_id,
    oi.seller_id,

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

INNER JOIN SILVER.ORDERS AS o
    ON oi.order_id = o.order_id;
    
/*
==========================================================
Surrogate Key Integration

This implementation replaces natural business keys with
surrogate keys generated from the Gold dimension tables.

Prerequisite:
Execute the surrogate key generation scripts located in
sql/surrogate_keys before running this script.

Natural Keys Replaced:
- customer_id -> customer_key
- product_id  -> product_key
- seller_id   -> seller_key

==========================================================
*/

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

-- ==========================================================
-- Verify Row Count
-- ========================================================== 
SELECT
    (SELECT COUNT(*) FROM GOLD.FACT_SALES) AS total_gold_table_rows,
    (SELECT COUNT(*) FROM SILVER.ORDER_ITEMS) AS total_silver_table_rows;
------------------------------------
-- Verification Complete
------------------------------------
-- Check the composite key
------------------------------------

SELECT 
        COUNT(*) AS total_rows,
        COUNT(DISTINCT CONCAT(order_id,'-',order_item_id)) AS unique_Rows
FROM GOLD.FACT_SALES;
-------------------------------------------------
-- Result: Both rows count are equal
------------------------------------------------

-- ==========================================================
-- Version 1.2 - Query Performance Optimization
-- Feature: Snowflake Clustering
-- ==========================================================
-- Objective:
-- Optimize analytical query performance by clustering the
-- FACT_SALES table on ORDER_PURCHASE_TIMESTAMP.
--
-- Rationale:
-- FACT_SALES is primarily queried using date-range filters
-- (monthly, quarterly and yearly reporting). Clustering on
-- ORDER_PURCHASE_TIMESTAMP improves micro-partition pruning
-- and reduces the amount of data scanned.
-- ==========================================================

-- ==========================================================
-- Step 1: Inspect Existing Table Structure
-- ==========================================================
SHOW COLUMNS IN TABLE GOLD.FACT_SALES;

-- ==========================================================
-- Step 2: Apply Clustering Key
-- ==========================================================
ALTER TABLE GOLD.FACT_SALES
CLUSTER BY (ORDER_PURCHASE_TIMESTAMP);

-- ==========================================================
-- Step 3: Verify Clustering Configuration
-- ==========================================================

-- Display table metadata
SHOW TABLES LIKE 'FACT_SALES' IN SCHEMA GOLD;

-- Display clustering information
SELECT SYSTEM$CLUSTERING_INFORMATION('GOLD.FACT_SALES');

-- (Optional) Display the table DDL to verify the
-- CLUSTER BY clause has been applied.
SELECT GET_DDL('TABLE', 'GOLD.FACT_SALES');