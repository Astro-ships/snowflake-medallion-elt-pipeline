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
-- Composite Key
-- ==========================================================
    oi.order_id,
    oi.order_item_id,

-- ==========================================================
-- Foreign Keys
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

-- ==========================================================
-- Verify Row Count
--=========================================================== 
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