-- Active: 1702301134289@@172.20.44.2@5432@contoso2

CREATE TABLE dim_accounts
(
  account_key INT NOT NULL,
  parent_account_key REAL NOT NULL,
  account_name VARCHAR(70) NOT NULL,
  account_description VARCHAR(70),
  account_type VARCHAR(30),
  value_type VARCHAR(30),
  PRIMARY KEY (account_key)
);

CREATE TABLE dim_channels
(
  channel_key INT NOT NULL,
  channel_name VARCHAR(30) NOT NULL,
  channel_description VARCHAR(50) NOT NULL,
  PRIMARY KEY (channel_key)
);

CREATE TABLE dim_currencies
(
  currency_key INT NOT NULL,
  currency_name VARCHAR(10) NOT NULL,
  currency_description VARCHAR(40) NOT NULL,
  PRIMARY KEY (currency_key)
);

CREATE TABLE calendar
(
  date_key DATE NOT NULL,
  calendar_year INT NOT NULL,
  calendar_year_label VARCHAR(20) NOT NULL,
  calendar_half_year_label VARCHAR(10) NOT NULL,
  calendar_quarter_label VARCHAR(10) NOT NULL,
  calendar_month_label VARCHAR(20) NOT NULL,
  calendar_week_label VARCHAR(20) NOT NULL,
  calendar_day_of_week_label VARCHAR(20) NOT NULL,
  fiscal_year INT NOT NULL,
  fiscal_year_label VARCHAR(20) NOT NULL,
  fiscal_half_year_label VARCHAR(10) NOT NULL,
  fiscal_quarter_label VARCHAR(10) NOT NULL,
  fiscal_month_label VARCHAR(20) NOT NULL,
  is_work_day VARCHAR(10) NOT NULL,
  is_holiday VARCHAR(10) NOT NULL,
  europe_season VARCHAR(30) NOT NULL,
  north_america_season VARCHAR(30) NOT NULL,
  asia_season VARCHAR(30) NOT NULL,
  month_number INT NOT NULL,
  calendar_day_of_week_number INT NOT NULL,
  PRIMARY KEY (date_key)
);

CREATE TABLE dim_employees
(
  employee_key INT NOT NULL,
  parent_employee_key INT,
  first_name VARCHAR(30) NOT NULL,
  last_name VARCHAR(30) NOT NULL,
  title VARCHAR(50),
  hire_date DATE NOT NULL,
  birth_date DATE NOT NULL,
  email_address VARCHAR(60) NOT NULL,
  phone VARCHAR(20) NOT NULL,
  emergency_contact_name VARCHAR(40),
  emergency_contact_phone VARCHAR(20),
  gender VARCHAR(10) NOT NULL,
  pay_frequency INT,
  base_rate NUMERIC(5,2) NOT NULL CHECK (base_rate >= 0),
  vacation_hours INT,
  department_name VARCHAR(40),
  start_date DATE,
  status VARCHAR(20) NOT NULL,
  salary_status VARCHAR(20) NOT NULL,
  is_sales_person VARCHAR(10) NOT NULL,
  is_married VARCHAR(10),
  PRIMARY KEY (employee_key)
);

CREATE TABLE dim_entities
(
  entity_key INT NOT NULL,
  parent_entity_key INT NOT NULL,
  parent_entity_label VARCHAR(40) NOT NULL,
  entity_name VARCHAR(40) NOT NULL,
  entity_description VARCHAR(40) NOT NULL,
  entity_type VARCHAR(20) NOT NULL,
  start_date TIMESTAMP NOT NULL,
  status VARCHAR(20) NOT NULL,
  PRIMARY KEY (entity_key)
);

CREATE TABLE dim_geography
(
  geography_key INT NOT NULL,
  geography_type VARCHAR(20) NOT NULL,
  continent_name VARCHAR(20) NOT NULL,
  city_name VARCHAR(30),
  state_province_name VARCHAR(50),
  region_country_name VARCHAR(30),
  PRIMARY KEY (geography_key)
);

