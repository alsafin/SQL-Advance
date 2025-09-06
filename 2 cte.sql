
/*
CTE-common table expression
Temporary,named result set(virtual table), that canbe used multiple time within query to simplify and organize complex query
When to use/why cte?
- Simplify complex queries by breaking them into readable steps.
- Enable recursion for hierarchical data (e.g., org charts, category trees).
-Reuse logic without repeating subqueries.
-Debug easily by isolating each transformation.
- one cte we can use multiple time but in subquery every time we need write subquery
NOTE: can not use order by in CTE
Types of CTE:
	-Non-Recurrsive CTE(Standalone CTE and	Nested CTE)
	-Recursive CTE
*/
---Non-Recurrsive CTE(Standalone CTE and	Nested CTE)
/*
StandAlone CTE:
-Defined and used independently
-Doesn;t rely on other CTE query
*/
USE SalesDB;

--tasl-1: 1.find the total sale per customer and 2. also find the last order date for each customer 3. rank the customer based on total sales per customer 4. segment customer based on their total sales
--step 1
WITH CTE_Total_Sales as 
(
select
	CustomerID,
	SUM(sales) as TotalSales
from
Sales.Orders
Group By CustomerID
)
/*
Multiple standalone CTE

*/
--step-2
, CTE_Last_Order as 
(
select
customerID,
MAX(OrderDate) as Last_order
from Sales.Orders
Group BY CustomerID

)

/*
Nested CTE
-CTE inside another CTE
*/
--step 3
,CTE_Cutomer_Rank as
(
Select
CustomerId,
TotalSales,
RANK() over( order BY TotalSales desc ) as Customer_Rank
From
CTE_Total_Sales

)

--step 4.(Nested CTE)
,CTE_Customer_Segment as
(
select
CustomerID,
Case When TotalSales>100 then  'high'
		when TotalSales  > 80 then 'medium'
		else  'low'
End Customer_Segment
from
CTE_Total_Sales
)

--main query

select
c.CustomerID,
c.FirstName,
c.LastName,
ct.TotalSales,
clo.Last_order,
ccr.Customer_Rank,
ccg.Customer_Segment
from Sales.Customers c
left join  CTE_Total_Sales  CT  on  CT.CustomerID = c.CustomerID
left join CTE_Last_Order clo on clo.CustomerID = c.CustomerID
left join CTE_Cutomer_Rank ccr on ccr.CustomerID = c.CustomerID
left join CTE_Customer_Segment ccg on ccg.CustomerID = c.CustomerID;



--recursive cte

--generate a squence of numbers from 1 to 20
--anchor query

with Series as (
--anchor query
select 
1 as myNumber
union all 
--recursive query
select
myNumber +1
from Series
where myNumber  < 20
)

select *
from series;


-- show the employee hierachy by displaying each employee level within the organization
--anchor query
WITH cte_emp_hierarchy AS (
    -- Anchor member: top-level managers
    SELECT
        EmployeeID,
        FirstName,
        ManagerID,
        1 AS Level
    FROM Sales.Employees
    WHERE ManagerID IS NULL

    UNION ALL

    -- Recursive member: employees reporting to previous level
    SELECT
        e.EmployeeID,
        e.FirstName,
        e.ManagerID,
        ceh.Level + 1
    FROM Sales.Employees AS e
    INNER JOIN cte_emp_hierarchy AS ceh
        ON e.ManagerID = ceh.EmployeeID
)

SELECT *
FROM cte_emp_hierarchy;
