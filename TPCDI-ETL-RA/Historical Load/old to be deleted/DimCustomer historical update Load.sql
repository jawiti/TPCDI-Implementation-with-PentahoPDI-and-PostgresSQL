
/*DimCustomer historical update*/

DROP FUNCTION IF EXISTS DimCustomerHistoryUpdateLoad();
CREATE FUNCTION DimCustomerHistoryUpdateLoad()
RETURNS VOID AS $$
BEGIN



	DROP TABLE IF EXISTS temp1,UPDCUSTtemp1,new,
	temp2,temp3,temp4,temp5,temp6,temp7,temp8,temp9,temp10,temp11,temp12,
	Utemp2,Utemp2T,UtempOriginal,T2,T3,TT,TT1,INACT,INACTJOIN,
	Utemp3,Utemp4,Utemp5,Utemp6,Utemp7,QUtemp8,NQUtemp9,Utemp10,Utemp11,Utemp12,
	Utemp13,Utemp14,Utemp15,Utemp16,taxtemp2,Utemp12Inact,
	INACTtemp1,INACTtemp,Itemp1;
	--msgTemp1,msgTemp2;


----------------------------------------------------------------------------------------
--------UPDCUST

CREATE TEMPORARY TABLE UPDCUSTtemp1 AS
	SELECT *  FROM tempall where ActionType='UPDCUST' order by customerid;

CREATE TEMPORARY TABLE TT AS
SELECT DISTINCT customerid FROM UPDCUSTtemp1;

	--JOIN UPDCUSTtemp1 TO DimCustomer to store their old surrogate keys
	-- for updating DimAccount
	INSERT INTO CustomerKeys(SK_CustomerID,customerid)
	SELECT D.SK_CustomerID, T.customerid FROM 
	TT T, DimCustomer D
	WHERE
	T.customerid=D.customerid AND
	D.IsCurrent = TRUE;

	
CREATE TEMPORARY TABLE INACT AS
	SELECT ActionType, CustomerID,ActionTS FROM tempall where ActionType='INACT' ORDER BY CustomerID;

	
CREATE TEMPORARY TABLE TT1 AS
SELECT DISTINCT customerid FROM INACT;


	INSERT INTO Customerkeysinact(SK_CustomerID,customerid)
	SELECT D.SK_CustomerID, T.customerid FROM 
	TT1 T, DimCustomer D
	WHERE
	T.customerid=D.customerid AND
	D.IsCurrent = TRUE ORDER BY CustomerID;

	
	--Add Phone attributes
 ALTER TABLE UPDCUSTtemp1
  ADD Phone1 varchar(30),
  ADD Phone2 varchar(30),
  ADD Phone3 varchar(30),
  ADD Status varchar(10) DEFAULT 'Active',
 -- ADD MarketingNameplate varchar(100),
  ADD IsCustomer BOOLEAN,
  ADD BatchID INT ;


--Calculate values for Phone 1
  --Phone1 : CTRY_CODE IS NOT NULL, AREA_CODE IS NOT NULL, C_LOCAL IS NOT NULL
UPDATE UPDCUSTtemp1
SET Phone1 = CONCAT('+',Phone1C_CTRY_CODE,'(',Phone1C_AREA_CODE,')',Phone1C_LOCAL)
WHERE (Phone1C_CTRY_CODE IS NOT NULL) AND (Phone1C_AREA_CODE IS NOT NULL) AND (Phone1C_LOCAL IS NOT NULL);

--Phone1 : CTRY_CODE IS  NULL, AREA_CODE IS NOT NULL, C_LOCAL IS NOT NULL
UPDATE UPDCUSTtemp1
SET Phone1 = CONCAT('(',Phone1C_AREA_CODE,')',Phone1C_LOCAL)
WHERE (Phone1C_CTRY_CODE IS  NULL) AND (Phone1C_AREA_CODE IS NOT NULL) AND (Phone1C_LOCAL IS NOT NULL);

--Phone1 :  AREA_CODE IS  NULL, C_LOCAL IS NOT NULL
UPDATE UPDCUSTtemp1
SET Phone1 = Phone1C_LOCAL
WHERE (Phone1C_AREA_CODE IS NULL) AND (Phone1C_LOCAL IS NOT NULL);


