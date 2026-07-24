# Deployment Guide

## Overview

This directory contains the deployment scripts required to deploy the complete Snowflake Medallion ELT Pipeline.

Each deployment script orchestrates the execution of the SQL modules in the correct dependency order, ensuring that all objects are created only after their dependencies exist.

The deployment is designed for use with the Snowflake CLI (`snow`) and GitHub Actions.

---

## GitHub Actions Workflow Status

> **Note**
>
> The GitHub Actions workflow has been successfully implemented, tested, and validated.
>
> To prevent unnecessary deployments during active development, the workflow has been intentionally disabled by renaming the workflow file:
>
> ```text
> .github/workflows/deploy-test.yml.disabled
> ```
>
> Since GitHub Actions only executes files ending with `.yml` or `.yaml` inside the `.github/workflows/` directory, this file is ignored while remaining in the repository for future use.
>
> ### Re-enabling the Workflow
>
> To enable automated deployments again:
>
> 1. Navigate to:
>
> ```text
> .github/workflows/
> ```
>
> 2. Rename:
>
> ```text
> deploy-test.yml.disabled
> ```
>
> back to:
>
> ```text
> deploy-test.yml
> ```
>
> 3. Commit and push the change:
>
> ```bash
> git add .github/workflows/deploy-test.yml
> git commit -m "chore(ci/cd): re-enable deployment workflow"
> git push
> ```
>
> Once restored, GitHub Actions will automatically detect the workflow and resume CI/CD execution according to the configured triggers.


# Deployment Environments

## Ecommerce_test

Used for:

* Development
* Testing
* Validation
* CI/CD verification

## Ecommerce_production

Used for:

* Production deployments
* Stable releases
* Business reporting

---

# Deployment Prerequisites

Before running the deployment pipeline, the following requirements must be satisfied.

## Snowflake

* Snowflake account
* Compute Warehouse
* Database
* Internal Stage
* File Format
* Required Roles and Users
* Appropriate privileges

Infrastructure objects are created using:

```
sql/setup/bootstrap_infrastructure.sql
```

This script is executed manually by an ACCOUNTADMIN and is **not** part of the automated deployment.

---

## Source Data

The Olist Brazilian E-commerce dataset must already be uploaded into the internal Snowflake stage.

Required datasets include:

* Customers
* Orders
* Order Items
* Payments
* Reviews
* Products
* Sellers
* Geolocation

---

## Authentication

Deployments require a configured Snowflake CLI connection.

For GitHub Actions, authentication is handled through encrypted GitHub Secrets.

Required secrets include:

* Snowflake Account
* Username
* Password
* Warehouse
* Database
* Role

---

# Deployment Order

The deployment script executes every layer in dependency order.

```
Infrastructure Bootstrap
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
Surrogate Key Generation
        │
        ▼
Analytics Layer
```

---

# Execution Flow

## 1. Bootstrap

Initializes the Snowflake session.

```
sql/setup/bootstrap.sql
```

---

## 2. RAW Layer

Creates RAW tables and loads source datasets.

```
sql/raw/deploy_raw_ingestions.sql
```

---

## 3. Bronze Layer

Creates the Bronze layer.

Responsibilities:

* Standardize naming
* Preserve source values
* Minimal transformations

```
sql/bronze/deploy_bronze.sql
```

---

## 4. Silver Layer

Creates the Silver layer.

Responsibilities:

* Data cleansing
* Deduplication
* Type standardization
* Missing value handling
* Data quality improvements

```
sql/silver/deploy_silver.sql
```

---

## 5. Gold Layer

Creates the dimensional warehouse.

Includes:

* Dimension Tables
* Fact Tables
* Star Schema

```
sql/gold/deploy_gold.sql
```

---

## 6. Surrogate Keys

Enhances the Gold layer by replacing business keys with surrogate keys.

Updates:

* Dimension tables
* Fact tables
* Key mapping tables

```
sql/key_generations/deploy_surrogate_keys.sql
```

---

## 7. Analytics Layer

Creates Snowflake Dynamic Tables for business reporting.

Current analytical datasets include:

* Monthly Sales
* Month-over-Month Growth
* Year-over-Year Growth
* Top 3 Products
* Top 3 Sellers

```
sql/dynamic_tables/deploy_analytics.sql
```

---

# Notes

* Deployment order must not be modified.
* Each layer depends on the successful completion of the previous layer.
* Surrogate Keys require the Gold layer to exist before execution.
* Analytics objects require the surrogate-key-enhanced Gold layer.

---

# Deployment Method

The deployment is fully automated through GitHub Actions.

Each push to the configured branch automatically:

1. Authenticates to Snowflake.
2. Executes the deployment script.
3. Builds the complete warehouse.
4. Creates analytical Dynamic Tables.

No manual intervention is required after the workflow starts.

---

# Version

Current Deployment Version

**v1.4**

Supports:

* Snowflake CLI
* GitHub Actions CI/CD
* Automated Medallion Architecture Deployment
* Dynamic Tables
* Surrogate Keys
* Environment-specific deployment
