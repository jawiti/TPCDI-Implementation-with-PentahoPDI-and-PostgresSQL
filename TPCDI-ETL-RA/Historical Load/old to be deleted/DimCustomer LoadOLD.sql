/*DimCustomer Load*/



DROP FUNCTION IF EXISTS DimCustomerLoad();
CREATE FUNCTION DimCustomerLoad()
RETURNS VOID AS $$
BEGIN



	DROP TABLE IF EXISTS temp1,UPDCUSTtemp1,
	temp2,temp3,temp4,temp5,temp6,temp7,temp8,temp9,temp10,temp11,temp12,
	Utemp2,Utemp2T,UtempOriginal,
	Utemp3,Utemp4,Utemp5,Utemp6,Utemp7,QUtemp8,NQUtemp9,Utemp10,Utemp11,Utemp12,
	Utemp13,Utemp14,Utemp15,Utemp16,taxtemp2,
	INACTtemp1,INACTtemp,Itemp1,
	msgTemp1,msgTemp2;

--UPDATE AddressLine2 Where Empty
	


	
--Select tuples with actiontype = 'NEW' into temp1
	CREATE TEMPORARY TABLE temp1 AS
	SELECT * FROM tempall where ActionType='NEW';

	

--Add the following Columns
ALTER TABLE temp1
  ADD Phone1 varchar(30),
  ADD Phone2 varchar(30),
  ADD Phone3 varchar(30),
  ADD Status varchar(10) DEFAULT 'Active',
  ADD MarketingNameplate varchar(100),
  ADD IsCustomer BOOLEAN,
  ADD BatchID INT ;

--------------SET PHONE NUMBERS----------------------

  --Phone1 : CTRY_CODE IS NOT NULL, AREA_CODE IS NOT NULL, C_LOCAL IS NOT NULL
UPDATE temp1
SET Phone1 = CONCAT('+',Phone1C_CTRY_CODE,'(',Phone1C_AREA_CODE,')',Phone1C_LOCAL)
WHERE (Phone1C_CTRY_CODE IS NOT NULL) AND (Phone1C_AREA_CODE IS NOT NULL) AND (Phone1C_LOCAL IS NOT NULL);

--Phone1 : CTRY_CODE IS  NULL, AREA_CODE IS NOT NULL, C_LOCAL IS NOT NULL
UPDATE temp1
SET Phone1 = CONCAT('(',Phone1C_AREA_CODE,')',Phone1C_LOCAL)
WHERE (Phone1C_CTRY_CODE IS  NULL) AND (Phone1C_AREA_CODE IS NOT NULL) AND (Phone1C_LOCAL IS NOT NULL);

--Phone1 :  AREA_CODE IS  NULL, C_LOCAL IS NOT NULL
UPDATE temp1
SET Phone1 = Phone1C_LOCAL
WHERE (Phone1C_AREA_CODE IS NULL) AND (Phone1C_LOCAL IS NOT NULL);


--Phone1 :  ALL ABOVE APPLIED AND C_EXT IS NOT NULL
UPDATE temp1
SET Phone1 = CONCAT(Phone1,Phone1C_EXT)
WHERE (Phone1 IS NOT NULL) AND (Phone1C_EXT IS NOT NULL);

--Phone1 :  NON OF THE  ABOVE RULE HAVE BEEN APPLIED
UPDATE temp1
SET Phone1 = NULL
WHERE Phone1 = '+()';

UPDATE temp1
SET 
Phone1 =substr(Phone1, 4,LENGTH(Phone1))
WHERE substr(Phone1, 1,3) = '+()'
;
UPDATE temp1
SET 
Phone1 =substr(Phone1, 2,LENGTH(Phone1))
WHERE substr(Phone1, 1,2) = '+('
;


 --Phone2 : CTRY_CODE IS NOT NULL, AREA_CODE IS NOT NULL, C_LOCAL IS NOT NULL
