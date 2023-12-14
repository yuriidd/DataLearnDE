--COPY summer(year,city,sport,discipline,athlete,country,gender,event,medal)
--FROM '/summer.csv'
--DELIMITER ','
--CSV HEADER;



COPY dim_accounts (
account_key 		,
parent_account_key 	,
account_name 		,
account_description 	,
account_type 		,
value_type 		) 
FROM '/mnt/d/sql/source/CleanedContosoDataset/CleanedContosoDataset_CSV/DimAccount.csv' DELIMITER ',' CSV HEADER;



COPY dim_channels (
channel_key,
channel_name,
channel_description ) 
FROM '/mnt/d/sql/source/CleanedContosoDataset/CleanedContosoDataset_CSV/DimChannel.csv' DELIMITER ',' CSV HEADER;



COPY dim_currencies (
currency_key 		,
currency_name 		,
currency_description 	)
FROM '/mnt/d/sql/source/CleanedContosoDataset/CleanedContosoDataset_CSV/DimCurrency.csv' DELIMITER ',' CSV HEADER;


COPY calendar (
date_key			,
calendar_year			,
calendar_year_label 		,
calendar_half_year_label	,
calendar_quarter_label		,
calendar_month_label		,
calendar_week_label		,
calendar_day_of_week_label	,
fiscal_year			,
fiscal_year_label 		,
fiscal_half_year_label		,
fiscal_quarter_label		,
fiscal_month_label		,
is_work_day			,
is_holiday			,
europe_season			,
north_america_season		,
asia_season			,
month_number			,
calendar_day_of_week_number	)
FROM '/mnt/d/sql/source/CleanedContosoDataset/CleanedContosoDataset_CSV/DimDate.csv' DELIMITER ',' CSV HEADER;


COPY dim_employees (
employee_key		,
parent_employee_key	,
first_name		,
last_name		,
title			,
hire_date		,
birth_date		,
email_address		,
phone			,
emergency_contact_name	,
emergency_contact_phone	,
gender			,
pay_frequency		,		-- ???
base_rate		,
vacation_hours		,
department_name		,
start_date		,
status			,
salary_status		,
is_sales_person		,
is_married		)
FROM '/mnt/d/sql/source/CleanedContosoDataset/CleanedContosoDataset_CSV/DimEmployee.csv' DELIMITER ',' CSV HEADER;


COPY dim_entities (
entity_key		,
parent_entity_key	,
parent_entity_label	,
entity_name		,
entity_description	,
entity_type		,
start_date 		,
status			)
FROM '/mnt/d/sql/source/CleanedContosoDataset/CleanedContosoDataset_CSV/DimEntity.csv' DELIMITER ',' CSV HEADER;



COPY dim_geography (
geography_key	,
geography_type	,
continent_name	,
city_name	,
state_province_name	,
region_country_name	)
FROM '/mnt/d/sql/source/CleanedContosoDataset/CleanedContosoDataset_CSV/DimGeography.csv' DELIMITER ',' CSV HEADER;


COPY dim_machines (
machine_key		,
store_key		,
machine_type		,
machine_name		,
machine_description	,
vendor_name		,
machine_os		,
machine_source		,
machine_hardware	,
machine_software	,
status			,
service_start_date	,
decommission_date	,
last_modified_date	)
FROM '/mnt/d/sql/source/CleanedContosoDataset/CleanedContosoDataset_CSV/DimMachine.csv' DELIMITER ',' CSV HEADER;



COPY dim_outages (
outage_key		,
outage_name		,
outage_type		,
outage_type_description	,
outage_sub_type		)
FROM '/mnt/d/sql/source/CleanedContosoDataset/CleanedContosoDataset_CSV/DimOutage.csv' DELIMITER ',' CSV HEADER;




COPY dim_products_categories (
product_category_key	,
product_category_name	)
FROM '/mnt/d/sql/source/CleanedContosoDataset/CleanedContosoDataset_CSV/DimProductCategory.csv' DELIMITER ',' CSV HEADER;


COPY dim_products_subcategories (
product_subcategory_key		,
product_subcategory_name	,
product_category_key		)
FROM '/mnt/d/sql/source/CleanedContosoDataset/CleanedContosoDataset_CSV/DimProductSubcategory.csv' DELIMITER ',' CSV HEADER;



COPY dim_promotions (
promotion_key		,
promotion_name		,
discount_percent	,
promotion_type		,
promotion_category	)
FROM '/mnt/d/sql/source/CleanedContosoDataset/CleanedContosoDataset_CSV/DimPromotion.csv' DELIMITER ',' CSV HEADER;



COPY dim_sales_territories (
sales_territory_key	,
geography_key		,
sales_territory_name	,
sales_territory_region	,
sales_territory_country	,
sales_territory_group	,
sales_territory_level	,
sales_territory_manager	,
status			,
employee_key		)
FROM '/mnt/d/sql/source/CleanedContosoDataset/CleanedContosoDataset_CSV/DimSalesTerritory.csv' DELIMITER ',' CSV HEADER;




