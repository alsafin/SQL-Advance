/*
Use case of Views
-Central Query logic-Store central,complex query logic in the database for access by multiple queries , reducing project complexity
Views Vs Cte:
Views-
-Reduce redundency within in multi-queries
CTE-
-reduce Redundency in 1 query

*/
use SalesDB

-- task-1:find the running total of sales for each month
--using cte
/*
WITH CTE_monthly_summery as 
(
select
DATETRUNC(month, OrderDate) as OrderMonth,
SUM(SALES) TotalSales,
COUNT(orderid) as TotalOrder,
SUM(quantity) as TotalSellQty
from
Sales.Orders
GROUP BY DATETRUNC(month, OrderDate)
)

select
OrderMonth,
TotalSales,
SUM(TotalSales) over(order by OrderMonth) as RunningTotal
from
CTE_monthly_summery

*/



-- Drop the view if it exists
DROP VIEW IF EXISTS v_monthly_summary;
GO

-- Create the view in a clean batch
CREATE VIEW v_monthly_summary AS
(
SELECT
    DATETRUNC(month, OrderDate) as OrderMonth,
    SUM(Sales) AS TotalSales,
    COUNT(OrderID) AS TotalOrders,
    SUM(Quantity) AS TotalSellQty
FROM Sales.Orders
GROUP BY DATETRUNC(month, OrderDate) 
);
GO
--Task-2:provide a view that combines details from orders,products,customersa nd employees
DROP VIEW IF EXISTS sales.details;
GO
Create view  sales.details as
(
    select
    O.OrderID,
    O.OrderDate,
    p.Product,
    p.Category,
    coalesce(c.FirstName,' ' ) + ' ' + coalesce( c.LastName , ' ' )as CustomerName,
    c.country as Country,
    coalesce(E.FirstName,' ' ) + ' ' + coalesce( E.LastName , ' ' )as SalesName,
    E.Department,
    O.Sales,
    O.Quantity
    from sales.Orders as O
    left join Sales.Products p
    on p.ProductID= o.ProductID
    left join Sales.Customers as c
    on c.CustomerID=o.CustomerID
    left join Sales.Employees as E
    on E.EmployeeID = o.SalesPersonID
    );
GO

--use case: Data Security
--Task-3: provide a views for the eu sales team that combines details from all tables and exclude data related to the usa 

DROP VIEW IF EXISTS v_order_details_eu;
GO

create view v_order_details_eu as 
(
 select
    O.OrderID,
    O.OrderDate,
    p.Product,
    p.Category,
    coalesce(c.FirstName,' ' ) + ' ' + coalesce( c.LastName , ' ' )as CustomerName,
    c.country as Country,
    coalesce(E.FirstName,' ' ) + ' ' + coalesce( E.LastName , ' ' )as SalesName,
    E.Department,
    O.Sales,
    O.Quantity
    from sales.Orders as O
    left join Sales.Products p
    on p.ProductID= o.ProductID
    left join Sales.Customers as c
    on c.CustomerID=o.CustomerID
    left join Sales.Employees as E
    on E.EmployeeID = o.SalesPersonID
    where c.Country != 'USA' --hide row all usa info
);
GO

/*
--use case: 
store central complex business logic to be reused,
flexibility and dynamic,
create in multiple language,
can be used as data marts in data warehouse system because they provide a flexible and efficient way to pres

*/