UPDATE temp1
SET Phone2 = CONCAT('+',Phone2C_CTRY_CODE,'(',Phone2C_AREA_CODE,')',Phone2C_LOCAL)
WHERE (Phone2C_CTRY_CODE IS NOT NULL) AND (Phone2C_AREA_CODE IS NOT NULL) AND (Phone2C_LOCAL IS NOT NULL);

--Phone2 : CTRY_CODE IS  NULL, AREA_CODE IS NOT NULL, C_LOCAL IS NOT NULL
UPDATE temp1
SET Phone2 = CONCAT('(',Phone2C_AREA_CODE,')',Phone2C_LOCAL)
WHERE (Phone2C_CTRY_CODE IS  NULL) AND (Phone2C_AREA_CODE IS NOT NULL) AND (Phone2C_LOCAL IS NOT NULL);

--Phone2 :  AREA_CODE IS  NULL, C_LOCAL IS NOT NULL
UPDATE temp1
SET Phone2 = Phone2C_LOCAL
WHERE (Phone2C_AREA_CODE IS NULL) AND (Phone2C_LOCAL IS NOT NULL);


--Phone2 :  ALL ABOVE APPLIED AND C_EXT IS NOT NULL
UPDATE temp1
SET Phone2 = CONCAT(Phone2,Phone2C_EXT)
WHERE (Phone2 IS NOT NULL) AND (Phone2C_EXT IS NOT NULL);

--Phone2 :  NON OF THE  ABOVE RULE HAVE BEEN APPLIED
UPDATE temp1
SET Phone2 = NULL
WHERE Phone2 = '+()';

UPDATE temp1
SET 
Phone2 =substr(Phone2, 4,LENGTH(Phone2))
WHERE substr(Phone2, 1,3) = '+()'
;
UPDATE temp1
SET 
Phone2 =substr(Phone2, 2,LENGTH(Phone2))
WHERE substr(Phone2, 1,2) = '+('
;



 --Phone3 : CTRY_CODE IS NOT NULL, AREA_CODE IS NOT NULL, C_LOCAL IS NOT NULL
UPDATE temp1
SET Phone3 = CONCAT('+',Phone3C_CTRY_CODE,'(',Phone3C_AREA_CODE,')',Phone3C_LOCAL)
WHERE (Phone3C_CTRY_CODE IS NOT NULL) AND (Phone3C_AREA_CODE IS NOT NULL) AND (Phone3C_LOCAL IS NOT NULL);

--Phone3 : CTRY_CODE IS  NULL, AREA_CODE IS NOT NULL, C_LOCAL IS NOT NULL
UPDATE temp1
SET Phone3 = CONCAT('(',Phone3C_AREA_CODE,')',Phone3C_LOCAL)
WHERE (Phone3C_CTRY_CODE IS  NULL) AND (Phone3C_AREA_CODE IS NOT NULL) AND (Phone3C_LOCAL IS NOT NULL);

--Phone3 :  AREA_CODE IS  NULL, C_LOCAL IS NOT NULL
UPDATE temp1
SET Phone3 = Phone3C_LOCAL
WHERE (Phone3C_AREA_CODE IS NULL) AND (Phone3C_LOCAL IS NOT NULL);


--Phone3 :  ALL ABOVE APPLIED AND C_EXT IS NOT NULL
UPDATE temp1
SET Phone3 = CONCAT(Phone3,Phone3C_EXT)
WHERE (Phone3 IS NOT NULL) AND (Phone3C_EXT IS NOT NULL);

--Phone3 :  NON OF THE  ABOVE RULE HAVE BEEN APPLIED
UPDATE temp1
SET Phone3 = NULL
WHERE Phone3 = '+()';


UPDATE temp1
SET 
Phone3 =substr(Phone3, 4,LENGTH(Phone3))
WHERE substr(Phone3, 1,3) = '+()'
;
UPDATE temp1
SET 
Phone3 =substr(Phone3, 2,LENGTH(Phone3))
WHERE substr(Phone3, 1,2) = '+('
;




