/**
CODE DESCRIPTION: METRICS to do the following:
        Sum of total revenue per family for May 2021
        Calculate the delivery days
        Service Category Name as the column headers, Total Revenue as the data values, and grouped by consignee name and only include shipments already delivered.
        Shows all Hawb values with their revenue, a column with the sum of ALL revenue, and another column with the % of sum total revenue

DEVELOPER: SADEEQ BELOW
CREATE DATE: 2023-04-13
VERSION: 1.0
**/

CREATE TABLE Customer
    ([ID] int, [CustomerName] varchar(30), [CustomerNumber] varchar(10), [Address] varchar(30), [City] varchar(30), [State] varchar(2), [Zip] varchar(10), [Country] varchar(2), [FamilyID] int)
;
INSERT INTO Customer
    ([ID], [CustomerName], [CustomerNumber], [Address], [City], [State], [Zip], [Country], [FamilyID])
VALUES
('37925182','Bicycles R Us 1','C9879A3','16 Shore St.','Fort Lauderdale','FL','33308','US','1321'),
('37925183','Globex Corporation NY','C6548A6','192 Cypress Lane','La Porte','NY','11741','US','6549'),
('37925184','Hooli East Coast','C2367A5','200 West Purple Finch St.','Johnstown','NC','49509','US','9843'),
('37925185','Ben Johnson','C3984A9','280 Oakland Rd.','Etobicoke','ON','L4C 6B9','CA',''),
('37925186','Hooli West Coast','C3284A5','7233 South James Road','Fayetteville','CA','28303','US','9843'),
('37925187','Globex Corporation CT','C8974A4','7375 Purple Finch Road','Derry','CT','03038','US','6549'),
('37925188','Bicycles R Us 2','C1321A8','7387 Grant Drive','Valley Stream','NY','11580','US','1321'),
('37925189','Hooli Northeast','C6543A7','7693 Marsh Dr.','Atwater','ME','04401','US','9843'),
('37925190','Globex Corporation PA','C6894A3','77 Mayfair Dr.','Taunton','PA','02780','US','6549'),
('37925193','Dylan Coopers','C4897A1','8107 Mayflower Street','Montreal','QC','H4P 1V5','CA','')
;
CREATE TABLE Family
    ([ID] int, [FamilyName] varchar(20), [FamilyNumber] varchar(10));
INSERT INTO Family
    ([ID], [FamilyName], [FamilyNumber])
VALUES
('1321','Bicycles R Us','BIKES100'),
('6549','Globex Corporation','GLOBCORP'),
('9843','Hooli','HOOLI123');
CREATE TABLE Hawb
    ([ID] int, [Hawb] varchar(10), [HawbDate] date, [ServiceCodeID] int, [DueDate] date, [PODDate] date, [ShipperID] int, [ConsigneeID] int, [TotalRevenue] decimal(10,2));
INSERT INTO Hawb
    ([ID], [Hawb], [HawbDate], [ServiceCodeID], [DueDate], [PODDate], [ShipperID], [ConsigneeID], [TotalRevenue])
VALUES
('1656549987','H659124','01/13/2021','101','01/15/2021','01/16/2021','37925182','37925193','37.50'),
('1656549988','H659125','05/21/2021','102','05/25/2021','05/23/2021','37925183','37925193','18.00'),
('1656549989','H659126','06/14/2021','100','06/22/2021','06/21/2021','37925186','37925185','21.00'),
('1656549990','H659127','05/16/2021','101','05/19/2021','05/19/2021','37925187','37925193','16.25'),
('1656549991','H659128','06/30/2021','100','07/01/2021','07/01/2021','37925188','37925185','15.00'),
('1656549992','H659129','05/25/2021','102','05/31/2021','06/01/2021','37925189','37925185','18.00'),
('1656549993','H659130','08/22/2020','100','08/29/2020','08/29/2020','37925190','37925193','21.00'),
('1656549994','H659131','02/26/2021','101','02/28/2021','02/27/2021','37925190','37925185','24.25'),
('1656549995','H659132','05/28/2020','101','05/30/2020','05/30/2020','37925184','37925193','14.00'),
('1656549996','H659133','12/24/2020','100','01/04/2021','01/03/2021','37925183','37925185','18.50'),
('1656549997','H659134','05/01/2021','102','05/09/2021','05/08/2021','37925182','37925185','32.00'),
('1656549998','H659135','07/15/2021','100','07/21/2021',NULL,'37925184','37925193','14.00'),
('1656549999','H659136','05/02/2021','101','05/10/2021','05/09/2021','37925183','37925185','37.50'),
('1656550000','H659137','03/15/2021','101','03/21/2021','03/27/2021','37925182','37925185','19.00'),
('1656550001','H659138','07/09/2021','102','07/15/2021',NULL,'37925183','37925193','27.25');
CREATE TABLE ServiceType
    ([ID] int, [ServiceCode] varchar(5), [ServiceDescription] varchar(15), [ServiceCategoryName] varchar(10));
INSERT INTO ServiceType
    ([ID], [ServiceCode], [ServiceDescription], [ServiceCategoryName])
VALUES
('100','S200','Express','Courier'),
('101','S400','Canada LTL','LTL'),
('102','S300','Ground','Courier');


-- 1	Write a query that shows sum of total revenue per family for May 2021. Only include completed shipments.
-- 	Hints: Join on ShipperID.  Revenue should be based on Hawb Date.

--CHECK RECORDS IN ALL TABLES	
SELECT * FROM Family;
SELECT * FROM ServiceType;
SELECT * FROM Customer;
SELECT * FROM Hawb;

--REVENUE PER FAMILY IN 2021

