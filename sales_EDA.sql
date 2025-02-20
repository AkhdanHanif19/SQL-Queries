#exploring sales
select *
from sales;

#ranking products based on revenue
select 
rank() over(order by sum(totalprice ) desc) ranking,
a.productid, 
b.productname,
b.categoryid,
round(sum(totalprice),2) product_revenue
from sales a
join products b
	on a.productid = b.productid
group by a.productid, b.productname, b.categoryid;

#ranking product categories based on revenue
with cte as
(
select 
rank() over(order by sum(totalprice ) desc) ranking,
a.productid, 
b.productname,
b.categoryid,
round(sum(totalprice),2) revenue
from sales a
join products b
	on a.productid = b.productid
group by a.productid, b.productname, b.categoryid
)
select 
rank() over (order by sum(revenue) desc) category_ranking,
cte.categoryid,
x.categoryname,
sum(revenue) category_revenue
from cte
join categories x
	on cte.categoryid = x.categoryid
group by cte.categoryid, x.categoryname;

-- despite having product 'wasabi powder' in the product category 2 'shell fish' as the product with the most
-- revenue across all categories, product category 2 ranks lowest among the categories based on revenue. 
-- Product categorization is questionable i know, this is a dummy AI generated data set i obtained from kaggle

#finding out the average, max, and min transaction of each product
select 
productid,
min(totalprice),
avg(totalprice),
max(totalprice)
from sales
group by productid
order by productid asc;

#finding out the average, max, and min quantity of each product per transaction
select
productid,
min(quantity),
avg(quantity),
max(quantity)
from sales
group by productid
order by productid asc;

#finding out the revenue and the growth of revenue of each day, and month
with dailygrowth as
(
select
sum(totalprice) day_revenue,
date_format(salesdate, '%Y-%m-%d') `date`
from sales
group by date_format(salesdate, '%Y-%m-%d')
having `date` is not null
order by date_format(salesdate, '%Y-%m-%d') asc)
select day_revenue, 
round(((day_revenue - lag(day_revenue) over()) / day_revenue * 100),3) growth, 
`date`
from dailygrowth;
-- january 16th of 2018 marks the day where the growth of sales from the day before is the highest with 12.149%
-- increase. on the other hand january 20th of 2018 the sales declined by -11.446% from the previous day
-- 2018-03-29 and 2018-04-16 respectively hold the day where the sales is highest and lowest

with monthlygrowth as
(
select
sum(totalprice) month_revenue,
date_format(salesdate, '%Y-%m') `month`
from sales
group by date_format(salesdate, '%Y-%m')
having `month` is not null
order by date_format(salesdate, '%Y-%m') asc)
select month_revenue, 
round(((month_revenue - lag(month_revenue) over()) / month_revenue * 100),3) growth, 
`month`
from monthlygrowth;
-- march of 2018 saw the highest, the first, and the only increase of percentage in sales, and declined again in the
-- following month. january of 2018 had the highest sales, while february of 2018 had the highest decline of sales
-- compared to the previous month with -11.036% as well as the lowest sales. february of 2018 had 3 less days than
-- january of 2018, so this might be the reason, but further analysis would be necessary to determine the actual
-- factor contributing to the decline

#finding the number of transaction at the time of the day to determine the peak hours
select
count(transactionnumber) count,
date_format(salesdate, '%H') `hour`
from sales
group by date_format(salesdate, '%H')
order by count desc;
-- it appears that the frequency of transaction is the highest at 10 in the morning, but the variation is minimum 
-- throughout the day

#finding avg sales per day
select
avg(TotalPrice) dailyaverage
from sales;

#finding category popularity performance
with cte as
(
select productid, sum(quantity) product_quantity, date_format(salesdate, '%Y-%m') `year_month`
from sales
where date_format(salesdate, '%Y-%m') is not null
group by `year_month`, productid
), cte2 as
(
select
c.`year_month`, 
a.categoryid, 
b.categoryname, 
sum(product_quantity) category_quantity
from products a
join categories b
	on a.categoryid = b.categoryid
join cte c
	on a.productid = c.productid
group by c.`year_month`, b.categoryid, b.categoryname
order by b.CategoryID, c.`year_month`
)
select 
`year_month`, 
categoryid, 
categoryname, 
category_quantity,
(category_quantity - lag(category_quantity) over(partition by categoryid))/category_quantity * 100 diff
from cte2;

#finding category sales performance
with cte as
(
select productid, sum(totalprice) product_sales, date_format(salesdate, '%Y-%m') `year_month`
from sales
where date_format(salesdate, '%Y-%m') is not null
group by `year_month`, productid
), cte2 as
(
select
c.`year_month`, 
a.categoryid, 
b.categoryname, 
sum(product_sales) category_sales
from products a
join categories b
	on a.categoryid = b.categoryid
join cte c
	on a.productid = c.productid
group by c.`year_month`, b.categoryid, b.categoryname
order by b.CategoryID, c.`year_month`
)
select 
`year_month`, 
categoryid, 
categoryname, 
category_sales,
(category_sales - lag(category_sales) over(partition by categoryid))/category_sales * 100 diff
from cte2;