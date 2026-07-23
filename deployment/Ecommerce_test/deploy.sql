-- ==========================================================
-- Deployment Script - TEST Environment
-- Version : 1.0
--
-- Executes the complete Snowflake Medallion ELT Pipeline
-- in dependency order.
-- ==========================================================

-- Bootstrap Snowflake Environment
!source sql/setup/bootstrap.sql

-- Raw Layer
!source sql/raw/deploy_raw_ingestions.sql

-- Bronze Layer
!source sql/bronze/deploy_bronze.sql

-- SILVER LAYER 
!source sql/silver/deploy_silver.sql

--Gold layer
 !source sql/gold/deploy_gold.sql
 -- Surrogate Keys
 !source sql/key_generations/deploy_surrogate_keys.sql
 -- Analytics 
 !source sql/dynamic_tables/deploy_analytics.sql
 -- pipeline build 
 