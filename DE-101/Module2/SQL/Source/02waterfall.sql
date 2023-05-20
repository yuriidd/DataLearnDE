SELECT * FROM (
	SELECT year, category, ROUND(SUM(profit),2) AS total_profit
	FROM orders
	WHERE year = 2019
	GROUP BY year, category 
	ORDER BY year, total_profit DESC 	) AS o1
UNION ALL
	SELECT year, 'TOTAL', ROUND(SUM(profit),2) AS total_profit
	FROM orders
	WHERE year = 2019
	GROUP BY year, 2 
;









