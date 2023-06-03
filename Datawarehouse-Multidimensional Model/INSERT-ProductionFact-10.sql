USE AdventureWorks;
USE AdventureWorksDWH;

DROP VIEW IF EXISTS `ProductSubView`;
CREATE VIEW ProductSubView AS
SELECT	P.ProductID,P.ProductSubCategoryID
FROM AdventureWorksDWH.Product AS P INNER JOIN AdventureWorksDWH.ProductSubCategory AS S ON P.ProductSubCategoryID=S.ProductSubCategoryID;


DROP VIEW IF EXISTS `ProductModelView`;
CREATE VIEW ProductModelView AS
SELECT P.ProductID,P.ProductModelID
FROM AdventureWorksDWH.Product AS P INNER JOIN AdventureWorksDWH.ProductModel AS M ON P.ProductModelID=M.ProductModelID;


DROP VIEW IF EXISTS `ProductWorkView`;
CREATE VIEW ProductWorkView AS
SELECT P.ProductID,W.WorkOrderID 
FROM AdventureWorksDWH.Product AS P INNER JOIN AdventureWorksDWH.WorkOrder AS W ON P.ProductID=W.ProductID;


DROP VIEW IF EXISTS `ProductMeasureView`;
CREATE VIEW ProductMeasureView AS
SELECT P.ProductID,U.Name
FROM AdventureWorksDWH.Product AS P INNER JOIN AdventureWorks.BillOfMaterials AS B ON P.ProductID=B.ProductAssemblyID
INNER JOIN AdventureWorks.unitmeasure AS U ON B.UnitMeasureCode=U.UnitMeasureCode;


DROP VIEW IF EXISTS `QtyShoppingView`;
CREATE VIEW QtyShoppingView AS
SELECT P.ProductID,Sum(SH.Quantity) AS Qty1
FROM AdventureWorksDWH.Product AS P INNER JOIN AdventureWorks.ShoppingCartItem AS SH ON P.ProductID=SH.ProductID
GROUP BY P.ProductID;



DROP VIEW IF EXISTS `SumOrderQtyView`;
CREATE VIEW SumOrderQtyView AS
SELECT P.ProductID,Sum(O.OrderQty) AS Qty2
FROM AdventureWorksDWH.Product AS P INNER JOIN AdventureWorks.PurchaseOrderDetail AS O ON P.ProductID=O.ProductID
GROUP BY P.ProductID;



DROP VIEW IF EXISTS `SumRejectedQtyView`;
CREATE VIEW SumRejectedQtyView AS
SELECT P.ProductID,Sum(O.RejectedQty) AS Qty3
FROM AdventureWorksDWH.Product AS P INNER JOIN AdventureWorks.PurchaseOrderDetail AS O ON P.ProductID=O.ProductID
GROUP BY P.ProductID;



DROP VIEW IF EXISTS `SumScrabedQtyView`;
CREATE VIEW SumScrabedQtyView AS
SELECT P.ProductID,Sum(W.ScrappedQty) AS Qty4
FROM AdventureWorksDWH.Product AS P INNER JOIN AdventureWorksDWH.WorkOrder AS W ON P.ProductID=W.ProductID
GROUP BY P.ProductID;


-- Production Fact Table:
INSERT IGNORE INTO AdventureWorksDWH.ProductionFact(ProductID,ProductSubCategoryID,ProductModelID,WorkOrderID,UnitMeasure,AvgQtyShopping,SumOrderQty,RejectedQty,SumScrabedQty)
SELECT P.ProductID ,SV.ProductSubCategoryID,MV.ProductModelID ,WV.WorkOrderID,PMV.Name AS MeasureName
,QSV.Qty1 AS ShppinCartQuantity,SOQV.Qty2 AS OrderQuantity,SRQV.Qty3 AS RejectedQuantity,SSQV.Qty4 AS ScrabedQuantity
FROM AdventureWorksDWH.Product AS P  left outer JOIN ProductSubView AS SV on P.ProductID=SV.ProductID
left outer JOIN ProductModelView AS MV on P.ProductID=MV.ProductID
left outer JOIN ProductWorkView AS WV on P.ProductID=WV.ProductID
left JOIN ProductMeasureView AS PMV ON P.ProductID=PMV.ProductID
 LEFT OUTER JOIN QtyShoppingView AS QSV ON P.ProductID=QSV.ProductID
LEFT OUTER JOIN SumOrderQtyView AS SOQV ON P.ProductID=SOQV.ProductID
LEFT OUTER JOIN SumRejectedQtyView AS SRQV ON P.ProductID=SRQV.ProductID
LEFT OUTER JOIN SumScrabedQtyView AS SSQV ON P.ProductID=SSQV.ProductID
GROUP BY P.ProductID,SV.ProductSubCategoryID,MV.ProductModelID,WV.WorkOrderID,PMV.Name