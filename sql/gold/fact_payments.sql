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

CREATE OR REPLACE TABLE GOLD.FACT_PAYMENTS AS

SELECT

-- ==========================================================
-- Composite Key
-- ==========================================================
    sp.order_id,
    sp.payment_sequential,

-- ==========================================================
-- Foreign Key
-- ==========================================================
    so.customer_id,

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
    ON sp.order_id = so.order_id;
