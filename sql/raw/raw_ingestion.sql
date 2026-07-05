--Creating environment 
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE compute_wh;
USE DATABASE ecommerce_db;
USE SCHEMA raw;
 
 --Verifying stage 
 SHOW STAGES;

-- Stage confirmed, Validating data
ls@ecom_stage;

SHOW FILE FORMATS;

-- Create a file format for bootstrapping table schemas from raw CSV files.
CREATE OR REPLACE FILE FORMAT infer_schema_csv
TYPE = CSV 
PARSE_HEADER = TRUE 
FIELD_OPTIONALLY_ENCLOSED_BY='"';


--VALIDATING FILE_FORMAT

SELECT *
FROM TABLE(
            infer_schema(
                LOCATION=>'@ecom_stage',
                FILE_FORMAT=>'infer_schema_csv',
                FILES=>('olist_customers_dataset.csv.gz')
            )
);

--Extract the blueprint of table to let snowflake create the table for us.
--1 Customer Table;
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