--GENDER
UPDATE TEMP1
SET GENDER = 'U'
WHERE (GENDER <> 'F' AND GENDER <> 'M') OR GENDER IS NULL;

--TAXRATE
CREATE TEMPORARY TABLE temp2 AS
SELECT  ActionType,CustomerID, TaxID, Status,LastName, FirstName, MiddleInitial, Gender, Tier, DOB,
	AddressLine1, AddressLine2, PostalCode, City, State_Prov, Country, Phone1, Phone2, Phone3,
	Email1, Email2,ActionTS, MarketingNameplate, 
	TX_NAME as NationalTaxRateDesc, TX_RATE as NationalTaxRate,C_LCL_TX_ID
	FROM temp1 LEFT OUTER JOIN TaxRate ON
	--WHERE
	 C_NAT_TX_ID = TX_ID;

CREATE TEMPORARY TABLE temp3 AS
	SELECT  ActionType,CustomerID, TaxID, Status,LastName, FirstName, MiddleInitial, Gender, Tier, DOB,
	AddressLine1, AddressLine2, PostalCode, City, State_Prov, Country, Phone1, Phone2, Phone3,
	Email1, Email2,ActionTS, MarketingNameplate,NationalTaxRateDesc,NationalTaxRate,
	 TX_NAME as LocalTaxRateDesc, TX_RATE as LocalTaxRate
	FROM temp2 LEFT OUTER JOIN TaxRate ON
	--WHERE 
	C_LCL_TX_ID = TX_ID;






----Select tuples with actiontype = 'UPDCUST' OR 'INACT' into temp5 FROM THE ORIGINAL DATA
CREATE TEMPORARY TABLE temp5 AS
SELECT  ActionType,CustomerID,ActionTS
FROM   tempall where ActionType='UPDCUST' OR ActionType='INACT';

-- THIS HAS DATA WITH  NEWER UPDCUST AND INACT ACTIONS
CREATE TEMPORARY TABLE temp6 AS
SELECT temp3.ActionType,temp3.CustomerID,temp3.ActionTS,
temp5.ActionType as temp5ActionType,temp5.CustomerID as temp5CustomerID,
temp5.ActionTS as temp5ActionTS FROM
temp5,temp3
WHERE
temp5.CustomerID=temp3.CustomerID AND 
((temp5.ActionType ='UPDCUST' OR temp5.ActionType ='INACT') AND temp5.ActionTS >temp3.ActionTS);



-- THESE TUPLES HAVE NO NEWER UPDCUST AND INACT ACTIONS
CREATE TEMPORARY TABLE temp7 AS
SELECT temp3.CustomerID
FROM  temp3 LEFT OUTER JOIN temp6 ON
temp3.CustomerID = temp6.CustomerID
where temp6.CustomerID IS NULL;

--SELECT ONLY THE ONES QUALIFIED FOR UPDATE
CREATE TEMPORARY TABLE temp8 AS
SELECT *
FROM 
temp7 NATURAL JOIN temp3;
	

--SELECT ONLY THE ONES not QUALIFIED FOR UPDATE
CREATE TEMPORARY TABLE temp9 AS
SELECT *
FROM 
temp6 NATURAL JOIN temp3;

--Obtain columns to help aquire AgencyID, CreditRating, Networth, marketingNameplate 
--for the Qualified tuples (temp8)if they 
--exist in prospect
	CREATE TEMPORARY TABLE temp4 AS
SELECT 	T.ActionType, T.CustomerID, T.TaxID, T.Status,T.LastName, T.FirstName, T.MiddleInitial, T.Gender,
T.Tier, T.DOB,	T.AddressLine1, T.AddressLine2, T.PostalCode, T.City, T.State_Prov, T.Country, T.Phone1, 
T.Phone2, T.Phone3, T.Email1, T.Email2, T.ActionTS, T.MarketingNameplate, T.NationalTaxRateDesc, T.NationalTaxRate,  T.LocalTaxRateDesc,
T.LocalTaxRate, P.AgencyID, P.CreditRating, P.NetWorth,P.numericberChildren, 
P.Age, P.Income, P.numericberCars, P.numericberCreditCards
FROM   temp8 T LEFT OUTER JOIN TempProspect P ON

