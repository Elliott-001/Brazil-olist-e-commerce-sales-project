create database brazil_sales;

create table customers (
customer_id varchar (250),
customer_unique_id varchar (250),
customer_zip_code_prefix int,
customer_city varchar (250),
customer_state varchar (250)
);

load data local infile 'C:/Users/Osabuohien/Documents/kaggle datasets/portfolio projects/brazil sales/olist_customers_dataset.csv'into table customers
fields terminated by ',' 
enclosed by '"'
ignore 1 lines;

create table geolocation (
geolocation_zip_code_prefix int,
geolocation_lat dec (16,14),
geolocation_lng dec (16,14),
geolocation_city varchar (250),
geolocation_state varchar (250)
);

load data local infile 'C:/Users/Osabuohien/Documents/kaggle datasets/portfolio projects/brazil sales/olist_geolocation_dataset.csv'into table geolocation
fields terminated by ',' 
enclosed by '"'
ignore 1 lines;


create table order_items (
order_id varchar (250),
order_item_id int,
product_id varchar (250),
seller_id varchar (250),
shipping_limit_date datetime,
price dec(6,2),
freight_value dec(5,2)
);

load data local infile 'C:/Users/Osabuohien/Documents/kaggle datasets/portfolio projects/brazil sales/olist_order_items_dataset.csv'into table order_items
fields terminated by ',' 
enclosed by '"'
ignore 1 lines;


create table order_payments (
order_id varchar (250),
payment_sequential int,
payment_type varchar (250),
payment_installments int,
payment_value dec(7,2)
);

load data local infile 'C:/Users/Osabuohien/Documents/kaggle datasets/portfolio projects/brazil sales/olist_order_payments_dataset.csv'into table order_payments
fields terminated by ',' 
enclosed by '"'
ignore 1 lines;


create table order_reviews (
review_id varchar (250),
order_id varchar (250),
review_score int,
review_comment_title varchar (250),
review_comment_message varchar (250),
review_creation_date datetime,
review_answer_timestamp datetime 
);

load data local infile 'C:/Users/Osabuohien/Documents/kaggle datasets/portfolio projects/brazil sales/olist_order_reviews_dataset.csv'into table order_reviews
fields terminated by ',' 
enclosed by '"'
ignore 1 lines;


create table orders (
order_id varchar(250),
customer_id varchar(250),
order_status varchar(250),
order_purchase_timestamp datetime,
order_approved_at datetime,
order_delivered_carrier_date datetime,
order_delivered_customer_date datetime,
order_estimated_delivery_date datetime
);

load data local infile 'C:/Users/Osabuohien/Documents/kaggle datasets/portfolio projects/brazil sales/olist_orders_dataset.csv'into table orders
fields terminated by ',' 
enclosed by '"'
ignore 1 lines;


create table products (
product_id varchar(250),
product_category_name varchar(250),
product_name_length int,
product_description_length int,
product_photos_qty int,
product_weight_g int,
product_length_cm int,
product_heigth_cm int,
product_width_cm int
);

load data local infile 'C:/Users/Osabuohien/Documents/kaggle datasets/portfolio projects/brazil sales/olist_products_dataset.csv'into table products
fields terminated by ',' 
enclosed by '"'
ignore 1 lines;


create table sellers (
seller_id varchar (250),
seller_zip_code_prefix int,
seller_city varchar (250),
seller_state varchar (250)
);

load data local infile 'C:/Users/Osabuohien/Documents/kaggle datasets/portfolio projects/brazil sales/olist_sellers_dataset.csv'into table sellers
fields terminated by ',' 
enclosed by '"'
ignore 1 lines;



create table product_category_translation (
product_category_name varchar (250),
product_category_name_english  varchar (250)
);

load data local infile 'C:/Users/Osabuohien/Documents/kaggle datasets/portfolio projects/brazil sales/product_category_name_translation.csv'into table product_category_translation
fields terminated by ',' 
ignore 1 lines;
