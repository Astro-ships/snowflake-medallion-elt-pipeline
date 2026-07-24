# Snowflake ELT Pipeline | Medallion Architecture Data Warehouse

## Project Overview

This project demonstrates the design and implementation of a modern ELT pipeline using **Snowflake** and **SQL**, following the **Medallion Architecture (Raw → Bronze → Silver → Gold)**. The pipeline transforms raw e-commerce data into a dimensional data warehouse optimized for business intelligence and analytical reporting.

The source data is the **Olist Brazilian E-commerce Dataset** obtained from Kaggle.

The project showcases end-to-end data engineering concepts including data ingestion, data transformation, dimensional modeling, data quality validation, and warehouse design.

---
# 🚀 Latest Updates
## Version 1.4 — Automated CI/CD Deployment using GitHub Actions

### ✨ New Features

* Implemented a fully automated CI/CD pipeline using **GitHub Actions**.
* Migrated deployment from **SnowSQL** to the **Snowflake CLI (`snow`)**.
* Automated end-to-end deployment of the complete Medallion Architecture.
* Added environment-specific deployment support (Test & Production).
* Configured secure authentication using **GitHub Secrets**.
* Implemented dependency-aware deployment order.
* Added infrastructure bootstrap automation.
* Improved deployment reliability through automated workflow execution.
* Extended repository documentation with CI/CD architecture and deployment process.
* Incoming:V1.4.1 - Add production layer.
* **Note**: Please refer to deployment/ReadMe.md file for requirements.

> **Pipeline Execution Order**
>
> Infrastructure Bootstrap
>
> ↓
>
> Raw Layer
>
> ↓
>
> Bronze Layer
>
> ↓
>
> Silver Layer
>
> ↓
>
> Gold Layer
>
> ↓
>
> Surrogate Key Generation
>
> ↓
>
> Analytics Layer (Dynamic Tables)

## Version 1.3 — Analytics Layer using Snowflake Dynamic Tables

### ✨ New Features

- Introduced an **Analytics Layer** powered by Snowflake Dynamic Tables.
- Implemented automated business-ready analytical datasets.
- Added **Monthly Sales** Dynamic Table.
- Added **Month-over-Month (MoM) Sales Growth** Dynamic Table.
- Added **Year-over-Year (YoY) Sales Growth** Dynamic Table.
- Added **Top 3 Products by Monthly Revenue** Dynamic Table.
- Added **Top 3 Sellers by Monthly Revenue** Dynamic Table.
- Implemented automatic refreshes using `TARGET_LAG`.
- Extended the Medallion Architecture beyond the Gold layer.
- Added comprehensive Analytics Layer documentation.

> **Prerequisites**
>
> Before deploying the Analytics Layer:
>
> - Gold Layer must already exist.
> - Surrogate Keys must already be implemented.
> - Fact tables must reference Dimension surrogate keys.
>
> Dynamic Tables depend on:
>
> - FACT_SALES
> - FACT_PAYMENTS
> - FACT_REVIEWS
> - DIM_CUSTOMERS
> - DIM_PRODUCTS
> - DIM_SELLERS

---

### v1.2 — Query Performance Optimization

**New Features**

- Introduced Snowflake Clustering to optimize analytical workloads.
- Clustered `FACT_SALES` on `ORDER_PURCHASE_TIMESTAMP`.
- Clustered `FACT_PAYMENTS` on `ORDER_PURCHASE_TIMESTAMP`.
- Added clustering validation using `SYSTEM$CLUSTERING_INFORMATION()`.
- Documented clustering strategy and implementation.
- Updated Gold Layer documentation.

> **Note**
>
> **Snowflake Clustering (v1.2)** was intentionally applied only to the **FACT_SALES** table because it is the primary analytical fact table and is frequently filtered using **`ORDER_PURCHASE_TIMESTAMP`** for time-based reporting.
>
> Dimension tables and smaller fact tables were intentionally left **unclustered** to avoid unnecessary serverless compute costs, as the performance benefits would not justify the additional maintenance overhead.
--
---

## Version 1.1 — Surrogate Key Enhancement

### ✨ What's New

- Introduced surrogate keys for all Gold dimension tables.
- Updated fact tables to reference surrogate keys instead of natural business keys.
- Added surrogate key generation scripts using:
  - `ROW_NUMBER()`
  - Snowflake `SEQUENCE` (recommended)
- Added comprehensive documentation for surrogate key generation.
- Improved warehouse design by aligning the Gold layer with Kimball dimensional modeling best practices.

### 🔄 Affected Tables

**Dimension Tables**

- DIM_CUSTOMERS
- DIM_PRODUCTS
- DIM_SELLERS

