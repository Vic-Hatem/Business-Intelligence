use AdventureWorksDWH;
UNLOCK TABLES;
CREATE TABLE `Department` (
  `DepartmentID` smallint NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `Groupp` varchar(50) NOT NULL,
  `ModifiedDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`DepartmentID`)
);


CREATE TABLE `CountryRegion` (
  `CountryRegionCode` varchar(3) NOT NULL,
  `Name` varchar(50) NOT NULL,
  PRIMARY KEY (`CountryRegionCode`)
);



CREATE TABLE `StateProvince` (
  `StateProvinceID` int(11) NOT NULL AUTO_INCREMENT,
  `CountryRegionCode` varchar(3) NOT NULL,
  `IsOnlyStateProvinceFlag` bit(1) NOT NULL DEFAULT b'1',
  `Name` varchar(50) NOT NULL,
  PRIMARY KEY (`StateProvinceID`)
);



CREATE TABLE `SalesTerritory` (
  `TerritoryID` int(11) NOT NULL AUTO_INCREMENT,
  `CountryRegionCode` varchar(3) NOT NULL,
  `Groupp` varchar(50) NOT NULL,
  PRIMARY KEY (`TerritoryID`)
);




CREATE TABLE `Shift` (
  `ShiftID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `StartTime` datetime NOT NULL,
  `EndTime` datetime NOT NULL,
  `ModifiedDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ShiftID`)
);



CREATE TABLE `Employee` (
	`EmployeeID` int(11) PRIMARY KEY NOT NULL,
	`LoginID` varchar(256) NOT NULL,
	`ManagerID` int(11) ,
	`ShiftID` int(11) NOT NULL ,
	`HireDate` datetime NOT NULL,
	`transportType` varchar(15) NOT NULL,
    FOREIGN KEY (ShiftID) REFERENCES Shift(ShiftID) 
);


CREATE TABLE `Date`(
	`DateID` int(11) NOT NULL AUTO_INCREMENT, 
	`year` int NOT NULL , 
	`month` int NOT NULL, 
	`day` int NOT NULL,
    PRIMARY KEY (`DateID`)
);


CREATE TABLE `AgeGroup`(
	`AgeGroupID` int(11) PRIMARY KEY NOT NULL, 
	`name` varchar(15) NOT NULL,
	`minDateID` int(11) NOT NULL ,
	`maxDateID` int(11) NOT NULL ,
  FOREIGN KEY (maxDateID) REFERENCES Date(DateID), 
  FOREIGN KEY (minDateID) REFERENCES Date(DateID)
);




CREATE TABLE `EmployeeFact` (
	`EmployeeID` int(11) NOT NULL ,
	`AgeGroupID` int(11) NOT NULL ,
	`StateProvinceID` int(11) NOT NULL ,
	`DepartmentID` smallint NOT NULL ,
	`TerritoryID` int(11) NOT NULL ,
	`TransportType` varchar(15) NOT NULL,
	`SickLeaveHours` smallint,
	`VacationHours` smallint,
	`AvgPurchacesPerMonth` int,
	`AvgSalesPerMonth` int,
    PRIMARY KEY(EmployeeID,AgeGroupID,StateProvinceID,DepartmentID,TerritoryID),
  FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
  FOREIGN KEY (AgeGroupID) REFERENCES AgeGroup(AgeGroupID),
  FOREIGN KEY (StateProvinceID) REFERENCES StateProvince(StateProvinceID),
  FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID),
  FOREIGN KEY (TerritoryID) REFERENCES SalesTerritory(TerritoryID)
);
