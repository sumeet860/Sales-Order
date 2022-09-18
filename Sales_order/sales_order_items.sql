use plantix;
SELECT 
    *
FROM
    sales_orders_items;

-- Total order quantity
SELECT 
    COUNT(*) order_quantity
FROM
    sales_orders_items;

-- Total product
SELECT 
    COUNT(DISTINCT (fk_product_id)) distinct_product
FROM
    sales_orders_items;

-- Total orders
SELECT 
    COUNT(DISTINCT (fk_order_id)) distinct_order
FROM
    sales_orders_items;

-- Total orders
SELECT 
    COUNT(DISTINCT (order_item_id)) distinct_order
FROM
    sales_orders_items;

-- Maximum order quantity of item and how much accepted
SELECT 
    order_item_id,
    fk_order_id,
    MAX(ordered_quantity) max_order,
    order_quantity_accepted
FROM
    sales_orders_items;

-- Minimum order quantity of item and how much accepted
SELECT 
    order_item_id,
    fk_order_id,
    MIN(ordered_quantity),
    order_quantity_accepted
FROM
    sales_orders_items;

-- Max order quantity rate
SELECT 
    MAX(ordered_quantity), rate
FROM
    sales_orders_items;

-- Min order quantity rate
SELECT 
    MIN(ordered_quantity), rate
FROM
    sales_orders_items;

-- Highest product price, it's id and order item id
SELECT 
    order_item_id, fk_product_id, MAX(rate)
FROM
    sales_orders_items;

-- Lowest product price, it's id and order item id
SELECT 
    order_item_id, fk_product_id, MIN(rate)
FROM
    sales_orders_items;

-- order quantity and order quantity accepted
SELECT 
    ordered_quantity, rate
FROM
    sales_orders_items
GROUP BY ordered_quantity
ORDER BY ordered_quantity;

-- Top 10 product with highest rate
SELECT 
    fk_product_id, rate
FROM
    sales_orders_items
GROUP BY fk_product_id
ORDER BY rate DESC
LIMIT 10;

-- Total quantity ordered, quantity accepted and quantity rejected
SELECT 
    fk_product_id,
    SUM(ordered_quantity) total_quantity,
    SUM(order_quantity_accepted) Quantity_accepted,
    (SUM(Ordered_quantity) - SUM(order_quantity_accepted)) Quantity_Rejected
FROM
    sales_orders_items
GROUP BY fk_product_id
ORDER BY total_quantity DESC
LIMIT 10;