**Fact Tables**

- FACT_SALES
- FACT_PAYMENTS
- FACT_REVIEWS

### 🔁 Foreign Key Changes
------------------------------
| Previous    | Current      |
|-------------|--------------|
|customer_id  |customer_key  |
|product_id   |product_key   |
|seller_id    |seller_key    |
------------------------------
### 📌 Unchanged

The following business identifiers remain as **Degenerate Dimensions** because they uniquely identify business transactions and contain no descriptive attributes:

- order_id
- order_item_id
- payment_sequential
- review_id

---

> **Note**
>
> Surrogate key generation scripts are located under:
>
> ```
> sql/surrogate_keys/
> ```
>
> These scripts must be executed before creating the updated Gold dimension and fact tables.
---------------
| Version  | Major Update                                                                  |
| -------- | ----------------------------------------------------------------------------- |
| **v1.0** | Built complete Snowflake Medallion ELT Pipeline                               |
| **v1.1** | Introduced surrogate keys and enhanced dimensional modeling                   |
| **v1.2** | Implemented Snowflake clustering for query performance optimization           |
| **v1.3** | Introduced Analytics Layer using Snowflake Dynamic Tables                     |
| **v1.4** | Implemented automated CI/CD deployment using GitHub Actions and Snowflake CLI |


# Objectives

* Build an end-to-end ELT pipeline using Snowflake.
* Implement the Medallion Architecture.
* Clean, standardize, and transform raw data.
* Design a Kimball-style dimensional data warehouse.
* Create reusable fact and dimension tables.
* Validate data quality throughout the pipeline.
* Document the complete warehouse design.

---

# Technology Stack

| Technology | Purpose                        |
| ---------- | ------------------------------ |
| Snowflake  | Cloud Data Warehouse           |
| SQL        | Data Transformation & Modeling |
| SnowSQL    | Data Loading                   |
| Git        | Version Control                |
| GitHub     | Source Control & Documentation |
| Kaggle     | Source Dataset                 |
|Snowflake Dynamic Tables|Automated Analytics 
---

# Dataset

**Dataset**

Olist Brazilian E-commerce Dataset

The dataset contains information about:

* Customers
* Orders
* Products
* Sellers
* Payments
* Reviews
* Geolocation

---
# Data Modeling

This project demonstrates two complementary data modeling approaches:

### Normalized Data Model (Silver Layer)

The Silver layer follows a normalized relational design to:

- Reduce data redundancy
- Improve data consistency
- Prepare clean datasets for analytical modeling

### Star Schema (Gold Layer)

The Gold layer follows a Kimball-style Star Schema consisting of fact and dimension tables.

Fact tables:

- FACT_SALES
- FACT_PAYMENTS
- FACT_REVIEWS

Dimension tables:

- DIM_CUSTOMER
- DIM_PRODUCT
- DIM_SELLER

The Star Schema simplifies analytical queries while improving reporting performance.


# Medallion Architecture

The project follows the Medallion Architecture consisting of four layers:

```text
Kaggle Dataset
      │
      ▼
 RAW Layer
      │
      ▼
BRONZE Layer
      │
      ▼
SILVER Layer
      │
      ▼
 GOLD Layer
      │
      ▼
ANALYTICS Layer
(Dynamic Tables)
```

## RAW Layer

Purpose:

* Store source data exactly as received.
* No transformations applied.
* Preserve original datasets.

---

## BRONZE Layer

Purpose:

* Rename columns.
* Standardize naming conventions.
* Preserve original business values.

---

## SILVER Layer

Purpose:

* Data cleansing.
* Remove duplicates.
* Standardize formats.
* Handle missing values.
* Improve data quality.
* Prepare data for dimensional modeling.

---

## GOLD Layer

Purpose:

* Build dimensional models.
* Create fact and dimension tables.
* Support reporting and business analytics.

---
# Analytics Layer

The Analytics layer extends the Medallion Architecture by utilizing **Snowflake Dynamic Tables** to automatically maintain business-ready analytical datasets.

Unlike traditional reporting tables that require scheduled ETL jobs or manual refreshes, Dynamic Tables continuously refresh themselves based on the configured `TARGET_LAG`, ensuring analytical datasets remain synchronized with the latest data in the Gold layer.

Current Dynamic Tables include:

- Monthly Sales
- Month-over-Month (MoM) Sales Growth
- Year-over-Year (YoY) Sales Growth
- Top 3 Products by Monthly Revenue
- Top 3 Sellers by Monthly Revenue

These datasets are designed for business intelligence, dashboarding, executive reporting, and analytical workloads.
I might add some more typical analytics queries.

