-- ==========================================================
-- Configure Snowflake session
-- ==========================================================
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE compute_wh;
USE DATABASE ecommerce_db;
USE SCHEMA SILVER;
-- ==========================================================
-- Data Profiling
-- ==========================================================

-- Check for columns 
SHOW COLUMNS IN TABLE BRONZE.geolocation;

-- Check for column values 
DESCRIBE TABLE BRONZE.GEOLOCATION;
--======================================
-- Check customer_zip_code_prefix values
--======================================
---- Check for NULL values
SELECT 
        COUNT(*)
FROM BRONZE.GEOLOCATION
WHERE GEOLOCATION_ZIP_CODE_PREFIX IS NULL;

--No Nulls Found
-- Check ZIP code length
SELECT
        COUNT(*) as total_rows,
        LENGTH(GEOLOCATION_ZIP_CODE_PREFIX) AS prefix_length
FROM BRONZE.GEOLOCATION
GROUP BY prefix_length
ORDER BY prefix_length;
-- Result:
-- Some ZIP code prefixes contain fewer than 5 digits.

--======================================
-- Check GEOLOCATION_LAT Values
--======================================
--Check for nulls
SELECT 
        COUNT(*)
FROM BRONZE.geolocation
WHERE geolocation_lat IS NULL;

-- Result: No Nulls found
-- Validate latitude values are within the valid geographic range (-90 to 90).
SELECT 
     GEOLOCATION_CITY
FROM BRONZE.GEOLOCATION
WHERE GEOLOCATION_LAT > 90 OR GEOLOCATION_LAT < -90;
-- Result:No NULLS found
-- All latitude values are within the valid geographic range (-90 to 90).
--======================================
-- Check GEOLOCATION_LNG  Values
--======================================
-- Check for nulls.
SELECT 
        COUNT(*)
FROM BRONZE.GEOLOCATION
WHERE GEOLOCATION_LNG IS NULL;
--Result: No Nulls found


--Validate longtitude values are within the valid geographic range (-180 to 180)./
SELECT 
        GEOLOCATION_CITY
FROM BRONZE.GEOLOCATION
WHERE GEOLOCATION_LNG > 180 OR GEOLOCATION_LNG < -180;

-- Result:
-- All longitude values are within the valid geographic range (-180 to 180).

--======================================
-- Check GEOLOCATION_CITY 
--======================================
--Check for nulls
SELECT 
        COUNT(*)
FROM BRONZE.GEOLOCATION
WHERE GEOLOCATION_CITY IS NULL;

-- Result: No Nulls found
-- Inspect GEOLOCATION_CITY for consistency
SELECT 
      DISTINCT  GEOLOCATION_CITY
FROM BRONZE.GEOLOCATION
-- Result:
-- Multiple formatting inconsistencies were found, including
-- differences in capitalization and accented characters.
-- City names will be standardized in the Silver layer.


--======================================
-- Check GEOLOCATION_STATE
--======================================

-- Check for NULL
SELECT 
        COUNT(*)
FROM BRONZE.GEOLOCATION
WHERE GEOLOCATION_STATE IS NULL;
-- Result: No NULL rows
-- Inspect GEOLOCATION_state for consistency
SELECT
      DISTINCT  GEOLOCATION_STATE
FROM BRONZE.GEOLOCATION
--Result: Data is consistent


-- ===========================================================
-- Data Transformation 
-- ===========================================================
-- Investigation:
-- ZIP code prefixes are stored as NUMBER, so leading zeros are removed.
-- ZIP codes should be standardized to a fixed 5-character format.
SELECT 
        LPAD(GEOLOCATION_ZIP_CODE_PREFIX,5,'0') AS GEOLOCATION_ZIP_CODE_PREFIX
FROM BRONZE.GEOLOCATION
LIMIT 50;

--Values standardized to 5 prefix
--===============================================================================
SELECT 
     DISTINCT
     (TRANSLATE(INITCAP(LOWER(geolocation_city)),'áàâãéêíóôõúç',
    'aaaaeeiooouc') ) as geolocation_city
FROM bronze.geolocation

-- Evaluate city name standardization.
-- Convert values to title case and remove accented characters
-- to verify the expected standardized output.
-- ===========================================================
-- Create table SILVER.GEOLOCATION
-- ===========================================================
-- Apply all validated transformations and create the Silver geolocation table.

CREATE OR REPLACE TABLE SILVER.GEOLOCATION
AS
   SELECT 
         LPAD(GEOLOCATION_ZIP_CODE_PREFIX,5,'0') AS geolocation_zip_code_prefix,
         geolocation_lat,
         geolocation_lng,
         TRANSLATE(INITCAP(LOWER(geolocation_city)),'áàâãéêíóôõúç','aaaaeeiooouc') as geolocation_city,
         geolocation_state
   FROM BRONZE.geolocation;

-- ===========================================================
-- Validate table 
-- ===========================================================
SELECT 
        *
FROM SILVER.GEOLOCATION
LIMIT 50;