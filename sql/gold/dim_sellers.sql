-- ==========================================================
-- Configure Snowflake session
-- ==========================================================
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE compute_wh;
USE DATABASE ecommerce_db;
USE SCHEMA GOLD;
-- ==========================================================
-- Create DIM_SELLER
-- ==========================================================
-- Dimension:
-- Seller
--
-- Grain:
-- One row represents one unique seller.
--
-- Primary Key:
-- seller_id
--
-- Source Table:
-- • SILVER.SELLERS
-- ==========================================================
CREATE OR REPLACE TABLE GOLD.dim_sellers AS 
SELECT 
      DISTINCT 
              seller_id,
              seller_zip_code_prefix,
              seller_city,
              seller_state
FROM SILVER.SELLERS;
