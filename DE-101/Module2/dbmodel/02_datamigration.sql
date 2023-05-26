--	customers

INSERT INTO customers
SELECT DISTINCT customer_id, customer_name, segment
FROM orders_old
;

--	delivery_places

UPDATE orders_old
SET postal_code = '12345'
WHERE country = 'United States' AND
	city = 'Burlington' AND state = 'Vermont';

INSERT INTO delivery_places
SELECT DISTINCT country, city, state, postal_code, region
FROM orders_old
;

--	orders

INSERT INTO orders
SELECT DISTINCT oo.order_id 
		, oo.order_date2 AS order_date
		, oo.ship_date2 AS ship_date
		, oo.customer_id 
		, s1.delivery_place_id
		, s2.ship_mode_id
FROM orders_old AS oo
LEFT JOIN delivery_places AS s1 
	ON oo.country = s1.country 
		AND oo.city = s1.city 
		AND oo.state = s1.state 
		AND oo.postal_code = s1.postal_code 
LEFT JOIN ship_modes AS s2 
	USING(ship_mode)
;



--	order_details

INSERT INTO order_details
SELECT 	sales
	, quantity 
	, discount 
	, profit 
	, product_id
	, order_id
FROM orders_old
;

/*
INSERT INTO order_details
	(order_id, product_id, sales, quantity, discount, profit)
SELECT 	order_id
	, product_id
	, sales
	, quantity 
	, discount 
	, profit 
FROM orders_old
;
*/


