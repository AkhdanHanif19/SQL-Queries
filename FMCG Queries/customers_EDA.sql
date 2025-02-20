#exploring customers and sales table 
select *
from customers;

select *
from sales;

#ranking customers based on the count of purchase
select 
dense_rank() over(order by count(*) desc) ranks,
customerid, count(*) purchase, sum(totalprice)
from sales
group by customerid
order by count(*) desc;

#ranking customers based on the total of purchase
with cte1 as
(
select 
percent_rank() over(order by sum(totalprice) desc) ranks,
customerid, sum(totalprice) purchase
from sales
group by customerid
order by sum(totalprice) desc)
#finding the most popular items among the top 10% customers
, popular_items as
(
select rank () over(order by sum(quantity) desc) product_rank, a.productid, b.ProductName, b.categoryid,
c.categoryname, sum(quantity) totalquantity, sum(totalprice) item_amount
from sales a
join products b
	on a.productid = b.productid
join categories c
	on b.CategoryID = c.categoryid
where customerid in (select customerid
					from cte1
                    where ranks <= 0.1)
group by a.productid, b.productname, b.categoryid, c.categoryname
order by totalquantity desc)
-- we find that
, popular_category as
( 
select 
rank() over(order by sum(totalquantity) desc) category_rank,
categoryid, categoryname, sum(totalquantity) category_quantity, sum(item_amount) category_amount
from popular_items
group by categoryid, categoryname
)
select *
from popular_category;

-- we found that puree - passion fruit is the most popular item by the quantity of purchase among the top 10%
-- customers, to retain their loyalty to the store, we might want to consider strenghtening our stock for the items
-- in the list of popular_items
-- also in the popular_category table we found that confections top the list as the most popular category among the
-- top 10% customers
