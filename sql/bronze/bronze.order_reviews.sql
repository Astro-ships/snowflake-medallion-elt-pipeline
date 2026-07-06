-- ==========================================================
-- Configure Snowflake session
-- ==========================================================
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE compute_wh;
USE DATABASE ecommerce_db;
USE SCHEMA BRONZE;
-- ==========================================================
-- CREATE ORDER_REVIEWS TABLE FROM RAW DATA
-- ==========================================================
CREATE OR REPLACE TABLE BRONZE.ORDER_REVIEWS AS 
SELECT 
        "review_id" AS review_id,
        "order_id" AS order_id,
        "review_score" AS review_score,
        "review_comment_title" AS review_comment_title,
        "review_comment_message" AS review_comment_message,
        "review_creation_date" AS review_creation_date,
        "review_answer_timestamp" AS review_answer_timestamp
FROM RAW.ORDERS_REVIEWS
-- ==========================================================
-- Validate Table
-- ==========================================================
SELECT *
FROM bronze.order_reviews
LIMIT 10;