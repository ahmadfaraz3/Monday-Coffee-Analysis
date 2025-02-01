select * from city
select * from products
select * from sales
select * from customers

--Monday Coffee sales Analysis
--Data Analysis & Reports

Q.1. Coffee consumers count
-- How many people in each city are estimated to consume coffee, given that 25% of the population does.

select city_name,round((c.population*0.25)/1000000,2) as coffee_consumers_in_millions ,city_rank
from city c
order by 2 desc;

Q.2. Total Revenue from Coffee Sales
What is the total revenue generated from coffee sales across all cities in the last quarter of 2023?

select cc.city_name, sum(s.total) as total_revenue
from sales s
join customers c on s.customer_id = c.customer_id
join city cc on c.city_id = cc.city_id
where sale_date between '2023-10-01' and '2023-12-31'
group by cc.city_name
order by 2 desc;

Q.3. Sales Count for Each Product
How many units of each coffee product have been sold?

select product_name, count(s.product_id) as product_sale_cnt
from sales s
right join products p on s.product_id = p.product_id
group by product_name
order by 2 desc;

Q.4. Average Sales Amount per City
What is the average sales amount per customer in each city?

select cc.city_name, round((sum(s.total) /count(distinct s.customer_id) ),2) as avg_sales_amt_per_cx
from sales s
join customers c on s.customer_id = c.customer_id
join city cc on c.city_id = cc.city_id
group  by cc.city_name
order by 2 desc;

Q.5. Average Rating per City
What is the average rating in each city?

select cc.city_name, avg(rating)*1.0  as avg_rating
from sales s
join customers c on s.customer_id = c.customer_id
join city cc on c.city_id = cc.city_id
group by cc.city_name
order by 2 desc;


Q.6 City Population and Coffee Consumers
Provide a list of cities along with their current customers and estimated coffee consumers.

select city_name,count(distinct customer_id) as current_cx_cnt, round((population * .25)/1000000,2) as estimated_coffee_cns_in_millions
from city c 
join customers cc on c.city_id = cc.city_id
group by city_name,population
order by  2 desc

Q.7. Top Selling Products by City
What are the top 3 selling products in each city based on sales volume?

with cte as (
select c.city_name, p.product_name, dense_rank() over(partition by c.city_name order by count(s.product_id) desc) as rnk
from city c
join customers cc on c.city_id = cc.city_id
join sales s on s.customer_id = cc.customer_id 
join products p on s.product_id = p.product_id
group by c.city_name, p.product_name )
select city_name, product_name, rnk
from cte
where rnk <= 3

Q.8. Customer Segmentation by City
How many unique customers are there in each city who have purchased coffee products?

select city_name, count(distinct s.customer_id) as unique_customers
from city c
join customers cc on c.city_id = cc.city_id
join sales s on s.customer_id = cc.customer_id 
join products p on p.product_id = s.product_id
where p.product_id <= 14
group by city_name
order by 2 desc;

Q.9. Average Sale vs Rent
Find each city and their average sale per customer and avg rent per customer

select cc.city_name, round((sum(s.total) /count(distinct s.customer_id) ),2) as avg_sales_amt_per_cx, 
round(estimated_rent/(count(distinct s.customer_id)),2) as avg_rent_per_cx
from sales s
join customers c on s.customer_id = c.customer_id
join city cc on c.city_id = cc.city_id
group  by cc.city_name,estimated_rent
order by 3 ;

Q.10. Monthly Sales Growth
Sales growth rate: Calculate the percentage growth (or decline) in sales over different time periods (monthly) by each city  

with cte as (
select cc.city_name,year(sale_date) as year, month(sale_date) as mnth, sum(total) as total_revenue, lag(sum(total)) over(partition by cc.city_name 
order by year(sale_date), month(sale_date) ) as prev_mon_revenue
from sales s
join customers c on c.customer_id = s.customer_id
join city cc on cc.city_id = c.city_id
group by cc.city_name,year(sale_date), month(sale_date)
 )
select city_name,year,mnth, round(((total_revenue/prev_mon_revenue)-1)*100,2) as revenue_growth
from cte
where round(((total_revenue/prev_mon_revenue)-1)*100,2) is not null and  city_name = 'Pune'
order by city_name,year,mnth
;

Q.11. Market Potential Analysis
Identify top 3 city based on highest sales, return city name, total sale, total rent, total customers, 
estimated coffee consumer

with cte as  (
select city_name,estimated_rent as total_rent,sum(total) as total_sale, count(distinct cc.customer_id) as total_customers, 
cast((c.population*0.25) as int) as estimated_customers, round((sum(s.total) /count(distinct s.customer_id) ),2) 
as avg_sales_amt_per_cx,round(estimated_rent/(count(distinct s.customer_id)),2) as avg_rent_per_cx,
row_number() over(order by sum(total) desc) as rnk
from city c
join customers cc on c.city_id = cc.city_id 
join sales s on s.customer_id = cc.customer_id
group by city_name,estimated_rent,c.population )
select city_name, total_rent, total_sale, total_customers, estimated_customers,avg_sales_amt_per_cx,avg_rent_per_cx
from cte 
order by 3 desc;

-------------------------------------------------------------------------------------------------------------------------------













