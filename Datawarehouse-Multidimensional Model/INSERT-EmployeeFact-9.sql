USE AdventureWorks;
USE AdventureWorksDWH;
CREATE VIEW ViewEmployeeState AS 
	SELECT E.EmployeeID, A.StateProvinceID 
    FROM AdventureWorks.Employee AS E join AdventureWorks.EmployeeAddress AS EA on E.EmployeeID = EA.EmployeeID
		join AdventureWorks.Address AS A on A.AddressID = EA.AddressID;
        
CREATE VIEW ViewEmployeeTerritory AS 
	SELECT E.EmployeeID, S.TerritoryID 
    FROM AdventureWorks.Employee AS E join AdventureWorks.EmployeeAddress AS EA on E.EmployeeID = EA.EmployeeID
		join AdventureWorks.Address AS A on A.AddressID = EA.AddressID 
        join AdventureWorks.StateProvince AS S on S.StateProvinceID = A.StateProvinceID;
        
CREATE VIEW ViewEmployeeAgeGroup1 AS
    SELECT EmployeeID, '1' as AgeGroupID
    FROM AdventureWorks.Employee
    WHERE year(AdventureWorks.Employee.BirthDate) <= 1941;
    
CREATE VIEW ViewEmployeeAgeGroup2 AS
    SELECT EmployeeID, '2' as AgeGroupID
    FROM AdventureWorks.Employee
     WHERE year(AdventureWorks.Employee.BirthDate) < 1955 and year(AdventureWorks.Employee.BirthDate) > 1941;

CREATE VIEW ViewEmployeeAgeGroup3 AS
    SELECT EmployeeID, '3' as AgeGroupID
    FROM AdventureWorks.Employee
    WHERE year(AdventureWorks.Employee.BirthDate) < 1969 and year(AdventureWorks.Employee.BirthDate) >= 1955;
    
CREATE VIEW ViewEmployeeAgeGroup4 AS
    SELECT EmployeeID, '4' as AgeGroupID
    FROM AdventureWorks.Employee
    WHERE year(AdventureWorks.Employee.BirthDate) >= 1969;
--     
CREATE VIEW ViewEmployeeAgeGroupID AS
	SELECT * FROM ViewEmployeeAgeGroup1
		UNION
	SELECT * FROM ViewEmployeeAgeGroup2
		UNION
	SELECT * FROM ViewEmployeeAgeGroup3
		UNION
	SELECT * FROM ViewEmployeeAgeGroup4;
    
CREATE VIEW ViewEmployeeTransportType AS 
	SELECT E.EmployeeID, T.TransportType
    FROM AdventureWorks.Employee AS E join AdventureWorks.Transport AS T on E.TransportID = T.TransportID;
    
CREATE VIEW ViewEmployeeAvgPurchaces AS 
	SELECT E.EmployeeID , SUM(P.TotalDue)/30  AS AvgPurchacesPerMonth
	FROM AdventureWorks.Employee AS E join AdventureWorks.PurchaseOrderHeader AS P on E.EmployeeID = P.EmployeeID
	WHERE DATEDIFF(NOW(),OrderDate) < 365*40
     GROUP BY E.EmployeeID;
    
    
CREATE VIEW ViewEmployeeAvgSales AS 
	SELECT E.EmployeeID , SUM(S.TotalDue)/30 AS AvgSalesPerMonth
	FROM AdventureWorks.Employee AS E join AdventureWorks.SalesOrderHeader AS S on E.EmployeeID = S.SalesPersonID
    WHERE DATEDIFF(NOW(),OrderDate) < 365*40
    GROUP BY E.EmployeeID;

CREATE VIEW ViewEmployeeDepartment AS 
	SELECT E.EmployeeID, EDH.DepartmentID
    FROM AdventureWorks.Employee AS E join AdventureWorks.EmployeeDepartmentHistory AS EDH on E.EmployeeID = EDH.EmployeeID;

INSERT INTO EmployeeFact(EmployeeID, AgeGroupID, StateProvinceID, DepartmentID, TerritoryID, TransportType, SickLeaveHours, VacationHours,AvgPurchacesPerMonth, AvgSalesPerMonth)
SELECT E.EmployeeID, AG.AgeGroupID, ES.StateProvinceID,D.DepartmentID,  ET.TerritoryID, ETT.TransportType, 
 		E.SickLeaveHours, E.VacationHours , EAP.AvgPurchacesPerMonth , EAS.AvgSalesPerMonth
FROM AdventureWorks.Employee AS E inner join ViewEmployeeAgeGroupID  AS AG on E.EmployeeID = AG.EmployeeID
								inner join ViewEmployeeState  AS ES on E.EmployeeID = ES.EmployeeID
                                inner join ViewEmployeeDepartment  AS D on E.EmployeeID = D.EmployeeID
                                inner join ViewEmployeeTerritory  AS ET on E.EmployeeID = ET.EmployeeID
                                inner join ViewEmployeeTransportType AS ETT on E.EmployeeID = ETT.EmployeeID
								left outer join ViewEmployeeAvgPurchaces AS EAP on E.EmployeeID = EAP.EmployeeID
                                left outer join ViewEmployeeAvgSales AS EAS on E.EmployeeID = EAS.EmployeeID;