--Phone1 :  ALL ABOVE APPLIED AND C_EXT IS NOT NULL
UPDATE UPDCUSTtemp1
SET Phone1 = CONCAT(Phone1,Phone1C_EXT)
WHERE (Phone1 IS NOT NULL) AND (Phone1C_EXT IS NOT NULL);

--Phone1 :  NON OF THE  ABOVE RULE HAVE BEEN APPLIED
UPDATE UPDCUSTtemp1
SET Phone1 = NULL
WHERE Phone1 = '+()';

UPDATE UPDCUSTtemp1
SET 
Phone1 =substr(Phone1, 4,LENGTH(Phone1))
WHERE substr(Phone1, 1,3) = '+()'
;
UPDATE UPDCUSTtemp1
SET 
Phone1 =substr(Phone1, 2,LENGTH(Phone1))
WHERE substr(Phone1, 1,2) = '+('
;


--Calculate values for Phone 2
 --Phone2 : CTRY_CODE IS NOT NULL, AREA_CODE IS NOT NULL, C_LOCAL IS NOT NULL
UPDATE UPDCUSTtemp1
SET Phone2 = CONCAT('+',Phone2C_CTRY_CODE,'(',Phone2C_AREA_CODE,')',Phone2C_LOCAL)
WHERE (Phone2C_CTRY_CODE IS NOT NULL) AND (Phone2C_AREA_CODE IS NOT NULL) AND (Phone2C_LOCAL IS NOT NULL);

--Phone2 : CTRY_CODE IS  NULL, AREA_CODE IS NOT NULL, C_LOCAL IS NOT NULL
UPDATE UPDCUSTtemp1
SET Phone2 = CONCAT('(',Phone2C_AREA_CODE,')',Phone2C_LOCAL)
WHERE (Phone2C_CTRY_CODE IS  NULL) AND (Phone2C_AREA_CODE IS NOT NULL) AND (Phone2C_LOCAL IS NOT NULL);

--Phone2 :  AREA_CODE IS  NULL, C_LOCAL IS NOT NULL
UPDATE UPDCUSTtemp1
SET Phone2 = Phone2C_LOCAL
WHERE (Phone2C_AREA_CODE IS NULL) AND (Phone2C_LOCAL IS NOT NULL);


--Phone2 :  ALL ABOVE APPLIED AND C_EXT IS NOT NULL
UPDATE UPDCUSTtemp1
SET Phone2 = CONCAT(Phone2,Phone2C_EXT)
WHERE (Phone2 IS NOT NULL) AND (Phone2C_EXT IS NOT NULL);

--Phone2 :  NON OF THE  ABOVE RULE HAVE BEEN APPLIED
UPDATE UPDCUSTtemp1
SET Phone2 = NULL
WHERE Phone2 = '+()';

UPDATE UPDCUSTtemp1
SET 
Phone2 =substr(Phone2, 4,LENGTH(Phone2))
WHERE substr(Phone2, 1,3) = '+()'
;
UPDATE UPDCUSTtemp1
SET 
Phone2 =substr(Phone2, 2,LENGTH(Phone2))
WHERE substr(Phone2, 1,2) = '+('
;


--Calculate values for Phone 3
 --Phone3 : CTRY_CODE IS NOT NULL, AREA_CODE IS NOT NULL, C_LOCAL IS NOT NULL
UPDATE UPDCUSTtemp1
SET Phone3 = CONCAT('+',Phone3C_CTRY_CODE,'(',Phone3C_AREA_CODE,')',Phone3C_LOCAL)
WHERE (Phone3C_CTRY_CODE IS NOT NULL) AND (Phone3C_AREA_CODE IS NOT NULL) AND (Phone3C_LOCAL IS NOT NULL);

--Phone3 : CTRY_CODE IS  NULL, AREA_CODE IS NOT NULL, C_LOCAL IS NOT NULL
UPDATE UPDCUSTtemp1
SET Phone3 = CONCAT('(',Phone3C_AREA_CODE,')',Phone3C_LOCAL)
WHERE (Phone3C_CTRY_CODE IS  NULL) AND (Phone3C_AREA_CODE IS NOT NULL) AND (Phone3C_LOCAL IS NOT NULL);