CREATE TABLE dim_machines
(
  machine_key INT NOT NULL,
  store_key INT NOT NULL,
  machine_type VARCHAR(30) NOT NULL,
  machine_name VARCHAR(100) NOT NULL,
  machine_description VARCHAR(150) NOT NULL,
  vendor_name VARCHAR(40) NOT NULL,
  machine_os VARCHAR(40) NOT NULL,
  machine_source VARCHAR(30) NOT NULL,
  machine_hardware VARCHAR(150) NOT NULL,
  machine_software VARCHAR(150) NOT NULL,
  status VARCHAR(20) NOT NULL,
  service_start_date TIMESTAMP NOT NULL,
  decommission_date TIMESTAMP NOT NULL,
  last_modified_date TIMESTAMP NOT NULL,
  PRIMARY KEY (machine_key)
);

CREATE TABLE dim_outages
(
  outage_key INT NOT NULL,
  outage_name VARCHAR(30) NOT NULL,
  outage_type VARCHAR(40) NOT NULL,
  outage_type_description VARCHAR(60) NOT NULL,
  outage_sub_type VARCHAR(50) NOT NULL,
  PRIMARY KEY (outage_key)
);

CREATE TABLE dim_products_categories
(
  product_category_key INT NOT NULL,
  product_category_name VARCHAR(50) NOT NULL,
  PRIMARY KEY (product_category_key)
);

CREATE TABLE dim_products_subcategories
(
  product_subcategory_key INT NOT NULL,
  product_subcategory_name VARCHAR(50) NOT NULL,
  product_category_key INT NOT NULL,
  PRIMARY KEY (product_subcategory_key),
  FOREIGN KEY (product_category_key) REFERENCES dim_products_categories(product_category_key)
);

CREATE TABLE dim_promotions
(
  promotion_key INT NOT NULL,
  promotion_name VARCHAR(70) NOT NULL,
  discount_percent REAL NOT NULL,
  promotion_type VARCHAR(40) NOT NULL,
  promotion_category VARCHAR(30) NOT NULL,
  PRIMARY KEY (promotion_key)
);

CREATE TABLE dim_sales_territories
(
  sales_territory_key INT NOT NULL,
  sales_territory_name VARCHAR(30) NOT NULL,
  sales_territory_region VARCHAR(30) NOT NULL,
  sales_territory_country VARCHAR(40) NOT NULL,
  sales_territory_group VARCHAR(30) NOT NULL,
  sales_territory_level INT NOT NULL,
  sales_territory_manager INT NOT NULL,
  status VARCHAR(20) NOT NULL,
  geography_key INT NOT NULL,
  employee_key INT NOT NULL,
  PRIMARY KEY (sales_territory_key),
  FOREIGN KEY (geography_key) REFERENCES dim_geography(geography_key),
  FOREIGN KEY (employee_key) REFERENCES dim_employees(employee_key)
);

CREATE TABLE dim_scenarios
(
  scenario_key INT NOT NULL,
  scenario_name VARCHAR(20) NOT NULL,
  PRIMARY KEY (scenario_key)
);

CREATE TABLE dim_stores
(
  store_key INT NOT NULL,
  geography_key INT NOT NULL,
  store_manager INT NOT NULL,
  store_type VARCHAR(20) NOT NULL,
  store_name VARCHAR(40) NOT NULL,
  status VARCHAR(20) NOT NULL,
  open_date DATE NOT NULL,
  close_date DATE NOT NULL,
  entity_key INT NOT NULL,
  store_phone VARCHAR(20) NOT NULL,
  store_fax VARCHAR(20) NOT NULL,
  close_reason VARCHAR(40) NOT NULL,
  employee_count INT NOT NULL,
  selling_area_size INT NOT NULL,
  last_remodel_date TIMESTAMP NOT NULL,
  employee_key INT NOT NULL,
  PRIMARY KEY (store_key)
);

CREATE TABLE fact_exchange_rates
(
  exchange_rate_key INT NOT NULL,
  average_rate NUMERIC(8,2),
  end_of_day_rate NUMERIC(8,2),
  currency_key INT NOT NULL,
  date_key DATE NOT NULL,
  PRIMARY KEY (exchange_rate_key),
  FOREIGN KEY (currency_key) REFERENCES dim_currencies(currency_key),
  FOREIGN KEY (date_key) REFERENCES calendar(date_key)
);

CREATE TABLE fact_it_machines
(
  it_machine_key INT NOT NULL,
  cost_amount NUMERIC(8,2) NOT NULL,
  cost_type VARCHAR(40) NOT NULL,
  machine_key INT NOT NULL,
  date_key DATE NOT NULL,
  PRIMARY KEY (it_machine_key),
  FOREIGN KEY (machine_key) REFERENCES dim_machines(machine_key),
  FOREIGN KEY (date_key) REFERENCES calendar(date_key)
);

