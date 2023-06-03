
use AdventureWorksdwh;

-- Fact table and measures create and insert


CREATE VIEW ProductOrderView AS
SELECT PD.ProductID , PD.PurchaseOrderID
FROM purchaseorderdetail as PD inner join producta as P on PD.ProductID=P.ProductID;

CREATE VIEW ProductOrders AS
select PV.ProductID as ProductID , PH.PurchaseOrderID  as PurchaseOrderID, PH.EmployeeID as EmployeeID, PH.VendorID as VendorID
FROM ProductOrderView AS PV inner join PurchaseOrderHeader as PH on PH.PurchaseOrderID=PV.PurchaseOrderID;





CREATE VIEW CountryRegoinView AS
SELECT V.VendorID as vendorID, S.CountryRegionCode as CountryCode
FROM vendor as V inner join address AS A on V.addressID=A.addressID inner join stateprovince as S on A.StateProvinceID=S.StateProvinceID
group by V.VendorID;

CREATE VIEW CountryName AS
SELECT CV.vendorID as vendorID , C.Name as countryName
From CountryRegoinView as CV inner join CountryRegion C on CV.CountryCode=C.CountryRegionCode
group by CV.vendorID;





CREATE VIEW ShipRateAvg AS 
SELECT PD.PurchaseOrderId ,PD.ProductID ,avg(SM.ShipRate) as rateAvg
FROM purchaseorderdetail as PD inner join  ShipMethod as  SM on PD.ShipMethodID=SM.ShipMethodID
group by PD.PurchaseOrderId;



CREATE VIEW RejectedQty AS
SELECT PD.PurchaseOrderId ,PD.ProductID , sum(PD.RejectedQty) as rejectedQty
FROM purchaseorderdetail as PD
group by PD.ProductID;



CREATE VIEW PriceSum AS
    SELECT 
        P.ProductID,
        PD.PurchaseOrderId,
        SUM(P.ListPrice) AS PriceSum
    FROM
        producta AS P
            INNER JOIN
        purchaseorderdetail AS PD ON P.ProductID = PD.ProductID
    GROUP BY P.ProductID;


CREATE VIEW orderQtyAvg AS
    SELECT 
        PD.PurchaseOrderId,
        PD.ProductID,
        AVG(PD.OrderQty) AS OrderQty
    FROM
        purchaseorderdetail AS PD
    GROUP BY PD.PurchaseOrderId;



INSERT IGNORE INTO AdventureWorksDWH.PurchasingFact(PurchaseOrderID,ProductID,VendorID,EmployeeID,CountryRegionName,PriceSum,OrderQtyAvg,ShipRateAvg,RejectedQty)
Select PH.PurchaseOrderID, VA.ProductID, PH.VendorID, PH.EmployeeID, /*CN.countryName , */PS.PriceSum, OQA.OrderQty, SRA.rateAvg -- , RQ.rejectedQty
FROM AdventureWorksDWH.PurchaseOrderHeader as PH inner join ProductOrders as VA  on  PH.PurchaseOrderID=VA.PurchaseOrderID
	INNER JOIN PriceSum AS PS on PS.ProductID=VA.ProductId
	inner join orderQtyAvg as OQA on OQA.ProductID=VA.ProductId
	-- inner join RejectedQty as RQ  on RQ.ProductID=VA.ProductId
	inner join ShipRateAvg as SRA on SRA.ProductID=VA.ProductId
	inner join CountryName AS CN on PH.VendorID=CN.vendorID



