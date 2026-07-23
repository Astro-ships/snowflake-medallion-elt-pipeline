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
