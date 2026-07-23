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
-- Composite Key (Degenerate Dimension)
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
    so.order_purchase_timestamp,
    sp.payment_type,
    sp.payment_installments,

-- ==========================================================
-- Measure
-- ==========================================================
    sp.payment_value

FROM SILVER.ORDER_PAYMENTS AS sp

INNER JOIN SILVER.ORDERS AS so
    ON sp.order_id = so.order_id;

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

-- ===============================================
-- Verify Row Count
-- ===============================================
SELECT 
        ( SELECT COUNT(*) FROM SILVER.ORDER_PAYMENTS) AS SILVER_ROWS,
        (SELECT COUNT(*) FROM GOLD.FACT_PAYMENTS) AS GOLD_ROWS;
-- ================================================
-- Version 1.2 - Query Performance Optimizaiton
-- Feature Snowflake cluster 
-- ===============================================
-- Objective:
-- Optimize analytical query performance by clustering the
-- FACT_PAYMENTS table on ORDER_PURCHASE_TIMESTAMP.
-- Rationale:
-- FACT_PAYMENTS is commonly queried alongside order dates for
-- payment trend analysis, monthly reporting, and financial
-- dashboards. Clustering by ORDER_PURCHASE_TIMESTAMP improves
-- micro-partition pruning for date-range queries.
-- ==========================================================
-- Step 1: Inspect Existing Table Structure
-- ==========================================================
SHOW COLUMNS IN TABLE FACT_PAYMENTS;
-- ==========================================================
-- Step 2: Apply Clustering Key
-- ==========================================================
ALTER TABLE GOLD.FACT_PAYMENTS
CLUSTER BY (ORDER_PURCHASE_TIMESTAMP);

-- ==========================================================
-- Step 3: Verify Clustering Configuration
-- ==========================================================
-- Display table metadata 
SHOW TABLES LIKE 'FACT_PAYMENTS' IN SCHEMA GOLD;

-- Display clustering information
SELECT SYSTEM$CLUSTERING_INFORMATION('GOLD.FACT_PAYMENTS');
-- Display table DDL
SELECT GET_DDL('TABLE', 'GOLD.FACT_PAYMENTS');
