<h1 align="center"> SQL Mini Project </h1>

<br>

## Table of Contents

### [Question 1](q1)
### [Question 2](#q2)
### [Question 3](#q3)

<div id='q1'/>

<br>

## Question 1 - Northwind Queries

1.1. _**Write a query that lists all Customers in either Paris or London. Include Customer ID, Company Name and all address fields.**_

```sql
SELECT c.CustomerID AS "Customer ID",
	c.CompanyName AS "Company Name",
    CONCAT(c.Address, ', ', c.City, ', ', c.PostalCode) AS "Address"
FROM Customers c WHERE c.City IN ('Paris', 'London');
```

1.2. _**List all products stored in bottles.**_

```sql
SELECT * FROM Products p
WHERE p.QuantityPerUnit LIKE '%bottles%';
```

1.3. _**Repeat question above, but add in the Supplier Name and Country.**_

```sql
SELECT p.*, s.CompanyName, s.Country FROM Products p
    INNER JOIN Suppliers s ON p.SupplierID = s.SupplierID
WHERE p.QuantityPerUnit LIKE '%bottle%';
```

1.4. _**Write an SQL Statement that shows how many products there are in each category. Include Category Name in result set and list the highest number first.**_

```sql
SELECT c.CategoryName, SUM(p.CategoryID) AS "Number In Category"
FROM Products p INNER JOIN Categories c ON p.CategoryID = c.CategoryID
GROUP BY c.CategoryID, c.CategoryName
ORDER BY "Number In Category" DESC;
```

1.5. _**List all UK employees using concatenation to join their title of courtesy, first name and last name together. Also include their city of residence.**_

```sql
SELECT CONCAT(e.TitleOfCourtesy, ' ', e.FirstName, ' ', e.LastName) AS "Name", 
    e.City AS "City of Residence"
FROM Employees e;
```

1.6. _**List Sales Totals for all Sales Regions (via the Territories table using 4 joins) with a Sales Total greater than 1,000,000. Use rounding or FORMAT to present the numbers.**_

```sql
SELECT t.RegionID, 
    ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 0) AS "Total Region Sales ($)"
FROM Territories t
    INNER JOIN EmployeeTerritories et ON t.TerritoryID = et.TerritoryID
    INNER JOIN Employees e ON et.EmployeeID = e.EmployeeID
    INNER JOIN Orders o ON e.EmployeeID = o.EmployeeID
    INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY t.RegionID
HAVING SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) > 1000000;
```

Alternative approach using an advanced subquerey to avoid repeating the aggregate function.

```sql
 SELECT rs.RegionID, rs."Total Region Sales ($)"
FROM
( SELECT t.RegionID, ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 0) AS "Total Region Sales ($)"
    FROM Territories t
        INNER JOIN EmployeeTerritories et ON t.TerritoryID = et.TerritoryID
        INNER JOIN Employees e ON et.EmployeeID = e.EmployeeID
        INNER JOIN Orders o ON e.EmployeeID = o.EmployeeID
        INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
    GROUP BY t.RegionID ) rs
WHERE "Total Region Sales ($)" > 1000000;
```

1.7. _**Count how many Orders have a Freight amount greater than 100.00 and either USA or UK as Ship Country.**_

```sql
SELECT COUNT(o.OrderID) AS "Number of Orders With Freight > 100 from USA or UK"
FROM Orders o WHERE o.Freight > 100 AND o.ShipCountry IN ('UK', 'USA');
```

1.8. _**Write an SQL Statement to identify the Order Number of the Order with the highest amount(value) of discount applied to that order.**_

```sql
SELECT TOP 1 od.OrderID AS "Order Number",
     od.UnitPrice * od.Quantity * od.Discount AS "Value of Discount"
FROM [Order Details] od
ORDER BY "Value of Discount" DESC;
```

<div id='q2'/>

## Question 2 - Table Creation

2.1. _**Write the correct SQL statement to create the following table:**_
	_**Spartans Table – include details about all the Spartans on this course. Separate Title, First Name and Last Name into separate columns, and include University attended, course taken and mark achieved. Add any other columns you feel would be appropriate.**_