(
TRIM(BOTH ' ' FROM UPPER(T.LastName)) = TRIM(BOTH ' ' FROM UPPER(P.LastName)) AND 
TRIM(BOTH ' ' FROM UPPER(T.FirstName)) = TRIM(BOTH ' ' FROM UPPER(P.FirstName)) AND 
TRIM(BOTH ' ' FROM UPPER(T.AddressLine1)) = TRIM(BOTH ' ' FROM UPPER(P.AddressLine1)) AND 
--LATER FIND OUT WHY IF AddressLine2 IS ADDED, SOME TUPLES DO NOT GET A MATCHING TempProspect ATTRIBUTES
--TRIM(BOTH ' ' FROM UPPER(T.AddressLine2)) = TRIM(BOTH ' ' FROM UPPER(P.AddressLine2)) AND 
TRIM(BOTH ' ' FROM UPPER(T.PostalCode)) = TRIM(BOTH ' ' FROM UPPER(P.PostalCode)));


--Just Add these columns to the unqualified tuples
ALTER TABLE temp9
ADD COLUMN AgencyID VARCHAR,
ADD COLUMN CreditRating NUMERIC(4),
ADD COLUMN NetWorth NUMERIC(12),
ADD COLUMN numericberChildren NUMERIC(2), 
ADD COLUMN Age NUMERIC(3), 
ADD COLUMN Income NUMERIC(9), 
ADD COLUMN numericberCars NUMERIC(2), 
ADD COLUMN numericberCreditCards NUMERIC(2);


--UNION BOTH
CREATE TEMPORARY TABLE temp10 AS
SELECT ActionType,CustomerID, TaxID, Status,LastName, FirstName, MiddleInitial, Gender, Tier, DOB,
	AddressLine1, AddressLine2, PostalCode, City, State_Prov, Country, Phone1, Phone2, Phone3,
	Email1, Email2,ActionTS, MarketingNameplate,NationalTaxRateDesc,NationalTaxRate,
	LocalTaxRateDesc,LocalTaxRate,AgencyID, CreditRating, NetWorth,numericberChildren, 
Age, Income, numericberCars, numericberCreditCards
FROM
temp4 
UNION
SELECT ActionType,CustomerID, TaxID, Status,LastName, FirstName, MiddleInitial, Gender, Tier, DOB,
	AddressLine1, AddressLine2, PostalCode, City, State_Prov, Country, Phone1, Phone2, Phone3,
	Email1, Email2,ActionTS, MarketingNameplate,NationalTaxRateDesc,NationalTaxRate,
	LocalTaxRateDesc,LocalTaxRate,AgencyID, CreditRating, NetWorth,numericberChildren, 
Age, Income, numericberCars, numericberCreditCards
FROM
temp9 ;


--Calculate AgencyID, CreditRating, Networth, marketingNameplate
UPDATE temp10
SET MarketingNameplate = CONCAT(MarketingNameplate, '+', 'HighValue')
WHERE NetWorth>1000000 OR Income > 200000;

UPDATE temp10
SET MarketingNameplate = CONCAT(MarketingNameplate , '+','Expenses')
WHERE numericberChildren>3 OR numericberCreditCards > 5;

UPDATE temp10
SET MarketingNameplate = CONCAT(MarketingNameplate, '+', 'Boomer')
WHERE Age>45;

UPDATE temp10
SET MarketingNameplate = CONCAT(MarketingNameplate, '+', 'MoneyAlert')
WHERE Income<50000 OR CreditRating < 600 OR NetWorth<100000;

UPDATE temp10
SET MarketingNameplate = CONCAT(MarketingNameplate, '+', 'Spender')
WHERE numericberCars>3 OR numericberCreditCards > 7;

