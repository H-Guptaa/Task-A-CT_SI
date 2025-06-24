--Q1
SELECT * FROM Sales.Customer;

--Q2
SELECT * 
FROM Sales.Customer c
JOIN Sales.Store s ON c.StoreID = s.BusinessEntityID
WHERE s.Name LIKE '%N';

--Q3
SELECT DISTINCT p.FirstName, p.LastName, a.City
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Person.BusinessEntityAddress bea ON c.PersonID = bea.BusinessEntityID
JOIN Person.Address a ON bea.AddressID = a.AddressID
WHERE a.City IN ('Berlin', 'London');

--Q4
SELECT DISTINCT p.FirstName, p.LastName, sp.Name AS Country
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Person.BusinessEntityAddress bea ON c.PersonID = bea.BusinessEntityID
JOIN Person.Address a ON bea.AddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
WHERE sp.CountryRegionCode IN ('US', 'GB');

--Q5
SELECT Name FROM Production.Product ORDER BY Name;

--Q6
SELECT * FROM Production.Product WHERE Name LIKE 'A%';

--Q7
SELECT DISTINCT c.CustomerID
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID;

--Q8
SELECT DISTINCT p.FirstName, p.LastName
FROM Sales.SalesOrderDetail sod
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Person.BusinessEntityAddress bea ON c.PersonID = bea.BusinessEntityID
JOIN Person.Address a ON bea.AddressID = a.AddressID
JOIN Production.Product prod ON sod.ProductID = prod.ProductID
WHERE prod.Name = 'Chai' AND a.City = 'London';

--Q9
SELECT c.CustomerID
FROM Sales.Customer c
LEFT JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
WHERE soh.CustomerID IS NULL;

--Q10
SELECT DISTINCT c.CustomerID
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
WHERE p.Name = 'Tofu';

--Q11
SELECT TOP 1 *
FROM Sales.SalesOrderHeader
ORDER BY OrderDate ASC;

--Q12
SELECT TOP 1 *
FROM Sales.SalesOrderHeader
ORDER BY TotalDue DESC;

--Q13
SELECT SalesOrderID, AVG(OrderQty) AS AvgQuantity
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID;

--Q14
SELECT SalesOrderID,
       MIN(OrderQty) AS MinQuantity,
       MAX(OrderQty) AS MaxQuantity
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID;

--Q15
SELECT 
    manager.BusinessEntityID AS ManagerID,
    COUNT(emp.BusinessEntityID) AS NumberOfReports
FROM HumanResources.Employee AS emp
JOIN HumanResources.Employee AS manager
    ON manager.OrganizationNode = emp.OrganizationNode.GetAncestor(1)
GROUP BY manager.BusinessEntityID;

--Q16
SELECT SalesOrderID, SUM(OrderQty) AS TotalQuantity
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID
HAVING SUM(OrderQty) > 300;

--Q17
SELECT *
FROM Sales.SalesOrderHeader
WHERE OrderDate >= '1996-12-31';

--Q18
SELECT soh.*
FROM Sales.SalesOrderHeader soh
JOIN Person.Address a ON soh.ShipToAddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
WHERE sp.CountryRegionCode = 'CA';

--Q19
SELECT *
FROM Sales.SalesOrderHeader
WHERE TotalDue > 200;

