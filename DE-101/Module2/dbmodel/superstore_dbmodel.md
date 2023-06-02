> [Начало](../../../README.md) >>  [Модуль 2](../README.md) >> Создание модели данных

#superstore #sql #dbmodel #erdiagram #schema

Все рисовки и разукрашки связанные с моделями данных опираются на одну важную вещь - это сущность. Все отношения в базах данных - это отношения между этими сущностями. Другого ничего нет) Поэтому ваша задача вникнуть в то, чем является сущность и какие артибуты Вы можете этой сущности дать, а какие не стоит.

До того как писать SQL запросы в любом виде, я посмотрел просто афигенский курс [freeCodeCamp.org - Database Design Course - Learn how to design and plan a database for beginners](https://www.youtube.com/watch?v=ztHopE5Wnpc), который дает концепцию построяния этих связей (отношений) между сущностями. В общем, за всем стоят сущности.

Открывая наш текущий вид базы `superstore`, мы видим наличие только одной сущности. Одна строка = одна запись этой сущности. Выглядит такая диаграмма связей (Entity Relationship Diagram - Диаграмма связей сущностей) вот так:

![](_att/Maxthon%20Snap20230522225712.png)

`superstore` - сущность, все остальное артибуты. Сущность одна, поэтому связей пока нет xD. Вот этим мы и займемся - разобьем на несколько сущностей и построим модель.

В разных источниках границы терминов концептуальная, логическая, физическая модели слегка размыты. Это как со словом `condition`, что одновременно означает `состояние` и `условие`. В курсе от DataCamp есть вот такая трактовка со ссылкой на Википедию, её я и буду использовать в дальнейшем.

![](_att/Pasted%20image%2020230526215658.png)

![](_att/Pasted%20image%2020230527103632.png)

## Conceptual Data Model. Entity Relationship Diagram

Разбиваю все имеющиеся атрибуты в таблице на группы. 

![](_att/Pasted%20image%2020230522234203.png)

У меня получилось 6 групп (по часовой стрелке):

- заказы, orders
- виды доставок, ship_mode
- клиент, customer
- куда отправлять заказ, delivery_place
- продукт, product
- информация по заказу, order_datails

Для каждой группы теперь делаю свою сущность. Это промежуточный вариант.

![](_att/Maxthon%20Snap20230523202350.png)

От колонки `row_id` буду избавлятся, потому что она мне не дает ничего. В новой таблице `orders` уникальным полем будет `order_id`, а второе уникальное просто безсмысленно. 

Вот так будет выглядеть моя модель, если я спрячу атрибуты. В терминологии Лекции 2-4 её называли концептуальной моделью.

![](_att/Maxthon%20Snap20230523205302.png)

Теперь подгоняю диаграмму выше под эту модель.

![](_att/Pasted%20image%2020230524214558.png)

Я не знаю, как правильно нужно отображать связи между сущностями[^1], поэтому совместил атрибуты (колонки), через которые будут связаны мои сущности. 

Для построения этих диаграмм я использовал инструмент [erdplus.com](https://erdplus.com) и я очень рад что его нашел, т.к. в нем нет ничего лишнего. Только сущности - атрибуты - отношения > схема > выгрузка в код.

## Logical Data Model. Relational Schema

Преобразовываю, что у меня получилось, в Relational Schema, и настраиваю связи между своими таблицами. Они сразу не были соединены.  

![](_att/Pasted%20image%2020230524215754.png)

Указываю типы данных в атрибутах. Пример для `orders`.

![](_att/Pasted%20image%2020230527104129.png)

Генерирую [SQL код](00_new_dbmodel.sql) после завершения строительства всех связей. Добавил еще в начале для всех таблиц `DROP TABLE IF EXISTS`.

```sql
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS ship_modes;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS delivery_places;
DROP TABLE IF EXISTS order_details;

CREATE TABLE products
(
  product_id VARCHAR(20) NOT NULL,
  category VARCHAR(40) NOT NULL,
  subcategory VARCHAR(40) NOT NULL,
  product_name VARCHAR(250) NOT NULL,
  PRIMARY KEY (product_id)
);

CREATE TABLE ship_modes
(
  ship_mode VARCHAR(14) NOT NULL,
  ship_mode_id SERIAL NOT NULL,
  PRIMARY KEY (ship_mode_id)
);

CREATE TABLE customers
(
  customer_id VARCHAR(10) NOT NULL,
  customer_name VARCHAR(30) NOT NULL,
  segment VARCHAR(15) NOT NULL,
  PRIMARY KEY (customer_id)
);

CREATE TABLE delivery_places
(
  country VARCHAR(30) NOT NULL,
  city VARCHAR(30) NOT NULL,
  state VARCHAR(30) NOT NULL,
  postal_code VARCHAR(30) NOT NULL,
  region VARCHAR(10) NOT NULL,
  delivery_place_id SERIAL NOT NULL,
  PRIMARY KEY (delivery_place_id)
);

CREATE TABLE orders
(
  order_id VARCHAR(14) NOT NULL,
  order_date DATE NOT NULL,
  ship_date DATE NOT NULL,
  customer_id VARCHAR(10) NOT NULL,
  delivery_place_id SERIAL NOT NULL,
  ship_mode_id SERIAL NOT NULL,
  PRIMARY KEY (order_id),
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  FOREIGN KEY (delivery_place_id) REFERENCES delivery_places(delivery_place_id),
  FOREIGN KEY (ship_mode_id) REFERENCES ship_modes(ship_mode_id)
);

CREATE TABLE order_details
(
  sales NUMERIC NOT NULL,
  quantity INT NOT NULL,
  discount NUMERIC NOT NULL,
  profit NUMERIC NOT NULL,
  product_id VARCHAR(20) NOT NULL,
  order_id VARCHAR(14) NOT NULL,
  FOREIGN KEY (product_id) REFERENCES products(product_id),
  FOREIGN KEY (order_id) REFERENCES orders(order_id)
);
```

## Создание таблиц для новой модели

В новой модели я создал новую таблицу `orders` и она будет конфликтовать с уже имеющейся. Удаляю текущую таблицу в базе, создаю `orders_old`, делаю снова импорт из csv, преобразовываю колонки дат в тип `DATE`.


```sql
DROP TABLE IF EXISTS orders;

CREATE TABLE orders_old (
id serial,
order_id varchar(14),
order_date varchar(10),
ship_date varchar(10),
ship_mode varchar(14),
customer_id varchar(10),
customer_name varchar(30),
segment varchar(15),
country varchar(30),
city varchar(30),
state varchar(30),
postal_code varchar(30),
region varchar(10),
product_id varchar(20),
category varchar(20),
subcategory varchar(20),
product_name varchar(200),
sales numeric,
quantity int,
discount numeric,
profit numeric
);

COPY orders_old(id,order_id,order_date,ship_date,ship_mode,customer_id,customer_name,segment,country,city,state,postal_code,region,product_id,category,subcategory,product_name,sales,quantity,discount,profit)
FROM '/mnt/d/git/DataLearnDE/DE-101/Module2/SQL/Source/orders.csv'
DELIMITER ';'
CSV HEADER;

ALTER TABLE orders_old
ADD COLUMN order_date2 DATE;
UPDATE orders_old SET order_date2 = to_date(order_date, 'DD.MM.YYYY');

ALTER TABLE orders_old
ADD COLUMN ship_date2 DATE;
UPDATE orders_old SET ship_date2 = to_date(ship_date, 'DD.MM.YYYY');
```

Запускаю ранее сгенерированный [код](00_new_dbmodel.sql) и создаю таблицы для новой модели. Итого.

```sql
superstore=> \d
                          List of relations
 Schema |                 Name                  |   Type   |  Owner
--------+---------------------------------------+----------+---------
 public | customers                             | table    | useraik
 public | delivery_places                       | table    | useraik
 public | delivery_places_delivery_place_id_seq | sequence | useraik
 public | order_details                         | table    | useraik
 public | orders                                | table    | useraik
 public | orders_delivery_place_id_seq          | sequence | useraik
 public | orders_old                            | table    | useraik
 public | orders_old_id_seq                     | sequence | useraik
 public | orders_ship_mode_id_seq               | sequence | useraik
 public | people                                | table    | useraik
 public | products                              | table    | useraik
 public | products_category_seq                 | sequence | useraik
 public | returns                               | table    | useraik
 public | ship_modes                            | table    | useraik
 public | ship_modes_ship_mode_id_seq           | sequence | useraik
(15 rows)
```

## Заполнение новых таблиц

Начинаю с конечных таблиц, которые не пересекаются, в них первичные ключи. Если добавлять сразу строки в таблицу фактов по типу `orders`, то не получится это сделать, потому что нет соответствующего значения в справочнике (например, `customers`).

Смотрим что у нас вообще есть. Это поможет проводить сверку в итоге.

```sql
SELECT	COUNT(*) as all,
	COUNT(DISTINCT order_id)	as order_id,
	COUNT(DISTINCT order_date2)	as order_date2,
	COUNT(DISTINCT ship_date2)	as ship_date2,
	COUNT(DISTINCT customer_id)	as customer_id,
	COUNT(DISTINCT customer_name)	as customer_name,
	COUNT(DISTINCT segment)	as segment,
	COUNT(DISTINCT country)	as country,
	COUNT(DISTINCT city)	as city,
	COUNT(DISTINCT state)	as state,
	COUNT(DISTINCT postal_code)	as postal_code
FROM orders_old
;

 all  | order_id | order_date2 | ship_date2 | customer_id | customer_name | segment | country | city | state | postal_code
------+----------+-------------+------------+-------------+---------------+---------+---------+------+-------+-------------
 9994 |     5009 |        1236 |       1334 |         793 |           793 |       3 |       1 |  531 |    49 |         630
(1 row)

SELECT 	COUNT(DISTINCT ship_mode)	as ship_mode,	
	COUNT(DISTINCT region)	as region,
	COUNT(DISTINCT product_id)	as product_id,
	COUNT(DISTINCT category)	as category,
	COUNT(DISTINCT subcategory)	as subcategory,
	COUNT(DISTINCT product_name)	as product_name,
	COUNT(DISTINCT sales)	as sales,
	COUNT(DISTINCT quantity)	as quantity,
	COUNT(DISTINCT discount)	as discount,
	COUNT(DISTINCT profit)	as profit
FROM orders_old
;

 ship_mode | region | product_id | category | subcategory | product_name | sales | quantity | discount | profit
-----------+--------+------------+----------+-------------+--------------+-------+----------+----------+--------
         4 |      4 |       1862 |        3 |          17 |         1850 |  5825 |       14 |       12 |   7287
(1 row)

```



#### Заполнение `ship_modes`

Самая простая таблица в виду всего нескольких строк.

```sql
INSERT INTO ship_modes
SELECT DISTINCT ship_mode
FROM orders_old
;
```

```sql
INSERT 0 4

superstore=> SELECT * FROM ship_modes;
   ship_mode    | ship_mode_id
----------------+--------------
 Standard Class |            1
 Second Class   |            2
 First Class    |            3
 Same Day       |            4
(4 rows)
```

`ship_mode_id` генерируется автоматически, т.к. это последовательность `SERIAL`.

#### Заполнение `products`

И получаем первый попадос, потому что данные у нас не чистые)).

