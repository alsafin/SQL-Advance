use SalesDB
--use case:create a table using ctas that show total number of order each month
--for refreshing or update ctas

If OBJECT_ID('sales.MonthlyOrder',  'U') is not null

	DROP  Table  sales.MonthlyOrder;
GO
--main query
select
	DATENAME(month, OrderDate) OrderMonth,
	COUNT(orderID) TotalOrder
INTO sales.MonthlyOrder
from Sales.Orders
Group By DATENAME(month, OrderDate)

--use case: Creating a snapshot		
