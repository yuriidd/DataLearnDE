DROP SCHEMA IF EXISTS stg CASCADE;
CREATE SCHEMA stg;

DROP TABLE IF EXISTS stg.orders;

CREATE TABLE stg.orders (
id int,
order_id varchar(14),
order_date varchar(10),
ship_date varchar(10),
ship_mode varchar(14),
customer_id varchar(10),
customer_name varchar(30),
segment varchar(15),
country varchar(30),
city varchar(30),
state varchar(30),
postal_code varchar(30),
region varchar(10),
product_id varchar(20),
category varchar(20),
subcategory varchar(20),
product_name varchar(200),
sales numeric,
quantity int,
discount numeric,
profit numeric
);

ALTER TABLE stg.orders
ADD COLUMN order_date2 DATE;
--UPDATE stg.orders SET order_date2 = to_date(order_date, 'DD.MM.YYYY');

ALTER TABLE stg.orders
ADD COLUMN ship_date2 DATE;
--UPDATE stg.orders SET ship_date2 = to_date(ship_date, 'DD.MM.YYYY');