```sql
INSERT INTO products
SELECT DISTINCT product_id, category, subcategory, product_name
FROM orders_old
;
```

```sql
ERROR:  duplicate key value violates unique constraint "products_pkey"
DETAIL:  Key (product_id)=(TEC-PH-10002200) already exists.
```

```sql
SELECT DISTINCT product_id, category, subcategory, product_name
FROM orders_old
WHERE product_id = 'TEC-PH-10002200'
;
```

```sql
   product_id    |  category  | subcategory |            product_name
-----------------+------------+-------------+-------------------------------------
 TEC-PH-10002200 | Technology | Phones      | Aastra 6757i CT Wireless VoIP phone
 TEC-PH-10002200 | Technology | Phones      | Samsung Galaxy Note 2
(2 rows)
```

У нас дубликаты есть в `product_id`. Находим все дубликаты.

```sql
SELECT product_id, COUNT(*)
FROM (
	SELECT DISTINCT product_id, product_name
	FROM orders_old
	GROUP BY product_id, product_name 
	ORDER BY product_id
	) AS o
GROUP BY product_id
HAVING COUNT(*) > 1
;
```

```sql
   product_id    | count
-----------------+-------
 FUR-BO-10002213 |     2
 FUR-CH-10001146 |     2
 FUR-FU-10001473 |     2
 FUR-FU-10004017 |     2
 FUR-FU-10004091 |     2
 FUR-FU-10004270 |     2
 FUR-FU-10004848 |     2
 FUR-FU-10004864 |     2
 OFF-AP-10000576 |     2
 OFF-AR-10001149 |     2
 OFF-BI-10002026 |     2
 OFF-BI-10004632 |     2
 OFF-BI-10004654 |     2
 OFF-PA-10000357 |     2
 OFF-PA-10000477 |     2
 OFF-PA-10000659 |     2
 OFF-PA-10001166 |     2
 OFF-PA-10001970 |     2
 OFF-PA-10002195 |     2
 OFF-PA-10002377 |     2
 OFF-PA-10003022 |     2
 OFF-ST-10001228 |     2
 OFF-ST-10004950 |     2
 TEC-AC-10002049 |     2
 TEC-AC-10002550 |     2
 TEC-AC-10003832 |     2
 TEC-MA-10001148 |     2
 TEC-PH-10001530 |     2
 TEC-PH-10001795 |     2
 TEC-PH-10002200 |     2
 TEC-PH-10002310 |     2
 TEC-PH-10004531 |     2
(32 rows)
```