# 🚀 CI/CD Pipeline

This project includes a fully automated CI/CD pipeline built using GitHub Actions and the Snowflake CLI.

Every push to the main branch automatically deploys the complete Snowflake ELT pipeline in dependency order.

## Deployment Order

Infrastructure Bootstrap
↓
Raw Layer
↓
Bronze Layer
↓
Silver Layer
↓
Gold Layer
↓
Surrogate Keys
↓
Analytics Layer

## Features

* Automated CI/CD Pipeline
* GitHub Actions Workflow Automation
* Snowflake CLI Deployment
* Environment-specific Deployments (Test & Production)
* Secure Authentication using GitHub Secrets


# Project Structure
## Project Structure

```text
snowflake-medallion-elt-pipeline/
│
├── README.md                  ⭐ Main documentation
├── CHANGELOG.md
├── LICENSE
├── .gitignore
│
├── .github/
│   └── workflows/
│       └── deploy-test.yml
│
├── data/
│
├── deployment/
│   ├── Ecommerce_test/
│   │   └── deploy.sql
│   └── Ecommerce_production/
│       
│
├── docs/
│   ├── architecture.png
│   ├── medallion_architecture.png
│   ├── star_schema.png
│   ├── cicd_pipeline.png
│   └── screenshots/
│
└── sql/
    ├── setup/
    ├── raw/
    ├── bronze/
    ├── silver/
    ├── gold/
    ├── Key_generations/
    └── dynamic_tables/
```

# ELT Workflow

1. Use the data source provided in data folder.
2. Upload CSV files into Snowflake internal stage using snownsql or snowsight. Download link for snowsql (https://www.snowflake.com/en/developers/downloads/snowsql/)
-- SnowSQL removes the file upload size limitation of snowsight.
3. Infer table schemas using `INFER_SCHEMA`.
4. Load datasets into the RAW layer using `COPY INTO`.
5. Transform data into the Bronze layer.
6. Clean and standardize data within the Silver layer.
7. Build dimensional models in the Gold layer.
8. Validate row counts, keys, and relationships.

---

# Gold Layer Overview

The Gold layer follows a Kimball-style dimensional model.

It consists of:

## Fact Tables

* FACT_SALES
* FACT_PAYMENTS
* FACT_REVIEWS

## Dimension Tables

* DIM_CUSTOMER
* DIM_PRODUCT
* DIM_SELLER

---

# Star Schema

```text
                     DIM_CUSTOMER
                          │
          ┌───────────────┼───────────────┐
          │               │               │
          ▼               ▼               ▼
     FACT_SALES     FACT_PAYMENTS    FACT_REVIEWS
          ▲
          │
    ┌─────┴─────┐
    │           │
    ▼           ▼
DIM_PRODUCT  DIM_SELLER
```

---

# Data Quality Validation

The warehouse was validated using several quality checks including:

* Row count validation between Silver and Gold layers.
* Composite primary key validation.
* Duplicate record detection.
* NULL primary key validation.
* Referential integrity verification between fact and dimension tables.

---

## 🚀 Features

- Medallion Architecture (RAW → Bronze → Silver → Gold → Analytics)
- Kimball Star Schema
- Snowflake SQL ELT Pipeline
- Snowflake Dynamic Tables
- Automated Business KPI Calculations
- Data Validation Framework
- Surrogate Key Implementation
- Degenerate Dimensions
- Snowflake Clustering for Query Optimization
- Comprehensive Documentation
- Git Version Control

---

# Documentation

Additional documentation is available in the **docs/** directory.

* Architecture
* Data Dictionary
* Data Ingestion Process

---

# Future Improvements
- Implement automated ingestion using Snowflake Streams and Tasks.
- Add Snowpark transformations.
- Implement Data Quality Monitoring.
- Introduce Incremental ELT patterns.
---

# Learning Outcomes

This project demonstrates practical knowledge of:

- ELT Pipeline Development
- Snowflake
- Snowflake Dynamic Tables
- SQL
- Medallion Architecture
- Data Warehousing
- Dimensional Modeling
- Star Schema Design
- Surrogate Keys
- Window Functions
- Business KPI Development
- Data Validation
- Git & GitHub

---

# Acknowledgements

Dataset:

**Olist Brazilian E-commerce Public Dataset**
Source:

https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

Available through Kaggle, also I have uploaded the relevant docs in doc folder for conveniece


---

# Author

**Muhammad Adnan Khan**

Electrical Telecommunication Engineer
- Cisco Certified Network Professional
- Aspiring Data Engineer

GitHub: https://github.com/Astro-ships

# Snowflake ELT Pipeline | Medallion Architecture Data Warehouse