--Phone3 :  AREA_CODE IS  NULL, C_LOCAL IS NOT NULL
UPDATE UPDCUSTtemp1
SET Phone3 = Phone3C_LOCAL
WHERE (Phone3C_AREA_CODE IS NULL) AND (Phone3C_LOCAL IS NOT NULL);


--Phone3 :  ALL ABOVE APPLIED AND C_EXT IS NOT NULL
UPDATE UPDCUSTtemp1
SET Phone3 = CONCAT(Phone3,Phone3C_EXT)
WHERE (Phone3 IS NOT NULL) AND (Phone3C_EXT IS NOT NULL);

--Phone3 :  NON OF THE  ABOVE RULE HAVE BEEN APPLIED
UPDATE UPDCUSTtemp1
SET Phone3 = NULL
WHERE Phone3 = '+()';


UPDATE UPDCUSTtemp1
SET 
Phone3 =substr(Phone3, 4,LENGTH(Phone3))
WHERE substr(Phone3, 1,3) = '+()'
;
UPDATE UPDCUSTtemp1
SET 
Phone3 =substr(Phone3, 2,LENGTH(Phone3))
WHERE substr(Phone3, 1,2) = '+('
;

--Drop table  Utemp2T 


CREATE TEMPORARY TABLE Utemp2T AS
SELECT D.TaxID ,D.Status,D.LastName, D.FirstName, D.MiddleInitial,D.Gender,D.dob,D.Tier,
D.NationalTaxRateDesc, D.NationalTaxRate, D.LocalTaxRateDesc,D.LocalTaxRate,
U.ActionType,U.CustomerID,U.ActionTS, 
D.AddressLine1, D.AddressLine2, D.PostalCode, D.City, D.StateProv, D.Country, 
D.Phone1, D.Phone2, D.Phone3,D.Email1, D.Email2,
U.Tier AS TierNew,U.AddressLine1 AS AddressLine1New , U.AddressLine2 AS AddressLine2New, U.PostalCode AS PostalCodeNew,
U.City AS CityNew,  U.State_Prov AS State_ProvNew, U.Country AS CountryNew, 
U.Phone1 AS Phone1New, U.Phone2 as Phone2New, U.Phone3 AS Phone3New,
U.Email1 AS Email1New, U.Email2 AS Email2New
--U.MarketingNameplate,
FROM UPDCUSTtemp1 U,DimCustomer D
WHERE
U.CustomerID=D.CustomerID AND D.IsCurrent=true;
--SELECT CustomerID,LastName,FirstName,ActionTS, tIER, TIERNEW FROM Utemp2T ORDER BY CustomerID,LastName,FirstName,ActionTS;

--UPDATE Utemp2T
--SET
--Tier = TierNew
--WHERE Tier != TierNew;-- OR Tier IS NULL;

UPDATE Utemp2T
SET
AddressLine1 = AddressLine1New
WHERE AddressLine1 != AddressLine1New;

UPDATE Utemp2T 
SET
AddressLine2 = AddressLine2New
WHERE AddressLine2 != AddressLine2New;

UPDATE Utemp2T 
SET
PostalCode = PostalCodeNew
WHERE PostalCode != PostalCodeNew;

UPDATE Utemp2T 
SET
City = CityNew
WHERE City != CityNew;

UPDATE Utemp2T 
SET
Country = CountryNew
WHERE Country != CountryNew;

UPDATE Utemp2T 
SET
StateProv = State_ProvNew
WHERE StateProv != State_ProvNew;

UPDATE Utemp2T
SET
Phone1 = Phone1New
WHERE Phone1 != Phone1New;

UPDATE Utemp2T 
SET
Phone2 = Phone2New
WHERE Phone2 != Phone2New;

UPDATE Utemp2T 
SET
Phone3 = Phone3New
WHERE Phone3 != Phone3New;

UPDATE Utemp2T 
SET
Email1 = Email1New
WHERE Email1 != Email1New;


UPDATE Utemp2T 
SET
Email2 = Email2New
WHERE Email2 != Email2New;


