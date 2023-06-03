use AdventureWorks;

ALTER TABLE `department` RENAME COLUMN `Group` TO `Groupp`;
ALTER TABLE `SalesTerritory` RENAME COLUMN `Group` TO `Groupp`;


use AdventureWorksDWH;
-- Date:
INSERT INTO AdventureWorksDWH.Date(day, month, year) 
SELECT day(BirthDate),month(BirthDate),year(BirthDate)
FROM AdventureWorks.Employee;


-- Contact:
INSERT INTO AdventureWorksDWH.Contact(ContactID,FirstName,MiddleName,LastName,EmailAddress,Phone,PasswordHash)
SELECT ContactID,FirstName,MiddleName,LastName,EmailAddress,Phone,PasswordHash
FROM AdventureWorks.contact;


-- CountryRegion:
INSERT INTO AdventureWorksDWH.CountryRegion(CountryRegionCode,Name)
SELECT CountryRegionCode,Name
FROM AdventureWorks.countryregion;


-- AgeGroup:
INSERT INTO AgeGroup
VALUES(1, 'young', 227,125), (2,'meduim', 125, 104), (3, 'old',104, 268),(4, 'older',268,174);


CREATE VIEW OfferStartDateView AS
SELECT SO.SpecialOfferID, DS.DateID AS StartDateID
FROM AdventureWorks.SpecialOffer as SO join adventureworksdwh.DateS as DS on (year(SO.StartDate) = DS.year) AND (month(SO.StartDate) = DS.month) AND (day(SO.StartDate) =DS.day);

CREATE VIEW OfferEndDateView AS
SELECT SO.SpecialOfferID, DS.DateID AS EndDateID
FROM AdventureWorks.SpecialOffer as SO join adventureworksdwh.DateS as DS on (year(SO.EndDate) = DS.year) AND (month(SO.EndDate) = DS.month) AND (day(SO.EndDate) =DS.day);

-- DateS:
INSERT INTO AdventureWorksDWH.DateS(day, month, year) 
SELECT day(OrderDate),month(OrderDate),year(OrderDate)
FROM AdventureWorks.SalesOrderHeader
UNION
SELECT day(EndDate),month(EndDate),year(EndDate)
FROM AdventureWorks.SpecialOffer 
UNION
SELECT day(StartDate),month(EndDate),year(EndDate)
FROM AdventureWorks.SpecialOffer;


-- -- SpecialOffer:
INSERT INTO AdventureWorksDWH.SpecialOffer(SpecialOfferID,Description,DiscountPct,Type,StartDateID,EndDateID,MinQty,MaxQty)
SELECT SO.SpecialOfferID,SO.Description,SO.DiscountPct,SO.Type,OSDV.StartDateID,OEDV.EndDateID,SO.MinQty,SO.MaxQty
FROM adventureworks.specialoffer AS SO left outer join adventureworksdwh.OfferStartDateView AS OSDV ON (SO.SpecialOfferID = OSDV.SpecialOfferID)
	 left outer join AdventureWorksDWH.OfferEndDateView as OEDV ON (SO.SpecialOfferID = OEDV.SpecialOfferID);


-- Department:
insert into AdventureWorksDWH.Department(DepartmentID,Name,Groupp)
SELECT DepartmentID,Name,Groupp
FROM AdventureWorks.department;


-- ProductModel:
INSERT INTO AdventureWorksDWH.ProductModel(ProductModelID,Name,CatalogDescription,Instructions)
SELECT ProductModelID,Name,CatalogDescription,Instructions
FROM AdventureWorks.productmodel;


--  ProductCategory:
INSERT INTO AdventureWorksDWH.ProductCategory(ProductCategoryID,Name)
Select ProductCategoryID,Name
From AdventureWorks.ProductCategory;


-- -- ProductSubCategory:
INSERT INTO AdventureWorksDWH.ProductSubCategory(ProductSubcategoryID,ProductCategoryID,Name)
SELECT ProductSubcategoryID,ProductCategoryID,Name
FROM AdventureWorks.productsubcategory;


-- Product:
INSERT INTO AdventureWorksDWH.Product(ProductID,Name,ProductNumber,FinishedGoodsFlag,Color,SafetyStockLevel,ReorderPoint,StandardCost,ListPrice,Size,Weight,ProductModelID,ProductSubCategoryID)
SELECT ProductID,Name,ProductNumber,FinishedGoodsFlag,Color,SafetyStockLevel,ReorderPoint,StandardCost,ListPrice,Size,Weight,ProductModelID,ProductSubCategoryID
FROM AdventureWorks.product;


