-- ==========================================================
-- Configure Snowflake session
-- ==========================================================
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE compute_wh;
USE DATABASE ecommerce_db;
USE SCHEMA GOLD;
-- ==========================================================
-- Create FACT_PAYMENTS
-- ==========================================================
-- Business Process:
-- Customer payments
--
-- Grain:
-- One row represents one payment transaction for an order.
--
-- Primary Key:
-- (order_id, payment_sequential)
--
-- Measures:
-- payment_value
-- ==========================================================

/*
==========================================================
Surrogate Key Integration

This implementation replaces the natural customer_id with
customer_key generated from the Gold dimension.

Prerequisite:
Execute sql/surrogate_keys/customer_keys.sql before
running this script.
==========================================================
*/

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