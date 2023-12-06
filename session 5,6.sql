select * from billing;
select * from customer;
select * from service_packages;
select * from service_usage;
select* from subscriptions;
-- _________________________________________
select * from service_packages s1 where monthly_rate< (select max(data_used)from service_usage s2
group by s2.service_type having s1.service_type=s2.service_type);
-- ___________________________
select * from billing;
select * from customer;

select c.customer_id, c.first_name,c.last_name,b.amount_due
from customer c
join billing b on c.customer_id = b.customer_id
where b.amount_due = (select avg(b2.amount_due)from billing b2
where b2.customer_id=c.customer_id);
-- ______________________________
select first_name, last_name,(select count(*)from subscriptions s 
where s.customer_id = c.customer_id) as total_subscriptions from customer c;
-- ____________________________
select customer_id , count(subscription_id) as total_subs,
rank() over(order by count(subscription_id) desc) as ranking from subscriptions
group by customer_id;

select customer_id , count(subscription_id) as total_subs,
dense_rank() over(order by count(subscription_id) desc) as ranking from subscriptions
group by customer_id;
-- __________________________
select * from feedback;
select customer_id, service_impacted, 
count(feedback_id) over (partition by customer_id, service_impacted) as feedback_count 
from feedback;
-- _____________________________
select* from service_usage;
select customer_id, service_type , data_used,
avg(data_used) over (partition by customer_id,service_type) as avg_data
from service_usage;
-- ______________________________
select * from feedback;
select customer_id, sum(rating) as total_rating,
dense_rank() over(order by sum(rating)desc) as rating_rank from feedback
group by customer_id;

select customer_id, sum(rating) as total_rating,
rank() over(order by sum(rating)desc) as rating_rank from feedback
group by customer_id;
-- __________________________________
select * from service_usage;
select customer_id, data_used as current_session,
lead(data_used) over(partition by customer_id) as next_session 
from service_usage;

select * from service_usage;
select customer_id, data_used as current_session,
lag(data_used) over(partition by customer_id) as next_session 
from service_usage;
-- ____________________________________-
select * from service_usage;
select customer_id, data_used as current_session,
lead(data_used) over(partition by customer_id) as next_session, 
lead(data_used) over (partition by customer_id)- data_used as differences 
from service_usage;

select * from service_usage;
select customer_id, data_used as current_session,
lag(data_used) over(partition by customer_id) as next_session, 
lag(data_used) over (partition by customer_id)- data_used as differences 
from service_usage;
-- _______________________________
select * from service_usage;
with avgdatausage as (select avg(data_used)as avg_data from service_usage)
select su.customer_id
from service_usage su , avgdatausage adu
where su.data_used > adu .avg_data;













