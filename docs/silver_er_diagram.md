**            
# Silver Layer Entity Relationship (ER) Diagram

## Overview

The Silver layer follows a normalized relational data model in which each table represents a single business entity or business process. The relationships between tables preserve data integrity while minimizing redundancy and preparing the dataset for dimensional modeling in the Gold layer.

## Business Process

The dataset models the lifecycle of an e-commerce transaction:

1. A **customer** places one or more **orders**.
2. Each **order** contains one or more **order items**.
3. Each **order item** represents a single product purchased within an order.
4. Every **order item** references one **product** and one **seller**.
5. Each **product** belongs to a single **product category**.
6. An **order** may contain one or more **payment records**, allowing support for installment payments.
7. An **order** may receive a **customer review** after delivery.
8. Both **customers** and **sellers** are associated with geographical information through the **Geolocation** dataset using ZIP code, city, and state.

This normalized design minimizes data redundancy while preserving the relationships required for analytical modeling.

---

## Relationship Summary

| Parent Table     | Child Table    | Relationship                                   |
| ---------------- | -------------- | ---------------------------------------------- |
| Customers        | Orders         | One customer can place many orders             |
| Orders           | Order Items    | One order contains many order items            |
| Products         | Order Items    | One product can appear in many order items     |
| Sellers          | Order Items    | One seller can sell many order items           |
| Product Category | Products       | One category contains many products            |
| Orders           | Order Payments | One order can have one or more payment records |
| Orders           | Order Reviews  | One order may receive a customer review        |
| Geolocation      | Customers      | Customer location information                  |
| Geolocation      | Sellers        | Seller location information                    |

---

## Design Notes

* The Silver layer represents a normalized relational model.
* Foreign key relationships are documented logically in the ER diagram but are not enforced within Snowflake.
* Referential integrity is validated during the ETL process through data profiling and business rule validation rather than database constraints.
* The Silver layer serves as the foundation for the Gold layer, where these normalized entities will be transformed into a dimensional Star Schema optimized for analytical reporting.


**
                     PRODUCT_CATEGORY
                           │
                           │
                     PRODUCTS
                           │
                           │
                           │
CUSTOMERS ─── ORDERS ─── ORDER_ITEMS ─── SELLERS
      │            │
      │            │
      │            ├──────── ORDER_PAYMENTS
      │            │
      │            └──────── ORDER_REVIEWS
      │
      │
 GEOLOCATION 
 
 
 

 
 
 **                          PRODUCT_CATEGORY
                     +-------------------------+
                     | PK product_category_name|
                     | product_category_name_en|
                     +-----------+-------------+
                                 |
                                 |
                                 |
                     +-----------v-------------+
                     |        PRODUCTS         |
                     |-------------------------|
                     | PK product_id           |
                     | FK product_category_name|
                     | weight                  |
                     | length                  |
                     | height                  |
                     | width                   |
                     +-----------+-------------+
                                 |
                                 |
                                 |
               +-----------------v------------------+
               |           ORDER_ITEMS              |
               |------------------------------------|
               | FK order_id                        |
               | PK/FK order_item_id*              |
               | FK product_id                      |
               | FK seller_id                       |
               | price                              |
               | freight_value                      |
               +--------+---------------+-----------+
                        |               |
                        |               |
                        |               |
         +--------------v----+    +-----v-----------+
         |      ORDERS       |    |    SELLERS      |
         |--------------------|    |-----------------|
         | PK order_id        |    | PK seller_id    |
         | FK customer_id     |    | seller_zip_code |
         | order_status       |    | seller_city     |
         | purchase_timestamp |    | seller_state    |
         +---------+----------+    +-----------------+
                   |
                   |
                   |
        +----------v----------+
        |     CUSTOMERS       |
        |---------------------|
        | PK customer_id      |
        | customer_unique_id  |
        | zip_code_prefix     |
        | customer_city       |
        | customer_state      |
        +----------+----------+
                   |
                   |
                   |
         +---------v----------+
         |    GEOLOCATION     |
         |--------------------|
         | zip_code_prefix    |
         | city               |
         | state              |
         | latitude           |
         | longitude          |
         +--------------------+

**                ORDERS
                    |
        +-----------+------------+
        |                        |
        |                        |
+-------v--------+       +-------v--------+
| ORDER_PAYMENTS |       | ORDER_REVIEWS  |
|----------------|       |----------------|
| FK order_id    |       | review_id      |
| payment_seq    |       | FK order_id    |
| payment_type   |       | review_score   |
| payment_value  |       | review_comment |
+----------------+       +----------------+