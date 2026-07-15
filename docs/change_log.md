# Changelog

All notable changes to this project are documented in this file.

This project follows semantic versioning.

---

# Version 1.1.0 — Surrogate Key Enhancement

## Overview

This release introduces **surrogate keys** into the Gold layer dimensional model to better align the warehouse with **Kimball dimensional modeling best practices**.

Prior to this release, the warehouse relied on **natural business keys** as both dimension identifiers and foreign keys within the fact tables.

---

## Previous Design

### Dimension Tables

The following dimension tables used **natural business identifiers** as their primary keys:

| Table         | Previous Primary Key |
| ------------- | -------------------- |
| DIM_CUSTOMERS | customer_id          |
| DIM_PRODUCTS  | product_id           |
| DIM_SELLERS   | seller_id            |

These identifiers originated directly from the source system.

---

### Fact Tables

The fact tables referenced dimensions using the same natural business identifiers.

Examples:

* customer_id
* product_id
* seller_id

Although functional, this approach has several limitations:

* Larger joins using string-based keys
* Tight coupling with operational source systems
* Difficult to support Slowly Changing Dimensions (SCD)
* Less aligned with enterprise dimensional modeling standards

---

## Changes Introduced

### Added

Implemented surrogate key generation for all Gold dimension tables.

New surrogate key mapping scripts were created:

* customer_keys.sql
* product_keys.sql
* seller_keys.sql

Two implementation methods are demonstrated:

* ROW_NUMBER()
* Snowflake SEQUENCE (Recommended)

---

### Dimension Tables Updated

The following dimensions were redesigned to use surrogate keys.

| Table         | Previous Key | New Key      |
| ------------- | ------------ | ------------ |
| DIM_CUSTOMERS | customer_id  | customer_key |
| DIM_PRODUCTS  | product_id   | product_key  |
| DIM_SELLERS   | seller_id    | seller_key   |

Natural business keys remain stored inside each dimension for business reference.

---

### Fact Tables Updated

The following fact tables were modified to reference surrogate keys instead of natural keys.

Affected tables:

* FACT_SALES
* FACT_PAYMENTS
* FACT_REVIEWS

Foreign key replacements:

| Previous Foreign Key | New Foreign Key |
| -------------------- | --------------- |
| customer_id          | customer_key    |
| product_id           | product_key     |
| seller_id            | seller_key      |

---

### Degenerate Dimensions

Business transaction identifiers remain inside the fact tables as **Degenerate Dimensions**.

No surrogate keys were introduced for:

* order_id
* order_item_id
* payment_sequential
* review_id

These values uniquely identify business transactions and contain no descriptive attributes requiring separate dimension tables.

---

### Documentation Improvements

Updated:

* Gold Layer Data Dictionary
* Gold Layer Architecture Diagram
* Gold Layer Summary
* Column definitions
* Primary key documentation
* Foreign key documentation

Added documentation explaining:

* Surrogate Keys
* Natural Keys
* Foreign Keys
* Degenerate Dimensions

---

### Project Structure

Added a dedicated surrogate key module.

```text
sql/
└── surrogate_keys/
    ├── README.md
    ├── customer_keys.sql
    ├── product_keys.sql
    └── seller_keys.sql
```

---

## Benefits

The warehouse now follows Kimball dimensional modeling best practices by:

* Using integer-based surrogate keys for all dimensions
* Preserving natural business identifiers
* Improving join performance
* Reducing dependency on operational source keys
* Supporting future Slowly Changing Dimension implementations
* Improving long-term warehouse maintainability

---

## Impact

### Modified

* DIM_CUSTOMERS
* DIM_PRODUCTS
* DIM_SELLERS
* FACT_SALES
* FACT_PAYMENTS
* FACT_REVIEWS

### Added

* customer_keys.sql
* product_keys.sql
* seller_keys.sql
* Surrogate key documentation
* Updated Gold architecture

---

## Breaking Changes

The following foreign keys have changed throughout the Gold layer:

| Previous    | Current      |
| ----------- | ------------ |
| customer_id | customer_key |
| product_id  | product_key  |
| seller_id   | seller_key   |

Any downstream analytical queries should reference the new surrogate keys.

---

## Migration Notes

Execute the surrogate key generation scripts before running the updated Gold layer scripts.

Execution order:

1. Create Gold dimension tables
2. Execute surrogate key generation scripts
3. Rebuild Gold dimensions using surrogate keys
4. Rebuild Gold fact tables using surrogate keys
