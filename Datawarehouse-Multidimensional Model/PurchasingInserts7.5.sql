use AdventureWorks;
use AdventureWorksDWH;
-- ShipMethod:
INSERT INTO AdventureWorksDWH.ShipMethod(ShipMethodID,Name,ShipBase,ShipRate)
SELECT	ShipMethodID,Name,ShipBase,ShipRate
FROM AdventureWorks.ShipMethod;


 -- Adress:
INSERT INTO AdventureWorksDWH.Address(AddressID,AddressLine1,AddressLine2,City,StateProvinceID,PostalCode)
SELECT	AddressID,AddressLine1,AddressLine2,City,StateProvinceID,PostalCode
FROM AdventureWorks.Address;

 
 -- Vendor:
INSERT INTO AdventureWorksDWH.Vendor(VendorID,AccountNumber,Name,CreditRating,PreferredVendorStatus,ActiveFlag,PurchasingWebServiceURL,AddressID)
SELECT	V.VendorID,V.AccountNumber,V.Name,V.CreditRating,V.PreferredVendorStatus,V.ActiveFlag,V.PurchasingWebServiceURL,A.AddressID
FROM AdventureWorks.Vendor V inner join AdventureWorks.vendoraddress A on V.vendorID=A.vendorId;


 -- employeeA:
INSERT INTO AdventureWorksDWH.employeeA(EmployeeID,NationalIDNumber,ContactID,Title,BirthDate,MaritalStatus,Gender,HireDate,SalariedFlag,VacationHours,SickLeaveHours,CurrentFlag,ModifiedDate)
SELECT	EmployeeID,NationalIDNumber,ContactID,Title,BirthDate,MaritalStatus,Gender,HireDate,SalariedFlag,VacationHours,SickLeaveHours,CurrentFlag,ModifiedDate
FROM AdventureWorks.employee;


 -- productA:
INSERT INTO AdventureWorksDWH.productA(ProductID,Name,ProductNumber,MakeFlag,FinishedGoodsFlag,Color,SafetyStockLevel,ReorderPoint,StandardCost,ListPrice,Size,ProductSubcategoryID)
SELECT	ProductID,Name,ProductNumber,MakeFlag,FinishedGoodsFlag,Color,SafetyStockLevel,ReorderPoint,StandardCost,ListPrice,Size,ProductSubcategoryID
FROM AdventureWorks.product;


  -- PurchaseOrderDetails:
 INSERT IGNORE INTO AdventureWorksDWH.PurchaseOrderDetail(PurchaseOrderID,DueDate,OrderQty,ProductId,UnitPrice,LineTotal,ReceivedQty,RejectedQty,StockedQty,ModifiedDate,ShipMethodID)
 SELECT	D.PurchaseOrderID,D.DueDate,D.OrderQty,D.ProductId,D.UnitPrice,D.LineTotal,D.ReceivedQty,D.RejectedQty,D.StockedQty,H.ModifiedDate,H.ShipMethodID
 FROM AdventureWorks.PurchaseOrderDetail as D inner join AdventureWorks.PurchaseOrderHeader as H on D.PurchaseOrderId=H.PurchaseOrderId ;
 
 
 -- PurchaseOrderHeader:
INSERT INTO AdventureWorksDWH.PurchaseOrderHeader(PurchaseOrderID,EmployeeID,VendorID,OrderDate,ShipDate,ModifiedDate)
SELECT	PH.PurchaseOrderID , PH.EmployeeID, PH.VendorID,PH.OrderDate,PH.ShipDate,PH.ModifiedDate
FROM AdventureWorks.PurchaseOrderHeader as PH inner join AdventureWorks.PurchaseOrderDetail as PD on PH.PurchaseOrderId=PD.PurchaseOrderId;