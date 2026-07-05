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
--===============================================================================================
--===============================================================================================

-- ============================================
-- Create RAW.order_items using inferred schema
-- ============================================
CREATE OR REPLACE TABLE RAW.order_items
USING TEMPLATE(
                SELECT ARRAY_AGG(OBJECT_CONSTRUCT(*))
                FROM TABLE(
                            INFER_SCHEMA(
                                LOCATION=>'@ecom_stage',
                                FILE_FORMAT=>'INFER_SCHEMA_CSV',
                                FILES=>('olist_order_items_dataset.csv.gz')
                            )
                )

);

-- ============================================
-- Validate staged data
-- ============================================

COPY INTO raw.order_items
FROM @ecom_stage/olist_order_items_dataset.csv.gz
FILE_FORMAT='CSV_FORMAT'
VALIDATION_MODE=RETURN_ERRORS;

-- ============================================
-- Load data into RAW.order_items
-- ============================================

COPY INTO raw.order_items
FROM  @ecom_stage/olist_order_items_dataset.csv.gz
FILE_FORMAT='CSV_FORMAT'
ON_ERROR=CONTINUE;

-- ================================================
-- -- Verify that the data was loaded successfully.
-- ================================================
SELECT * 
FROM raw.order_items
LIMIT 10;
--===============================================================================================
--===============================================================================================
-- =============================================================
-- Create the RAW.ORDER_PAYMENTS table using the inferred schema
-- =============================================================


CREATE OR REPLACE TABLE RAW.ORDER_PAYMENTS 
USING TEMPLATE (
                SELECT ARRAY_AGG(OBJECT_CONSTRUCT(*))
                FROM TABLE(
                            INFER_SCHEMA(
                                LOCATION=>'@ecom_stage',
                                FILE_FORMAT=>'infer_Schema_csv',
                                FILES=>('olist_order_payments_dataset.csv.gz')
                            )
                )

);

-- ============================================
-- Validate staged data
-- ============================================

COPY INTO RAW.ORDER_PAYMENTS
FROM @ecom_stage/olist_order_payments_dataset.csv.gz
FILE_FORMAT=(FORMAT_NAME='CSV_FORMAT')
VALIDATION_MODE=RETURN_ERRORS;

-- ============================================
-- Load data into RAW.ORDER_PAYMENTS
-- ============================================
COPY INTO RAW.ORDER_PAYMENTS
FROM @ecom_stage/olist_order_payments_dataset.csv.gz
FILE_FORMAT=(FORMAT_NAME='CSV_FORMAT')
ON_ERROR=CONTINUE;

-- ================================================
-- -- Verify that the data was loaded successfully.
-- ================================================

SELECT *
FROM RAW.ORDER_PAYMENTS
LIMIT 10;


--===============================================================================================
--===============================================================================================


-- ==========================================================
-- Create the RAW.PRODUCTS table using the inferred schema
-- ==========================================================

CREATE OR REPLACE TABLE RAW.PRODUCTS 
USING TEMPLATE(
                SELECT ARRAY_AGG(OBJECT_CONSTRUCT(*))
                FROM TABLE(
                            INFER_SCHEMA(
                                LOCATION=>'@ecom_Stage',
                                FILE_FORMAT=>'infer_schema_csv',
                                FILES=>('olist_products_dataset.csv.gz')
                            )
                )
);
-- ==========================================================
-- Validate staged data
-- ==========================================================
COPY INTO RAW.PRODUCTS
FROM @ecom_stage/olist_products_dataset.csv.gz
FILE_FORMAT=(FORMAT_NAME='CSV_FORMAT')
VALIDATION_MODE=RETURN_ERRORS;

-- ============================================
-- Load data into RAW.PRODUCTS
-- ============================================
COPY INTO RAW.PRODUCTS
FROM @ecom_stage/olist_products_dataset.csv.gz
FILE_FORMAT=(FORMAT_NAME='CSV_FORMAT')
ON_ERROR=CONTINUE;

-- ================================================
-- -- Verify that the data was loaded successfully.
-- ================================================

SELECT *
FROM RAW.PRODUCTS
LIMIT 10;
--===============================================================================================
--===============================================================================================



-- =============================================================
-- Create the RAW.ORDER_REVIEWS table using the inferred schema
-- =============================================================

CREATE OR REPLACE TABLE RAW.ORDERS_REVIEWS
USING TEMPLATE(
                SELECT ARRAY_AGG(OBJECT_CONSTRUCT(*))
                FROM TABLE(
                            INFER_SCHEMA(
                                LOCATION=>'@ECOM_STAGE',
                                FILE_FORMAT=>'infer_schema_csv',
                                FILES=>('olist_order_reviews_dataset.csv.gz')
                            )
                )
);

