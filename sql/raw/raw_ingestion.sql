--Creating environment 
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE compute_wh;
USE DATABASE ecommerce_db;
USE SCHEMA raw;
 
 --Verifying stage 
 SHOW STAGES;

-- Stage confirmed, Validating data
ls@ecom_stage;