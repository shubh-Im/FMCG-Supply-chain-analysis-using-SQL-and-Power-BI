-- 1.CITY WISE CUSTOMER AND TOTAL ORDER
SELECT city,COUNT(DISTINCT(customer_id)) AS customers,COUNT(DISTINCT(order_id)) AS orders_count
FROM dim_customers
LEFT JOIN fact_order_lines
USING (customer_id)
GROUP BY city
ORDER BY orders_count DESC;

-- 2. Customerwise Total orders
SELECT customer_name,COUNT(DISTINCT(order_id)) AS orders
FROM dim_customers
LEFT JOIN fact_order_lines
USING (customer_id)
GROUP BY customer_name
ORDER BY orders DESC;

-- 3. Average delivary time for Each city
SELECT city,ROUND(AVG(DATEDIFF(actual_delivery_date,order_placement_date)),2) AS avg_delivary_days
FROM dim_customers
LEFT JOIN fact_order_lines
USING (customer_id)
GROUP BY city;

-- 4. CITY WISE TOTAL ORDERS,TOTAL ORDERS ON TIME,TOTAL ORDERS IN FULL,TOTAL ORDERS ON TIME IN FULL?
SELECT city,COUNT(*) AS total_orders,
COUNT(DISTINCT(CASE WHEN on_time=1 THEN order_id ELSE 0 END)) AS on_time_orders,
COUNT(DISTINCT(CASE WHEN in_full=1 THEN order_id ELSE 0 END)) AS in_full_orders,
COUNT(DISTINCT(CASE WHEN otif=1 THEN order_id ELSE 0 END)) AS on_time_in_full_orders
FROM dim_customers
LEFT JOIN fact_orders_aggregate
USING (customer_id)
GROUP BY city;

-- 5. CUSTOMER WISE TOTAL ORDERS,TOTAL ORDERS ON TIME,TOTAL ORDERS IN FULL,TOTAL ORDERS ON TIME IN FULL?
WITH x AS (
SELECT customer_name,COUNT(*) AS total_orders,
SUM(CASE WHEN on_time=1 THEN 1 ELSE 0 END) AS on_time_orders,
SUM(CASE WHEN in_full=1 THEN 1 ELSE 0 END) AS in_full_orders,
SUM(CASE WHEN otif=1 THEN 1 ELSE 0 END) AS on_time_in_full_orders
FROM dim_customers
LEFT JOIN fact_orders_aggregate
USING (customer_id)
GROUP BY customer_name)
SELECT customer_name,total_orders,on_time_orders,in_full_orders,on_time_in_full_orders,
CONCAT(ROUND((on_time_orders*100/total_orders),2),'%')AS 'OT%',
CONCAT(ROUND((in_full_orders*100/total_orders),2),'%') AS 'IF%',
CONCAT(ROUND((on_time_in_full_orders*100/total_orders),2),'%') AS 'OTIF%'
FROM x;

-- 6. CUSTOMER DEVIATION BETWEEN TARGET AND ACTUAL IF%,OT%,OTIF%
WITH deviation AS (
SELECT customer_name,ROUND(AVG(ontime_target),2) AS Target_OT,
ROUND(AVG(infull_target),2) AS Target_IF,ROUND(AVG(otif_target),2) AS Target_OTIF,
ROUND(SUM(CASE WHEN on_time=1 THEN 1 ELSE 0 END)*100/COUNT(*),2) AS Actual_OT,
ROUND(SUM(CASE WHEN in_full=1 THEN 1 ELSE 0 END)*100/COUNT(*),2) AS Actual_IF,
ROUND(SUM(CASE WHEN otif=1 THEN 1 ELSE 0 END)*100/COUNT(*),2) AS Actual_OTIF
FROM dim_customers dc 
JOIN dim_targets_orders dt 
ON dc.customer_id=dt.customer_id
LEFT JOIN fact_orders_aggregate fa 
ON dc.customer_id=fa.customer_id
GROUP BY customer_name)
SELECT customer_name,Target_OT-Actual_OT AS OT_deviation,Target_IF-Actual_IF AS IF_deviation,
Target_OTIF-Actual_OTIF AS OTIF_deviation
FROM deviation;

-- 7. CITYWISE DEVIATION BETWEEN TARGET AND ACTUAL IF%,OT%,OTIF%
WITH target AS (
SELECT city,AVG(ontime_target) AS target_OT,AVG(infull_target) AS target_IF,
AVG(otif_target) AS target_OTIF
FROM dim_targets_orders
JOIN dim_customers
USING (customer_id)
GROUP BY city),
 actual AS (
SELECT city,
SUM(CASE WHEN on_time=1 THEN 1 ELSE 0 END)*100/COUNT(*) AS OT,
SUM(CASE WHEN in_full=1 THEN 1 ELSE 0 END)*100/COUNT(*) AS IF_,
SUM(CASE WHEN otif=1 THEN 1 ELSE 0 END)*100/COUNT(*) AS OTIF
FROM dim_customers
LEFT JOIN fact_orders_aggregate
USING (customer_id)
GROUP BY city)
SELECT city,ROUND((target_OT-OT),2) AS 'OT%_deviation',
ROUND((target_IF-IF_),2) AS 'IF%_deviation',
ROUND((target_OTIF-OTIF),2) AS 'OTIF%_deviation'
FROM target
JOIN actual
USING (city);


