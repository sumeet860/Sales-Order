use plantix;
-- Sales order 
SELECT 
    *
FROM
    sales_orders;

-- Total order Count
SELECT 
    COUNT(*) order_id
FROM
    sales_orders;

-- Order status count by depot
SELECT 
    sales_order_status, COUNT(*) Orders
FROM
    sales_orders
GROUP BY sales_order_status;

-- Total order count by year
SELECT 
    YEAR(DATE(creation_time)) AS period,
    sales_order_status,
    COUNT(*) orders
FROM
    sales_orders
GROUP BY sales_order_status, period;

-- Total order count for each depot
SELECT 
    fk_depot_id, COUNT(sales_order_status) total_count
FROM
    sales_orders
GROUP BY fk_depot_id
ORDER BY fk_depot_id;

-- Total Shipped order for each depot
SELECT 
    fk_depot_id, COUNT(sales_order_status) shipped
FROM
    sales_orders
WHERE
    sales_order_status IN ('Shipped')
GROUP BY fk_depot_id
ORDER BY fk_depot_id;

-- Total Rejected order for each depot
SELECT 
    fk_depot_id, COUNT(sales_order_status) rejected
FROM
    sales_orders
WHERE
    sales_order_status IN ('Rejected')
GROUP BY fk_depot_id
ORDER BY fk_depot_id;

-- Total distinct buyer
SELECT DISTINCT
    (fk_buyer_id)
FROM
    sales_orders;

-- Distinct buyer by year
SELECT 
    YEAR(DATE(creation_time)) AS year,
    COUNT(DISTINCT (fk_buyer_id)) Distinct_Buyers
FROM
    sales_orders
GROUP BY year;

-- Total Order placed in year 2021 by depot
SELECT 
    fk_depot_id,
    COUNT(sales_order_status) Total_count,
    YEAR(DATE(creation_time)) AS period
FROM
    sales_orders
WHERE
    creation_time IN (2021)
GROUP BY fk_depot_id , period
ORDER BY fk_depot_id;

-- Total Order placed in year 2022 by depot
SELECT 
    fk_depot_id,
    COUNT(sales_order_status) Total_count,
    YEAR(DATE(creation_time)) AS period
FROM
    sales_orders
WHERE
    creation_time IN (2022)
GROUP BY fk_depot_id , period
ORDER BY fk_depot_id;

-- Total, Shipped and Rejected orders
with cte_21 as (select
(select count(sales_order_status) from sales_orders
where year(date(creation_time))=2021) as total_count,
(select count(sales_order_status) from sales_orders 
where sales_order_status = 'Shipped' and year(date(creation_time))=2021) as Shipped_Count21,
(select count(sales_order_status) from sales_orders 
where sales_order_status = 'Rejected' and year(date(creation_time))=2021) as Rejected_Count21)
select total_count, Shipped_Count21, Rejected_Count21 from cte_21;

-- Total Order placed in year 2022 by depot
SELECT 
    fk_depot_id,
    COUNT(sales_order_status) Total_count,
    YEAR(DATE(creation_time)) AS period
FROM
    sales_orders
WHERE
    creation_time IN (2022)
GROUP BY fk_depot_id , period
ORDER BY fk_depot_id;

-- Total, Shipped and Rejected orders
with cte_22 as (select
(select count(sales_order_status) from sales_orders
where year(date(creation_time))=2022) as total_count,
(select count(sales_order_status) from sales_orders 
where sales_order_status = 'Shipped' and year(date(creation_time))=2022) as Shipped_Count22,
(select count(sales_order_status) from sales_orders 
where sales_order_status = 'Rejected' and year(date(creation_time))=2022) as Rejected_Count22)
select total_count, Shipped_Count22, Rejected_Count22 from cte_22;

-- Increaed Buyer %
with cte_percent as (select 
(select count(distinct(fk_buyer_id)) 
from  sales_orders) Distinct_buyers,
(select count(distinct(fk_buyer_id)) 
from  sales_orders
where year(date(creation_time))=2021) Total_Distinct_Buyers21,
(select count(distinct(fk_buyer_id)) Distinct_buyers
from  sales_orders
where year(date(creation_time))=2022) Total_Distinct_Buyers22)
select Distinct_buyers,
Total_Distinct_Buyers22,
Total_Distinct_Buyers21,
(( Total_Distinct_Buyers22-Total_Distinct_Buyers21)/Distinct_Buyers*100) as Increased_Buyer_Percent
from cte_percent;

-- Sale Order status count and % of item shipped and rejected  by day
SELECT 
    sales_order_status,
    DAYNAME(creation_time) AS DayOfWeek,
    COUNT(*) sales_order_status,
    SUM(CASE
        WHEN sales_order_status IN ('Shipped') THEN 1
        ELSE 0
    END) / COUNT(*) * 100 '%Shipped',
    SUM(CASE
        WHEN sales_order_status IN ('Rejected') THEN 1
        ELSE 0
    END) / COUNT(*) * 100 '%Rejected'
FROM
    sales_orders
GROUP BY DayOfWeek
ORDER BY sales_order_status DESC;
