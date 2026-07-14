

## Note
-- If the data provided is corrupted, Please click on the link below to download the files from the source.
 # Data Folder

This directory contains the source datasets used in this project.

## Dataset Source

The data used in this project is the **Olist Brazilian E-commerce Public Dataset**, available on Kaggle.

**Kaggle Dataset:**
https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

## Download Instructions

1. Visit the Kaggle dataset page using the link above.
2. Download the dataset as a ZIP file.
3. Extract the contents.
4. Copy the following CSV files into this `data/` directory:

* `olist_customers_dataset.csv`
* `olist_geolocation_dataset.csv`
* `olist_order_items_dataset.csv`
* `olist_order_payments_dataset.csv`
* `olist_order_reviews_dataset.csv`
* `olist_orders_dataset.csv`
* `olist_products_dataset.csv`
* `olist_sellers_dataset.csv`
* `product_category_name_translation.csv`

## Purpose

These files serve as the source data for the ETL pipeline and are loaded into Snowflake during the ingestion process. The datasets are transformed through the Raw, Bronze, Silver, and Gold layers following the Medallion Architecture.

> **Note:** The datasets are publicly available for educational and research purposes through Kaggle. Please refer to the Kaggle dataset page for licensing and attribution information.