Исправляем данные. Я это делал ручками, полный код [тут](01_datamigration.sql). И продолжаем заполнение.

```sql
INSERT INTO products
SELECT DISTINCT product_id, category, subcategory, product_name
FROM orders_old
;
```

Сверка с источником.

```sql
INSERT 0 1894

superstore=> SELECT COUNT(DISTINCT product_id) AS product_id
FROM products
;

 product_id
------------
       1894
(1 row)
```

#### Заполнение `customers`

```sql
INSERT INTO customers
SELECT DISTINCT customer_id, customer_name, segment
FROM orders_old
;
```

#### Заполнение `delivery_places`

В одном адресе почтового индекса не оказалось, я его обновил своим значением. Хотя, наверное, правильно было бы снять ограничение NOT NULL, но не факт)).

```sql
UPDATE orders_old
SET postal_code = '12345'
WHERE country = 'United States' AND
	city = 'Burlington' AND state = 'Vermont';

INSERT INTO delivery_places
SELECT DISTINCT country, city, state, postal_code, region
FROM orders_old
;
```

#### Заполнение `orders`

Если с id'шниками клиентов все нормально, то id'шники доставок нам не доступны изначально в таблице `orders_old`. Надо их присоединять.

```sql
INSERT INTO orders
SELECT DISTINCT oo.order_id 
		, oo.order_date2 AS order_date
		, oo.ship_date2 AS ship_date
		, oo.customer_id 
		, s1.delivery_place_id
		, s2.ship_mode_id
FROM orders_old AS oo
LEFT JOIN delivery_places AS s1 
	ON oo.country = s1.country 
		AND oo.city = s1.city 
		AND oo.state = s1.state 
		AND oo.postal_code = s1.postal_code 
LEFT JOIN ship_modes AS s2 
	USING(ship_mode)
;
```

