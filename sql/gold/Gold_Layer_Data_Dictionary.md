# GOLD Layer Data Dictionary

The Gold layer contains the dimensional model used for business analytics. It follows a Kimball-style dimensional modeling approach consisting of multiple fact tables and shared dimensions. Each table below documents its business purpose, grain, primary key, and column definitions.

---

# FACT_SALES

### Business Process

Sales

### Grain

One row represents one product purchased within one order.

### Primary Key

**(order_id, order_item_id)**

| Column                        | Description                                          |
| ----------------------------- | ---------------------------------------------------- |
| order_id                      | Unique order identifier.                             |
| order_item_id                 | Line item identifier within an order.                |
| customer_id                   | Customer who placed the order. *(FK → DIM_CUSTOMER)* |
| product_id                    | Purchased product. *(FK → DIM_PRODUCT)*              |
| seller_id                     | Seller who sold the product. *(FK → DIM_SELLER)*     |
| order_status                  | Current status of the order.                         |
| order_purchase_timestamp      | Date and time the order was placed.                  |
| shipping_limit_date           | Deadline for the seller to ship the item.            |
| order_estimated_delivery_date | Estimated delivery date.                             |
| order_delivered_carrier_date  | Date the carrier received the package.               |
| order_delivered_customer_date | Date the customer received the package.              |
| sales_amount                  | Product sale price.                                  |
| shipping_cost                 | Shipping cost charged for the product.               |

---

# DIM_CUSTOMER

### Business Entity

Customer

### Grain

One row represents one customer.

### Primary Key

**customer_id**

| Column                   | Description                                            |
| ------------------------ | ------------------------------------------------------ |
| customer_id              | Unique customer identifier.                            |
| customer_unique_id       | Persistent customer identifier across multiple orders. |
| customer_zip_code_prefix | Customer ZIP code prefix.                              |
| customer_city            | Customer city.                                         |
| customer_state           | Customer state.                                        |

---

# DIM_PRODUCT

### Business Entity

Product

### Grain

One row represents one product.

### Primary Key

**product_id**

| Column                     | Description                        |
| -------------------------- | ---------------------------------- |
| product_id                 | Unique product identifier.         |
| product_category_name      | Product category.                  |
| product_name_length        | Length of the product name.        |
| product_description_length | Length of the product description. |
| product_photos_qty         | Number of product photos.          |
| product_weight_g           | Product weight in grams.           |
| product_length_cm          | Product length in centimeters.     |
| product_height_cm          | Product height in centimeters.     |
| product_width_cm           | Product width in centimeters.      |

---

# DIM_SELLER

### Business Entity

Seller

### Grain

One row represents one seller.

### Primary Key

**seller_id**

| Column                 | Description               |
| ---------------------- | ------------------------- |
| seller_id              | Unique seller identifier. |
| seller_zip_code_prefix | Seller ZIP code prefix.   |
| seller_city            | Seller city.              |
| seller_state           | Seller state.             |

---

# FACT_PAYMENTS

### Business Process

Payments

### Grain

One row represents one payment transaction for one order.

### Primary Key

**(order_id, payment_sequential)**

| Column                   | Description                                                      |
| ------------------------ | ---------------------------------------------------------------- |
| order_id                 | Order associated with the payment.                               |
| payment_sequential       | Sequential payment number for the order.                         |
| customer_id              | Customer who made the payment. *(FK → DIM_CUSTOMER)*             |
| order_status             | Current status of the order at the time of purchase.             |
| payment_type             | Payment method (Credit Card, Voucher, Boleto, Debit Card, etc.). |
| payment_installments     | Number of payment installments.                                  |
| payment_value            | Total payment amount.                                            |
| order_purchase_timestamp | Date and time the order was placed.                              |

---

# FACT_REVIEWS

### Business Process

Customer Reviews

### Grain

One row represents one review associated with one order.

### Primary Key

**(review_id, order_id)**

| Column                  | Description                                                       |
| ----------------------- | ----------------------------------------------------------------- |
| review_id               | Unique review identifier.                                         |
| order_id                | Order associated with the review.                                 |
| customer_id             | Customer who submitted the review. *(FK → DIM_CUSTOMER)*          |
| review_score            | Customer rating ranging from 1 to 5.                              |
| review_comment_title    | Review title. *(Retained for future NLP / sentiment analysis.)*   |
| review_comment_message  | Review message. *(Retained for future NLP / sentiment analysis.)* |
| review_creation_date    | Date the review was created.                                      |
| review_answer_timestamp | Date and time the review was answered.                            |

---

# Gold Warehouse Architecture

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

# Overall Summary

| Table         | Type      | Grain                                   | Primary Key                    |
| ------------- | --------- | --------------------------------------- | ------------------------------ |
| FACT_SALES    | Fact      | One product purchased within one order. | (order_id, order_item_id)      |
| DIM_CUSTOMER  | Dimension | One customer.                           | customer_id                    |
| DIM_PRODUCT   | Dimension | One product.                            | product_id                     |
| DIM_SELLER    | Dimension | One seller.                             | seller_id                      |
| FACT_PAYMENTS | Fact      | One payment transaction for one order.  | (order_id, payment_sequential) |
| FACT_REVIEWS  | Fact      | One review associated with one order.   | (review_id, order_id)          |