COPY dim_scenarios (
scenario_key	,
scenario_name	)
FROM '/mnt/d/sql/source/CleanedContosoDataset/CleanedContosoDataset_CSV/DimScenario.csv' DELIMITER ',' CSV HEADER;



COPY dim_stores (
store_key		,
geography_key		,
store_manager		,
store_type		,
store_name		,
status			,
open_date		,
close_date		,
entity_key		,
store_phone		,
store_fax		,
close_reason		,
employee_count		,
selling_area_size	,
last_remodel_date	,
employee_key		)
FROM '/mnt/d/sql/source/CleanedContosoDataset/CleanedContosoDataset_CSV/DimStore.csv' DELIMITER ',' CSV HEADER;


COPY fact_exchange_rates (
exchange_rate_key	,
currency_key		,
date_key		,
average_rate		,
end_of_day_rate		)
FROM '/mnt/d/sql/source/CleanedContosoDataset/CleanedContosoDataset_CSV/FactExchangeRate.csv' DELIMITER ',' CSV HEADER;



COPY fact_it_machines (
it_machine_key	,
machine_key	,
date_key	,
cost_amount	,
cost_type	)
FROM '/mnt/d/sql/source/CleanedContosoDataset/CleanedContosoDataset_CSV/FactITMachine.csv' DELIMITER ',' CSV HEADER;



COPY fact_itsla (
itsla_key		,
date_key		,
store_key		,
machine_key		,
outage_key		,
outage_start_time	,
outage_end_time		,
down_time		)
FROM '/mnt/d/sql/source/CleanedContosoDataset/CleanedContosoDataset_CSV/FactITSLA.csv' DELIMITER ',' CSV HEADER;



COPY fact_strategy_plan (
strategy_plan_key	,
date_key		,
entity_key		,
scenario_key		,
account_key		,
currency_key		,
product_category_key	,
amount			)
FROM '/mnt/d/sql/source/CleanedContosoDataset/CleanedContosoDataset_CSV/FactStrategyPlan.csv' DELIMITER ',' CSV HEADER;



COPY dim_customers (
row_num 		,
customer_key 		,
geography_key 		,
first_name 		,
last_name 		,
birth_date 		,
marital_status 		,
gender 			,
yearly_income 		,
total_children 		,
number_children_at_home	,
education 		,
occupation 		,
house_owner_flag 	,
number_cars_owned 	)
FROM '/mnt/d/sql/source/CleanedContosoDataset/CleanedContosoDataset_CSV/DimCustomer.csv' DELIMITER ',' CSV HEADER;



COPY dim_products (
product_key		,
product_name		,
product_description	,
product_subcategory_key	,
manufacturer		,
brand_name		,
class_id		,
class_name		,
style_id		,
style_name		,
color_id		,
color_name		,
weight			,
weight_unit_measure_id	,
unit_of_measure_id	,
unit_of_measure_name	,
stock_type_id		,
stock_type_name		,
unit_cost		,
unit_price		,
available_for_sale_date	,
status			)
FROM '/mnt/d/sql/source/CleanedContosoDataset/CleanedContosoDataset_CSV/DimProduct.csv' DELIMITER ',' CSV HEADER;



COPY fact_inventory (
inventory_key		,
date_key		,
store_key		,
product_key		,
currency_key		,
on_hand_quantity	,
on_order_quantity	,
safety_stock_quantity	,
unit_cost		,
days_in_stock		,
min_day_in_stock	,
max_day_in_stock	,
aging			)
FROM '/mnt/d/sql/source/CleanedContosoDataset/CleanedContosoDataset_CSV/FactInventory.csv' DELIMITER ',' CSV HEADER;



COPY fact_online_sales (
online_sales_key	,
date_key		,
store_key		,
product_key		,
promotion_key		,
currency_key		,
customer_key		,
sales_order_number	,
sales_order_line_number	,
sales_quantity 		,
sales_amount		,
return_quantity		,
return_amount		,
discount_quantity	,
discount_amount		,
total_cost		,
unit_cost		,
unit_price		)
FROM '/mnt/d/sql/source/CleanedContosoDataset/CleanedContosoDataset_CSV/FactOnlineSales.csv' DELIMITER ',' CSV HEADER;



COPY fact_sales (
sales_key		,
date_key		,
channel_key		,
store_key		,
product_key		,
promotion_key		,
currency_key		,
unit_cost		,
unit_price		,
sales_quantity		,
return_quantity		,
return_amount		,
discount_quantity	,
discount_amount		,
total_cost		,
sales_amount		)
FROM '/mnt/d/sql/source/CleanedContosoDataset/CleanedContosoDataset_CSV/FactSales.csv' DELIMITER ',' CSV HEADER;



COPY fact_sales_quota (
sales_quota_key		,
channel_key		,
store_key		,
product_key		,
date_key		,
currency_key		,
scenario_key		,
sales_quantity_quota	,
sales_amount_quota	,
gross_margin_quota	)
FROM '/mnt/d/sql/source/CleanedContosoDataset/CleanedContosoDataset_CSV/FactSalesQuota.csv' DELIMITER ',' CSV HEADER;
















