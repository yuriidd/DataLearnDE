-- create DB

--DROP DATABASE IF EXISTS superstore;
--CREATE DATABASE superstore;

-- create table orders

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
id serial,
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


-- create table people

DROP TABLE IF EXISTS people;
CREATE TABLE people (
person varchar(30),
region varchar(10)
);


-- create table returns

DROP TABLE IF EXISTS returns;
CREATE TABLE returns (
returned varchar(5),
order_id varchar(14)
);