-- -- SalesTerritory:
INSERT INTO AdventureWorksDWH.SalesTerritory(TerritoryID,CountryRegionCode,Groupp)
SELECT TerritoryID,CountryRegionCode,Groupp
FROM AdventureWorks.SalesTerritory;


-- -- StateProvince:
INSERT INTO AdventureWorksDWH.StateProvince(StateProvinceID,CountryRegionCode,IsOnlyStateProvinceFlag,Name)
SELECT StateProvinceID,CountryRegionCode,IsOnlyStateProvinceFlag,Name
FROM AdventureWorks.stateprovince;


-- ScrapReason:
INSERT INTO AdventureWorksDWH.ScrapReason(ScrapReasonID,Reason)
SELECT ScrapReasonID,Reason
FROM AdventureWorks.scrapreason;


-- -- Shift:
INSERT INTO AdventureWorksDWH.Shift(ShiftID,Name,StartTime,EndTime)
SELECT	ShiftID,Name,StartTime,EndTime
FROM AdventureWorks.shift;


--  WorkOrder:
INSERT INTO AdventureWorksDWH.WorkOrder(WorkOrderID,ProductID,OrderQty,StockedQty,ScrappedQty,StartDate,EndDate,DueDate,ScrapReasonID)
SELECT	WorkOrderID,ProductID,OrderQty,StockedQty,ScrappedQty,StartDate,EndDate,DueDate,ScrapReasonID
FROM AdventureWorks.WorkOrder;


--  ProductS:
INSERT INTO AdventureWorksDWH.ProductS(ProductID,Name,Color,StandardCost,ListPrice,ProductSubcategoryID,SellStartDate,SellEndDate,DiscontinuedDate)
SELECT ProductID,Name,Color,StandardCost,ListPrice,ProductSubcategoryID,SellStartDate,SellEndDate,DiscontinuedDate
FROM AdventureWorks.Product;


-- Employee:
INSERT INTO AdventureWorksDWH.Employee(EmployeeID,LoginID,ManagerID,ShiftID,HireDate,transportType)
SELECT E.EmployeeID,E.LoginID,E.ManagerID, EDH.ShiftID,E.HireDate,T.TransportType
FROM AdventureWorks.Employee as E JOIN AdventureWorks.Transport as T On E.TransportID=T.TransportID
join AdventureWorks.EmployeeDepartmentHistory as EDH on E.EmployeeID = EDH.EmployeeID
where EDH.endDate is null;


-- EmployeeS:
INSERT INTO AdventureWorksDWH.EmployeeS(EmployeeID,ContactID,ShiftID,LoginID,ManagerID,HireDate)
SELECT E.EmployeeID,E.ContactID,EDH.ShiftID,E.LoginID,E.ManagerID,E.HireDate
FROM AdventureWorks.Employee as E join AdventureWorks.EmployeeDepartmentHistory as EDH on E.EmployeeID = EDH.EmployeeID
where EDH.endDate is null;


-- Customer:
INSERT INTO AdventureWorksDWH.Customer(CustomerID,TerritoryID,AccountNumber,CustomerType)
SELECT CustomerID,TerritoryID,AccountNumber,CustomerType
FROM AdventureWorks.customer;


-- SalesPesron:
INSERT INTO AdventureWorksDWH.SalesPerson(SalesPersonID,SalesQuota,Bonus,SalesYTD,SalesLastYear)
SELECT	SalesPersonID,SalesQuota,Bonus,SalesYTD,SalesLastYear
FROM AdventureWorks.salesperson;


 -- Store:
INSERT INTO AdventureWorksDWH.Store(CustomerID,Name,Demographics,SalesPersonID)
SELECT	CustomerID,Name,Demographics,SalesPersonID
FROM AdventureWorks.store;

-- SalesOrderDetail:
INSERT INTO AdventureWorksDWH.SalesOrderDetail(SalesOrderDetailID,SalesOrderID,CarrierTrackingNumber,OrderQty,ProductID,SpecialOfferID,UnitPrice,UnitPriceDiscount)
SELECT SalesOrderDetailID,SalesOrderID,CarrierTrackingNumber,OrderQty,ProductID,SpecialOfferID,UnitPrice,UnitPriceDiscount
FROM AdventureWorks.SalesOrderDetail;