CREATE TEMPORARY TABLE Utemp2 AS
SELECT TaxID ,Status,LastName, FirstName, MiddleInitial,Gender,dob,Tier,
NationalTaxRateDesc, NationalTaxRate, LocalTaxRateDesc, LocalTaxRate,
ActionType, CustomerID, ActionTS, 
 AddressLine1 ,  AddressLine2, PostalCode,
 City,  StateProv, Country, 
Phone1, Phone2, Phone3,
Email1, Email2
FROM Utemp2T;


/*
--Join Updating Tuples to DimCustomer on the CustomerID column.
--Atrributes that exist in the xml file will be used but attributes that do not exist in the xml file
--will retain their values already in DimCustomer.
--Store in Utemp2
CREATE TEMPORARY TABLE Utemp2 AS
SELECT D.TaxID ,D.Status,D.LastName, D.FirstName, D.MiddleInitial,D.Gender,D.dob,D.Tier,
U.ActionType,U.CustomerID,U.ActionTS,D.AddressLine1, U.AddressLine2, D.PostalCode,
 D.City, U.State_Prov, U.Country,
U.Phone1, U.Phone2, U.Phone3,
--U.MarketingNameplate,
U.Email1, U.Email2,D.NationalTaxRateDesc, D.NationalTaxRate, D.LocalTaxRateDesc,D.LocalTaxRate
FROM UPDCUSTtemp1 U,DimCustomer D
WHERE
U.CustomerID=D.CustomerID AND D.IsCurrent=true;

*/


--THIS HAS ALL ORIGINAL DATA where actiontype is 'UPDCUST' or 'INACT'
CREATE TEMPORARY TABLE UtempOriginal AS
SELECT  ActionType,CustomerID,ActionTS
FROM   tempall where ActionType='UPDCUST' OR ActionType='INACT';

-- Tuples in Utemp2 that has NEWER UPDCUST AND INACT ACTIONS
CREATE TEMPORARY TABLE Utemp6 AS
SELECT  U.CustomerID
FROM
UtempOriginal T,Utemp2 U
WHERE
T.CustomerID=U.CustomerID AND 
(T.ActionType ='UPDCUST' OR T.ActionType ='INACT') AND
 T.ActionTS >U.ActionTS ORDER BY CUSTOMERID ASC;


-- THESE TUPLES HAVE NOT NO NEWER UPDCUST AND INACT ACTIONS
CREATE TEMPORARY TABLE Utemp7 AS
SELECT distinct Utemp2.CustomerID
FROM  Utemp2 LEFT OUTER JOIN Utemp6 ON
Utemp2.CustomerID = Utemp6.CustomerID
where Utemp6.CustomerID IS NULL;

--SELECT ONLY THE ONES QUALIFIED FOR agencyid,creditrating etc from prospect
CREATE TEMPORARY TABLE QUtemp8 AS
SELECT *
FROM 
Utemp7 NATURAL JOIN Utemp2;-- ORDER BY CUSTOMERID ASC;

--SELECT ONLY THE ONES not QUALIFIED FOR UPDATE from prospect.
-- The attributes remain as in dimcustomer
CREATE TEMPORARY TABLE NQUtemp9 AS
SELECT *
FROM 
Utemp6 NATURAL JOIN Utemp2; 
	


--For tuples in NQUtemp9, maintain AgencyID, 
--CreditRating, NetWorth, MarketingNameplate attributes in DimCustomer
CREATE TEMPORARY TABLE Utemp3 AS
SELECT 	T.TaxID ,T.Status,T.LastName, T.FirstName, T.MiddleInitial,T.Gender,T.dob,T.Tier,
T.ActionType,T.CustomerID,T.ActionTS,T.AddressLine1, T.AddressLine2, T.PostalCode,
 T.City, T.StateProv, T.Country,
T.Phone1, T.Phone2, T.Phone3,T.Email1, T.Email2,T.NationalTaxRateDesc, 
T.NationalTaxRate, T.LocalTaxRateDesc,T.LocalTaxRate,
D.AgencyID, D.CreditRating, D.NetWorth,D.MarketingNameplate
FROM   NQUtemp9 T , DimCustomer D WHERE
T.CustomerID=D.CustomerID AND D.Iscurrent=true;