-- =============================================================
-- Validate staged data.
-- =============================================================
COPY INTO RAW.ORDERS_REVIEWS
FROM @ecom_stage/olist_order_reviews_dataset.csv.gz
FILE_FORMAT=(FORMAT_NAME='CSV_FORMAT')
VALIDATION_MODE=RETURN_ERRORS;

-- =============================================================
-- Load data into table RAW.ORDER_REVIEWS
-- =============================================================

COPY INTO RAW.ORDERS_REVIEWS 
FROM @ecom_stage/olist_order_reviews_dataset.csv.gz
FILE_FORMAT=(FORMAT_NAME='CSV_FORMAT')
ON_ERROR=CONTINUE;

-- =============================================================
-- Verify that the data was loaded succefully
-- =============================================================
SELECT * 
FROM RAW.ORDERS_REVIEWS
LIMIT 10;

--===============================================================================================
--===============================================================================================

-- =============================================================
-- Create the RAW.ORDERS table using the inferred schema
-- =============================================================
CREATE OR REPLACE TABLE RAW.ORDERS 
USING TEMPLATE (
                SELECT ARRAY_AGG(OBJECT_CONSTRUCT(*))
                FROM TABLE(
                            INFER_SCHEMA(
                                LOCATION=>'@ecom_stage',
                                FILE_FORMAT=>'infer_schema_csv',
                                FILES=>('olist_orders_dataset.csv.gz')

                            )
                )
);

-- =============================================================
-- Validate staged data.
-- =============================================================

COPY INTO RAW.ORDERS
FROM @ecom_stage/olist_orders_dataset.csv.gz
FILE_FORMAT=(FORMAT_NAME='CSV_FORMAT')
VALIDATION_MODE=RETURN_ERRORS;


-- =============================================================
-- Load data into table RAW.ORDERS
-- =============================================================

COPY INTO RAW.ORDERS
FROM @ecom_stage/olist_orders_dataset.csv.gz
FILE_FORMAT=(FORMAT_NAME='CSV_FORMAT')
ON_ERROR=CONTINUE;

-- =============================================================
-- Verify that the data was loaded succefully
-- =============================================================

SELECT *
FROM RAW.ORDERS
LIMIT 10;

--===============================================================================================
--===============================================================================================


-- =============================================================
-- Create the RAW.SELLERS table using the inferred schema
-- =============================================================
CREATE OR REPLACE TABLE RAW.SELLERS 
USING TEMPLATE (
                SELECT ARRAY_AGG(OBJECT_CONSTRUCT(*))
                FROM TABLE(
                            INFER_SCHEMA(
                                LOCATION=>'@ecom_stage',
                                FILE_FORMAT=>'INFER_SCHEMA_CSV',
                                FILES=>('olist_sellers_dataset.csv.gz')

                            )
                )
);

-- =============================================================
-- Validate staged data.
-- =============================================================
COPY INTO RAW.SELLERS
FROM @ecom_stage/olist_sellers_dataset.csv.gz
FILE_FORMAT=(FORMAT_NAME='CSV_FORMAT')
VALIDATION_MODE=RETURN_ERRORS;

-- =============================================================
-- Load data into table RAW.SELLERS
-- =============================================================

COPY INTO RAW.SELLERS
FROM @ecom_stage/olist_sellers_dataset.csv.gz
FILE_FORMAT=(FORMAT_NAME='CSV_FORMAT')
ON_ERROR=CONTINUE;

-- =============================================================
-- Verify that the data was loaded succefully
-- =============================================================

SELECT * 
FROM RAW.ORDERS
LIMIT 10;

--===============================================================================================
--===============================================================================================


-- ===============================================================
-- Create the RAW.PRODUCT_CATEGORY table using the inferred schema
-- ===============================================================

CREATE OR REPLACE TABLE RAW.PRODUCT_CATEGORY
USING TEMPLATE(
                SELECT ARRAY_AGG(OBJECT_CONSTRUCT(*))
                FROM TABLE (
                            INFER_SCHEMA(
                                LOCATION=>'@ecom_stage',
                                FILE_FORMAT=>'INFER_SCHEMA_CSV',
                                FILES=>('product_category_name_translation.csv.gz')
                            )
                )
);

-- =============================================================
-- Validate staged data.
-- =============================================================
COPY INTO RAW.PRODUCT_CATEGORY
FROM @ecom_stage/product_category_name_translation.csv.gz
FILE_FORMAT=(FORMAT_NAME='CSV_FORMAT')
VALIDATION_MODE=RETURN_ERRORS;

-- =============================================================
-- Load data into table RAW.SELLERS
-- =============================================================
COPY INTO RAW.PRODUCT_CATEGORY
FROM @ecom_stage/product_category_name_translation.csv.gz
FILE_FORMAT=(FORMAT_NAME='CSV_FORMAT')
ON_ERROR=CONTINUE;

-- =============================================================
-- Verify that the data was loaded succefully
-- =============================================================

SELECT *
FROM RAW.PRODUCT_CATEGORY
LIMIT 10;
