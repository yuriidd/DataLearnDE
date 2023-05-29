DROP SCHEMA IF EXISTS dw CASCADE;
CREATE SCHEMA dw;

/*
DROP TABLE IF EXISTS dw.orders;
DROP TABLE IF EXISTS dw.products;
DROP TABLE IF EXISTS dw.ship_modes;
DROP TABLE IF EXISTS dw.customers;
DROP TABLE IF EXISTS dw.delivery_places;
DROP TABLE IF EXISTS dw.order_details;
*/

CREATE TABLE dw.products
(
  product_id VARCHAR(20) NOT NULL,
  category VARCHAR(40) NOT NULL,
  subcategory VARCHAR(40) NOT NULL,
  product_name VARCHAR(250) NOT NULL,
  PRIMARY KEY (product_id)
);

CREATE TABLE dw.ship_modes
(
  ship_mode VARCHAR(14) NOT NULL,
  ship_mode_id SERIAL NOT NULL,
  PRIMARY KEY (ship_mode_id)
);

CREATE TABLE dw.customers
(
  customer_id VARCHAR(10) NOT NULL,
  customer_name VARCHAR(30) NOT NULL,
  segment VARCHAR(15) NOT NULL,
  PRIMARY KEY (customer_id)
);

CREATE TABLE dw.delivery_places
(
  delivery_place_id SERIAL NOT NULL,
  country VARCHAR(30) NOT NULL,
  city VARCHAR(30) NOT NULL,
  state VARCHAR(30) NOT NULL,
  postal_code VARCHAR(30) NOT NULL,
  region VARCHAR(10) NOT NULL,
  PRIMARY KEY (delivery_place_id)
);

CREATE TABLE dw.orders
(
  order_id VARCHAR(14) NOT NULL,
  order_date DATE NOT NULL,
  ship_date DATE NOT NULL,
  customer_id VARCHAR(10) NOT NULL,
  delivery_place_id SERIAL NOT NULL,
  ship_mode_id SERIAL NOT NULL,
  PRIMARY KEY (order_id),
  FOREIGN KEY (customer_id) REFERENCES dw.customers(customer_id),
  FOREIGN KEY (delivery_place_id) REFERENCES dw.delivery_places(delivery_place_id),
  FOREIGN KEY (ship_mode_id) REFERENCES dw.ship_modes(ship_mode_id)
);

CREATE TABLE dw.order_details
(
  order_id VARCHAR(14) NOT NULL,
  product_id VARCHAR(20) NOT NULL,
  sales NUMERIC NOT NULL,
  quantity INT NOT NULL,
  discount NUMERIC NOT NULL,
  profit NUMERIC NOT NULL,
  FOREIGN KEY (product_id) REFERENCES dw.products(product_id),
  FOREIGN KEY (order_id) REFERENCES dw.orders(order_id)
);