UPDATE temp10
SET MarketingNameplate = CONCAT(MarketingNameplate, '+', 'Inherited')
WHERE Age<25 AND NetWorth>1000000;

UPDATE temp10
SET MarketingNameplate = btrim(MarketingNameplate, '+');


--Create TEMPORARY TABLE temp11 AS
--SELECT MIN(datevalue) AS EffectiveDate FROM DimDate;

--Create TEMPORARY TABLE temp12 AS
--SELECT *
--FROM temp11 RIGHT OUTER JOIN temp10 ON
--EffectiveDate IS NOT NULL
--ORDER BY CustomerID ASC;

--JUST TO SORT
Create TEMPORARY TABLE temp12 AS
SELECT ActionType,CustomerID, TaxID, Status,LastName, FirstName, MiddleInitial, Gender, Tier, DOB,
	AddressLine1, AddressLine2, PostalCode, City, State_Prov, Country, Phone1, Phone2, Phone3,
	Email1, Email2,ActionTS, MarketingNameplate,NationalTaxRateDesc,NationalTaxRate,
	LocalTaxRateDesc,LocalTaxRate,AgencyID, CreditRating, NetWorth,numericberChildren, 
Age, Income, numericberCars, numericberCreditCards
FROM temp10 
ORDER BY CustomerID ASC;


--Finally insert tuples with action='new'
	INSERT INTO DimCustomer(SK_CustomerID,CustomerID, TaxID, Status,LastName, FirstName, MiddleInitial,
	 Gender, Tier, DOB, AddressLine1, AddressLine2, PostalCode, City, StateProv, Country,
	  Phone1, Phone2, Phone3,Email1, Email2,NationalTaxRateDesc,
	  NationalTaxRate,LocalTaxRateDesc,LocalTaxRate,AgencyID, CreditRating, NetWorth,MarketingNameplate,
	  IsCurrent,BatchID,EffectiveDate,EndDate)
	SELECT row_number() over( order by 1) AS SK_CustomerID, CustomerID, TaxID, Status,LastName, FirstName, MiddleInitial,
	 Gender, Tier::int, DOB, AddressLine1, AddressLine2, PostalCode, City, State_Prov, Country,
	  Phone1, Phone2, Phone3,Email1, Email2,NationalTaxRateDesc,
	  NationalTaxRate,LocalTaxRateDesc,LocalTaxRate,AgencyID, CreditRating, NetWorth,MarketingNameplate,
	  TRUE,1,ActionTS,'9999-12-31'
	FROM 
	temp12 ;
	
	--INVALID TIER (NOT 1,2 OR 3)
CREATE TEMPORARY TABLE msgTemp1 AS
	SELECT * FROM DimCustomer
	WHERE Tier IS NULL OR
	(Tier!= 1 AND Tier!= 2 AND Tier!= 3);

INSERT INTO DImessages(MessageDateAndTime, BatchID, MessageSource, MessageText, MessageType,MessageData)
	SELECT CURRENT_TIMESTAMP, 1, 'DimCustomer', 'Invalid customer tier', 'Alert',
	CONCAT('C_ID = ',CustomerID, ', C_TIER = ',Tier)
	FROM
	msgTemp1;




	--INVALID DOB
	CREATE TEMPORARY TABLE msgTemp2 AS
	SELECT distinct CustomerID,DoB FROM DimCustomer, BatchDate
	WHERE 
	DoB < (BatchDate.BatchDateColumn - INTERVAL '100 years') OR
	DoB > BatchDate.BatchDateColumn order by CustomerID;

INSERT INTO DImessages(MessageDateAndTime, BatchID, MessageSource, MessageText, MessageType,MessageData)
	SELECT CURRENT_TIMESTAMP, 1, 'DimCustomer', 'DOB out of range', 'Alert',
	CONCAT('C_ID = ',CustomerID, ', C_DOB = ',DoB)
	FROM
	msgTemp2;


END;
$$ LANGUAGE 'plpgsql';
 
--SELECT * FROM Itemp1
