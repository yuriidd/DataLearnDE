-- growth = this year / last year - 1
-- and convert to percent

SELECT
	year,
--	ROUND(SUM(sales),2) AS Sum_of_Sales,
	ROUND(	(SUM(sales) / LAG(SUM(sales)) OVER (ORDER BY year) - 1) * 100, 2) 
		AS Sales_Grwth_prc,

--	ROUND(SUM(profit),2) AS Sum_of_Profit,
	ROUND(	(SUM(profit) / LAG(SUM(profit)) OVER (ORDER BY year) - 1) * 100, 2) 
		AS Profit_Grwth_prc,

--	SUM(quantity) AS Sum_of_Quantity,
	ROUND(	(SUM(quantity::numeric)	/ LAG(SUM(quantity::numeric)) OVER (ORDER BY year) - 1) * 100, 2) 
		AS Quantity_Grwth_prc,

--	count(order_id) AS Count_OrderID,
	ROUND(	(count(order_id)::numeric / LAG(count(order_id)::numeric) OVER (ORDER BY year) - 1) * 100, 2) 
		AS Orders_Grwth_prc,

--	SUM(profit)/SUM(sales) AS Profit_Margin,
	ROUND(	((SUM(profit)/SUM(sales)) / LAG(SUM(profit)/SUM(sales)) OVER (ORDER BY year) - 1) * 100, 2) 
		AS Profit_Margin_Grwth_prc

FROM orders
GROUP BY year
ORDER BY year
;