--Q20
SELECT sp.CountryRegionCode, SUM(soh.TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader soh
JOIN Person.Address a ON soh.ShipToAddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
GROUP BY sp.CountryRegionCode;

--Q21
SELECT 
    p.FirstName + ' ' + p.LastName AS ContactName,
    COUNT(soh.SalesOrderID) AS OrderCount
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
GROUP BY p.FirstName, p.LastName;

--Q22
SELECT 
    p.FirstName + ' ' + p.LastName AS ContactName,
    COUNT(soh.SalesOrderID) AS OrderCount
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
GROUP BY p.FirstName, p.LastName
HAVING COUNT(soh.SalesOrderID) > 3;

--Q23
SELECT DISTINCT p.Name
FROM Production.Product p
JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
WHERE p.DiscontinuedDate IS NOT NULL
AND soh.OrderDate BETWEEN '1997-01-01' AND '1998-01-01';

--Q24
SELECT 
    e.BusinessEntityID AS EmployeeID,
    pe.FirstName AS EmployeeFirstName,
    pe.LastName AS EmployeeLastName,
    pm.FirstName AS ManagerFirstName,
    pm.LastName AS ManagerLastName
FROM HumanResources.Employee AS e
JOIN Person.Person AS pe ON e.BusinessEntityID = pe.BusinessEntityID
JOIN HumanResources.Employee AS m
    ON m.OrganizationNode = e.OrganizationNode.GetAncestor(1)
JOIN Person.Person AS pm ON m.BusinessEntityID = pm.BusinessEntityID;

--Q25
SELECT 
    SalesPersonID,
    SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader
WHERE SalesPersonID IS NOT NULL
GROUP BY SalesPersonID;

--Q26
SELECT *
FROM Person.Person
WHERE FirstName LIKE '%a%';

--Q27
SELECT 
    m.BusinessEntityID AS ManagerID,
    COUNT(e.BusinessEntityID) AS ReportCount
FROM HumanResources.Employee AS e
JOIN HumanResources.Employee AS m
    ON m.OrganizationNode = e.OrganizationNode.GetAncestor(1)
GROUP BY m.BusinessEntityID
HAVING COUNT(e.BusinessEntityID) > 4;

--Q28
SELECT 
    sod.SalesOrderID,
    p.Name AS ProductName
FROM Sales.SalesOrderDetail sod
JOIN Production.Product p ON sod.ProductID = p.ProductID;

--Q29
SELECT TOP 1 soh.CustomerID, SUM(TotalDue) AS TotalSpent
FROM Sales.SalesOrderHeader soh
GROUP BY soh.CustomerID
ORDER BY SUM(TotalDue) DESC;

--Q30
SELECT soh.*
FROM Sales.SalesOrderHeader soh
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Person.ContactType ct ON ct.ContactTypeID = c.StoreID -- fallback logic
WHERE p.EmailPromotion = 0 -- Assuming no fax is implied by no promotion
--Note: AdventureWorks doesn't store fax directly per customer, so assumption is made.

--Q31
SELECT DISTINCT a.PostalCode
FROM Sales.SalesOrderDetail sod
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Person.Address a ON soh.ShipToAddressID = a.AddressID
WHERE p.Name = 'Tofu';

--Q32
SELECT DISTINCT a.PostalCode
FROM Sales.SalesOrderDetail sod
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Person.Address a ON soh.ShipToAddressID = a.AddressID
WHERE p.Name = 'Tofu';

--Q33
SELECT pr.Name AS ProductName, pc.Name AS Category
FROM Production.Product pr
JOIN Production.ProductSubcategory ps ON pr.ProductSubcategoryID = ps.ProductSubcategoryID
JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
JOIN Purchasing.ProductVendor pv ON pr.ProductID = pv.ProductID
JOIN Purchasing.Vendor v ON pv.BusinessEntityID = v.BusinessEntityID
WHERE v.Name = 'Specialty Biscuits, Ltd.';

--Q34
SELECT p.Name
FROM Production.Product p
LEFT JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
WHERE sod.ProductID IS NULL;

--Q35
SELECT Name, SafetyStockLevel, ReorderPoint
FROM Production.Product
WHERE SafetyStockLevel < 10 AND ReorderPoint = 0;

--Q36
SELECT TOP 10 sp.CountryRegionCode, SUM(soh.TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader soh
JOIN Person.Address a ON soh.ShipToAddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
GROUP BY sp.CountryRegionCode
ORDER BY TotalSales DESC;

--Q37
-- Note: CustomerID in AdventureWorks is numeric. This seems to reference a different schema.
-- Providing a relevant adjusted version:
SELECT SalesPersonID, COUNT(*) AS OrderCount
FROM Sales.SalesOrderHeader
WHERE SalesPersonID IS NOT NULL
GROUP BY SalesPersonID;

--Q38

SELECT TOP 1 OrderDate, TotalDue
FROM Sales.SalesOrderHeader
ORDER BY TotalDue DESC;

--Q39
SELECT p.Name, SUM(sod.LineTotal) AS Revenue
FROM Sales.SalesOrderDetail sod
JOIN Production.Product p ON sod.ProductID = p.ProductID
GROUP BY p.Name
ORDER BY Revenue DESC;

--Q40
SELECT pv.BusinessEntityID AS SupplierID, COUNT(*) AS ProductCount
FROM Purchasing.ProductVendor pv
GROUP BY pv.BusinessEntityID;

--Q41
SELECT TOP 10 soh.CustomerID, SUM(TotalDue) AS TotalSpent
FROM Sales.SalesOrderHeader soh
GROUP BY soh.CustomerID
ORDER BY TotalSpent DESC;

--Q42
SELECT SUM(TotalDue) AS TotalCompanyRevenue
FROM Sales.SalesOrderHeader;

