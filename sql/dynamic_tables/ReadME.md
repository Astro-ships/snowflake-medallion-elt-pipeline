# Analytics Layer – Snowflake Dynamic Tables

## Overview

The **Analytics** layer extends the Medallion Architecture by leveraging **Snowflake Dynamic Tables** to automatically maintain business-ready analytical datasets.

Unlike traditional tables that require scheduled ETL jobs or manual refreshes, Dynamic Tables continuously refresh themselves based on the configured `TARGET_LAG`, ensuring analytical results remain up to date with minimal operational effort.

This layer demonstrates how Snowflake can be used to automate common reporting and KPI calculations while reducing maintenance overhead.

---

## Prerequisites

Before creating any Dynamic Tables, the following components **must already exist**:

* **Gold Layer**

  * All Fact and Dimension tables must be created.
  * Gold layer transformations must be completed successfully.

* **Surrogate Keys**

  * All Dimension tables must contain surrogate keys.
  * Fact tables must reference Dimension tables using surrogate keys.

The Dynamic Tables in this project depend on the following Gold objects:

* `FACT_SALES`
* `FACT_PAYMENTS`
* `FACT_REVIEWS`
* `DIM_CUSTOMERS`
* `DIM_PRODUCTS`
* `DIM_SELLERS`

---

## Refresh Strategy

All Dynamic Tables are configured using:

```sql
TARGET_LAG = '1 day'
```

This allows Snowflake to automatically refresh analytical datasets within a maximum freshness window of one day whenever the underlying Gold tables receive new data.

---

## Dynamic Tables Included

### Monthly Sales

Calculates total sales revenue for each calendar month.

**Purpose**

* Monthly revenue reporting
* Sales trend analysis
* Executive dashboards

---

### Month-over-Month Growth

Calculates monthly sales growth using the `LAG()` window function.

**Purpose**

* Measure monthly business performance
* Identify growth and decline trends

---

### Year-over-Year Growth

Calculates annual sales growth percentages using yearly sales totals.

**Purpose**

* Annual business comparison
* Executive KPI reporting

---

### Top 3 Products by Month

Ranks the highest-selling products each month using `DENSE_RANK()`.

**Purpose**

* Product performance analysis
* Best-selling product reporting

---

### Top 3 Sellers by Month

Ranks the highest-performing sellers each month using `DENSE_RANK()`.

**Purpose**

* Seller performance monitoring
* Marketplace analytics

---

## SQL Concepts Demonstrated

The Analytics layer showcases several advanced Snowflake SQL features, including:

* Snowflake Dynamic Tables
* Common Table Expressions (CTEs)
* Window Functions

  * `LAG()`
  * `DENSE_RANK()`
* Aggregate Functions
* `DATE_TRUNC()`
* Fact-to-Dimension Joins
* Automated dataset refreshes
* Business KPI calculations

---

## Notes

* Dynamic Tables automatically maintain analytical datasets whenever the underlying source tables change.
* Complex transformations involving joins, aggregations, and window functions may consume additional compute during refresh operations.
* In production environments, `TARGET_LAG` should be selected based on business freshness requirements and compute cost considerations.

---

## Validation

After creating a Dynamic Table, validate the results using a standard query.

Example:

```sql
SELECT *
FROM ANALYTICS.MONTHLY_SALES
ORDER BY sales_month;
```

---

## Summary

The Analytics layer demonstrates how Snowflake Dynamic Tables can be used to build **self-maintaining analytical datasets** without relying on external orchestration or scheduled ETL jobs. By combining Dynamic Tables with the Gold layer and surrogate-key-based dimensional modeling, this project delivers automated, business-ready reporting datasets suitable for dashboards and advanced analytics.