ALTER TABLE QUtemp8
ADD MarketingNameplate varchar(100);


-- For tuples in QUtemp8, get corresponding tuples in Prospect.
--Left outer join will substitute Prospect fields with null if they do not exist
	CREATE TEMPORARY TABLE Utemp4 AS
SELECT 	T.ActionType, T.CustomerID, T.TaxID,T.Status,T.LastName, T.FirstName, T.MiddleInitial, T.Gender,
T.Tier, T.DOB,	T.AddressLine1, T.AddressLine2, T.PostalCode, T.City, T.StateProv, T.Country, T.Phone1, 
T.Phone2, T.Phone3, T.Email1, T.Email2, T.ActionTS, T.MarketingNameplate, T.NationalTaxRateDesc, T.NationalTaxRate,  T.LocalTaxRateDesc,
T.LocalTaxRate, P.AgencyID, P.CreditRating, P.NetWorth,P.numericberChildren, 
P.Age, P.Income, P.numericberCars, P.numericberCreditCards
FROM   QUtemp8 T LEFT OUTER JOIN TempProspect P ON

(
TRIM(BOTH ' ' FROM UPPER(T.LastName)) = TRIM(BOTH ' ' FROM UPPER(P.LastName)) AND 
TRIM(BOTH ' ' FROM UPPER(T.FirstName)) = TRIM(BOTH ' ' FROM UPPER(P.FirstName)) AND 
TRIM(BOTH ' ' FROM UPPER(T.AddressLine1)) = TRIM(BOTH ' ' FROM UPPER(P.AddressLine1)) AND 
--LATER FIND OUT WHY IF AddressLine2 IS ADDED, SOME TUPLES DO NOT GET A MATCHING TempProspect ATTRIBUTES
TRIM(BOTH ' ' FROM UPPER(T.AddressLine2)) = TRIM(BOTH ' ' FROM UPPER(P.AddressLine2)) AND 
TRIM(BOTH ' ' FROM UPPER(T.PostalCode)) = TRIM(BOTH ' ' FROM UPPER(P.PostalCode)));



--Calculate MarketingNameplate
UPDATE Utemp4
SET MarketingNameplate = CONCAT(MarketingNameplate, '+', 'HighValue')
WHERE NetWorth>1000000 OR Income > 200000;

UPDATE Utemp4
SET MarketingNameplate = CONCAT(MarketingNameplate , '+','Expenses')
WHERE numericberChildren>3 OR numericberCreditCards > 5;

UPDATE Utemp4
SET MarketingNameplate = CONCAT(MarketingNameplate, '+', 'Boomer')
WHERE Age>45;

UPDATE Utemp4
SET MarketingNameplate = CONCAT(MarketingNameplate, '+', 'MoneyAlert')
WHERE Income<50000 OR CreditRating < 600 OR NetWorth<100000;

UPDATE Utemp4
SET MarketingNameplate = CONCAT(MarketingNameplate, '+', 'Spender')
WHERE numericberCars>3 OR numericberCreditCards > 7;

UPDATE Utemp4
SET MarketingNameplate = CONCAT(MarketingNameplate, '+', 'Inherited')
WHERE Age<25 AND NetWorth>1000000;

UPDATE Utemp4
SET MarketingNameplate = btrim(MarketingNameplate, '+');


--UNION BOTH
CREATE TEMPORARY TABLE Utemp10 AS
SELECT ActionType,CustomerID, TaxID,Status,LastName, FirstName, MiddleInitial, Gender, Tier, DOB,
	AddressLine1, AddressLine2, PostalCode, City, StateProv, Country, Phone1, Phone2, Phone3,
	Email1, Email2,ActionTS, MarketingNameplate,NationalTaxRateDesc,NationalTaxRate,
	LocalTaxRateDesc,LocalTaxRate,AgencyID, CreditRating, NetWorth
	--,numericberChildren, Age, Income, numericberCars, numericberCreditCards
