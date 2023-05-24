> [Начало](../../../README.md) >>  [Модуль 2](../README.md) >> SQL запросы для дашборда к Superstore

#superstore #sql #dbmodel #ERdiagram #DDL

Все рисовки и разукрашки связанные с моделями данных опираются на одну важную вещь - это сущность. Все отношения в базах данных - это отношения между этими сущностями. Другого ничего нет) Поэтому ваша задача вникнуть в то, чем является сущность и какие артибуты Вы можете этой сущности дать, а какие не стоит.

До того как писать SQL запросы в любом виде, я посмотрел просто афигенский курс [freeCodeCamp.org - Database Design Course - Learn how to design and plan a database for beginners](https://www.youtube.com/watch?v=ztHopE5Wnpc), который дает концепцию построяния этих связей (отношений) между сущностями. В общем, за всем стоят сущности.

Открывая наш текущий вид базы `superstore`, мы видим наличие только одной сущности. Одна строка = одна сущность. Выглядит такая диаграмма связей (Entity Relationship Diagram - Диаграмма связей сущностей) вот так:

![](_att/Maxthon%20Snap20230522225712.png)

`superstore` - сущность, все остальное артибуты. Сущность одна, поэтому связей пока нет xD. Вот этим мы и займемся - разобьем на несколько сущностей и построим модель.

## Entity Relationship Diagram

Или логическая модель.

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

## Концептуальная модель

Вот так будет выглядеть моя концептуальная модель - это сущности без атрибутов.

![](_att/Maxthon%20Snap20230523205302.png)

Теперь подгоняю диаграмму (логическую модель) выше под мою концептуальную модель.

![](_att/Pasted%20image%2020230524214558.png)

Я не знаю, как правильно нужно отображать связи между сущностями, поэтому совместил атрибуты, через которые будут связаны мои сущности. 

Для построения этих диаграмм я использовал инструмент [erdplus.com](https://erdplus.com) и я очень рад что его нашел, т.к. в нем нет ничего лишнего. Только сущности - атрибуты - отношения > схема > выгрузка в код.

## Relational Schema

Преобразовываю, что у меня получилось в Relational Schema (или физическая модель по уроку), и настраиваю связи между своими таблицами. Они сразу не были соединены.  Указываю типы данных в атрибутах.

![](_att/Pasted%20image%2020230524215754.png)

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
  category SERIAL NOT NULL,
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

Запускаю [SQL код](00_new_dbmodel.sql) и создаю таблицы для новой модели.

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

Смотрим что у нас вообще есть.

```sql
SELECT	COUNT(*) as all,
	COUNT(DISTINCT order_id)	as order_id,
	COUNT(DISTINCT order_date2)	as order_date2,
	COUNT(DISTINCT ship_date2)	as ship_date2,
	COUNT(DISTINCT ship_mode)	as ship_mode,
	COUNT(DISTINCT customer_id)	as customer_id,
	COUNT(DISTINCT customer_name)	as customer_name,
	COUNT(DISTINCT segment)	as segment,
	COUNT(DISTINCT country)	as country,
	COUNT(DISTINCT city)	as city,
	COUNT(DISTINCT state)	as state,
	COUNT(DISTINCT postal_code)	as postal_code
FROM orders_old
;

 all  | order_id | order_date2 | ship_date2 | ship_mode | customer_id | customer_name | segment | country | city | state | postal_code
------+----------+-------------+------------+-----------+-------------+---------------+---------+---------+------+-------+-------------
 9994 |     5009 |        1236 |       1334 |         4 |         793 |           793 |       3 |       1 |  531 |    49 |         630
(1 row)

SELECT	COUNT(DISTINCT region)	as region,
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

 region | product_id | category | subcategory | product_name | sales | quantity | discount | profit
--------+------------+----------+-------------+--------------+-------+----------+----------+--------
      4 |       1862 |        3 |          17 |         1850 |  5825 |       14 |       12 |   7287
(1 row)

```



#### Заполнение `ship_modes`

Самая простая таблица в виду всего нескольких строк.




DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
~~DROP TABLE IF EXISTS ship_modes;~~
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS delivery_places;
DROP TABLE IF EXISTS order_details;

---



