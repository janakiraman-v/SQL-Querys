-- The below SQL queries are performed in Snowflake, Hope it will work other tools also
1. Use group by & order by like below

select category, sum(sales) as total_sales, year(order_date) as year_order
from orders
group by category, year_order
order by category, year_order

select category, sum(sales) as total_sales, year(order_date) as year_order
from orders
group by 1,3
order by 1,2

select category, sum(sales) as total_sales, year(order_date) as year_order
from orders
group by ALL
order by 1,2

select category, sum(sales) as total_sales, year(order_date) as year_order
from orders
group by category, year_order
order by 1,2


2. Fetch the column like below

-- Use the temporary column in the where clause
select *, sales-profit as cost,
case when cost > 200 then 'High Profit Item' else 'Low Profit Item' end as item_cost_category
from orders
where item_cost_category = 'High Profit Item'


3. Use the Like function like this

-- Using upper you will get all records, because like 'Fur%' is case sensitive
select * from orders
where upper(product_id) like 'FUR%'


-- we can use lower also
select * from orders
where lower(product_id) like 'FUR%'



--Using this iLike function, you can fetch the record,d both small and capital words
select * from orders
where product_id ilike 'FuR%'

4. Split the string like below

-- split the name like this
SELECT *,
LEFT(customer_name, CHARINDEX(' ', customer_name) - 1) AS first_name,
SUBSTRING(customer_name, CHARINDEX(' ', customer_name) + 1, LEN(customer_name)) AS last_name
FROM orders;

SELECT *,
LEFT(customer_name, position(' ', customer_name) - 1) AS first_name,
SUBSTRING(customer_name, position(' ', customer_name) + 1, LEN(customer_name)) AS last_name
FROM orders;

select *, split_part(customer_name,' ',1) as first_name,
split_part(customer_name,' ',2) as last_name
from orders

5. top 3 products in each category by sales

-- Top 3 products in each category by sales

with cte as (
Select category, product_id, sum(sales) as total_sales
from orders
group by all
)
select * from (select *,
row_number() over(partition by category order by total_sales desc) as rn
from cte)
where rn<=3

-- Top 3 products in each category by sales using the qualify clause

Select category, product_id, sum(sales) as total_sales
from orders
group by all
qualify row_number() over(partition by category order by total_sales desc) <= 3
