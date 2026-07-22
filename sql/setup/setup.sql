
-- ==========================================================
-- Configure the Snowflake session and compute warehouse
-- ==========================================================
USE ROLE ACCOUNTADMIN;
CREATE OR REPLACE WAREHOUSE compute_wh
WAREHOUSE_SIZE ='small'
INITIALLY_SUSPENDED=TRUE
MIN_CLUSTER_COUNT=1
MAX_CLUSTER_COUNT=4
AUTO_SUSPEND=60
AUTO_RESUME=TRUE
SCALING_POLICY=standard;
-- ==========================================================
-- Create the database and schemas for each data layer
-- ==========================================================

CREATE OR REPLACE DATABASE ecommerce_db;

CREATE OR REPLACE SCHEMA raw;
CREATE OR REPLACE SCHEMA bronze;

CREATE OR REPLACE SCHEMA silver;
CREATE OR REPLACE SCHEMA gold;
-- ==========================================================
-- Create an internal stage for raw source files
-- ==========================================================
USE WAREHOUSE compute_wh;
USE DATABASE ecommerce_db;
USE SCHEMA RAW;
CREATE OR REPLACE STAGE ecom_stage;
-- ==========================================================
-- THE FILE FORMAT THE DATA WILL USE TO PARSE INTO TABLE
-- ==========================================================

CREATE OR REPLACE FILE FORMAT csv_format
TYPE='CSV'
SKIP_HEADER = 1 
FIELD_OPTIONALLY_ENCLOSED_BY='"';

-- ==========================================
-- File format for InferSchema 
-- ===========================================

CREATE FILE FORMAT IF NOT EXISTS infer_schema_csv 
TYPE='CSV'
PARSE_HEADER=TRUE
FIELD_OPTIONALLY_ENCLOSED_BY='"';