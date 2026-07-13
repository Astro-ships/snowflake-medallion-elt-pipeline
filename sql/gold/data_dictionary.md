| Silver Table         | Important Columns                                                                                           |
| -------------------- | ----------------------------------------------------------------------------------------------------------- |
| **CUSTOMERS**        | customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, customer_state                    |
| **ORDERS**           | order_id, customer_id, order_status, order_purchase_timestamp, order_delivered_customer_date                |
| **ORDER_ITEMS**      | order_id, order_item_id, product_id, seller_id, shipping_limit_date, price, freight_value                   |
| **ORDER_PAYMENTS**   | order_id, payment_sequential, payment_type, payment_installments, payment_value                             |
| **ORDER_REVIEWS**    | review_id, order_id, review_score, review_comment_title, review_comment_message                             |
| **PRODUCTS**         | product_id, product_category_name, product_weight_g, product_length_cm, product_height_cm, product_width_cm |
| **PRODUCT_CATEGORY** | product_category_name, product_category_name_english                                                        |
| **SELLERS**          | seller_id, seller_zip_code_prefix, seller_city, seller_state                                                |
| **GEOLOCATION**      | geolocation_zip_code_prefix, geolocation_city, geolocation_state, geolocation_lat, geolocation_lng          |
