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

