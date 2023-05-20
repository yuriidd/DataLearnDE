-- import csv orders

COPY orders(id,order_id,order_date,ship_date,ship_mode,customer_id,customer_name,segment,country,city,state,postal_code,region,product_id,category,subcategory,product_name,sales,quantity,discount,profit)
FROM '/mnt/d/git/DataLearnDE/DE-101/Module2/SQL/Source/orders.csv'
DELIMITER ';'
CSV HEADER;

-- import csv people

COPY people(person,region)
FROM '/mnt/d/git/DataLearnDE/DE-101/Module2/SQL/Source/people.csv'
DELIMITER ';'
CSV HEADER;

-- import csv returns

COPY returns(returned,order_id)
FROM '/mnt/d/git/DataLearnDE/DE-101/Module2/SQL/Source/returns.csv'
DELIMITER ';'
CSV HEADER;




