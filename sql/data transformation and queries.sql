--  adding the english translation of the products category to the products table
alter table products
add column product_category varchar (100);

update products
join product_category_translation on products.product_category_name =  product_category_translation.product_category_name
set products.product_category = product_category_translation.product_category_name_english
where products.product_category_name = product_category_translation.product_category_name; 

/* hypothesis testing to test if payment_installments is significantly affected by payment value using linear regression.
The results of this view are entered into excel where a regression analysis was run */
create view payment_regression as
select payment_installments, payment_value
from order_payments; -- correlation = 0.33

-- Datetime transformations
create view durations as 
with cte as 
(
select oi.order_id, oi.seller_id, o.customer_id, o.order_status, oi.shipping_limit_date, o.order_purchase_timestamp, 
		o.order_approved_at, o.order_delivered_carrier_date, o.order_delivered_customer_date, o.order_estimated_delivery_date
from order_items oi
join orders 
on oi.order_id = o.order_id
)
select distinct order_id,
	timestampdiff(hour, order_purchase_timestamp, order_approved_at) as approval_duration_hrs,
    timestampdiff(day, order_purchase_timestamp, order_delivered_carrier_date) as logistics_delivery_days,
    timestampdiff(day, order_purchase_timestamp, order_delivered_customer_date) as customer_delivery_days, 
    timestampdiff(hour, order_delivered_carrier_date, shipping_limit_date) as shipping_lag_hrs, -- negative values indicate deliveries later than specified limit
    timestampdiff(day,order_delivered_customer_date, order_estimated_delivery_date) as delivery_lag_days -- negative values indicate later than estimated deliveries
from cte;

-- finding the correlation coefficient between time taken to deliver to logistics company and time taken for logistics company to deliver to customer
with cte as 
(
select logistics_delivery_days as ldd, (customer_delivery_days - logistics_delivery_days) as stc
from durations
)
select (avg(ldd*stc) - avg(ldd) * avg(stc)) / (stddev_pop(ldd) * stddev_pop(stc)) as correlation
from cte; /* correlation = 0.02. This indicates that there is no strong relationship between time taken to deliver to logistics company 
			and time taken for logistics company to deliver to customer.*/
 
 -- Assessing shipping durations
with cte as 
(
select shipping_lag_hrs, 
case
	when shipping_lag_hrs < 0 then 'late'
  when shipping_lag_hrs > 0 then 'early'
	else 'no_difference' 
end as shipping_assessment
from durations
)
select count(shipping_assessment), shipping_assessment
from cte
group by shipping_assessment;


-- gross merchandise value
select sum(payment_value)
from order_payments;

-- average order value of each customer 
with cte as 
(
select c.customer_unique_id, c.customer_id, op.order_id, op.payment_value 
from order_payments op
join orders o 
on op.order_id = o.order_id
join customers c 
on o.customer_id = c.customer_id
)
select customer_unique_id, avg(payment_value)
from cte 
group by customer_unique_id;

 -- customers and how many orders they placed overall
select count(customer_id), customer_unique_id 
from customers
group by customer_unique_id
order by 1 desc
limit 1; -- customer with the most orders placed

-- customers and how many orders they placed each year
with cte as 
(
select count(c.customer_id) as order_count, c.customer_unique_id, year(o.order_purchase_timestamp) as  years
from customers c
join orders o 
on c.customer_id = o.customer_id
group by c.customer_unique_id, years
order by 3,1 desc -- customers and how many orders they placed each year
)
select max(order_count), years
from cte
group by years
order by 2,1; -- maximum number of orders per customer each year

-- calculating the correlation coefficient between average review score and average customer delivery time
with orders as 
(
select r.review_score as rsc, d.order_id as did, d.customer_delivery_days as cdd
from order_reviews r
left join durations d 
on r.order_id = d.order_id
union
select r.review_score as rsc,  d.order_id as did, d.customer_delivery_days as cdd
from order_reviews r
right join durations d 
on r.order_id = d.order_id -- syntax does a full outer join because mysql doesn't have a default outer join keyword
), cte as 
(
select did, avg(rsc) as rsc, avg(cdd) as cdd
from orders
group by did
order by 2, 3 desc -- average review score and average time to customer grouped by order_id
)
select (avg(rsc*cdd) - avg(rsc) * avg(cdd)) / (stddev_pop(rsc) * stddev_pop(cdd)) as correlation
from cte; -- formula to calculate correlation coefficient (-0.28). calculation was done on non-aggregated data


-- average review score by product category
with cte as 
(
select r.order_id, r.review_score, p.product_category
from order_reviews r
join order_items oi
on r.order_id = oi.order_id
join products p
on oi.product_id = p.product_id
)
select avg(review_score), product_category
from cte
group by product_category
order by 1 desc;

-- average review score grouped by review comment titles
select review_comment_title, count(review_comment_message), avg(review_score)
from order_reviews
group by review_comment_title
order by 3 desc;

-- customer insights (regarding payment type)
select sum(payment_value), count(payment_type), payment_type
from order_payments
group by payment_type;
