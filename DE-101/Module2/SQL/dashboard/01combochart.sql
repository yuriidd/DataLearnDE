SELECT
	DATE_PART('month', order_date2) AS Order_Month,
	ROUND(SUM(sales),2) AS Sum_of_Sales,
	ROUND(SUM(profit),2) AS Sum_of_Profit
FROM orders
WHERE EXTRACT(year FROM order_date2) = 2019 --or WHERE year = 2019
GROUP BY Order_Month
;