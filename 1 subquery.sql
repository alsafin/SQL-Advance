/*
----Subquery:-----
a query inside another query
--why this:
--two category:
1.non correlated
2.correlated(not dependent)
--result types:
1.scaler subquery:--return only one signle value like avg
2.row subquery,-return only one column
3.table subquery--returen more than one column
*/
use SalesDB
--task-1:find the prodcut that have a price than avg price of all product

select
ProductID,
PRODUCT,
price,
avg_product_price
from(
	select
	ProductID,
	Product,
	price,
	avg(price) over() as avg_product_price
	from 
	Sales.Products
)t
where Price > avg_product_price;


--task-2: Rank the customer based on their total amount of sales
select
customerid,
Total_sales,
RANK() over( order by  Total_sales desc) CustomerRank

from(
	select
	CustomerID,
	
	SUM(sales)  Total_sales
	from 
	Sales.Orders
	group by CustomerID
	)t;

	--subquery in select clause(only allowed  scaler sub query)

	--task-3: show the product ids, product names, prices and the total number of orders
select
ProductID,
Product,
Price,
(select  count(*)  from Sales.Orders) as total_ordedrs 
from Sales.Products;

/*
--join subquery:-
Used to prepare the data(filtering or aggregation) before joinning it with other tables
*/

--task-4: show customer details and find the total ordersfor each customer

select
C.*,
O.total_orders
from
Sales.Customers C
left join(
select 
customerid,
count(*) as total_orders
from Sales.orders
group by CustomerID) O

on C.CustomerID = O.CustomerID

/*
--subquery in where clause
Used for complex filtering logic and makes query flexible and dynamic
*/

--task-5: show the details of orders made by customer in Germany

select
*
from Sales.orders
where  customerid in (
select
CustomerID
from
Sales.Customers
where Country = 'Germany'
)

--Operato any
--check if a value mathces any value within a list
--task-6: find female employees whose salaries are greater than the salaries of any male employee
select
employeeId,
FirstName,
salary
from
sales.Employees
where gender='F'
and salary > any (select salary from sales.Employees where gender='M')

--all operator
--check if a value within a list
--task-7: find female employees whose salaries are greater than the salaries of all male employee
select
employeeId,
FirstName,
salary
from
sales.Employees
where gender='F'
and salary > all (select salary from sales.Employees where gender='M')

/*
subquery---
-non correlated : a subquery that can run independently from the main query
-correlated : A subquery that relays on values from the main query

*/
--task-8: show all customer details and find the total orders of each customer

select
*,
( select count(*) from sales.Orders o where o.CustomerID = c.CustomerID) TotalSales
from
sales.customers c

/*
Exist operator-
check if a subquery return any row
*/