-- 8. Average delivary time for Each customer
SELECT customer_name,ROUND(AVG(DATEDIFF(actual_delivery_date,order_placement_date)),2) AS avg_delivary_days
FROM dim_customers
LEFT JOIN fact_order_lines
USING (customer_id)
GROUP BY customer_name
ORDER BY avg_delivary_days ASC;

-- 9. WEEKLY TOTAL ORDERS,OT,IF,OTIF ORDERS
SELECT week_no,
SUM(CASE WHEN on_time=1 THEN 1 ELSE 0 END)*100/COUNT(*) AS 'OT%',
SUM(CASE WHEN in_full=1 THEN 1 ELSE 0 END)*100/COUNT(*) AS 'IF%',
SUM(CASE WHEN otif=1 THEN 1 ELSE 0 END)*100/COUNT(*) AS 'OTIF%'
FROM dim_date d
LEFT JOIN fact_orders_aggregate f
ON f.order_placement_date=d.date
GROUP BY week_no
ORDER BY week_no ASC;

-- 10. TOP 10 CUSTOMERS BY ORDER QUANTITY
SELECT customer_name,SUM(order_qty) AS order_qty
FROM dim_customers
LEFT JOIN fact_order_lines
USING(customer_id)
GROUP BY customer_name
ORDER BY order_qty DESC;


-- 11. CUSTOMERWISE CATEGORY WISE QUANTITY
WITH x AS (
SELECT customer_name,
SUM(CASE WHEN category='Dairy' THEN order_qty ELSE 0 END) AS dairy_qty,
SUM(CASE WHEN category='Food' THEN order_qty  ELSE 0 END) AS food_qty,
SUM(CASE WHEN category='beverages' THEN order_qty  ELSE 0 END) AS beverages_qty,
SUM(order_qty) AS total_qty
FROM dim_customers
JOIN fact_order_lines
USING (customer_id)
JOIN dim_products
USING (product_id)
GROUP BY customer_name
ORDER BY total_qty DESC)
SELECT customer_name,
dairy_qty*100/total_qty AS dairy_pct,food_qty*100/total_qty AS food_pct,
beverages_qty*100/total_qty AS beverages_pct
FROM x;

-- 12. TOP 3 PRODUCTS ORDERED IN EACH CATEGORY
WITH x AS (
SELECT category,product_name,SUM(order_qty) AS order_qty
FROM dim_products
LEFT JOIN fact_order_lines
USING (product_id)
GROUP BY category,product_name),
y AS (
SELECT category,product_name,order_qty,
RANK() OVER(PARTITION BY category ORDER BY order_qty DESC) AS rnk
FROM x)
SELECT category,product_name,order_qty,rnk
FROM y
WHERE rnk<=3;

-- 13. CITYWISE CATEGORYWISE ORDERS
SELECT city,
COUNT(DISTINCT(CASE WHEN category='Dairy' THEN order_id END))*100/COUNT(*) AS Dairy,
COUNT(DISTINCT(CASE WHEN category='Food' THEN order_id END))*100/COUNT(*) AS Food,
COUNT(DISTINCT(CASE WHEN category='beverages' THEN order_id END))*100/COUNT(*) AS Beverages
FROM dim_customers dc 
LEFT JOIN fact_order_lines fo 
ON dc.customer_id=fo.customer_id
RIGHT JOIN dim_products dp 
ON fo.product_id=dp.product_id
GROUP BY city;


-- 14. EACH CUSTOMER MOST AND LEAST ORDERED PRODUCTS
WITH most_orders AS (
SELECT c.customer_name,p.product_name,COUNT(f.product_id) AS product_count
FROM dim_customers c
JOIN fact_order_lines f 
ON c.customer_id=f.customer_id
JOIN dim_products p
ON p.product_id=f.product_id
GROUP BY c.customer_name,p.product_name
ORDER BY product_count DESC),
x AS (
SELECT customer_name,product_name,
RANK() OVER(PARTITION BY customer_name ORDER BY product_count DESC) AS rnk_max,
RANK() OVER(PARTITION BY customer_name ORDER BY product_count ASC) AS rnk_min
FROM most_orders)
SELECT customer_name,
MAX(CASE WHEN rnk_max=1 THEN product_name END) AS most_ordered_product,
MAX(CASE WHEN rnk_min=1 THEN product_name END) AS least_ordered_product
FROM x
GROUP BY customer_name;

-- 15. week over week change of orders
WITH x AS (
SELECT week_no,COUNT(DISTINCT(order_id)) AS orders
FROM dim_date d
LEFT JOIN fact_order_lines f
ON d.date=f.order_placement_date
GROUP BY week_no
ORDER BY week_no),
y AS (
SELECT week_no,orders,LAG(orders,1,0) OVER(ORDER BY week_no ASC) AS previous_week_orders
FROM x)
SELECT week_no,orders,previous_week_orders,
IFNULL(ROUND(((orders/previous_week_orders)-1)*100,2),0) AS percentage_change
FROM y;
