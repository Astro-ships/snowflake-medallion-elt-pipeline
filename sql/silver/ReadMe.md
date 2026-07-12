# Silver Layer – Data Profiling & Transformation Report

## Overview

The Silver layer is responsible for transforming raw Bronze data into a clean, validated, and standardized dataset while preserving the integrity of the original source. This layer serves as the foundation for analytical modeling in the Gold layer.

The primary objective of the Silver layer is not to modify data unnecessarily, but to investigate data quality, enforce business rules where appropriate, standardize inconsistent values, and document data quality issues before the data is consumed by downstream reporting and analytics.

---

# Objectives

* Validate the integrity of the Bronze layer.
* Perform comprehensive data profiling on every source table.
* Standardize inconsistent data formats.
* Preserve valid source data whenever possible.
* Remove only invalid inconsistencies while maintaining business meaning.
* Prepare normalized relational tables for dimensional modeling in the Gold layer.

---

# Data Profiling

Each table in the Bronze layer was profiled individually before any transformation was applied.

The following validation checks were performed throughout the Silver layer:

* NULL value analysis
* Duplicate record detection
* Primary key validation
* Composite key validation
* Business rule validation
* Data type verification
* Range validation
* Consistency checks
* Standardization assessment

---

# Business Rule Validation

Several business rules were validated during profiling, including:

* Latitude values fall within the valid geographic range (-90 to 90).
* Longitude values fall within the valid geographic range (-180 to 180).
* Product dimensions and weights do not contain negative values.
* ZIP code prefixes follow the expected five-digit format.
* Composite business keys remain unique where applicable.

---

# Data Quality Investigation

Rather than immediately transforming data, each anomaly was investigated to determine whether it represented a true data quality issue or a valid business scenario.

Examples include:

* Validation of composite keys within transactional tables.
* Identification of missing product metadata.
* Investigation of missing product dimensions.
* Verification that missing review comments represent expected business behavior.
* Validation that payment and order identifiers require composite keys instead of individual uniqueness.

The Silver layer preserves source data whenever missing values represent legitimate business cases rather than data corruption.

---

# Transformations Applied

Only transformations that improved data consistency without altering business meaning were implemented.

## Geolocation

* Standardized city names using title case.
* Removed accented characters using the TRANSLATE() function.

Example:

São Paulo → Sao Paulo

Rio de Janeiro → Rio De Janeiro

## ZIP Code Standardization

ZIP code prefixes were standardized to a fixed five-character format using LPAD() to restore leading zeros removed by the source system.

Example:

1234 → 01234

---

# Data Model

The Silver layer follows a normalized relational model.

Each table represents a single business entity while preserving relationships between entities.

The resulting Silver layer contains:

* Customers
* Orders
* Order Items
* Products
* Product Categories
* Sellers
* Payments
* Reviews
* Geolocation

Normalization reduces redundancy, improves data consistency, and creates a clean foundation for analytical modeling.

---

# Business Decisions

Several design decisions were made during implementation:

* Expected NULL values (such as review comments) were preserved.
* Missing product metadata was retained to preserve source system integrity.
* Composite keys were validated where single-column uniqueness was not expected.
* Transformations were only applied when they improved consistency without changing business meaning.
* No assumptions or artificial values were introduced into the dataset.

---

# Technologies Used

* Snowflake
* SQL
* SnowSQL
* Git
* GitHub

---

# Outcome

The Silver layer produces clean, validated, and standardized relational datasets while maintaining source data integrity.

The resulting tables provide a reliable foundation for analytical workloads and dimensional modeling.

---

# Next Step

The next phase of the project is the Gold layer.

The normalized Silver tables will be transformed into a dimensional Star Schema consisting of Fact and Dimension tables optimized for business intelligence, reporting, and analytical queries.
