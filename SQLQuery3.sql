USE AdventureWorks2019;

-- 1. List of all customers
SELECT * FROM Sales.Customer;

-- 2. Customers where company name ends with 'N'
SELECT * FROM Sales.Store WHERE Name LIKE '%N';

-- 3. Customers who live in Berlin or London
SELECT * FROM Person.Address WHERE City IN ('Berlin', 'London');

-- 4. Customers who live in UK or USA
SELECT * FROM Person.CountryRegion WHERE Name IN ('United Kingdom', 'United States');

-- 5. All products sorted by product name
SELECT Name FROM Production.Product ORDER BY Name;

-- 6. Products where name starts with 'A'
SELECT * FROM Production.Product WHERE Name LIKE 'A%';

-- 7. List of customers who ever placed an order
SELECT DISTINCT CustomerID FROM Sales.SalesOrderHeader;

-- 8. Customers who live in London and have bought chai
SELECT DISTINCT c.CustomerID
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product pr ON sod.ProductID = pr.ProductID
JOIN Person.BusinessEntityAddress bea ON p.BusinessEntityID = bea.BusinessEntityID
JOIN Person.Address a ON bea.AddressID = a.AddressID
WHERE a.City = 'London'
  AND pr.Name = 'Chai';


-- 9. Customers who never placed an order
SELECT CustomerID
FROM Sales.Customer
WHERE CustomerID NOT IN (SELECT DISTINCT CustomerID FROM Sales.SalesOrderHeader);

-- 10. Customers who ordered Tofu
SELECT DISTINCT c.CustomerID
FROM Sales.Customer c, Sales.SalesOrderHeader soh, Sales.SalesOrderDetail sod, Production.Product p
WHERE c.CustomerID = soh.CustomerID
  AND soh.SalesOrderID = sod.SalesOrderID
  AND sod.ProductID = p.ProductID
  AND p.Name = 'Tofu';

-- 11. Details of first order of the system
SELECT TOP 1 * FROM Sales.SalesOrderHeader ORDER BY OrderDate;

-- 12. Details of most expensive order date
SELECT TOP 1 * FROM Sales.SalesOrderHeader ORDER BY TotalDue DESC;

-- 13. OrderID and average quantity of items in that order
SELECT SalesOrderID, AVG(OrderQty) AS AvgQuantity
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID;

-- 14. OrderID, minimum and maximum quantity in that order
SELECT SalesOrderID, MIN(OrderQty) AS MinQuantity, MAX(OrderQty) AS MaxQuantity
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID;

-- 15. List of all managers and total number of employees reporting to them
SELECT mgr.BusinessEntityID AS ManagerID, COUNT(emp.BusinessEntityID) AS NumberOfEmployees
FROM HumanResources.Employee mgr, HumanResources.Employee emp
WHERE emp.OrganizationNode.GetAncestor(1) = mgr.OrganizationNode
GROUP BY mgr.BusinessEntityID;

-- 16. OrderID and total quantity for each order with total quantity > 300
SELECT SalesOrderID, SUM(OrderQty) AS TotalQuantity
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID
HAVING SUM(OrderQty) > 300;

-- 17. List of all orders placed on or after 1996-12-31
SELECT * FROM Sales.SalesOrderHeader WHERE OrderDate >= '1996-12-31';

-- 16. OrderID and total quantity for orders with total quantity > 300
SELECT SalesOrderID, SUM(OrderQty) AS TotalQuantity
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID
HAVING SUM(OrderQty) > 300;


-- 17. List of all orders placed on or after 1996-12-31
SELECT *
FROM Sales.SalesOrderHeader
WHERE OrderDate >= '1996-12-31';


-- 18. List of all orders shipped to Canada
SELECT soh.*
FROM Sales.SalesOrderHeader soh
JOIN Person.Address a ON soh.ShipToAddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
WHERE sp.CountryRegionCode = 'CA';





-- 19. List of all orders with total due > 200
SELECT *
FROM Sales.SalesOrderHeader
WHERE TotalDue > 200;

