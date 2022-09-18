-- Using both sales_orders and sales_order_items tables finding the data.
use plantix;
select * from sales_orders;
select * from sales_orders_items;


-- Products in both year
select year(s.creation_time) period, count(distinct(fk_product_id)) distinct_product,
round((sum(order_quantity_accepted))/sum(Ordered_quantity)*100, 2) accepted_quantity_percent,
round(((sum(Ordered_quantity)-sum(order_quantity_accepted))/sum(Ordered_quantity))*100, 2) rejected_quantity_percent
from sales_orders_items st join sales_orders s on s.order_id = st.fk_order_id
group by period;

-- Top 3 selling products in 2021
select year(s.creation_time) period, fk_product_id,
sum(ordered_quantity) total_quantity, sum(order_quantity_accepted) Quantity_accepted,
round((sum(order_quantity_accepted))/sum(Ordered_quantity)*100, 2) accepted_quantity_percent,
round(((sum(Ordered_quantity)-sum(order_quantity_accepted))/sum(Ordered_quantity))*100, 2) rejected_quantity_percent
from sales_orders_items st join sales_orders s on s.order_id = st.fk_order_id
group by period, fk_product_id
having period = 2021
order by total_quantity desc limit 3;

-- Rejected product count
with cte_rejected_products as(select fk_product_id,year(o.creation_time) period,
sum(ordered_quantity) total_quantity, sum(order_quantity_accepted) accepted_quantity,
sum(order_quantity_accepted)/sum(ordered_quantity)*100 accpted_quantity_percent
from sales_orders_items i join sales_orders o on o.order_id=i.fk_order_id 
group by fk_product_id
having accpted_quantity_percent = 0)
select period,count(*) rejected_products
from cte_rejected_products
group by period;

-- Top 3 selling products in 2022
select year(s.creation_time) period, fk_product_id,
sum(ordered_quantity) total_quantity, sum(order_quantity_accepted) Quantity_accepted,
round((sum(order_quantity_accepted))/sum(Ordered_quantity)*100, 2) accepted_quantity_percent,
round(((sum(Ordered_quantity)-sum(order_quantity_accepted))/sum(Ordered_quantity))*100, 2) rejected_quantity_percent
from sales_orders_items st join sales_orders s on s.order_id = st.fk_order_id
group by period, fk_product_id
having period = 2022
order by total_quantity desc limit 3;

-- Total orders made in 2021
with cte_orders as
(select year(s.creation_time) period, count(*) fk_order_id from sales_orders_items st 
join sales_orders s on s.order_id = st.fk_order_id 
group by period having period = 2021) select * from cte_orders;

-- Total orders made in 2022
with cte_orders as
(select year(s.creation_time) period, count(*) fk_order_id from sales_orders_items st 
join sales_orders s on s.order_id = st.fk_order_id 
group by period having period = 2022) select * from cte_orders;


-- % increase in Total orders made in 2021 to 2022
with cte_increase as (select
(select count(*) fk_order_id from sales_orders_items st 
join sales_orders s on s.order_id = st.fk_order_id 
where creation_time = 2022) as 22_order_count,
(select count(*) fk_order_id from sales_orders_items st 
join sales_orders s on s.order_id = st.fk_order_id 
where creation_time = 2021) as 21_order_count,
(select round(((22_order_count - 21_order_count)/(21_order_count))*100, 2)) as percent_increase)
select 22_order_count, 21_order_count, percent_increase from cte_increase;

-- Products with 100% Shipping 
select fk_product_id, sum(ordered_quantity) total_quantity, sum(order_quantity_accepted) accepted_quantity
from sales_orders_items
group by fk_product_id
having total_quantity = accepted_quantity;

-- %Rejected orders by year 
with cte_reject as(select fk_product_id, year(s.creation_time) period,
sum(ordered_quantity) total_quantity, sum(order_quantity_accepted) accepted_quantity,
round(sum(order_quantity_accepted)/sum(ordered_quantity)*100, 2) percent_quantity_accepted
from sales_orders_items st join sales_orders s on s.order_id=st.fk_order_id 
group by fk_product_id
having percent_quantity_accepted = 0)
select period, count(*)'rejected_product', (select count(distinct (fk_product_id)) Total_products
from sales_orders_items st join sales_orders s on s.order_id=st.fk_order_id and year(s.creation_time)=period) Total_products_by_year,
count(*)/(select count(distinct (fk_product_id)) Total_products
from sales_orders_items st join sales_orders s on s.order_id=st.fk_order_id and year(s.creation_time)=period)*100 '%order_Rejected'
from cte_reject 
group by period;


