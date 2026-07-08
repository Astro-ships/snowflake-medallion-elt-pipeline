# RAW Layer

## Purpose

The RAW layer is the landing zone for source data.

Data is loaded into Snowflake without business transformations to preserve the original structure of the source files.

## Responsibilities

- Load CSV files from the internal stage.
- Infer schemas using `INFER_SCHEMA`.
- Create tables using `USING TEMPLATE`.
- Ingest data using `COPY INTO`.
- Perform load validation before ingestion.

## Source

Olist Brazilian E-commerce Dataset