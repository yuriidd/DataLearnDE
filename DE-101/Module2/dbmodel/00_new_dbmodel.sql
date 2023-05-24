DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS ship_modes;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS delivery_places;
DROP TABLE IF EXISTS order_details;

CREATE TABLE products
(
  product_id VARCHAR(20) NOT NULL,
  category SERIAL NOT NULL,
  subcategory VARCHAR(40) NOT NULL,
  product_name VARCHAR(250) NOT NULL,
  PRIMARY KEY (product_id)
);

CREATE TABLE ship_modes
(
  ship_mode VARCHAR(14) NOT NULL,
  ship_mode_id SERIAL NOT NULL,
  PRIMARY KEY (ship_mode_id)
);

CREATE TABLE customers
(
  customer_id VARCHAR(10) NOT NULL,
  customer_name VARCHAR(30) NOT NULL,
  segment VARCHAR(15) NOT NULL,
  PRIMARY KEY (customer_id)
);

CREATE TABLE delivery_places
(
  country VARCHAR(30) NOT NULL,
  city VARCHAR(30) NOT NULL,
  state VARCHAR(30) NOT NULL,
  postal_code VARCHAR(30) NOT NULL,
  region VARCHAR(10) NOT NULL,
  delivery_place_id SERIAL NOT NULL,
  PRIMARY KEY (delivery_place_id)
);

CREATE TABLE orders
(
  order_id VARCHAR(14) NOT NULL,
  order_date DATE NOT NULL,
  ship_date DATE NOT NULL,
  customer_id VARCHAR(10) NOT NULL,
  delivery_place_id SERIAL NOT NULL,
  ship_mode_id SERIAL NOT NULL,
  PRIMARY KEY (order_id),
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  FOREIGN KEY (delivery_place_id) REFERENCES delivery_places(delivery_place_id),
  FOREIGN KEY (ship_mode_id) REFERENCES ship_modes(ship_mode_id)
);

CREATE TABLE order_details
(
  sales NUMERIC NOT NULL,
  quantity INT NOT NULL,
  discount NUMERIC NOT NULL,
  profit NUMERIC NOT NULL,
  product_id VARCHAR(20) NOT NULL,
  order_id VARCHAR(14) NOT NULL,
  FOREIGN KEY (product_id) REFERENCES products(product_id),
  FOREIGN KEY (order_id) REFERENCES orders(order_id)
);