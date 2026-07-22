-- ==========================================================
-- Configure Snowflake session
-- ==========================================================
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE compute_wh;
USE DATABASE ecommerce_db;
USE SCHEMA GOLD;

/*
==========================================================
Customer Surrogate Key Generation
==========================================================

Business Entity : Customer

Grain           : One row represents one unique customer.

Primary Key     : customer_key

Natural Key     : customer_id

NOTE:
This script demonstrates two approaches for generating
surrogate keys.

• Method 1: ROW_NUMBER() (Demonstration)
• Method 2: Snowflake SEQUENCE (Production)

Execute only ONE method at a time because both methods
create the CUSTOMER_KEYS table.

For a detailed explanation of each approach, refer to
the README in the surrogate_keys folder.
==========================================================
*/

--==========================================================
-- Method 1 : ROW_NUMBER()
--==========================================================

CREATE OR REPLACE TABLE customer_keys AS

SELECT
    customer_id,
    ROW_NUMBER() OVER (ORDER BY customer_id) AS customer_key
FROM GOLD.DIM_CUSTOMERS;

--==========================================================
-- Validation
--==========================================================

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customer_key) AS unique_customer_keys,
    COUNT(DISTINCT customer_id) AS unique_customer_ids
FROM customer_keys;

SELECT *
FROM customer_keys
ORDER BY customer_key
LIMIT 50;

--==========================================================
-- Method 2 : Snowflake SEQUENCE (Recommended)
--==========================================================

CREATE OR REPLACE SEQUENCE customer_key_seq
START = 1
INCREMENT = 1;

CREATE OR REPLACE TABLE customer_keys AS

SELECT
    customer_key_seq.NEXTVAL AS customer_key,
    customer_id
FROM GOLD.DIM_CUSTOMERS;

--==========================================================
-- Validation
--==========================================================

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customer_key) AS unique_customer_keys,
    COUNT(DISTINCT customer_id) AS unique_customer_ids
FROM customer_keys;

SELECT *
FROM customer_keys
ORDER BY customer_key
LIMIT 50;

-- ==========================================================
-- Prerequisite: Surrogate Key Generation
-- ==========================================================
-- Gold and Silver layer must exists 
-------------------------------------------------------
CREATE OR REPLACE TABLE GOLD.dim_customers 
AS 
SELECT 
DISTINCT 
    ck.customer_key,
    sc.customer_id,
    sc.customer_unique_id,
    sc.customer_zip_code_prefix,
    sc.customer_city,
    sc.customer_state
FROM silver.customers AS sc
INNER JOIN customer_keys as ck 
ON 
sc.customer_id = ck.customer_id ;

-------------------
-- Inspect table 
-------------------
SELECT * 
FROM dim_customers
ORDER BY customer_key 
LIMIT 50;