```sql
INSERT 0 5009
```

#### Заполнение `orders`

Забавно вышло, но для такой вставки надо было таблицу подготовить с такой последовательностью полей, ровно как в новой созданной. Поэтому `order_id` и `product_id` аж в самом конце.

```sql
superstore=> \d order_details
                    Table "public.order_details"
   Column   |         Type          | Collation | Nullable | Default
------------+-----------------------+-----------+----------+---------
 sales      | numeric               |           | not null |
 quantity   | integer               |           | not null |
 discount   | numeric               |           | not null |
 profit     | numeric               |           | not null |
 product_id | character varying(20) |           | not null |
 order_id   | character varying(14) |           | not null |
Foreign-key constraints:
    "order_details_order_id_fkey" FOREIGN KEY (order_id) REFERENCES orders(order_id)
    "order_details_product_id_fkey" FOREIGN KEY (product_id) REFERENCES products(product_id)
```

```sql
INSERT INTO order_details
SELECT 	sales
	, quantity 
	, discount 
	, profit 
	, product_id
	, order_id
FROM orders_old
;
```

```sql
INSERT 0 9994
```

Позже оказалось, что можно явно указать названия столбцов в `INSERT INTO` и писать в удобной для себя последовательности.

```sql
INSERT INTO order_details
	(order_id, product_id, sales, quantity, discount, profit)
SELECT 	order_id
	, product_id
	, sales
	, quantity 
	, discount 
	, profit 
FROM orders_old
;
```

**Готово**. Теперь все новые таблицы заполнены и `orders_old` можно дропать за ненадобностью ;).

[^1]: Но обязательно это выясню и буду применять ^.^

---

> [Начало](../../../README.md) >>  [Модуль 2](../README.md) >> Создание модели данных

