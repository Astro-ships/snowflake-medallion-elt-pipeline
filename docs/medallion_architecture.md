# Medallion Architecture

## Overview

This project implements the Medallion Architecture, a multi-layered data engineering design pattern that progressively improves data quality as it moves through the pipeline.

The architecture is divided into three logical layers:

* **Bronze** – Raw data ingestion
* **Silver** – Data validation, cleansing, and standardization
* **Gold** – Business-ready dimensional model optimized for analytics

Each layer has a distinct responsibility, making the pipeline easier to maintain, test, and scale.

---

# Architecture

```text
                 Source Dataset
                       │
                       ▼
                ┌──────────────┐
                │    Bronze    │
                │ Raw Ingestion│
                └──────┬───────┘
                       │
                       ▼
                ┌──────────────┐
                │    Silver    │
                │ Data Quality │
                │ Validation   │
                │ Standardize  │
                └──────┬───────┘
                       │
                       ▼
                ┌──────────────┐
                │     Gold     │
                │ Star Schema  │
                │ Analytics    │
                └──────────────┘
```

---

# Bronze Layer

The Bronze layer stores the original source data exactly as received.

No business logic or transformations are applied in this layer.

### Responsibilities

* Load raw source data
* Preserve original records
* Maintain historical integrity
* Serve as the source for downstream processing

---

# Silver Layer

The Silver layer focuses on improving data quality while preserving business meaning.

Each source table is profiled individually to identify data quality issues and validate business rules before analytical modeling.

### Activities Performed

* Data profiling
* NULL value analysis
* Duplicate detection
* Composite key validation
* Business rule validation
* Data type verification
* Geographic range validation
* Data standardization
* ZIP code normalization
* City name standardization
* Preservation of expected NULL values
* Normalized relational modeling

The Silver layer produces clean, validated relational tables that serve as the foundation for the Gold layer.

---

# Gold Layer

The Gold layer transforms the normalized Silver model into a dimensional Star Schema optimized for reporting and business intelligence.

This layer is designed for analytical workloads rather than transactional processing.

### Planned Activities

* Build Fact and Dimension tables
* Implement Star Schema
* Create business-friendly models
* Optimize analytical queries
* Support dashboards and reporting

---

# Why Medallion Architecture?

Separating the pipeline into Bronze, Silver, and Gold layers provides several advantages:

* Improves data quality incrementally
* Preserves raw source data
* Simplifies troubleshooting
* Separates ingestion from transformation
* Supports scalable data engineering pipelines
* Enables reusable datasets for analytics

---

# Technologies Used

* Snowflake
* SQL
* SnowSQL
* Git
* GitHub

---

# Project Workflow

```text
Source Data
      │
      ▼
 Bronze Layer
      │
      ▼
 Silver Layer
(Data Profiling & Standardization)
      │
      ▼
 Gold Layer
(Dimensional Star Schema)
      │
      ▼
Business Intelligence
Dashboards
Analytics
```
