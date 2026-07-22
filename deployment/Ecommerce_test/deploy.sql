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
!source/sql/bronze/deploy_bronze.sql