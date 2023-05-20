-- imported order date is text column
-- better way to create new column for future calculating

ALTER TABLE orders
ADD COLUMN order_date2 DATE;

ALTER TABLE orders
ADD COLUMN year INTEGER;

UPDATE orders SET order_date2 = to_date(order_date, 'DD.MM.YYYY');
UPDATE orders SET year =  EXTRACT(year FROM order_date2);