CREATE TABLE fact_itsla
(
  itsla_key INT NOT NULL,
  outage_start_time TIMESTAMP NOT NULL,
  outage_end_time TIMESTAMP,
  down_time INT NOT NULL,
  date_key DATE NOT NULL,
  store_key INT NOT NULL,
  machine_key INT NOT NULL,
  outage_key INT NOT NULL,
  PRIMARY KEY (itsla_key),
  FOREIGN KEY (date_key) REFERENCES calendar(date_key),
  FOREIGN KEY (store_key) REFERENCES dim_stores(store_key),
  FOREIGN KEY (machine_key) REFERENCES dim_machines(machine_key),
  FOREIGN KEY (outage_key) REFERENCES dim_outages(outage_key)
);

CREATE TABLE fact_strategy_plan
(
  strategy_plan_key INT NOT NULL,
  amount NUMERIC(11,2) NOT NULL,
  date_key DATE NOT NULL,
  entity_key INT NOT NULL,
  account_key INT NOT NULL,
  scenario_key INT NOT NULL,
  currency_key INT NOT NULL,
  product_category_key INT NOT NULL,
  PRIMARY KEY (strategy_plan_key),
  FOREIGN KEY (date_key) REFERENCES calendar(date_key),
  FOREIGN KEY (entity_key) REFERENCES dim_entities(entity_key),
  FOREIGN KEY (account_key) REFERENCES dim_accounts(account_key),
  FOREIGN KEY (scenario_key) REFERENCES dim_scenarios(scenario_key),
  FOREIGN KEY (currency_key) REFERENCES dim_currencies(currency_key),
  FOREIGN KEY (product_category_key) REFERENCES dim_products_categories(product_category_key)
);

--DROP TABLE IF EXISTS dim_customers;
CREATE TABLE dim_customers
(
  row_num INT NOT NULL,
  customer_key INT NOT NULL,
  first_name VARCHAR(40) NOT NULL,
  last_name VARCHAR(40) NOT NULL,
  birth_date DATE,
  marital_status VARCHAR(10),
  gender VARCHAR(10) NOT NULL,
  yearly_income NUMERIC(10,2),
  total_children NUMERIC(4,2),
  number_children_at_home NUMERIC(4,2),
  education VARCHAR(30),
  occupation VARCHAR(40),
  house_owner_flag NUMERIC(4,2),
  number_cars_owned NUMERIC(4,2),
  geography_key INT NOT NULL,
  PRIMARY KEY (customer_key),
  FOREIGN KEY (geography_key) REFERENCES dim_geography(geography_key)
);

CREATE TABLE dim_products
(
  product_key INT NOT NULL,
  product_name VARCHAR(150) NOT NULL,
  product_description VARCHAR(256) NOT NULL,
  manufacturer VARCHAR(40) NOT NULL,
  brand_name VARCHAR(30) NOT NULL,
  class_id INT NOT NULL,
  class_name VARCHAR(40) NOT NULL,
  style_id INT NOT NULL,
  style_name VARCHAR(40) NOT NULL,
  color_id INT NOT NULL,
  color_name VARCHAR(20) NOT NULL,
  weight NUMERIC(6,2) NOT NULL,
  weight_unit_measure_id VARCHAR(20) NOT NULL,
  unit_of_measure_id INT NOT NULL,
  unit_of_measure_name VARCHAR(20) NOT NULL,
  stock_type_id INT NOT NULL,
  stock_type_name VARCHAR(40) NOT NULL,
  unit_cost NUMERIC(9,2) NOT NULL CHECK (unit_cost >= 0),
  unit_price NUMERIC(9,2) NOT NULL CHECK (unit_price >= 0),
  available_for_sale_date DATE,
  status VARCHAR(20) NOT NULL,
  product_subcategory_key INT NOT NULL,
  PRIMARY KEY (product_key),
  FOREIGN KEY (product_subcategory_key) REFERENCES dim_products_subcategories(product_subcategory_key)
);