SELECT FORMAT (PODDate, 'yyyy-MM') as YearMonth,
FamilyName,
FamilyNumber, 
SUM([TotalRevenue]) AS TotalRevenue
FROM 
( 
SELECT [H].[ID] AS H_ID,
[H].[Hawb],
[H].[HawbDate],
[H].[ServiceCodeID],
[H].[DueDate],
H.[PODDate],
[H].[ShipperID],
[H].[ConsigneeID],
[H].[TotalRevenue],
F.ID AS F_ID,
[F].[FamilyName],
[F].[FamilyNumber] ,
C.* --ALL RECORDS IN CUSTOMER TBL
FROM Family F
JOIN Customer C
ON F.ID = C.FamilyID
JOIN Hawb H
ON C.ID = H.ShipperID
WHERE H.PODDate BETWEEN '2021-05-01' AND '2021-05-31'
AND H.PODDate IS NOT NULL
) AS F GROUP BY 
FamilyName,
FamilyNumber,
FORMAT (PODDate, 'yyyy-MM')
;
	
-- 2	For each record in the Hawb table calculate the delivery days.  Be sure to account for Hawbs that are still en-route.
	SELECT [H].[ID],
    [H].[Hawb],
    [H].[HawbDate],
    [H].[ServiceCodeID],
    [H].[DueDate],
    [H].[PODDate],
    [H].[ShipperID],
    [H].[ConsigneeID],
    [H].[TotalRevenue], 
    DATEDIFF(DAY, H.HawbDate, H.PODDate) AS 'Delivery Days'
    FROM Hawb H
	
		
-- 3	Calculate the number of late delivery days and the value of those deliveries grouped by family.
	SELECT X.FamilyName,
    X.FamilyNumber,
   LateDeliveryDays
    FROM
    ( --INNER QUERY
    SELECT [H].[ID],
    [H].[Hawb],
    [H].[HawbDate],
    [H].[ServiceCodeID],
    [H].[DueDate],
    [H].[PODDate],
    [H].[ShipperID],
    [H].[ConsigneeID],
    [H].[TotalRevenue], 
   DATEDIFF(DAY, H.DueDate, H.PODDate) AS 'LateDeliveryDays',
    F.ID AS F_ID,
[F].[FamilyName],
[F].[FamilyNumber] ,
C.ID AS C_ID
FROM Hawb H
JOIN Customer C
ON C.ID = H.ShipperID
JOIN  Family F
ON F.ID = C.FamilyID
) AS X GROUP BY FamilyName,
    FamilyNumber,
    LateDeliveryDays
    ORDER BY FamilyName ASC;
    	
-- 4	Create a pivot with the Service Code concatenated with Service Category Name as the column headers, Total Revenue as the data values, and grouped by consignee name.
-- 	Only include shipments already delivered.

--1ST APPROACH: USING DISTINCT FUNCTION TO ELIMINATE DUPLICATES
SELECT * FROM (
SELECT DISTINCT
(ServiceCode + ServiceCategoryName) AS SVH,
[H].[ConsigneeID],
H.TotalRevenue
FROM Hawb H
JOIN ServiceType S
ON S.ID = H.ServiceCodeID
WHERE H.PODDate IS NOT NULL
) AS SourceTable 
PIVOT (SUM(TotalRevenue) FOR SVH IN ([S200Courier],[S300Courier],[S400LTL])
) AS PivotTable;

--2ND APPROACH: USING GROUP BY INSTEAD OF DISTINCT IN ABOVE CODE FUNCTION TO ELIMINATE DUPLICATES
SELECT * FROM (
SELECT 
(ServiceCode + ServiceCategoryName) AS SVH,
[H].[ConsigneeID],
H.TotalRevenue
FROM Hawb H
JOIN ServiceType S
ON S.ID = H.ServiceCodeID
WHERE H.PODDate IS NOT NULL
GROUP BY (ServiceCode + ServiceCategoryName) ,
[H].[ConsigneeID],
H.TotalRevenue
) AS SourceTable 
PIVOT (SUM(TotalRevenue) FOR SVH IN ([S200Courier],[S300Courier],[S400LTL])
) AS PivotTable;

	
	
-- 5	Write a query that shows all Hawb values with their revenue, a column with the sum of ALL revenue, and another column with the % of sum total revenue. 
-- 	Hint: Using a SQL window function to calculate the ALL revenue column if you know how.
	WITH CTE AS (
    SELECT [H].[ID],
    [H].[Hawb],
    [H].[HawbDate],
    [H].[ServiceCodeID],
    [H].[DueDate],
    [H].[PODDate],
    [H].[ShipperID],
    [H].[ConsigneeID],
    [H].[TotalRevenue],
SUM([H].[TotalRevenue]) OVER (
  PARTITION BY [H].[ServiceCodeID]
  ORDER BY [H].[ID] ASC) AS running_total --SHOWS TOTAL SUM BY EACH ID
FROM  Hawb H
--ORDER BY [H].[ID] ASC
    )
    SELECT [C].[ID],
    [C].[Hawb],
    [C].[HawbDate],
    [C].[ServiceCodeID],
    [C].[DueDate],
    [C].[PODDate],
    [C].[ShipperID],
    [C].[ConsigneeID],
    [C].[TotalRevenue],
    [C].[running_total],
     ([C].[TotalRevenue] /  ((MAX([C].[running_total])  * 0.1))) AS '% of sum total revenue'
    FROM CTE C
    GROUP BY [C].[ID],
    [C].[Hawb],
    [C].[HawbDate],
    [C].[ServiceCodeID],
    [C].[DueDate],
    [C].[PODDate],
    [C].[ShipperID],
    [C].[ConsigneeID],
    [C].[TotalRevenue],
    [C].[running_total];
	