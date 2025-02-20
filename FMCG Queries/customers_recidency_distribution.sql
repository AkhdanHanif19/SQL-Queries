#exploring customers table
select *
from customers;

#finding out the distribution of customers across the country
select *
from cities;

with cte as
(
select
rank() over(order by count(*) desc) ranks,
a.cityid, cityname, 
count(*) customer_count,
count(*)/ (sum(count(*)) over()) * 100.0 distribution
from customers a 
join cities b
	on a.cityid = b.cityid
group by a.cityid, b.cityname
order by count(*) desc
)
select (max(customer_count) - min(customer_count))/max(customer_count) *100.0
from cte;

-- Tucson is the city which reside the most customers, but the variation in number of customers among the cities 
-- is very minor with the city which has the least amount of customer having 12.681% (140) less customers than
-- city with the most customer

#ranking city by the sales revenue
##creating related table between sales, customers, and cities table 
with cte as
(
select a.customerid, sum(totalprice) amount, b.cityid, c.cityname
from sales a
join customers b
	on a.customerid = b.customerid
join cities c
	on b.cityid = c.cityid
group by a.customerid, b.cityid, c.cityname 
)
select
rank() over(order by sum(amount) desc)
cityid, cityname, sum(amount) city_revenue
from cte
group by cityid, cityname;
-- tucson is the city which hold the largest customer base and supplying the highest revenue
