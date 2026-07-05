-- ==========================================================
-- Configure Snowflake session
-- ==========================================================

USE ROLE ACCOUNTADMIN;
USE WAREHOUSE compute_wh;
USE DATABASE ecommerce_db;
USE SCHEMA raw;
 
-- ==========================================================
-- Verify that the required stage exists
-- ==========================================================

 SHOW STAGES;
-- ==========================================================
-- Verify existing file formats
-- ==========================================================

ls@ecom_stage;

SHOW FILE FORMATS;

--- ==========================================================
-- Create a file format for schema inference
-- This file format is used by INFER_SCHEMA to bootstrap
-- column names and data types from the source CSV files.
-- ==========================================================

CREATE OR REPLACE FILE FORMAT infer_schema_csv
TYPE = CSV 
PARSE_HEADER = TRUE 
FIELD_OPTIONALLY_ENCLOSED_BY='"';

-- ==========================================================
-- Validate the inferred schema before creating the table
-- ==========================================================

SELECT *
FROM TABLE(
            infer_schema(
                LOCATION=>'@ecom_stage',
                FILE_FORMAT=>'infer_schema_csv',
                FILES=>('olist_customers_dataset.csv.gz')
            )
);

-- ==========================================================
-- Create the RAW.CUSTOMERS table using the inferred schema
-- ==========================================================
CREATE OR REPLACE TABLE RAW.CUSTOMERS 
USING TEMPLATE(
                SELECT ARRAY_AGG(OBJECT_CONSTRUCT(*))
                FROM TABLE(
                            infer_schema(
                                            LOCATION=>'@ecom_stage',
                                            FILE_FORMAT=>'INFER_SCHEMA_CSV',
                                            FILES=>('olist_customers_dataset.csv.gz')
                            )
                )
);
-- ==========================================================
-- Verify the existing loading file format
-- ==========================================================

DESC FILE FORMAT csv_format;

-- ==========================================================
-- Create the file format used for loading CSV data
-- ==========================================================

CREATE OR REPLACE FILE FORMAT CSV_FORMAT
TYPE=CSV 
SKIP_HEADER=1
FIELD_OPTIONALLY_ENCLOSED_BY='"';
-- ==========================================================
-- Validate the staged data before loading
-- This step returns parsing or data type errors without
-- inserting any records into the table.
-- ==========================================================

COPY INTO raw.customers 
FROM @ecom_stage/olist_customers_dataset.csv.gz
FILE_FORMAT='CSV_FORMAT'
VALIDATION_MODE=RETURN_ERRORS;

-- ==========================================================
-- Load customer data into the RAW layer
-- ==========================================================


COPY INTO raw.customers
FROM @ecom_stage/olist_customers_dataset.csv.gz
FILE_FORMAT='CSV_FORMAT'
ON_ERROR=continue;

-- ==========================================================
-- Verify that the data has been loaded successfully
-- ==========================================================

SELECT * 
FROM raw.customers
LIMIT 10;

-- ============================================
-- Create RAW.GEOLOCATION using inferred schema
-- ============================================
CREATE OR REPLACE table raw.geolocation
USING TEMPLATE(
                SELECT ARRAY_AGG(OBJECT_CONSTRUCT(*))
                FROM TABLE(
                            infer_schema(
                                LOCATION=>'@ecom_stage',
                                FILE_FORMAT=>'infer_schema_csv',
                                FILES=>('olist_geolocation_dataset.csv.gz')
                            )
                )
)

-- ============================================
-- Validate staged data
-- ============================================

COPY INTO raw.geolocation
FROM @ecom_stage/olist_geolocation_dataset.csv.gz
FILE_FORMAT='CSV_FORMAT'
VALIDATION_MODE=RETURN_ERRORS;


-- ============================================
-- Load data into RAW.GEOLOCATION
-- ============================================
FROM @ecom_stage/olist_geolocation_dataset.csv.gz
FILE_FORMAT='CSV_FORMAT'
ON_ERROR=CONTINUE;


-- ============================================
-- Verify loaded data
-- ============================================

SELECT *
FROM raw.geolocation
limit 10;