-- 20. List of countries and total sales made in each country
SELECT cr.Name AS Country, SUM(soh.TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader soh
JOIN Person.Address a ON soh.BillToAddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
JOIN Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode
GROUP BY cr.Name;

-- 21. List of Customer ContactName and number of orders they placed
SELECT c.CustomerID, c.PersonID, p.FirstName, p.LastName, COUNT(soh.SalesOrderID) AS NumberOfOrders
FROM Sales.Customer c
LEFT JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
LEFT JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
GROUP BY c.CustomerID, c.PersonID, p.FirstName, p.LastName;


-- 22. List of customer contact names who have placed more than 3 orders
SELECT c.CustomerID, p.FirstName, p.LastName, COUNT(soh.SalesOrderID) AS NumberOfOrders
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
GROUP BY c.CustomerID, p.FirstName, p.LastName
HAVING COUNT(soh.SalesOrderID) > 3;


-- 23. List of discontinued products ordered between 1/1/1997 and 1/1/1998
SELECT DISTINCT p.ProductID, p.Name
FROM Production.Product p
JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
WHERE p.DiscontinuedDate IS NOT NULL
  AND soh.OrderDate >= '1997-01-01'
  AND soh.OrderDate < '1998-01-01';

-- 24. List of employee firstname, lastname, supervisor firstname, lastname
SELECT 
    e.BusinessEntityID,
    e.JobTitle,
    eH.FirstName AS EmployeeFirstName,
    eH.LastName AS EmployeeLastName,
    sH.FirstName AS SupervisorFirstName,
    sH.LastName AS SupervisorLastName
FROM HumanResources.Employee e
JOIN HumanResources.vEmployee eH ON e.BusinessEntityID = eH.BusinessEntityID
LEFT JOIN HumanResources.Employee s 
    ON e.OrganizationNode.GetAncestor(1) = s.OrganizationNode
LEFT JOIN HumanResources.vEmployee sH ON s.BusinessEntityID = sH.BusinessEntityID
ORDER BY e.BusinessEntityID;



-- 25. List of employee IDs and total sales conducted by employee
SELECT sp.BusinessEntityID, v.FirstName, v.LastName, SUM(soh.TotalDue) AS TotalSales
FROM Sales.SalesPerson sp
JOIN Sales.SalesOrderHeader soh ON sp.BusinessEntityID = soh.SalesPersonID
JOIN HumanResources.vEmployee v ON sp.BusinessEntityID = v.BusinessEntityID
GROUP BY sp.BusinessEntityID, v.FirstName, v.LastName;

-- 26: Employees whose FirstName contains 'a'
SELECT FirstName, LastName
FROM HumanResources.vEmployee
WHERE FirstName LIKE '%a%';

-- 27: Managers with more than 4 direct reports
SELECT 
    sH.FirstName AS ManagerFirstName,
    sH.LastName AS ManagerLastName,
    COUNT(e.BusinessEntityID) AS NumberOfReports
FROM HumanResources.Employee e
LEFT JOIN HumanResources.Employee s 
    ON e.OrganizationNode.GetAncestor(1) = s.OrganizationNode
JOIN HumanResources.vEmployee sH 
    ON s.BusinessEntityID = sH.BusinessEntityID
GROUP BY sH.FirstName, sH.LastName
HAVING COUNT(e.BusinessEntityID) > 4;

-- 28: List all Orders with their Product Names
SELECT 
    soh.SalesOrderID, 
    p.Name AS ProductName
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod 
    ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p 
    ON sod.ProductID = p.ProductID;

-- 29: Orders placed by the customer with the highest number of orders
WITH BestCustomer AS (
    SELECT TOP 1 CustomerID, COUNT(*) AS OrderCount
    FROM Sales.SalesOrderHeader
    GROUP BY CustomerID
    ORDER BY OrderCount DESC
)
SELECT 
    soh.SalesOrderID, 
    soh.CustomerID, 
    c.AccountNumber
FROM Sales.SalesOrderHeader soh
JOIN BestCustomer bc 
    ON soh.CustomerID = bc.CustomerID
JOIN Sales.Customer c 
    ON soh.CustomerID = c.CustomerID;

-- 30.List of orders placed by customers who do not have a Fax number
DECLARE @FaxTypeID INT;

SELECT @FaxTypeID = PhoneNumberTypeID
FROM Person.PhoneNumberType
WHERE Name = 'Fax';

WITH CustomersWithoutFax AS (
    SELECT c.CustomerID
    FROM Sales.Customer c
    LEFT JOIN Person.Person p ON c.CustomerID = p.BusinessEntityID
    LEFT JOIN Person.PersonPhone pp 
        ON p.BusinessEntityID = pp.BusinessEntityID AND pp.PhoneNumberTypeID = @FaxTypeID
    WHERE pp.PhoneNumber IS NULL
)

SELECT soh.SalesOrderID, soh.CustomerID
FROM Sales.SalesOrderHeader soh
JOIN CustomersWithoutFax c
    ON soh.CustomerID = c.CustomerID;

-- 31.List of Postal codes where the product Tofu was shipped
SELECT DISTINCT a.PostalCode
FROM Sales.SalesOrderHeader h
JOIN Sales.SalesOrderDetail d ON h.SalesOrderID = d.SalesOrderID
JOIN Production.Product p ON d.ProductID = p.ProductID
JOIN Person.Address a ON h.ShipToAddressID = a.AddressID
WHERE p.Name = 'Tofu';

-- 32. List of product names that were shipped to France
SELECT DISTINCT p.Name
FROM Sales.SalesOrderHeader h
JOIN Sales.SalesOrderDetail d ON h.SalesOrderID = d.SalesOrderID
JOIN Production.Product p ON d.ProductID = p.ProductID
JOIN Person.Address a ON h.ShipToAddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
JOIN Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode
WHERE cr.Name = 'France';

-- 33. List of product names and categories for the supplier 'Specialty Biscuits, Ltd.'
SELECT p.Name AS ProductName, pc.Name AS Category
FROM Production.Product p
JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
JOIN Purchasing.ProductVendor pv ON p.ProductID = pv.ProductID
JOIN Purchasing.Vendor v ON pv.BusinessEntityID = v.BusinessEntityID
WHERE v.Name = 'Specialty Biscuits, Ltd.';

-- 34. List of products that were never ordered
SELECT p.Name
FROM Production.Product p
LEFT JOIN Sales.SalesOrderDetail d ON p.ProductID = d.ProductID
WHERE d.ProductID IS NULL;

-- 35. Products where units in stock < 10 and units on order = 0
SELECT Name
FROM Production.Product
WHERE SafetyStockLevel < 10 AND ReorderPoint = 0;

-- 36. Top 10 countries by sales
SELECT TOP 10 cr.Name AS Country, SUM(h.TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader h
JOIN Person.Address a ON h.BillToAddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
JOIN Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode
GROUP BY cr.Name
ORDER BY TotalSales DESC;

-- 37. Number of orders each employee has taken for customers with IDs between 'A' and 'AO'
SELECT e.BusinessEntityID, COUNT(h.SalesOrderID) AS OrderCount
FROM Sales.SalesOrderHeader h
JOIN HumanResources.Employee e ON h.SalesPersonID = e.BusinessEntityID
JOIN Sales.Customer c ON h.CustomerID = c.CustomerID
WHERE c.AccountNumber BETWEEN 'A' AND 'AO'
GROUP BY e.BusinessEntityID;

-- 38. Order date of the most expensive order
SELECT TOP 1 OrderDate
FROM Sales.SalesOrderHeader
ORDER BY TotalDue DESC;

-- 39. Product name and total revenue from that product
SELECT p.Name, SUM(d.LineTotal) AS TotalRevenue
FROM Sales.SalesOrderDetail d
JOIN Production.Product p ON d.ProductID = p.ProductID
GROUP BY p.Name
ORDER BY TotalRevenue DESC;

-- 40. Supplier ID and number of products offered
SELECT pv.BusinessEntityID AS SupplierID, COUNT(pv.ProductID) AS ProductCount
FROM Purchasing.ProductVendor pv
GROUP BY pv.BusinessEntityID;

-- 41. Top 10 customers based on their business (total order value)
SELECT TOP 10 c.CustomerID, SUM(h.TotalDue) AS TotalSpent
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader h ON c.CustomerID = h.CustomerID
GROUP BY c.CustomerID
ORDER BY TotalSpent DESC;

-- 42. What is the total revenue of the company?
SELECT SUM(TotalDue) AS TotalRevenue
FROM Sales.SalesOrderHeader;





