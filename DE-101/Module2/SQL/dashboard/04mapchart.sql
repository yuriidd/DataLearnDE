SELECT
	state
	, ROUND(SUM(sales)/1000,2) AS total_sales_$k
FROM orders
WHERE year = 2019
GROUP BY state
ORDER BY state ASC
;