FROM
Utemp4 --QUALIFIED
UNION
SELECT ActionType,CustomerID, TaxID,Status, LastName, FirstName, MiddleInitial, Gender, Tier, DOB,
	AddressLine1, AddressLine2, PostalCode, City, StateProv, Country, Phone1, Phone2, Phone3,
	Email1, Email2,ActionTS, MarketingNameplate,NationalTaxRateDesc,NationalTaxRate,
	LocalTaxRateDesc,LocalTaxRate,AgencyID, CreditRating, NetWorth
	--,numericberChildren, Age, Income, numericberCars, numericberCreditCards
FROM
Utemp3;--NOT QUALIFIED



--FIND current Matching tuples in DimCustomer for Utemp10.
CREATE TEMPORARY TABLE Utemp13 AS
	SELECT CustomerID,IsCurrent,EndDate
	FROM DimCustomer C
	WHERE EXISTS
	(SELECT CustomerID
	FROM Utemp10 T where C.CustomerID = T.CustomerID AND C.IsCurrent=TRUE); 




-- Retire matching tuples in DimCustomer
	UPDATE DimCustomer SET
	EndDate=  (SELECT MAX(datevalue) AS EffectiveDate FROM DimDate),
	--EndDate=  (SELECT ActionTS AS EffectiveDate FROM DimDate),
	IsCurrent = False
	WHERE EXISTS
	(SELECT Utemp13.CustomerID
	FROM Utemp13 WHERE Utemp13.CustomerID = DimCustomer.CustomerID AND DimCustomer.IsCurrent=TRUE);


--Get the maximum surrogate key value. 
--This will be used as starting surrogate key for inserting updated tuples.
CREATE TEMPORARY TABLE Utemp12 AS
	SELECT MAX(SK_CustomerID) AS SK_CustomerID_value FROM DimCustomer;






--Insert Updating tuples

	INSERT INTO DimCustomer(SK_CustomerID,CustomerID, TaxID, Status,LastName, FirstName, MiddleInitial,
	 Gender, Tier, DOB, AddressLine1, AddressLine2, PostalCode, City, StateProv, Country,
	  Phone1, Phone2, Phone3,Email1, Email2,NationalTaxRateDesc,
	  NationalTaxRate,LocalTaxRateDesc,LocalTaxRate,AgencyID, CreditRating, NetWorth,MarketingNameplate,
	  IsCurrent,BatchID,EffectiveDate,EndDate)
	SELECT U.SK_CustomerID_value + row_number() over( order by U.SK_CustomerID_value) as SK_CustomerID, 
	T.CustomerID, TaxID, Status,LastName, FirstName, MiddleInitial,
	 Gender, T.Tier::int, DOB, AddressLine1, AddressLine2, PostalCode, City, StateProv, Country,
	  Phone1, Phone2, Phone3,Email1, Email2,NationalTaxRateDesc,
	  NationalTaxRate,LocalTaxRateDesc,LocalTaxRate,AgencyID, CreditRating, NetWorth,MarketingNameplate,
	  --TRUE,1,(SELECT MAX(datevalue) AS EffectiveDate FROM DimDate),'9999-12-31'
	  TRUE,1,T.ActionTS,'9999-12-31'
	FROM 
	Utemp10 T,Utemp12 U
	ORDER BY SK_CustomerID ASC;

--Set enddate and IsCurrent of all UPDCUST tuples 
CREATE TEMPORARY TABLE T2 AS
    SELECT *,
    lead(EffectiveDate) over (partition by customerid order by EffectiveDate) as enddatenew,
    lead(iscurrent) over (partition by customerid order by EffectiveDate) as iscurrentnew
    FROM DimCustomer;-- where iscurrent=true;


UPDATE T2 SET
iscurrent=FALSE,
enddate= enddatenew
WHERE iscurrentnew is not null and enddatenew is not null;

ALTER TABLE DimAccount
 DROP CONSTRAINT  IF EXISTS   dimaccount_sk_customerid_fkey;

DELETE FROM DimCustomer WHERE SK_CustomerID IS NOT NULL;


