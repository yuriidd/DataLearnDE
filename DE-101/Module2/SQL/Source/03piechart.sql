SELECT
	category
	, ROUND(SUM(sales)/(SELECT SUM(sales) FROM orders WHERE year = 2019),2) * 100 AS Sales_Percent
FROM orders
WHERE year = 2019
GROUP BY category
--GROUP BY ROLLUP (category)
ORDER BY category
;