use adventureworksdwh;

 
 CREATE TABLE `DateS`(
	`DateID` int(11) NOT NULL AUTO_INCREMENT, 
	`year` int NOT NULL , 
	`month` int NOT NULL, 
	`day` int NOT NULL,
    PRIMARY KEY (`DateID`)
);


CREATE TABLE `SpecialOffer` (
  `SpecialOfferID` int(11) NOT NULL AUTO_INCREMENT,
  `Description` varchar(255) NOT NULL,
  `DiscountPct` double NOT NULL DEFAULT '0',
  `Type` varchar(50) NOT NULL,
  `StartDateID` int(11),
  `EndDateID` int(11),
  `MinQty` int(11) NOT NULL DEFAULT '0',
  `MaxQty` int(11) DEFAULT NULL,
  PRIMARY KEY (`SpecialOfferID`),
  FOREIGN KEY (StartDateID) REFERENCES DateS(DateID), 
  FOREIGN KEY (EndDateID) REFERENCES DateS(DateID)
);



CREATE TABLE `ProductS` (
  `ProductID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `Color` varchar(15) DEFAULT NULL,
  `StandardCost` double NOT NULL, 
  `PreviousCost` double,
  `ListPrice` double NOT NULL,
  `ProductSubcategoryID` int(11) DEFAULT NULL,
  `SellStartDate` datetime NOT NULL,
  `SellEndDate` datetime DEFAULT NULL,
  `DiscontinuedDate` datetime DEFAULT NULL,
  `ModifiedDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ProductID`),
FOREIGN KEY (ProductSubcategoryID) REFERENCES ProductSubCategory(ProductSubcategoryID)
);


CREATE TABLE `SalesOrderDetail` (
  `SalesOrderID` int(11) NOT NULL,
  `SalesOrderDetailID` int(11) NOT NULL AUTO_INCREMENT,
  `CarrierTrackingNumber` varchar(25) DEFAULT NULL,
  `OrderQty` smallint(6) NOT NULL,
  `ProductID` int(11) NOT NULL,
  `SpecialOfferID` int(11) NOT NULL,
  `UnitPrice` double NOT NULL,
  `UnitPriceDiscount` double NOT NULL,
PRIMARY KEY (`SalesOrderDetailID`,`SalesOrderID`) ,
FOREIGN KEY(SpecialOfferID) REFERENCES SpecialOffer(SpecialOfferID),
FOREIGN KEY(ProductID) REFERENCES ProductS(ProductID)
);

 
 
CREATE TABLE `Customer` (
  `CustomerID` int(11) NOT NULL AUTO_INCREMENT,
  `TerritoryID` int(11) DEFAULT NULL,
  `AccountNumber` varchar(10) NOT NULL,
  `CustomerType` varchar(1) NOT NULL,
  PRIMARY KEY (`CustomerID`),
FOREIGN KEY (TerritoryID) REFERENCES SalesTerritory(TerritoryID)
);



CREATE TABLE `Contact` (
  `ContactID` int(11) NOT NULL AUTO_INCREMENT,
  `FirstName` varchar(50) CHARACTER SET latin1 NOT NULL,
  `MiddleName` varchar(50) CHARACTER SET latin1 DEFAULT NULL,
  `LastName` varchar(50) CHARACTER SET latin1 NOT NULL,
  `EmailAddress` varchar(50) CHARACTER SET latin1 DEFAULT NULL,
  `Phone` varchar(25) CHARACTER SET latin1 DEFAULT NULL,
  `PasswordHash` varchar(40) CHARACTER SET latin1 NOT NULL,
  PRIMARY KEY (`ContactID`)
);
 

CREATE TABLE `EmployeeS` (
  `EmployeeID` int(11) NOT NULL,
  `ContactID` int(11) NOT NULL,
  `ShiftID` int(11) NOT NULL,
  `LoginID` varchar(256) NOT NULL,
  `ManagerID` int(11) DEFAULT NULL,
  `HireDate` datetime NOT NULL,
  PRIMARY KEY (`EmployeeID`),
FOREIGN KEY (ContactID) REFERENCES Contact(ContactID),
FOREIGN KEY (ShiftID) REFERENCES Shift(ShiftID)
);
 
CREATE TABLE `SalesPerson` (
  `SalesPersonID` int(11) NOT NULL,
  `SalesQuota` double DEFAULT NULL,
  `Bonus` double NOT NULL,
  `SalesYTD` double NOT NULL,
  `SalesLastYear` double NOT NULL,
  PRIMARY KEY (`SalesPersonID`),
FOREIGN KEY (SalesPersonID) REFERENCES EmployeeS (EmployeeID)
);
 
 
CREATE TABLE `Store`(
`CustomerID` int(11) NOT NULL,
`Name` varchar(50) NOT NULL,
`Demographics` text,
`SalesPersonID` int(11) DEFAULT NULL,
 PRIMARY KEY (`CustomerID`),
FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
FOREIGN KEY (SalesPersonID) REFERENCES SalesPerson(SalesPersonID)
);
 

CREATE TABLE `ProductSalesFact`(
	`SalesOrderDetailID` int(11) NOT NULL,
	`ProductID` int(11) NOT NULL,
	`StoreID` int(11) NOT NULL,
	`SalesPersonID` int(11) NOT NULL,
	`DateID` int(11) NOT NULL,
	`CurrencyName` varchar(3) NOT NULL,
	`GrossProfit` double NOT NULL,
	`UnitPrice` int NOT NULL,
	`OrderQty` int NOT NULL, 
	`DiscountPct` double NOT NULL,
PRIMARY KEY (`SalesOrderDetailID`,`ProductID`,`StoreID`,`SalesPersonID`),
FOREIGN KEY (StoreID) REFERENCES Store(CustomerID),
FOREIGN KEY (ProductID) REFERENCES ProductS(ProductID),
FOREIGN KEY (SalesOrderDetailID) REFERENCES SalesOrderDetail(SalesOrderDetailID),
FOREIGN KEY (SalesPersonID) REFERENCES SalesPerson(SalesPersonID),
FOREIGN KEY (DateID ) REFERENCES Date(DateID)
);