-- 2.13  Percentage_of_Products_with_100%_order_Rejected by year
with cte_rejected_percent as(select fk_product_id, year(s.creation_time) period,
sum(ordered_quantity) total_quantity, sum(order_quantity_accepted) accepted_quantity,
sum(order_quantity_accepted)/sum(ordered_quantity)*100 percent_quantity_accepted
from sales_orders_items st join sales_orders s on s.order_id=st.fk_order_id 
group by fk_product_id
having percent_quantity_accepted = 0)
select period,count(*) rejected_products, (select count(distinct (fk_product_id)) total_product
from sales_orders_items st join sales_orders s on s.order_id=st.fk_order_id and year(s.creation_time)=period) total_products,
count(*)/(select count(distinct (fk_product_id)) Total_products
from sales_orders_items st join sales_orders s on s.order_id=st.fk_order_id and year(s.creation_time)=period)*100 rejected_prodcut_percent
from cte_rejected_percent
group by period;


-- Orders made per week in 2021
select week(s.creation_time) week_period, count(*) fk_order_id
from sales_orders_items st 
join sales_orders s on s.order_id = st.fk_order_id
where year(creation_time) = 2021
group by week_period;

-- Orders made per week in 2022
select week(s.creation_time) week_period, count(*) fk_order_id
from sales_orders_items st 
join sales_orders s on s.order_id = st.fk_order_id
where year(creation_time) = 2022
group by week_period;

-- Total Sales by year
select year(s.creation_time) year,round(sum( st.order_quantity_accepted * st.rate),4) total_sales_year
from sales_orders s
join sales_orders_items st on s.order_id=st.fk_order_id
group by year;

-- week sales in 2021
select round(sum(st.order_quantity_accepted * st.rate)/ count(distinct(week(s.creation_time))),2) week_sale, 
week(s.creation_time) weeks
from sales_orders_items st 
join sales_orders s on s.order_id = st.fk_order_id
where year(s.creation_time) in (2021)
group by weeks;

-- week sales in 2022
select round(sum(st.order_quantity_accepted * st.rate)/ count(distinct(week(s.creation_time))),2) week_sale, 
week(s.creation_time) weeks
from sales_orders_items st 
join sales_orders s on s.order_id = st.fk_order_id
where year(s.creation_time) in (2022)
group by weeks;

-- %increase week sale
with cte_week_sale as (select
(select round(sum( st.order_quantity_accepted * st.rate)/ count(distinct(week(s.creation_time))),2) 
from sales_orders s
join sales_orders_items st on s.order_id=st.fk_order_id) Total_week_sale,
(select round(sum( st.order_quantity_accepted * st.rate)/ count(distinct(week(s.creation_time))),2) 
from sales_orders s
join sales_orders_items st on s.order_id=st.fk_order_id
where year(s.creation_time) =2021) week_sale_2021,
(select round(sum( st.order_quantity_accepted * st.rate)/ count(distinct(week(s.creation_time))),2) 
from sales_orders s
join sales_orders_items st on s.order_id=st.fk_order_id
where year(s.creation_time) =2022 ) week_sale_2022)
select total_week_sale,week_sale_2021,week_sale_2022,
round((week_sale_2022-week_sale_2021)/total_week_sale*100, 2)  increase_percent_week_sale
from cte_week_sale;

-- % increase week sale in 2022 from 2021
with cte_increase_week_sale as (
select 
(select round((count(*)/count( distinct week(creation_time))), 2)
from sales_orders) as Total_week_sale,
(select round((count(*)/count( distinct week(creation_time))), 2)
from sales_orders
where year(creation_time)=2021 ) week_sale_21,
(select round((count(*)/count( distinct week(creation_time))), 2)
from sales_orders
where year(creation_time)=2022) week_sale_22)
select total_week_sale,week_sale_21,week_sale_22,
round((week_sale_22-week_sale_21)/total_week_sale*100, 2) increase_week_sale_in_22
from cte_increase_week_sale
