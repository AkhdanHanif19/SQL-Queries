select *
from customers;

#altering null values in customers table

select distinct address
from customers
where address is null;

update customers
set middleinitial = ifnull(middleinitial, '');

#concatenating firstname, middleinitial, lastname into 1 column in customers table
select concat(firstname, ' ', middleinitial, ' ', lastname)
from customers;

update customers
set firstname = concat(firstname, ' ', middleinitial, ' ', lastname);

update customers
set firstname = substring_index(firstname, ' ', 1)
where middleinitial = '';

update customers
set firstname = concat(firstname, ' ', lastname)
where middleinitial = '';

alter table customers
drop column middleinitial;

alter table customers
drop column lastname;

alter table customers
rename column firstname to fullname;

#populating total price column from sales table
select *
from sales;

select salesid, a.productid, quantity, discount, b.price, (quantity * (1 - discount) * b.price) totalprice
from sales a 
join products b
	on a.productid = b.productid;
    
UPDATE sales a
JOIN products b ON a.productid = b.productid
SET a.totalprice = a.quantity * (1 - a.discount) * b.price;

#transforming employee table
select *
from employees;

update employees
set firstname = concat(firstname, ' ', middleinitial, ' ', lastname);

update employees
set gender = 'Male'
where gender = 'M';

update employees
set gender = 'Female'
where gender = 'F';

alter table employees
drop column lastname;

alter table employees
drop column MiddleInitial;