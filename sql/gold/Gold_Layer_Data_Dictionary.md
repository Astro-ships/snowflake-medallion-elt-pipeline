# GOLD Layer Data Dictionary

The Gold layer contains the dimensional model used for business analytics. It follows a Kimball-style dimensional modeling approach consisting of multiple fact tables and shared dimensions. Each table below documents its business purpose, grain, primary key, and column definitions.

---

# FACT_SALES

## Business Process

Sales

---

## Grain

One row represents **one product purchased within one order**.

---

## Row Identifier

**Composite Business Identifier (Degenerate Dimensions)**

```
(order_id, order_item_id)
```

Both `order_id` and `order_item_id` are **Degenerate Dimensions (DD)**. They uniquely identify each sales transaction but have no descriptive attributes requiring separate dimension tables.

---

## Columns
--------------------------------------------------------------------------------------------------------------------
| Column                             | Type                 | Description                                          |
|------------------------------------|----------------------|------------------------------------------------------|
| **order_id**                       | Degenerate Dimension | Business identifier for an order.                    |
| **order_item_id**                  | Degenerate Dimension | Identifies an individual line item within an order.  |
| **customer_key**                   | Foreign Key          | References **DIM_CUSTOMERS**.                        |
| **product_key**                    | Foreign Key          | References **DIM_PRODUCTS**.                         |
| **seller_key**                     | Foreign Key          | References **DIM_SELLERS**.                          |
| **order_status**                   | Attribute            | Current status of the order.                         |
| **order_purchase_timestamp**       | Attribute            | Timestamp when the order was placed.                 |
| **shipping_limit_date**            | Attribute            | Deadline for the seller to ship the product.         |
| **order_estimated_delivery_date**  | Attribute            | Estimated delivery date.                             |
| **order_delivered_carrier_date**   | Attribute            | Date the carrier received the package.               |
| **order_delivered_customer_date**  | Attribute            | Date the customer received the package.              |
| **sales_amount**                   | Measure              | Product sale price.                                  |
| **shipping_cost**                  | Measure              | Shipping cost charged for the product.               |
--------------------------------------------------------------------------------------------------------------------

---

# DIM_CUSTOMERS

### Business Entity

Customer

### Grain

One row represents one customer.

### Primary Key

**customer_key**

| Column                       | Description                                            |
|------------------------------|--------------------------------------------------------|
| **customer_key**             | Surrogate key generated for the customer dimension.    |
| **customer_id**              | Natural business identifier.                           |
| **customer_unique_id**       | Persistent customer identifier across multiple orders. |
| **customer_zip_code_prefix** | Customer ZIP code prefix.                              |
| **customer_city**            | Customer city.                                         |
| **customer_state**           | Customer state.                                        |                                    

---

# DIM_PRODUCTS

### Business Entity

Product

### Grain

One row represents one product.

### Primary Key

**product_key**

| Column                           | Type          | Description                                                   |
|----------------------------------|---------------|---------------------------------------------------------------|
| **product_key**                  | Surrogate Key | System-generated unique identifier for the product dimension. |
| **product_id**                   | Natural Key   | Original business identifier for the product.                 |
| **product_category_name**        | Attribute     | Product category.                                             |
| **product_name_length**          | Attribute     | Length of the product name.                                   |
| **product_description_length**   | Attribute     | Length of the product description.                            |
| **product_photos_qty**           | Attribute     | Number of product photos available.                           |
| **product_weight_g**             | Attribute     | Product weight in grams.                                      |
| **product_length_cm**            | Attribute     | Product length in centimeters.                                |
| **product_height_cm**            | Attribute     | Product height in centimeters.                                |          
| **product_width_cm**             | Attribute     | Product width in centimeters.                                 |

# DIM_SELLERS

### Business Entity

Seller

### Grain

One row represents one seller.

### Primary Key

**seller_key**

| Column                     | Description                                      |
|----------------------------|--------------------------------------------------|
| **seller_key**             | Surrogate key generated for the seller dimension.|
| **seller_id**              | Natural business identifier.                     |
| **seller_zip_code_prefix** | Seller ZIP code prefix.                          |
| **seller_city**            | Seller city.                                     |
| **seller_state**           | Seller state.                                    |
---

# FACT_PAYMENTS

## Business Process

Payments

---

## Grain

One row represents one payment transaction for one order.

---

## Row Identifier

**Composite Business Identifier (Degenerate Dimensions)**

(order_id, payment_sequential)

Both **order_id** and **payment_sequential** are **Degenerate Dimensions (DD)**. They uniquely identify each payment transaction but contain no descriptive attributes requiring separate dimension tables.

---

## Columns

| Column                     | Type                 | Description                               |
|----------------------------|----------------------|-------------------------------------------|
| **order_id**               | Degenerate Dimension | Unique order identifier.                  |
| **payment_sequential**     | Degenerate Dimension | Payment sequence within an order.         |
| **customer_key**           | Foreign Key          | References **DIM_CUSTOMERS**.             |
| **order_status**           | Attribute            | Current order status.                     |
| **payment_type**           | Attribute            | Payment method.                           |
| **payment_installments**   | Attribute            | Number of payment installments.           |
| **order_purchase_timestamp** | Attribute          | Order purchase timestamp.                 |
| **payment_value**          | Measure              | Payment amount.                           |
---

# FACT_REVIEWS

## Business Process

Customer Reviews

---

## Grain

One row represents one review associated with one order.

---

## Row Identifier

**Composite Business Identifier (Degenerate Dimensions)**

(review_id, order_id)

Both **review_id** and **order_id** are **Degenerate Dimensions (DD)** because they uniquely identify review transactions but contain no descriptive attributes requiring separate dimension tables.

---

## Columns

| Column                      | Type                 | Description                       |
|-----------------------------|----------------------|-----------------------------------|
| **review_id**               | Degenerate Dimension | Unique review identifier.         |
| **order_id**                | Degenerate Dimension | Unique order identifier.          |
| **customer_key**            | Foreign Key          | References **DIM_CUSTOMERS**.     |
| **review_creation_date**    | Attribute            | Review creation date.             |
| **review_answer_timestamp** | Attribute            | Review response timestamp.        |
| **review_score**            | Measure              | Customer review rating (1–5).     |

# Gold Warehouse Architecture

```text
                     DIM_CUSTOMERS
                   (customer_key)
                    /     |      \
                   /      |       \
                  ▼       ▼        ▼
          FACT_SALES  FACT_PAYMENTS  FACT_REVIEWS
             ▲
            / \
           /   \
          ▼     ▼
 DIM_PRODUCTS   DIM_SELLERS
 (product_key)  (seller_key)
```

---

## Overall Summary

- **FACT_SALES**
  - **Type:** Fact
  - **Grain:** One product per order
  - **Key:** `(order_id, order_item_id)` *(Degenerate Dimensions)*

- **DIM_CUSTOMERS**
  - **Type:** Dimension
  - **Grain:** One customer
  - **Key:** `customer_key`

- **DIM_PRODUCTS**
  - **Type:** Dimension
  - **Grain:** One product
  - **Key:** `product_key`

- **DIM_SELLERS**
  - **Type:** Dimension
  - **Grain:** One seller
  - **Key:** `seller_key`

- **FACT_PAYMENTS**
  - **Type:** Fact
  - **Grain:** One payment per order
  - **Key:** `(order_id, payment_sequential)` *(Degenerate Dimensions)*

- **FACT_REVIEWS**
  - **Type:** Fact
  - **Grain:** One review per order
  - **Key:** `(review_id, order_id)` *(Degenerate Dimensions)*