INSERT INTO DimCustomer(SK_CustomerID,CustomerID, TaxID, Status,LastName, FirstName, MiddleInitial,
	 Gender, Tier, DOB, AddressLine1, AddressLine2, PostalCode, City, StateProv, Country,
	  Phone1, Phone2, Phone3,Email1, Email2,NationalTaxRateDesc,
	  NationalTaxRate,LocalTaxRateDesc,LocalTaxRate,AgencyID, CreditRating, NetWorth,MarketingNameplate,
	  IsCurrent,BatchID,EffectiveDate,EndDate)
	SELECT SK_CustomerID,CustomerID, TaxID, Status,LastName, FirstName, MiddleInitial,
	 Gender, Tier, DOB, AddressLine1, AddressLine2, PostalCode, City, StateProv, Country,
	  Phone1, Phone2, Phone3,Email1, Email2,NationalTaxRateDesc,
	  NationalTaxRate,LocalTaxRateDesc,LocalTaxRate,AgencyID, CreditRating, NetWorth,MarketingNameplate,
	  IsCurrent,BatchID,EffectiveDate,EndDate
	FROM T2;



ALTER TABLE DimAccount 
ADD CONSTRAINT dimaccount_sk_customerid_fkey FOREIGN KEY (SK_CustomerID) REFERENCES DimCustomer (SK_CustomerID);




----------------------------------------------------------------------------------------
--------INACT

--Get tuples from xml where ActionType='INACT'
--Store in INACTtemp1


CREATE TEMPORARY TABLE INACTtemp1 AS
	SELECT ActionType, CustomerID,ActionTS FROM tempall where ActionType='INACT' order by CustomerID;

CREATE TEMPORARY TABLE INACTJOIN AS
SELECT SK_CustomerID,D.CustomerID, TaxID, Status,LastName, FirstName, MiddleInitial,
	 Gender, Tier, DOB, AddressLine1, AddressLine2, PostalCode, City, StateProv, Country,
	  Phone1, Phone2, Phone3,Email1, Email2,NationalTaxRateDesc,
	  NationalTaxRate,LocalTaxRateDesc,LocalTaxRate,AgencyID, CreditRating, NetWorth,MarketingNameplate,
	  BatchID,ActionTS
FROM INACTtemp1 I, DimCustomer D
WHERE I.CustomerID = D.CustomerID AND
D.IsCurrent=TRUE;
	

	
--For tuples in DimCustomer with matches in INACTtemp1, set status as 'Inactive'
UPDATE DimCustomer D SET
	Status=  'Inactive',
	IsCurrent=FALSE
	--THIS CREATES ERROR IN UPDACCT. SOME ACCONTID DO NOT GET SK_CUSTOMERID THAT FALLS ON 
	--THE DATE RANGE OF EFFECTIVE DATE AND END DATE
	,EndDate=(SELECT date_trunc('day', ActionTS)
               FROM INACTtemp1
               WHERE INACTtemp1.CustomerID = D.CustomerID)
	WHERE EXISTS
	(SELECT CustomerID
	FROM INACTtemp1 I where D.CustomerID = I.CustomerID AND D.IsCurrent=TRUE);



CREATE TEMPORARY TABLE Utemp12Inact AS
	SELECT MAX(SK_CustomerID) AS SK_CustomerID_value FROM DimCustomer;


	
INSERT INTO DimCustomer(SK_CustomerID,CustomerID, TaxID, Status,LastName, FirstName, MiddleInitial,
	 Gender, Tier, DOB, AddressLine1, AddressLine2, PostalCode, City, StateProv, Country,
	  Phone1, Phone2, Phone3,Email1, Email2,NationalTaxRateDesc,
	  NationalTaxRate,LocalTaxRateDesc,LocalTaxRate,AgencyID, CreditRating, NetWorth,MarketingNameplate,
	  IsCurrent,BatchID,EffectiveDate,EndDate)
	SELECT U.SK_CustomerID_value + row_number() over( order by U.SK_CustomerID_value) as SK_CustomerID,
	CustomerID, TaxID, 'Inactive',LastName, FirstName, MiddleInitial,
	 Gender, Tier, DOB, AddressLine1, AddressLine2, PostalCode, City, StateProv, Country,
	  Phone1, Phone2, Phone3,Email1, Email2,NationalTaxRateDesc,
	  NationalTaxRate,LocalTaxRateDesc,LocalTaxRate,AgencyID, CreditRating, NetWorth,MarketingNameplate,
	  TRUE,BatchID,ActionTS,'9999-12-31'
	FROM INACTJOIN, Utemp12Inact U;

