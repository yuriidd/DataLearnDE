> [Начало](../../../README.md) >>  [Модуль 2](../README.md) >> SQL запросы для дашборда к Superstore

#superstore #sql

## Вспомогательные [действия](dashboard/00add.sql).

Мы импортировали дату заказа и дату отправки как текстовые поля, а не поля типа `date`.  С текстовой датой в виде `05.12.2018` очень неудобно работать и что-бы в последующих запросах не нагромождать много кода для перевода и калькуляции срезов по месяцам/годам, создаю две колонки: год заказа как `integer` и дату заказа как `date`. 

```sql
-- imported order date is text column
-- better way to create new column for future calculating

ALTER TABLE orders
ADD COLUMN order_date2 DATE;

ALTER TABLE orders
ADD COLUMN year INTEGER;

UPDATE orders SET order_date2 = to_date(order_date, 'DD.MM.YYYY');
UPDATE orders SET year =  EXTRACT(year FROM order_date2);
```

Оригинальную `order_date`, конечно, можно удалить - но нам она не мешает.

```sql 
superstore=> SELECT order_date, year, order_date2 FROM orders LIMIT 1;

 order_date | year | order_date2
------------+------+-------------
 05.12.2018 | 2018 | 2018-12-05
(1 row)
```

## ComboChart - [sql](dashboard/01combochart.sql)

```sql
SELECT
	DATE_PART('month', order_date2) AS Order_Month,
	ROUND(SUM(sales),2) AS Sum_of_Sales,
	ROUND(SUM(profit),2) AS Sum_of_Profit
FROM orders
WHERE EXTRACT(year FROM order_date2) = 2019 --or WHERE year = 2019
GROUP BY Order_Month
;
```

```sql
 order_month | sum_of_sales | sum_of_profit
-------------+--------------+---------------
           1 |     43971.37 |       7140.44
           2 |     20301.13 |       1613.87
           3 |     58872.35 |      14751.89
           4 |     36521.54 |        933.29
           5 |     44261.11 |       6342.58
           6 |     52981.73 |       8223.34
           7 |     45264.42 |       6952.62
           8 |     63120.89 |       9040.96
           9 |     87866.65 |      10991.56
          10 |     77776.92 |       9275.28
          11 |    118447.83 |       9690.10
          12 |     83829.32 |       8483.35
(12 rows)
```

## WaterfallChart - [sql](dashboard/02waterfall.sql)

```sql
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
```

```sql
 year |    category     | total_profit
------+-----------------+--------------
 2019 | Technology      |     50684.26
 2019 | Office Supplies |     39736.62
 2019 | Furniture       |      3018.39
 2019 | TOTAL           |     93439.27
(4 rows)
```

Сделал через UNION, потому что нужен был максимальный результат в году по категори сверху и общее внизу. Удобно смотреть на первый результат в году и на последний. Чисто зрительная особенность восприятия. Как-нибудь я сделаю это через функцию, чтобы автоматом давать такие результаты для каждого года последовательно.

Через ROLLUP сортировка дает другой результат. 

```sql
 year |    category     | total_profit
------+-----------------+--------------
 2019 | Furniture       |    3018.3913
 2019 | Office Supplies |   39736.6217
 2019 | Technology      |   50684.2566
 2019 |                 |   93439.2696
```

## PieChart - [sql](dashboard/03piechart.sql)

```sql
SELECT
	category
	, ROUND(SUM(sales)/(SELECT SUM(sales) FROM orders WHERE year = 2019),2) * 100 AS Sales_Percent
FROM orders
WHERE year = 2019
GROUP BY category
--GROUP BY ROLLUP (category)
ORDER BY category
;
```

```sql
    category     | sales_percent
-----------------+---------------
 Furniture       |         29.00
 Office Supplies |         34.00
 Technology      |         37.00
(3 rows)
```

## MapChart - [sql](dashboard/04mapchart.sql)

```sql
SELECT
	state
	, ROUND(SUM(sales)/1000,2) AS total_sales_$k
FROM orders
WHERE year = 2019
GROUP BY state
ORDER BY state ASC
;
```

```sql
        state         | total_sales_$k
----------------------+----------------
 Alabama              |           1.83
 Arizona              |          11.13
 Arkansas             |           2.71
 California           |         146.39
 Colorado             |          10.30
 Connecticut          |           5.31
 Delaware             |          13.75
 District of Columbia |           0.08
 Florida              |          26.44
 Georgia              |          19.16
 Idaho                |           1.23
 Illinois             |          24.35
 Indiana              |          18.52
 Iowa                 |           0.72
 Kansas               |           0.73
 Kentucky             |          15.53
 Louisiana            |           5.50
 Maryland             |           9.45
 Massachusetts        |           8.14
 Michigan             |          25.83
 Minnesota            |           6.73
 Mississippi          |           3.00
 Missouri             |           9.35
 Montana              |           4.23
 Nebraska             |           3.58
 Nevada               |           3.14
 New Hampshire        |           1.51
 New Jersey           |           9.48
 New Mexico           |           2.82
 New York             |          93.92
 North Carolina       |          23.46
 North Dakota         |           0.92
 Ohio                 |          23.26
 Oklahoma             |           6.23
 Oregon               |           2.89
 Pennsylvania         |          42.69
 Rhode Island         |           3.43
 South Carolina       |           1.56
 South Dakota         |           1.15
 Tennessee            |          16.11
 Texas                |          43.42
 Utah                 |           2.46
 Vermont              |           0.84
 Virginia             |           7.60
 Washington           |          65.54
 West Virginia        |           1.21
 Wisconsin            |           5.57
(47 rows)
```

