# Setup

## Purpose

This folder contains the SQL script used to initialize the Snowflake environment for the project.

## Responsibilities

The `setup.sql` script performs the following tasks:

* Creates the project warehouse.
* Creates the project database.
* Creates the `RAW`, `BRONZE`, `SILVER`, and `GOLD` schemas.
* Creates the internal stage used to upload source data.
* Creates the file formats required for loading CSV files.

## Execution Order

Run `setup.sql` before executing any ingestion or transformation scripts.

## Notes

This script is intended to be executed only once when setting up a new Snowflake environment. It can also be rerun safely because it uses `CREATE OR REPLACE` statements where appropriate.