--get NEW
CREATE TEMPORARY TABLE new AS
	SELECT * FROM tempall where ActionType='NEW' order by customerid;


--JOIN INACT TO NEW TO GET LastName,FirstName,AddressLine1,AddressLine2,PostalCode
CREATE TEMPORARY TABLE INACTtemp AS
SELECT I.ActionType, I.CustomerID, I.ActionTS ,T.LastName, T.FirstName, T.AddressLine1, T.AddressLine2, 
T.PostalCode FROM
INACTtemp1 I, new T
WHERE I.CustomerID = T.CustomerID ORDER BY CustomerID ASC;



--Store tuples with matches in Prospect in  Itemp1
CREATE TEMPORARY TABLE Itemp1 AS
SELECT T.ActionType, T.CustomerID,T.LastName, T.FirstName, T.AddressLine1, T.AddressLine2, 
T.PostalCode, P.AgencyID, P.CreditRating, P.NetWorth,P.numericberChildren, 
P.Age, P.Income, P.numericberCars, P.numericberCreditCards
FROM   INACTtemp T LEFT OUTER JOIN TempProspect P ON
(
TRIM(BOTH ' ' FROM UPPER(T.LastName)) = TRIM(BOTH ' ' FROM UPPER(P.LastName)) AND 
TRIM(BOTH ' ' FROM UPPER(T.FirstName)) = TRIM(BOTH ' ' FROM UPPER(P.FirstName)) AND 
TRIM(BOTH ' ' FROM UPPER(T.AddressLine1)) = TRIM(BOTH ' ' FROM UPPER(P.AddressLine1)) AND 
TRIM(BOTH ' ' FROM UPPER(T.AddressLine2)) = TRIM(BOTH ' ' FROM UPPER(P.AddressLine2)) AND 
TRIM(BOTH ' ' FROM UPPER(T.PostalCode)) = TRIM(BOTH ' ' FROM UPPER(P.PostalCode)));




Alter Table Itemp1
ADD COLUMN MarketingNameplate VARCHAR(100);

--Calculate MarketingNameplate for Inactive tuples
UPDATE Itemp1
SET MarketingNameplate = CONCAT(MarketingNameplate, '+', 'HighValue')
WHERE NetWorth>1000000 OR Income > 200000;

UPDATE Itemp1
SET MarketingNameplate = CONCAT(MarketingNameplate , '+','Expenses')
WHERE numericberChildren>3 OR numericberCreditCards > 5;

UPDATE Itemp1
SET MarketingNameplate = CONCAT(MarketingNameplate, '+', 'Boomer')
WHERE Age>45;

UPDATE Itemp1
SET MarketingNameplate = CONCAT(MarketingNameplate, '+', 'MoneyAlert')
WHERE Income<50000 OR CreditRating < 600 OR NetWorth<100000;

UPDATE Itemp1
SET MarketingNameplate = CONCAT(MarketingNameplate, '+', 'Spender')
WHERE numericberCars>3 OR numericberCreditCards > 7;

UPDATE Itemp1
SET MarketingNameplate = CONCAT(MarketingNameplate, '+', 'Inherited')
WHERE Age<25 AND NetWorth>1000000;

UPDATE Itemp1
SET MarketingNameplate = btrim(MarketingNameplate, '+');






--For tuples in DimCustomer with matches in Itemp1, set the corresponding attributes
UPDATE DimCustomer D SET
 AgencyID = (SELECT AgencyID
                 FROM Itemp1
                 WHERE Itemp1.CustomerID = D.CustomerID),
 CreditRating =(SELECT CreditRating
                 FROM Itemp1
                 WHERE Itemp1.CustomerID = D.CustomerID),
 NetWorth =(SELECT NetWorth
                 FROM Itemp1
                 WHERE Itemp1.CustomerID = D.CustomerID),
 MarketingNameplate=(SELECT MarketingNameplate
                 FROM Itemp1
                 WHERE Itemp1.CustomerID = D.CustomerID)
WHERE EXISTS
	(
SELECT D.CustomerID FROM Itemp1 I WHERE
D.CustomerID = I.CustomerID);





	END;
$$ LANGUAGE 'plpgsql';