# Surrogate Key Generation

## Overview

This folder contains SQL scripts that demonstrate two approaches for generating **surrogate keys** in Snowflake for dimension tables.

Surrogate keys are integer-based identifiers that replace natural business keys (such as `customer_id`, `seller_id`, and `product_id`) within a dimensional data warehouse. They simplify joins, improve query performance, and provide stable identifiers for analytical workloads.

The scripts included in this folder are intended for educational purposes and to demonstrate common data warehousing techniques.

---

## Surrogate Key Generation Methods

### 1. ROW_NUMBER()

This method generates surrogate keys using the `ROW_NUMBER()` window function.

**Characteristics**

* Simple to implement.
* Suitable for static datasets.
* Useful for demonstrations and one-time data loads.
* Surrogate keys may change if the source data changes or is reloaded.

---

### 2. Snowflake SEQUENCE (Recommended)

This method generates surrogate keys using Snowflake `SEQUENCE` objects.

**Characteristics**

* Recommended for production data warehouses.
* Produces stable surrogate keys.
* Supports incremental data loading.
* Commonly used in enterprise ETL/ELT pipelines.

---

## Scripts

| Script              | Description                                          |
| ------------------- | ---------------------------------------------------- |
| `customer_keys.sql` | Generates surrogate keys for the Customer dimension. |
| `seller_keys.sql`   | Generates surrogate keys for the Seller dimension.   |
| `product_keys.sql`  | Generates surrogate keys for the Product dimension.  |

Each script demonstrates both surrogate key generation techniques and includes validation queries to verify one-to-one mappings between natural keys and surrogate keys.

---

## Validation

Each script performs the following validation checks:

* Total row count.
* Distinct surrogate key count.
* Distinct natural key count.
* Sample output inspection.

These checks help ensure that every natural key maps to exactly one surrogate key.

---

## Prerequisites

**These scripts cannot be executed independently.**

Before running any surrogate key generation script, the corresponding Gold Layer dimension tables **must already exist**.

Required dimension tables:

* `GOLD.DIM_CUSTOMERS`
* `GOLD.DIM_PRODUCTS`
* `GOLD.DIM_SELLERS`

These tables are created as part of the **Gold layer** of the Medallion ELT Pipeline. Execute the Gold layer scripts before running the surrogate key generation scripts.