## Top5 Subcategory - [sql](dashboard/05top5.sql)

```sql
SELECT
	subcategory
	, ROUND(SUM(sales),2) AS total_sales
FROM orders
WHERE year = 2019
GROUP BY subcategory
ORDER BY total_sales DESC
LIMIT 5
;
```

```sql
 subcategory | total_sales
-------------+-------------
 Phones      |   105340.52
 Chairs      |    95554.35
 Binders     |    72788.05
 Storage     |    69677.62
 Copiers     |    62899.39
(5 rows)
```

## KPI - [sql](dashboard/06kpi.sql)

```sql
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
```


```sql
 order_month | sum_of_sales | sum_of_profit | sum_of_quantity | count_orderid | profit_margin
-------------+--------------+---------------+-----------------+---------------+---------------
           1 |     43971.37 |       7140.44 |             597 |           155 |        0.1624
           2 |     20301.13 |       1613.87 |             363 |           107 |        0.0795
           3 |     58872.35 |      14751.89 |             885 |           238 |        0.2506
           4 |     36521.54 |        933.29 |             733 |           203 |        0.0256
           5 |     44261.11 |       6342.58 |             887 |           242 |        0.1433
           6 |     52981.73 |       8223.34 |             931 |           245 |        0.1552
           7 |     45264.42 |       6952.62 |             840 |           226 |        0.1536
           8 |     63120.89 |       9040.96 |             884 |           218 |        0.1432
           9 |     87866.65 |      10991.56 |            1660 |           459 |        0.1251
          10 |     77776.92 |       9275.28 |            1133 |           298 |        0.1193
          11 |    118447.83 |       9690.10 |            1840 |           459 |        0.0818
          12 |     83829.32 |       8483.35 |            1723 |           462 |        0.1012
(12 rows)
```
## KPIYOY - [sql](dashboard/07kpiyoy.sql)

Последняя вышла интересная. На сколько выросли показатели, по сравнению с прошлым годом. 

```sql
-- growth = this year / last year - 1
-- and convert to percent

SELECT
	year,
--	ROUND(SUM(sales),2) AS Sum_of_Sales,
	ROUND(  (SUM(sales) / LAG(SUM(sales)) OVER (ORDER BY year) - 1) * 100, 2) 
		AS Sales_Grwth_prc,

--	ROUND(SUM(profit),2) AS Sum_of_Profit,
	ROUND(  (SUM(profit) / LAG(SUM(profit)) OVER (ORDER BY year) - 1) * 100, 2) 
		AS Profit_Grwth_prc,

--	SUM(quantity) AS Sum_of_Quantity,
	ROUND(  (SUM(quantity::numeric) / LAG(SUM(quantity::numeric)) OVER (ORDER BY year) - 1) * 100, 2) 
		AS Quantity_Grwth_prc,

--	count(order_id) AS Count_OrderID,
	ROUND(  (count(order_id)::numeric / LAG(count(order_id)::numeric) OVER (ORDER BY year) - 1) * 100, 2) 
		AS Orders_Grwth_prc,

--	SUM(profit)/SUM(sales) AS Profit_Margin,
	ROUND( ((SUM(profit)/SUM(sales)) / LAG(SUM(profit)/SUM(sales)) OVER (ORDER BY year) - 1) * 100, 2) 
		AS Profit_Margin_Grwth_prc

FROM orders
GROUP BY year
ORDER BY year
;
```

Оказывается в 2019 году доход на объем продаж упал на 5%. Зарабатывать стали меньше. Вот тебе и инсайт >"_"<.

```sql
 year | sales_grwth_prc | profit_grwth_prc | quantity_grwth_prc | orders_grwth_prc | profit_margin_grwth_prc
------+-----------------+------------------+--------------------+------------------+-------------------------
 2016 |                 |                  |                    |                  |
 2017 |           -2.83 |            24.37 |               5.25 |             5.47 |                   28.00
 2018 |           29.47 |            32.74 |              23.29 |            23.07 |                    2.53
 2019 |           20.36 |            14.24 |              26.83 |            28.02 |                   -5.09
(4 rows)
```


---
> [Начало](../../../README.md) >>  [Модуль 2](../README.md) >> SQL запросы для дашборда к Superstore