select EmployeeID, 
timestampdiff(year, birthdate, current_timestamp),
concat(firstname, ' ', middleinitial, ' ', lastname) fullname
from employees;

select EmployeeID, 
timestampdiff(year, hiredate, current_timestamp),
concat(firstname, ' ', middleinitial, ' ', lastname) fullname
from employees;

# ranking salesperson based on the revenue they generated
select 
rank() over(order by sum(totalprice) desc) ranks,
timestampdiff(year, birthdate, current_timestamp) age,
timestampdiff(day, hiredate, current_timestamp) employment_duration,
salespersonid, concat(firstname, ' ', middleinitial, ' ', lastname) fullname, sum(totalprice)
from sales
join employees
	on sales.salespersonid = employees.EmployeeID
group by salespersonid, fullname, age, employment_duration
order by sum(totalprice) desc
;

#employee monthly performance data
with cte as
(
select 
date_format(salesdate, '%Y-%m') `year_month`,
salespersonid,
sum(totalprice) amount
from sales
where date_format(salesdate, '%Y-%m') is not null
group by `year_month`, salespersonid
order by  salespersonid, `year_month`
)
select
`year_month`, salespersonid, amount,
(amount - lag(amount) over(partition by salespersonid))/amount * 100.0 diff
from cte
-- sales person Daphne X King generated the most revenue despite only being with the company for 11 years, 
-- we might want to increase her base salary to keep her incentivized to do a good job, but considering her age of 68 years old, 
-- and the decline of her performance between march and april of 2018 further observation will be necessary.
-- While the decline of performance seems to be the trend among the employees between march and april, employee
-- Jean P Vang and Wendi G Buckley were able to score growth in sales

