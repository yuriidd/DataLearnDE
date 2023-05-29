--	ship_modes

INSERT INTO dw.ship_modes
SELECT DISTINCT ship_mode
FROM stg.orders
;

--	products

INSERT INTO dw.products
SELECT DISTINCT product_id, category, subcategory, product_name
FROM stg.orders
;

--	customers

INSERT INTO dw.customers
SELECT DISTINCT customer_id, customer_name, segment
FROM stg.orders
;

--	delivery_places

INSERT INTO dw.delivery_places
	(country, city, state, postal_code, region)
SELECT DISTINCT country, city, state, postal_code, region
FROM stg.orders
;

--	orders

INSERT INTO dw.orders
SELECT DISTINCT oo.order_id 
		, oo.order_date2 AS order_date
		, oo.ship_date2 AS ship_date
		, oo.customer_id 
		, s1.delivery_place_id
		, s2.ship_mode_id
FROM stg.orders AS oo
LEFT JOIN dw.delivery_places AS s1 
	ON oo.country = s1.country 
		AND oo.city = s1.city 
		AND oo.state = s1.state 
		AND oo.postal_code = s1.postal_code 
LEFT JOIN dw.ship_modes AS s2 
	USING(ship_mode)
;

--	order_details

INSERT INTO dw.order_details
	(order_id, product_id, sales, quantity, discount, profit)
SELECT 	order_id
	, product_id
	, sales
	, quantity 
	, discount 
	, profit 
FROM stg.orders
;