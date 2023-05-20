SELECT
	DATE_PART('month', order_date2) AS Order_Month,
	ROUND(SUM(sales),2) AS Sum_of_Sales,
	ROUND(SUM(profit),2) AS Sum_of_Profit,
	SUM(quantity) AS Sum_of_Quantity,
	count(order_id) AS Count_OrderID,
	ROUND(SUM(profit)/SUM(sales),4) AS Profit_Margin

FROM orders
WHERE year = 2019
GROUP BY Order_Month
ORDER BY Order_Month
;