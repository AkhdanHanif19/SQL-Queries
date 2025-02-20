#exploring products and category table
select *
from categories;

select *
from products; 

#finding the number of products for each category
select 
count(*), categoryid
from products
group by categoryid
order by categoryid;

#finding average, max, and min price of items in each category
select a.categoryid, b.categoryname, 
max(price) max_price,
round(avg(price),2) avg_price,
min(price) min_price
from products a 
join categories b
	on a.CategoryID = b.categoryid
group by a.categoryid, b.categoryname
order by a.categoryid;

#finding distribution of class among the product categories
with cte as
(
select
a.categoryid,
b.categoryname,
case when class = 'low' then count(*) end low,
case when class = 'medium' then count(*) end med,
case when class = 'high' then count(*) end high
from products a
join categories b
	on a.categoryid = b.CategoryID
group by a.categoryid, b.categoryname, class
order by a.categoryid asc
)
select categoryid, categoryname, sum(low) low_class, sum(med) medium_class, sum(high) high_class
from cte
group by categoryid, categoryname;

#finding distribution of product resistance among the product categories
with cte as
(
select
a.categoryid,
b.categoryname,
case when resistant = 'weak' then count(*) end weak,
case when resistant = 'unknown' then count(*) end `unknown`,
case when resistant = 'durable' then count(*) end durable
from products a
join categories b
	on a.categoryid = b.CategoryID
group by a.categoryid, b.categoryname, resistant
order by a.categoryid asc
)
select categoryid, categoryname, sum(weak) weak, sum(`unknown`) `unknown`, sum(durable) durable
from cte
group by categoryid, categoryname;