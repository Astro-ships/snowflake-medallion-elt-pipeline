-- ==========================================================
-- Infrastructure Bootstrap
-- Version : 1.0
--
-- Purpose:
-- Creates the core Snowflake infrastructure required before
-- the CI/CD pipeline can deploy objects.
--
-- This script is executed manually by ACCOUNTADMIN.
-- GitHub Actions DOES NOT execute this script.
-- ==========================================================

-- ==========================================================
-- Switch to ACCOUNTADMIN.
-- ACCOUNTADMIN is required to create warehouses,
-- databases, roles and users.
-- ==========================================================
USE ROLE ACCOUNTADMIN;

-- ==========================================================
-- Create the warehouse used by the deployment pipeline.
-- AUTO_RESUME starts the warehouse automatically.
-- AUTO_SUSPEND minimizes cost by shutting it down after
-- 10 minutes of inactivity.
-- ==========================================================
CREATE OR REPLACE WAREHOUSE compute_wh
INITIALLY_SUSPENDED = TRUE
AUTO_RESUME = TRUE
AUTO_SUSPEND = 600
MIN_CLUSTER_COUNT = 1
MAX_CLUSTER_COUNT = 4
SCALING_POLICY = STANDARD
WAREHOUSE_SIZE = 'SMALL';

-- ==========================================================
-- Create the project database.
-- IF NOT EXISTS prevents failures if the database already
-- exists.
-- ==========================================================
CREATE DATABASE IF NOT EXISTS ECOMMERCE_DB;

-- ==========================================================
-- Create the dedicated role used by GitHub Actions.
-- This follows the principle of least privilege.
-- ==========================================================
CREATE ROLE IF NOT EXISTS GITHUB_ACTIONS_ROLE;

-- ==========================================================
-- Allow the role to use the compute warehouse.
-- ==========================================================
GRANT USAGE
ON WAREHOUSE compute_wh
TO ROLE GITHUB_ACTIONS_ROLE;

-- ==========================================================
-- Grant required database privileges.
-- ==========================================================
GRANT ALL
ON DATABASE ECOMMERCE_DB
TO ROLE GITHUB_ACTIONS_ROLE;

-- ==========================================================
-- Grant permissions on all existing schemas.
-- ==========================================================
GRANT ALL PRIVILEGES
ON ALL SCHEMAS IN DATABASE ECOMMERCE_DB
TO ROLE GITHUB_ACTIONS_ROLE;

-- ==========================================================
-- Automatically grant privileges on schemas created in the
-- future.
-- ==========================================================
GRANT ALL PRIVILEGES
ON FUTURE SCHEMAS IN DATABASE ECOMMERCE_DB
TO ROLE GITHUB_ACTIONS_ROLE;

-- ==========================================================
-- Create the service account used by GitHub Actions.
--
-- Password should be changed manually after creation and
-- stored securely as a GitHub Secret.
-- ==========================================================
CREATE USER IF NOT EXISTS github_actions
PASSWORD = '<set_manually>'
DEFAULT_ROLE = GITHUB_ACTIONS_ROLE
DEFAULT_WAREHOUSE = compute_wh
DEFAULT_NAMESPACE = ECOMMERCE_DB.RAW;

-- ==========================================================
-- Assign the deployment role to the GitHub Actions user.
-- ==========================================================
GRANT ROLE GITHUB_ACTIONS_ROLE
TO USER github_actions;

-- ==========================================================
-- Allow the deployment role to read files from the internal
-- stage.
-- Required for COPY INTO and LIST operations.
-- ==========================================================
GRANT READ
ON STAGE ECOMMERCE_DB.RAW.ECOM_STAGE
TO ROLE GITHUB_ACTIONS_ROLE;

-- ==========================================================
-- Allow the deployment role to write files to the internal
-- stage if required in the future.
-- ==========================================================
GRANT WRITE
ON STAGE ECOMMERCE_DB.RAW.ECOM_STAGE
TO ROLE GITHUB_ACTIONS_ROLE;