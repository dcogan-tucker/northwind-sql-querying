USE Northwind

-- Question 1.1 --
-- Table of Customer ID, Company Name and Address for all Customers
-- in London or Paris.
SELECT c.CustomerID, c.CompanyName, 
    CONCAT(c.Address, ', ', c.City, ', ', c.PostalCode) AS "Address"
FROM Customers c WHERE c.City IN ('Paris', 'London');

-- Question 1.2 --
-- Table of products which come in bottles.
SELECT * FROM Products p
WHERE p.QuantityPerUnit LIKE '%bottle%';

-- Question 1.3 --
-- Table of products, and their suppliers name and country, which come in bottles.
SELECT p.*, s.CompanyName, s.Country FROM Products p
    INNER JOIN Suppliers s ON p.SupplierID = s.SupplierID
WHERE p.QuantityPerUnit LIKE '%bottle%';

-- Question 1.4 --
-- The number of products in each category.
SELECT c.CategoryName, SUM(p.CategoryID) AS "Number In Category"
FROM Products p INNER JOIN Categories c ON p.CategoryID = c.CategoryID
GROUP BY c.CategoryID, c.CategoryName
ORDER BY "Number In Category" DESC;

-- Question 1.5 --
-- The Full Name and City of residence of each employee.
SELECT CONCAT(e.TitleOfCourtesy, ' ', e.FirstName, ' ', e.LastName) AS "Name", 
    e.City AS "City of Residence"
FROM Employees e;

-- Question 1.6 --
-- The sum of total sales for each region, where total sales exceed $1,000,000.
SELECT t.RegionID,
    ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 0) AS "Total Region Sales ($)"
FROM Territories t
    INNER JOIN EmployeeTerritories et ON t.TerritoryID = et.TerritoryID
    INNER JOIN Employees e ON et.EmployeeID = e.EmployeeID
    INNER JOIN Orders o ON e.EmployeeID = o.EmployeeID
    INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY t.RegionID
HAVING SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) > 1000000;

-- Using subquery to avoid calling the aggregate function multiple times.
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

-- Question 1.7 --
-- Number of orders in the USA or UK whihc have a freight value of greather than 100.
SELECT COUNT(o.OrderID) AS "Number of Orders With Freight > 100 from USA or UK"
FROM Orders o WHERE o.Freight > 100 AND o.ShipCountry IN ('UK', 'USA');

-- Question 1.8 --
-- The Order with the greatest total discount.
SELECT TOP 1 od.OrderID AS "Order Number",
     od.UnitPrice * od.Quantity * od.Discount AS "Value of Discount"
FROM [Order Details] od
ORDER BY "Value of Discount" DESC;