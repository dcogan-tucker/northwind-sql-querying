USE Northwind

-- Question 3.1 --
-- A table of each employee and their name and who they report to.
SELECT CONCAT(e.FirstName, ' ', e.lastName) AS "Employee's Name", 
    e2.FirstName + ' ' + e2.LastName AS "Superior's Name"
FROM Employees e LEFT JOIN Employees e2 ON e.ReportsTo = e2.EmployeeID;

-- Question 3.2 --
-- Table of total sales amount for each Supplier.
SELECT s.CompanyName, ROUND(SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)), 0) AS "Total Sales ($)"
FROM Suppliers s 
    INNER JOIN Products p ON s.SupplierID = p.SupplierID
    INNER JOIN [Order Details] od ON p.ProductID = od.ProductID
GROUP BY s.CompanyName, s.SupplierID
HAVING SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)) > 10000
ORDER BY "Total Sales ($)" DESC;

-- Alternate approach using a sub-querey to avoid repeating the aggregate function.
SELECT ts.CompanyName, ts."Total Sales ($)"
FROM (
    SELECT s.CompanyName, ROUND(SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)), 0) AS "Total Sales ($)"
    FROM Suppliers s
        INNER JOIN Products p ON s.SupplierID = p.SupplierID
        INNER JOIN [Order Details] od ON p.ProductID = od.ProductID
    GROUP BY s.CompanyName, s.SupplierID ) ts
WHERE "Total Sales ($)" > 10000
ORDER BY ts."Total Sales ($)" DESC;

-- Question 3.3 --
-- Table of the top 10 Customers based on total spent in YTD.
SELECT TOP 10 c.CustomerID, 
    ROUND(SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)), 0) AS "Total Spent in YTD ($)"
FROM Customers c
    INNER JOIN Orders o ON c.CustomerID = o.CustomerID
    INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE YEAR(o.ShippedDate) = 
    (SELECT MAX(YEAR(ShippedDate)) FROM Orders)
    AND o.ShippedDate IS NOT NULL
GROUP BY c.CustomerID, YEAR(o.ShippedDate)
ORDER BY "Total Spent in YTD ($)" DESC;

-- Question 3.4 --
-- Table of the average ship time in days for each given month.
SELECT CONCAT(MONTH(o.OrderDate), '-', YEAR(o.OrderDate)) AS "Month",  
    AVG(DATEDIFF(d, o.OrderDate, o.ShippedDate)) AS "Avg Ship Time (Days)"
FROM Orders o
GROUP BY MONTH(o.OrderDate), YEAR(o.OrderDate)
ORDER BY YEAR(o.OrderDate), MONTH(o.OrderDate);