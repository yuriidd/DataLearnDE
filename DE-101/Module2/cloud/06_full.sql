SELECT *
FROM dw.orders AS o1
LEFT JOIN dw.customers AS c
	USING(customer_id)
LEFT JOIN dw.delivery_places AS d
	USING(delivery_place_id)
LEFT JOIN dw.ship_modes AS s
	USING(ship_mode_id)
LEFT JOIN dw.order_details AS o2
	USING(order_id)
LEFT JOIN dw.products
	USING(product_id)
;