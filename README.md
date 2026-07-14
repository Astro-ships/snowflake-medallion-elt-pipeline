# Snowflake ELT Pipeline | Medallion Architecture Data Warehouse

## Project Overview

This project demonstrates the design and implementation of a modern ELT pipeline using **Snowflake** and **SQL**, following the **Medallion Architecture (Raw → Bronze → Silver → Gold)**. The pipeline transforms raw e-commerce data into a dimensional data warehouse optimized for business intelligence and analytical reporting.

The source data is the **Olist Brazilian E-commerce Dataset** obtained from Kaggle.

The project showcases end-to-end data engineering concepts including data ingestion, data transformation, dimensional modeling, data quality validation, and warehouse design.

---

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

# Project Structure
## Project Structure

```text
snowflake-medallion-elt-pipeline/
│
├── .github/
│   └── workflows/
│
├── data/
│   ├── README.md
│   ├── olist_customers_dataset.csv
│   ├── olist_geolocation_dataset.csv
│   ├── olist_order_items_dataset.csv
│   ├── olist_order_payments_dataset.csv
│   ├── olist_order_reviews_dataset.csv
│   ├── olist_orders_dataset.csv
│   ├── olist_products_dataset.csv
│   ├── olist_sellers_dataset.csv
│   └── product_category_name_translation.csv
│
├── docs/
│   ├── README.md
│   ├── architecture.md
│   └── data_dictionary.md
│
├── sql/
│   ├── setup/
│   │   ├── README.md
│   │   └── setup.sql
│   │
│   ├── raw/
│   │   ├── README.md
│   │   └── raw_ingestion.sql
│   │
│   ├── bronze/
│   │   ├── README.md
│   │   ├── bronze_customers.sql
│   │   ├── bronze_geolocation.sql
│   │   ├── bronze_order_items.sql
│   │   ├── bronze_order_payments.sql
│   │   ├── bronze_order_reviews.sql
│   │   ├── bronze_orders.sql
│   │   ├── bronze_product_category_translation.sql
│   │   ├── bronze_products.sql
│   │   └── bronze_sellers.sql
│   │
│   ├── silver/
│   │   ├── README.md
│   │   ├── silver_customers.sql
│   │   ├── silver_geolocation.sql
│   │   ├── silver_order_items.sql
│   │   ├── silver_order_payments.sql
│   │   ├── silver_order_reviews.sql
│   │   ├── silver_orders.sql
│   │   ├── silver_product_category_translation.sql
│   │   ├── silver_products.sql
│   │   └── silver_sellers.sql
│   │
│   └── gold/
│       ├── README.md
│       ├── fact_sales.sql
│       ├── fact_payments.sql
│       ├── fact_reviews.sql
│       ├── dim_customers.sql
│       ├── dim_products.sql
│       └── dim_sellers.sql
│
├── .gitignore
├── LICENSE
└── README.md
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

# Key Features

* Medallion Architecture implementation.
* Snowflake data warehouse.
* Star Schema dimensional modeling.
* Fact and Dimension table design.
* Composite primary key validation.
* Data quality checks.
* Well-documented SQL transformations.
* Complete project documentation.

---

# Documentation

Additional documentation is available in the **docs/** directory.

* Architecture
* Data Dictionary
* Data Ingestion Process

---

# Future Improvements

* Implement automated data ingestion using Snowflake Tasks and Streams.
* Build interactive Power BI dashboards.
* Add Python-based orchestration.
* Implement CI/CD using GitHub Actions.
* Extend analytical reporting.

---

# Learning Outcomes

This project demonstrates practical knowledge of:

* ELT Pipeline Development
* Snowflake
* SQL
* Medallion Architecture
* Data Warehousing
* Dimensional Modeling
* Star Schema Design
* Data Validation
* Git & GitHub

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

