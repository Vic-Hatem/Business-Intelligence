

-- tables creation

CREATE DATABASE IF NOT EXISTS AdventureWorksDWH;
USE AdventureWorksDWH;

DROP TABLE IF EXISTS `ShipMethod`;
CREATE TABLE `ShipMethod` (
  `ShipMethodID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` nvarchar(50) NOT NULL,
  `ShipBase` double,
  `ShipRate` double,
 PRIMARY KEY (`ShipMethodID`)
);

DROP TABLE IF EXISTS `purchaseorderdetail`;

CREATE TABLE `purchaseorderdetail` (
  `PurchaseOrderID` int(11) NOT NULL AUTO_INCREMENT,
  `DueDate` datetime NOT NULL,
  `OrderQty` smallint(6) NOT NULL,
  `ProductID` int(11) NOT NULL,
  `UnitPrice` double NOT NULL,
  `LineTotal` double NOT NULL,
  `ReceivedQty` decimal(8,2) NOT NULL,
  `RejectedQty` decimal(8,2) NOT NULL,
  `StockedQty` decimal(9,2) NOT NULL,
  `ModifiedDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ShipMethodID` int(11) NOT NULL,

  PRIMARY KEY (`PurchaseOrderID`),
  FOREIGN KEY (ShipMethodID) REFERENCES ShipMethod(ShipMethodID)

); 

DROP TABLE IF EXISTS `address`;

CREATE TABLE `address` (
  `AddressID` int(11) NOT NULL AUTO_INCREMENT,
  `AddressLine1` varchar(60) NOT NULL,
  `AddressLine2` varchar(60) DEFAULT NULL,
  `City` varchar(30) NOT NULL,
  `StateProvinceID` int(11) NOT NULL,
  `PostalCode` varchar(15) NOT NULL,
  PRIMARY KEY (`AddressID`),
  FOREIGN KEY (StateProvinceID) REFERENCES StateProvince(StateProvinceID)

);


DROP TABLE IF EXISTS `vendor`;

CREATE TABLE `vendor` (
  `VendorID` int(11) NOT NULL AUTO_INCREMENT,
  `AccountNumber` varchar(15) NOT NULL,
  `Name` varchar(50) NOT NULL,
  `CreditRating` tinyint(4) NOT NULL,
  `PreferredVendorStatus` bit(1) NOT NULL DEFAULT b'1',
  `ActiveFlag` bit(1) NOT NULL DEFAULT b'1',
  `PurchasingWebServiceURL` mediumtext,
   `AddressID` int(11) NOT NULL,
   PRIMARY KEY (`VendorID`),
   FOREIGN KEY (AddressID) REFERENCES address(AddressID)

);


DROP TABLE IF EXISTS `employeeA`;

CREATE TABLE `employeeA` (
  `EmployeeID` int(11) NOT NULL,
  `NationalIDNumber` varchar(15) NOT NULL,
  `ContactID` int(11) NOT NULL,
  `Title` varchar(50) NOT NULL,
  `BirthDate` datetime NOT NULL,
  `MaritalStatus` varchar(1) NOT NULL,
  `Gender` varchar(1) NOT NULL,
  `HireDate` datetime NOT NULL,
  `SalariedFlag` bit(1) NOT NULL,
  `VacationHours` smallint(6) NOT NULL,
  `SickLeaveHours` smallint(6) NOT NULL,
  `CurrentFlag` bit(1) NOT NULL,
  `ModifiedDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`EmployeeID`),
    FOREIGN KEY (ContactID) REFERENCES Contact(ContactID)

);


DROP TABLE IF EXISTS `productA`;

CREATE TABLE `productA` (
  `ProductID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `ProductNumber` varchar(25) NOT NULL,
  `MakeFlag` bit(1) NOT NULL,
  `FinishedGoodsFlag` bit(1) NOT NULL,
  `Color` varchar(15) DEFAULT NULL,
  `SafetyStockLevel` smallint(6) NOT NULL,
  `ReorderPoint` smallint(6) NOT NULL,
  `StandardCost` double NOT NULL,
  `ListPrice` double NOT NULL,
  `Size` varchar(5) DEFAULT NULL,
  `ProductSubcategoryID` int(11) DEFAULT NULL,
  PRIMARY KEY (`ProductID`),
     FOREIGN KEY (ProductSubcategoryID) REFERENCES ProductSubcategory(ProductSubcategoryID)
);


DROP TABLE IF EXISTS `purchaseorderheader`;

CREATE TABLE `purchaseorderheader` (
  `PurchaseOrderID` int(11) DEFAULT NULL,
  `EmployeeID` int(11) DEFAULT NULL,
  `VendorID` int(11) DEFAULT NULL,
  `OrderDate` datetime DEFAULT NULL,
  `ShipDate` datetime DEFAULT NULL,
  `ModifiedDate` datetime DEFAULT NULL
);


CREATE TABLE `PurchasingFact`(
  `PurchaseOrderID` int(11) NOT NULL,
  `ProductID` int(11) NOT NULL,
  `VendorID` int(11) NOT NULL,
  `EmployeeID` int(11) NOT NULL,
  `CountryRegionName` nvarchar(50) NOT NULL,
`PriceSum` double NOT NULL,
`OrderQtyAvg` double NOT NULL,
`ShipRateAvg` int NOT NULL,
`RejectedQty` double,
PRIMARY KEY(PurchaseOrderID,ProductID,VendorID,EmployeeID),
FOREIGN KEY (ProductID) REFERENCES ProductA(ProductID),
FOREIGN KEY (VendorID) REFERENCES Vendor(VendorID),
FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
FOREIGN KEY (PurchaseOrderID) REFERENCES PurchaseOrderDetail(PurchaseOrderID)
);
