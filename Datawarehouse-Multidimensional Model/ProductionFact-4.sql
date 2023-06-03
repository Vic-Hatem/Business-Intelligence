CREATE DATABASE IF NOT EXISTS AdventureWorksDWH;
USE AdventureWorksDWH;


DROP TABLE IF EXISTS `ProductModel`;

CREATE TABLE `ProductModel` (
  `ProductModelID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `CatalogDescription` text,
  `Instructions` text,
 PRIMARY KEY (`ProductModelID`)
);

DROP TABLE IF EXISTS `Product`;
CREATE TABLE `Product` (
  `ProductID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `ProductNumber` varchar(25) NOT NULL,
  `FinishedGoodsFlag` bit(1) NOT NULL,
  `Color` varchar(15) DEFAULT NULL,
  `SafetyStockLevel` smallint(6) NOT NULL,
  `ReorderPoint` smallint(6) NOT NULL,
  `StandardCost` double NOT NULL,
  `ListPrice` double NOT NULL,
  `Size` varchar(5) DEFAULT NULL,
  `Weight` decimal(8,2) DEFAULT NULL,
  `ProductModelID` int(11),
  `ProductSubcategoryID` int(11) DEFAULT NULL,
   PRIMARY KEY (`ProductID`),
   FOREIGN KEY (ProductModelID) REFERENCES ProductModel(ProductModelID)
);


DROP TABLE IF EXISTS `ProductCategory`;

CREATE TABLE `ProductCategory` (
  `ProductCategoryID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
PRIMARY KEY (`ProductCategoryID`)
);

DROP TABLE IF EXISTS `ProductSubCategory`;

CREATE TABLE `ProductSubCategory` (
  `ProductSubcategoryID` int(11) NOT NULL AUTO_INCREMENT,
  `ProductCategoryID` int(11) NOT NULL,
  `Name` varchar(50) NOT NULL,
PRIMARY KEY (`ProductSubcategoryID`),
FOREIGN KEY (ProductCategoryID) REFERENCES ProductCategory(ProductCategoryID) 
);



DROP TABLE IF EXISTS `ScrapReason`;

CREATE TABLE `ScrapReason` (
  `ScrapReasonID` int(11) NOT NULL AUTO_INCREMENT,
  `Reason` varchar(50) NOT NULL,
 PRIMARY KEY (`ScrapReasonID`)
);

DROP TABLE IF EXISTS `WorkOrder`;

CREATE TABLE `WorkOrder` (
  `WorkOrderID` int(11) NOT NULL AUTO_INCREMENT,
  `ProductID` int(11) NOT NULL,
  `OrderQty` int(11) NOT NULL,
  `StockedQty` int(11) NOT NULL,
  `ScrappedQty` smallint(6) NOT NULL,
  `StartDate` datetime NOT NULL,
  `EndDate` datetime DEFAULT NULL,
  `DueDate` datetime NOT NULL,
  `ScrapReasonID` int(11) DEFAULT NULL,
  `ModifiedDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`WorkOrderID`),
	FOREIGN KEY (ProductID)  REFERENCES Product(ProductID) ON DELETE cascade,
	FOREIGN KEY (ScrapReasonID) REFERENCES ScrapReason(ScrapReasonID) ON DELETE cascade
);

DROP TABLE IF EXISTS `ProductionFact`;

	CREATE TABLE `ProductionFact`(
 `ProductID` int NOT NULL, 
`ProductSubCategoryID` int NOT NULL,
 `ProductModelID` int NOT NULL,
 `WorkOrderID` int NOT NULL, 
`UnitMeasure` varchar(15) , 
`AvgQtyShopping` int ,
 `SumOrderQty` int , 
`RejectedQty` int ,
 `SumScrabedQty` int,
 PRIMARY KEY(ProductID,ProductSubCategoryID,ProductModelID,WorkOrderID),
FOREIGN KEY(ProductID) REFERENCES Product(ProductID) ON DELETE cascade,
FOREIGN KEY(ProductSubCategoryID) REFERENCES ProductSubCategory (ProductSubcategoryID) ON DELETE cascade,
FOREIGN KEY(ProductModelID) REFERENCES ProductModel(ProductModelID) ON DELETE cascade,
FOREIGN KEY(WorkOrderID) REFERENCES WorkOrder(WorkOrderID) ON DELETE cascade
);
