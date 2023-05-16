-- create DB

--DROP DATABASE IF EXISTS superstore;
--CREATE DATABASE superstore;

-- import table orders

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

COPY orders(id,order_id,order_date,ship_date,ship_mode,customer_id,customer_name,segment,country,city,state,postal_code,region,product_id,category,subcategory,product_name,sales,quantity,discount,profit)
FROM '/mnt/d/git/DataLearnDE/DE-101/Module2/SQL/Source/orders.csv'
DELIMITER ';'
CSV HEADER;

-- import table people

DROP TABLE IF EXISTS people;
CREATE TABLE people (
person varchar(30),
region varchar(10)
);

COPY people(person,region)
FROM '/mnt/d/git/DataLearnDE/DE-101/Module2/SQL/Source/people.csv'
DELIMITER ';'
CSV HEADER;

-- import table returns

DROP TABLE IF EXISTS returns;
CREATE TABLE returns (
returned varchar(5),
order_id varchar(14)
);

COPY returns(returned,order_id)
FROM '/mnt/d/git/DataLearnDE/DE-101/Module2/SQL/Source/returns.csv'
DELIMITER ';'
CSV HEADER;