```sql
CREATE TABLE spartans_table
(
    id INT IDENTITY(1, 1) PRIMARY KEY,
    first_name VARCHAR(15),
    last_name VARCHAR(15),
    university_name VARCHAR(15),
    course_taken VARCHAR(15),
    mark_achieved INT
)
```

2.2. _**Write SQL statements to add the details of the Spartans in your course to the table you have created.**_

```sql
INSERT INTO spartans_table
(first_name, last_name, university_name, course_taken, mark_achieved)
VALUES
('Dominic', 'Cogan-Tucker', 'Birmingham', 'Comp Sci MSc', 100),
('Kurtis', 'Hanson', 'London', 'Comp Sci BSc', 90),
('Bradley', 'Williams', 'York', 'Comp Sci BSc', 85),
('Aaron', 'Banjoko', 'London', 'Comp Sci BSc', 95),
('Malik', 'Shams', 'London', 'Comp Sci MSc', 75),
('Wahdel', 'Woodhouse', 'Manchester', 'Comp Sci', 80),
('Joel', 'Fright', 'York', 'Comp Sci BSc', 99);

SELECT * FROM spartans_table;
```

<div id='q3'/>

## Question 3 - Data Analysis

3.1. _**List all Employees from the Employees table and who they report to. No Excel required. Include Employee names and ReportTo names.**_

```sql
SELECT CONCAT(e.FirstName, ' ', e.lastName) AS "Employee's Name", 
    CONCAT(e2.FirstName, ' ', e2.LastName) AS "Superior's Name"
FROM Employees e LEFT JOIN Employees e2 ON e.ReportsTo = e2.EmployeeID;
```

3.2. _**List all Suppliers with total sales over $10,000 in the Order Details table. Include the Company Name from the Suppliers Table and present as a bar chart as below:**_

```sql
SELECT s.CompanyName, ROUND(SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)), 0) AS "Total Sales ($)"
FROM Suppliers s 
    INNER JOIN Products p ON s.SupplierID = p.SupplierID
    INNER JOIN [Order Details] od ON p.ProductID = od.ProductID
GROUP BY s.CompanyName, s.SupplierID
HAVING SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)) > 10000
ORDER BY "Total Sales ($)" DESC;
```

Alternative approach using an advanced subquerey to avoid repeating the aggregate function.

```sql
SELECT ts.CompanyName, ts."Total Sales ($)"
FROM
( SELECT s.CompanyName, ROUND(SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)), 0) AS "Total Sales ($)"
    FROM Suppliers s
        INNER JOIN Products p ON s.SupplierID = p.SupplierID
        INNER JOIN [Order Details] od ON p.ProductID = od.ProductID
    GROUP BY s.CompanyName, s.SupplierID ) ts
WHERE "Total Sales ($)" > 10000
ORDER BY ts."Total Sales ($)" DESC;
```

![](totalsales.png)

3.3. _**List the Top 10 Customers YTD for the latest year in the Orders file. Based on total value of orders shipped. No Excel required.**_

```sql
SELECT TOP 10 c.CustomerID, 
    ROUND(SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)), 0) AS "Total Spent in YTD ($)"
FROM Customers c
    INNER JOIN Orders o ON c.CustomerID = o.CustomerID
    INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, YEAR(o.ShippedDate)
HAVING YEAR(o.ShippedDate) = 
    (SELECT MAX(YEAR(ShippedDate)) FROM Orders)
ORDER BY "Total Spent in YTD ($)" DESC;
```

3. 4. _**Plot the Average Ship Time by month for all data in the Orders Table using a line chart as below.**_

```sql
SELECT CONCAT(MONTH(o.OrderDate), '-', YEAR(o.OrderDate)) AS "Month",  
    AVG(DATEDIFF(d, o.OrderDate, o.ShippedDate)) AS "Avg Ship Time (Days)"
FROM Orders o
GROUP BY MONTH(o.OrderDate), YEAR(o.OrderDate)
ORDER BY YEAR(o.OrderDate), MONTH(o.OrderDate);
```

![](averageshipdays.png)