CREATE TABLE fact_inventory
(
  inventory_key INT NOT NULL,
  on_hand_quantity INT NOT NULL,
  on_order_quantity INT NOT NULL,
  safety_stock_quantity INT,
  unit_cost NUMERIC(9,2) NOT NULL,
  days_in_stock INT,
  min_day_in_stock INT,
  max_day_in_stock INT,
  aging INT,
  date_key DATE NOT NULL,
  store_key INT NOT NULL,
  product_key INT NOT NULL,
  currency_key INT NOT NULL,
  PRIMARY KEY (inventory_key),
  FOREIGN KEY (date_key) REFERENCES calendar(date_key),
  FOREIGN KEY (store_key) REFERENCES dim_stores(store_key),
  --FOREIGN KEY (product_key) REFERENCES dim_products(product_key),
  FOREIGN KEY (currency_key) REFERENCES dim_currencies(currency_key)
);

CREATE TABLE fact_online_sales
(
  online_sales_key INT NOT NULL,
  sales_order_number VARCHAR(20) NOT NULL,
  sales_order_line_number INT NOT NULL,
  sales_quantity INT NOT NULL,
  sales_amount NUMERIC(9,2) NOT NULL CHECK (sales_amount >= 0),
  return_quantity INT,
  return_amount NUMERIC(8,2),
  discount_quantity INT,
  discount_amount NUMERIC(8,2),
  total_cost NUMERIC(9,2) NOT NULL,
  unit_cost NUMERIC(9,2) NOT NULL CHECK (unit_cost >= 0),
  unit_price NUMERIC(9,2) NOT NULL CHECK (unit_price >= 0),
  date_key DATE NOT NULL,
  store_key INT NOT NULL,
  product_key INT NOT NULL,
  promotion_key INT,
  currency_key INT NOT NULL,
  customer_key INT NOT NULL,
  PRIMARY KEY (online_sales_key),
  FOREIGN KEY (date_key) REFERENCES calendar(date_key),
  FOREIGN KEY (store_key) REFERENCES dim_stores(store_key),
  --FOREIGN KEY (product_key) REFERENCES dim_products(product_key),
  FOREIGN KEY (promotion_key) REFERENCES dim_promotions(promotion_key),
  FOREIGN KEY (currency_key) REFERENCES dim_currencies(currency_key),
  FOREIGN KEY (customer_key) REFERENCES dim_customers(customer_key)
);

CREATE TABLE fact_sales
(
  sales_key BIGINT NOT NULL,
  unit_cost NUMERIC(9,2) NOT NULL,
  unit_price NUMERIC(9,2) NOT NULL,
  sales_quantity INT NOT NULL,
  return_quantity	 INT NOT NULL,
  return_amount NUMERIC(9,2) NOT NULL,
  discount_quantity INT NOT NULL,
  discount_amount NUMERIC(9,2) NOT NULL,
  total_cost NUMERIC(9,2) NOT NULL,
  sales_amount NUMERIC(11,2) NOT NULL,
  store_key INT NOT NULL,
  product_key INT NOT NULL,
  date_key DATE NOT NULL,
  channel_key INT NOT NULL,
  currency_key INT NOT NULL,
  promotion_key INT,
  PRIMARY KEY (sales_key),
  FOREIGN KEY (store_key) REFERENCES dim_stores(store_key),
  --FOREIGN KEY (product_key) REFERENCES dim_products(product_key),
  FOREIGN KEY (date_key) REFERENCES calendar(date_key),
  FOREIGN KEY (channel_key) REFERENCES dim_channels(channel_key),
  FOREIGN KEY (currency_key) REFERENCES dim_currencies(currency_key),
  FOREIGN KEY (promotion_key) REFERENCES dim_promotions(promotion_key)
);

CREATE TABLE fact_sales_quota
(
  sales_quota_key INT NOT NULL,
  sales_quantity_quota NUMERIC(9,2) NOT NULL,
  sales_amount_quota NUMERIC(9,2) NOT NULL,
  gross_margin_quota NUMERIC(9,2) NOT NULL,
  store_key INT NOT NULL,
  channel_key INT NOT NULL,
  product_key INT NOT NULL,
  date_key DATE NOT NULL,
  currency_key INT NOT NULL,
  scenario_key INT NOT NULL,
  PRIMARY KEY (sales_quota_key),
  FOREIGN KEY (store_key) REFERENCES dim_stores(store_key),
  FOREIGN KEY (channel_key) REFERENCES dim_channels(channel_key),
  --FOREIGN KEY (product_key) REFERENCES dim_products(product_key),
  FOREIGN KEY (date_key) REFERENCES calendar(date_key),
  FOREIGN KEY (currency_key) REFERENCES dim_currencies(currency_key),
  FOREIGN KEY (scenario_key) REFERENCES dim_scenarios(scenario_key)
);