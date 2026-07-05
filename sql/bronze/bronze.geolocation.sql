-- ==========================================================
-- Configure Snowflake session
-- ==========================================================
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE compute_wh;
USE DATABASE ecommerce_db;
USE SCHEMA BRONZE;

-- ==========================================================
-- CREATE CUSTOMER TABLE FROM RAW DATA
-- ==========================================================

CREATE OR REPLACE TABLE bronze.geolocation AS
SELECT 
        "geolocation_zip_code_prefix", 
        "geolocation_lat",
        "geolocation_lng",
        UPPER("geolocation_city") as geolocation_city,
        "geolocation_state"
FROM RAW.GEOLOCATION;