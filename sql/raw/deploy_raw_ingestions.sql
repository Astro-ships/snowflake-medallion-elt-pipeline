-- ==========================================================
-- Configure Snowflake session
-- ==========================================================

-- USE ROLE GITHUB_ACTIONS_ROLE;
USE WAREHOUSE compute_wh;
USE DATABASE ecommerce_db;
USE SCHEMA raw;

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
-- Load customer data into the RAW layer
-- ==========================================================


COPY INTO raw.customers
FROM @ecom_stage/olist_customers_dataset.csv.gz
FILE_FORMAT='CSV_FORMAT'
ON_ERROR=continue;

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
);
-- ============================================
-- Load data into RAW.GEOLOCATION
-- ============================================
COPY INTO raw.geolocation 
FROM @ecom_stage/olist_geolocation_dataset.csv.gz
FILE_FORMAT='CSV_FORMAT'
ON_ERROR=CONTINUE;


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
-- Load data into RAW.order_items
-- ============================================

COPY INTO raw.order_items
FROM  @ecom_stage/olist_order_items_dataset.csv.gz
FILE_FORMAT='CSV_FORMAT'
ON_ERROR=CONTINUE;

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
-- Load data into RAW.ORDER_PAYMENTS
-- ============================================
COPY INTO RAW.ORDER_PAYMENTS
FROM @ecom_stage/olist_order_payments_dataset.csv.gz
FILE_FORMAT=(FORMAT_NAME='CSV_FORMAT')
ON_ERROR=CONTINUE;



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


-- ============================================
-- Load data into RAW.PRODUCTS
-- ============================================
COPY INTO RAW.PRODUCTS
FROM @ecom_stage/olist_products_dataset.csv.gz
FILE_FORMAT=(FORMAT_NAME='CSV_FORMAT')
ON_ERROR=CONTINUE;


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
-- Load data into table RAW.ORDER_REVIEWS
-- =============================================================

COPY INTO RAW.ORDERS_REVIEWS 
FROM @ecom_stage/olist_order_reviews_dataset.csv.gz
FILE_FORMAT=(FORMAT_NAME='CSV_FORMAT')
ON_ERROR=CONTINUE;


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
-- Load data into table RAW.ORDERS
-- =============================================================

COPY INTO RAW.ORDERS
FROM @ecom_stage/olist_orders_dataset.csv.gz
FILE_FORMAT=(FORMAT_NAME='CSV_FORMAT')
ON_ERROR=CONTINUE;


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
-- Load data into table RAW.SELLERS
-- =============================================================

COPY INTO RAW.SELLERS
FROM @ecom_stage/olist_sellers_dataset.csv.gz
FILE_FORMAT=(FORMAT_NAME='CSV_FORMAT')
ON_ERROR=CONTINUE;


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
-- Load data into table RAW.SELLERSProducts_category
-- =============================================================
COPY INTO RAW.PRODUCT_CATEGORY
FROM @ecom_stage/product_category_name_translation.csv.gz
FILE_FORMAT=(FORMAT_NAME='CSV_FORMAT')
ON_ERROR=CONTINUE;
