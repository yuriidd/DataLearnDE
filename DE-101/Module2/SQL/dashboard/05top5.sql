/*
SELECT * FROM (
	SELECT
	subcategory
	, ROUND(SUM(sales),2) AS total_sales
	FROM orders
	WHERE year = 2019
	GROUP BY subcategory
--	GROUP BY ROLLUP (subcategory)
	ORDER BY total_sales DESC
	LIMIT 5
 	) AS o1
UNION ALL
	SELECT 	'TOTAL', 
		(SELECT ROUND(SUM(sales),2) 
		FROM orders WHERE year = 2019)
;
*/


SELECT
	subcategory
	, ROUND(SUM(sales),2) AS total_sales
FROM orders
WHERE year = 2019
GROUP BY subcategory
ORDER BY total_sales DESC
LIMIT 5
;

