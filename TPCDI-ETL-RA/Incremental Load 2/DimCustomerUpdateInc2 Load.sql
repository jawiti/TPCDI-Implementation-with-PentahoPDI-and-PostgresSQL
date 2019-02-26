/*DimCustomerUpdate Load Inc1*/



DROP FUNCTION IF EXISTS DimCustomerUpdateLoadInc2();
CREATE FUNCTION DimCustomerUpdateLoadInc2()
RETURNS VOID AS $$
BEGIN

	DROP TABLE IF EXISTS inc2temph1,inc2temph2,inc2temph3,inc2temph4,inc2temph5,inc2temph6,inc2temph7,inc2temph8,
	inc2temph9,inc2temph10,incCtemphSur,Old2keys,Old2keys2,Old2keys3,Old2keys4;

	
	--Select tuples with actiontype = 'NEW' into temp1
	CREATE TEMPORARY TABLE inc2temph1 AS
	SELECT CDC_FLAG, CDC_DSN, C_ID, C_TAX_ID, C_ST_ID, C_L_NAME, C_F_NAME, C_M_NAME, C_GNDR,
		C_TIER,C_DOB, C_ADLINE1, C_ADLINE2, C_ZIPCODE, C_CITY, C_STATE_PROV, C_CTRY,
		C_CTRY_1, C_AREA_1, C_LOCAL_1, C_EXT_1, C_CTRY_2, C_AREA_2, C_LOCAL_2, C_EXT_2,
		C_CTRY_3, C_AREA_3, C_LOCAL_3, C_EXT_3, C_EMAIL_1, C_EMAIL_2, C_LCL_TX_ID, C_NAT_TX_ID
	 FROM Customer2 where CDC_FLAG='U' ;



	--FOR LATER UPDATE OF ACCOUNT
	CREATE TEMPORARY TABLE Old2keys AS
	SELECT D.Sk_CustomerID, D.CustomerID
	 FROM inc2temph1 I, DimCustomer D
	 WHERE
	 I.C_ID = D.CustomerID AND
	 D.IsCurrent=TRUE;

	 
	-- Retire matching tuples in DimCustomer
	UPDATE DimCustomer SET
	EndDate=  (SELECT BatchDateColumn AS EndDATE FROM BatchDate2),
	IsCurrent = False
	WHERE EXISTS
	(SELECT inc2temph1.C_ID
	FROM inc2temph1 WHERE inc2temph1.C_ID = DimCustomer.CustomerID AND DimCustomer.IsCurrent=TRUE);


	--GENDER
	UPDATE inc2temph1
	SET C_GNDR = 'U'
	WHERE (C_GNDR <> 'F' AND C_GNDR <> 'M') OR C_GNDR IS NULL;



	CREATE TEMPORARY TABLE inc2temph2 AS
	SELECT  CDC_FLAG, CDC_DSN, C_ID, C_TAX_ID, C_ST_ID, C_L_NAME, C_F_NAME, C_M_NAME, C_GNDR,
		C_TIER,C_DOB, C_ADLINE1, C_ADLINE2, C_ZIPCODE, C_CITY, C_STATE_PROV, C_CTRY,
		C_CTRY_1, C_AREA_1, C_LOCAL_1, C_EXT_1, C_CTRY_2, C_AREA_2, C_LOCAL_2, C_EXT_2,
		C_CTRY_3, C_AREA_3, C_LOCAL_3, C_EXT_3, C_EMAIL_1, C_EMAIL_2, C_LCL_TX_ID, C_NAT_TX_ID,
		 ST_NAME as Status
	FROM inc2temph1 I LEFT OUTER JOIN StatusType S ON
	--WHERE 
	I.C_ST_ID = S.ST_ID;

	--Add the following Columns
	ALTER TABLE inc2temph2
	  ADD Phone1 varchar(30),
	  ADD Phone2 varchar(30),
	  ADD Phone3 varchar(30),
	  ADD MarketingNameplate varchar(100)
	  --,
	 -- ADD IsCustomer BOOLEAN,
	 -- ADD BatchID INT 
	 ;

	--------------SET PHONE NUMBERS----------------------

	  --Phone1 : CTRY_CODE IS NOT NULL, AREA_CODE IS NOT NULL, C_LOCAL IS NOT NULL
	UPDATE inc2temph2
	SET Phone1 = CONCAT('+',TRIM(BOTH ' ' FROM C_CTRY_1),' (',C_AREA_1,') ',C_LOCAL_1)
	WHERE (C_CTRY_1 IS NOT NULL) AND (C_AREA_1 IS NOT NULL) AND (C_LOCAL_1 IS NOT NULL);

	--Phone1 : CTRY_CODE IS  NULL, AREA_CODE IS NOT NULL, C_LOCAL IS NOT NULL
	UPDATE inc2temph2
	SET Phone1 = CONCAT('(',C_AREA_1,')',' ',C_LOCAL_1)
	WHERE (C_CTRY_1 IS  NULL) AND (C_AREA_1 IS NOT NULL) AND (C_LOCAL_1 IS NOT NULL);

	--Phone1 :  AREA_CODE IS  NULL, C_LOCAL IS NOT NULL
	UPDATE inc2temph2
	SET Phone1 = C_LOCAL_1
	WHERE (C_AREA_1 IS NULL) AND (C_LOCAL_1 IS NOT NULL);


	--Phone1 :  ALL ABOVE APPLIED AND C_EXT IS NOT NULL
	UPDATE inc2temph2
	SET Phone1 = CONCAT(Phone1,C_EXT_1)
	WHERE (Phone1 IS NOT NULL) AND (C_EXT_1 IS NOT NULL);

	--Phone1 :  NON OF THE  ABOVE RULE HAVE BEEN APPLIED
	UPDATE inc2temph2
	SET Phone1 = NULL
	WHERE Phone1 = '+ (   ) ';

	UPDATE inc2temph2
	SET 
	Phone1 =substr(Phone1, 9,LENGTH(Phone1))
	WHERE substr(Phone1, 1,8) = '+ (   ) '
	;
	UPDATE inc2temph2
	SET 
	Phone1 =substr(Phone1, 3,LENGTH(Phone1))
	WHERE substr(Phone1, 1,3) = '+ ('
	;





	 --Phone2 : CTRY_CODE IS NOT NULL, AREA_CODE IS NOT NULL, C_LOCAL IS NOT NULL
	UPDATE inc2temph2
	SET Phone2 = CONCAT('+',TRIM(BOTH ' ' FROM C_CTRY_2),' (',C_AREA_2,') ',C_LOCAL_2)
	WHERE (C_CTRY_2 IS NOT NULL) AND (C_AREA_2 IS NOT NULL) AND (C_LOCAL_2 IS NOT NULL);

	--Phone2 : CTRY_CODE IS  NULL, AREA_CODE IS NOT NULL, C_LOCAL IS NOT NULL
	UPDATE inc2temph2
	SET Phone2 = CONCAT('(',C_AREA_2,')',' ',C_LOCAL_2)
	WHERE (C_CTRY_2 IS  NULL) AND (C_AREA_2 IS NOT NULL) AND (C_LOCAL_2 IS NOT NULL);

	--Phone2 :  AREA_CODE IS  NULL, C_LOCAL IS NOT NULL
	UPDATE inc2temph2
	SET Phone2 = C_LOCAL_2
	WHERE (C_AREA_2 IS NULL) AND (C_LOCAL_2 IS NOT NULL);


	--Phone2 :  ALL ABOVE APPLIED AND C_EXT IS NOT NULL
	UPDATE inc2temph2
	SET Phone2 = CONCAT(Phone2,C_EXT_2)
	WHERE (Phone2 IS NOT NULL) AND (C_EXT_2 IS NOT NULL);

	--Phone2 :  NON OF THE  ABOVE RULE HAVE BEEN APPLIED
	UPDATE inc2temph2
	SET Phone2 = NULL
	WHERE Phone2 = '+ (   ) ' or Phone2 = '               ';

	UPDATE inc2temph2
	SET 
	Phone2 =substr(Phone2, 9,LENGTH(Phone2))
	WHERE substr(Phone2, 1,8) = '+ (   ) '
	;
	UPDATE inc2temph2
	SET 
	Phone2 =substr(Phone2, 3,LENGTH(Phone2))
	WHERE substr(Phone2, 1,3) = '+ ('
	;


		  
	 --Phone3 : CTRY_CODE IS NOT NULL, AREA_CODE IS NOT NULL, C_LOCAL IS NOT NULL
	UPDATE inc2temph2
	SET Phone3 = CONCAT('+',TRIM(BOTH ' ' FROM C_CTRY_3),' (',C_AREA_3,') ',C_LOCAL_3)
	WHERE (C_CTRY_3 IS NOT NULL) AND (C_AREA_3 IS NOT NULL) AND (C_LOCAL_3 IS NOT NULL);

	--Phone3 : CTRY_CODE IS  NULL, AREA_CODE IS NOT NULL, C_LOCAL IS NOT NULL
	UPDATE inc2temph2
	SET Phone3 = CONCAT('(',C_AREA_3,')',' ',C_LOCAL_3)
	WHERE (C_CTRY_3 IS  NULL) AND (C_AREA_3 IS NOT NULL) AND (C_LOCAL_3 IS NOT NULL);

	--Phone3 :  AREA_CODE IS  NULL, C_LOCAL IS NOT NULL
	UPDATE inc2temph2
	SET Phone3 = C_LOCAL_3
	WHERE (C_AREA_3 IS NULL) AND (C_LOCAL_3 IS NOT NULL);


	--Phone3 :  ALL ABOVE APPLIED AND C_EXT IS NOT NULL
	UPDATE inc2temph2
	SET Phone3 = CONCAT(Phone3,C_EXT_3)
	WHERE (Phone3 IS NOT NULL) AND (C_EXT_3 IS NOT NULL);

	--Phone3 :  NON OF THE  ABOVE RULE HAVE BEEN APPLIED
	UPDATE inc2temph2
	SET Phone3 = NULL
	WHERE Phone3 = '+ (   ) ' or Phone3 = '               ';


	UPDATE inc2temph2
	SET 
	Phone3 =substr(Phone3, 9,LENGTH(Phone3))
	WHERE substr(Phone3, 1,8) = '+ (   ) '
	;
	UPDATE inc2temph2
	SET 
	Phone3 =substr(Phone3, 3,LENGTH(Phone3))
	WHERE substr(Phone3, 1,3) = '+ ('
	;



	--trim trailing spaces
	UPDATE inc2temph2
	SET 
	Phone1=TRIM(BOTH '          ' FROM Phone1),
	Phone2= TRIM(BOTH '          ' FROM Phone2),
	Phone3= TRIM(BOTH '          ' FROM Phone3)
	;

	--TAXRATE
	CREATE TEMPORARY TABLE inc2temph3 AS
	SELECT CDC_FLAG, CDC_DSN, C_ID, C_TAX_ID, C_ST_ID, C_L_NAME, C_F_NAME, C_M_NAME, C_GNDR,
			C_TIER,C_DOB, C_ADLINE1, C_ADLINE2, C_ZIPCODE, C_CITY, C_STATE_PROV, C_CTRY,
			Phone1, Phone2, Phone3, C_EMAIL_1, C_EMAIL_2, C_LCL_TX_ID, C_NAT_TX_ID,
			 Status, MarketingNameplate, 
		TX_NAME as NationalTaxRateDesc, TX_RATE as NationalTaxRate
		FROM inc2temph2 I LEFT OUTER JOIN TaxRate T ON
		--WHERE
		 I.C_NAT_TX_ID = T.TX_ID;

	CREATE TEMPORARY TABLE inc2temph4 AS
		SELECT  CDC_FLAG, CDC_DSN, C_ID, C_TAX_ID, C_ST_ID, C_L_NAME, C_F_NAME, C_M_NAME, C_GNDR,
			C_TIER,C_DOB, C_ADLINE1, C_ADLINE2, C_ZIPCODE, C_CITY, C_STATE_PROV, C_CTRY,
			Phone1, Phone2, Phone3, C_EMAIL_1, C_EMAIL_2, C_LCL_TX_ID, C_NAT_TX_ID,
			 Status, MarketingNameplate,NationalTaxRateDesc,NationalTaxRate,
		 TX_NAME as LocalTaxRateDesc, TX_RATE as LocalTaxRate
		FROM inc2temph3 I LEFT OUTER JOIN TaxRate T ON
		--WHERE 
		I.C_LCL_TX_ID = T.TX_ID;


	--Obtain columns to help aquire AgencyID, CreditRating, Networth, marketingNameplate 
	--exist in prospect
		CREATE TEMPORARY TABLE inc2temph5 AS
	SELECT 	CDC_FLAG, CDC_DSN, C_ID, C_TAX_ID, C_ST_ID, C_L_NAME, C_F_NAME, C_M_NAME, C_GNDR,
			C_TIER,C_DOB, C_ADLINE1, C_ADLINE2, C_ZIPCODE, C_CITY, C_STATE_PROV, C_CTRY,
			Phone1, Phone2, Phone3, C_EMAIL_1, C_EMAIL_2, C_LCL_TX_ID, C_NAT_TX_ID,
			 Status,NationalTaxRateDesc,NationalTaxRate,
		LocalTaxRateDesc, LocalTaxRate, P.AgencyID, P.CreditRating, P.NetWorth,P.numericberChildren, 
	P.Age, P.Income, P.numericberCars, P.numericberCreditCards, T.MarketingNameplate
	FROM   inc2temph4 T LEFT OUTER JOIN Prospect P ON

	(
	TRIM(BOTH ' ' FROM UPPER(T.C_L_NAME)) = TRIM(BOTH ' ' FROM UPPER(P.LastName)) AND 
	TRIM(BOTH ' ' FROM UPPER(T.C_F_NAME)) = TRIM(BOTH ' ' FROM UPPER(P.FirstName)) AND 
	TRIM(BOTH ' ' FROM UPPER(T.C_ADLINE1)) = TRIM(BOTH ' ' FROM UPPER(P.AddressLine1))AND 
	--LATER FIND OUT WHY IF AddressLine2 IS ADDED, SOME TUPLES DO NOT GET A MATCHING Prospect ATTRIBUTES
	TRIM(BOTH ' ' FROM UPPER(T.C_ADLINE2)) = TRIM(BOTH ' ' FROM UPPER(P.AddressLine2)) AND 
	TRIM(BOTH ' ' FROM UPPER(T.C_ZIPCODE)) = TRIM(BOTH ' ' FROM UPPER(P.PostalCode)));


	--Calculate AgencyID, CreditRating, Networth, marketingNameplate
	UPDATE inc2temph5
	SET MarketingNameplate = CONCAT(MarketingNameplate, '+', 'HighValue')
	WHERE NetWorth>1000000 OR Income > 200000;

	UPDATE inc2temph5
	SET MarketingNameplate = CONCAT(MarketingNameplate , '+','Expenses')
	WHERE numericberChildren>3 OR numericberCreditCards > 5;

	UPDATE inc2temph5
	SET MarketingNameplate = CONCAT(MarketingNameplate, '+', 'Boomer')
	WHERE Age>45;

	UPDATE inc2temph5
	SET MarketingNameplate = CONCAT(MarketingNameplate, '+', 'MoneyAlert')
	WHERE Income<50000 OR CreditRating < 600 OR NetWorth<100000;

	UPDATE inc2temph5
	SET MarketingNameplate = CONCAT(MarketingNameplate, '+', 'Spender')
	WHERE numericberCars>3 OR numericberCreditCards > 7;

	UPDATE inc2temph5
	SET MarketingNameplate = CONCAT(MarketingNameplate, '+', 'Inherited')
	WHERE Age<25 AND NetWorth>1000000;

	UPDATE inc2temph5
	SET MarketingNameplate = btrim(MarketingNameplate, '+');


	--Batch Date
	CREATE TEMPORARY TABLE inc2temph6 AS
		SELECT  CDC_FLAG, CDC_DSN, C_ID, C_TAX_ID, C_ST_ID, C_L_NAME, C_F_NAME, C_M_NAME, C_GNDR,
		C_TIER,C_DOB, C_ADLINE1, C_ADLINE2, C_ZIPCODE, C_CITY, C_STATE_PROV, C_CTRY,
		Phone1, Phone2, Phone3, C_EMAIL_1, C_EMAIL_2, C_LCL_TX_ID, C_NAT_TX_ID,
		 Status,NationalTaxRateDesc,NationalTaxRate,
	LocalTaxRateDesc,  LocalTaxRate, AgencyID, CreditRating, NetWorth, MarketingNameplate, BatchDateColumn
	FROM inc2temph5, BatchDate2;

		
	--This will be used as starting surrogate key for inserting updated tuples.
	CREATE TEMPORARY TABLE inc2temph7 AS
	SELECT MAX(SK_CustomerID) AS SK_CustomerID_value FROM DimCustomer;


	--Insert Updating tuples

	INSERT INTO DimCustomer(SK_CustomerID,CustomerID, TaxID, Status,LastName, FirstName, MiddleInitial,
	 Gender, Tier, DOB, AddressLine1, AddressLine2, PostalCode, City, StateProv, Country,
	  Phone1, Phone2, Phone3,Email1, Email2,NationalTaxRateDesc,
	  NationalTaxRate,LocalTaxRateDesc,LocalTaxRate,AgencyID, CreditRating, NetWorth,MarketingNameplate,
	  IsCurrent,BatchID,EffectiveDate,EndDate)
	SELECT U.SK_CustomerID_value + row_number() over( order by U.SK_CustomerID_value) as SK_CustomerID, 
	 C_ID, C_TAX_ID, Status,C_L_NAME, C_F_NAME, C_M_NAME, C_GNDR, C_TIER::int, C_DOB, 
	C_ADLINE1, C_ADLINE2, C_ZIPCODE, C_CITY, C_STATE_PROV, C_CTRY,
	  Phone1, Phone2, Phone3,C_EMAIL_1, C_EMAIL_2,
	  NationalTaxRateDesc, NationalTaxRate,LocalTaxRateDesc,LocalTaxRate,
	  AgencyID, CreditRating, NetWorth,MarketingNameplate,
	  TRUE,3,BatchDateColumn,'9999-12-31'
	FROM 
	inc2temph6 T,inc2temph7 U
	ORDER BY SK_CustomerID ASC;








	---FOR ACCOUNT UPDATES
		

	CREATE TEMPORARY TABLE  Old2keys2 AS
	SELECT O.Sk_CustomerID, O.CustomerID,A.AccountID
	FROM
	inc2temph1 U,Old2keys O, DimAccount A WHERE
	 U.C_ID = O.CustomerID AND
		 O.Sk_CustomerID =A.Sk_CustomerID AND
	A.IsCurrent=TRUE;

	


	--GET TNE NEW SK_CustomerID
	CREATE TEMPORARY TABLE  Old2keys3 AS
      SELECT D.Sk_CustomerID,O.CustomerID,O.AccountID
      FROM
	Old2keys2 O, DimCustomer D
	WHERE D.CustomerID=O.CustomerID AND 
	D.IsCurrent=TRUE;
	

	CREATE TEMPORARY TABLE  Old2keys4 AS	
	SELECT O.AccountID,A.SK_BrokerID,O.SK_CustomerID,A.Status,A.AccountDesc, A.TaxStatus
	FROM
	Old2keys3 O, DimAccount A WHERE
	 O.AccountID =A.AccountID AND
	A.IsCurrent=TRUE;



	UPDATE DimAccount D SET
	Status=  'Inactive',
	IsCurrent=FALSE,
	EndDate=(SELECT BatchDateColumn AS EndDATE FROM BatchDate2)
	WHERE EXISTS
	(SELECT AccountID
	FROM Old2keys2 I where D.AccountID = I.AccountID AND D.IsCurrent=TRUE);



	
	CREATE TEMPORARY TABLE inc2temph10 AS
	SELECT MAX(SK_AccountID) AS SK_AccountID_value FROM DimAccount;

	
	INSERT INTO DimAccount(SK_AccountID,AccountID,SK_BrokerID,SK_CustomerID,
	Status,AccountDesc, TaxStatus,IsCurrent,BatchID,EffectiveDate,EndDate)
	SELECT  U.SK_AccountID_value +  row_number() over( order by U.SK_AccountID_value)
	 as SK_AccountID, 
	AccountID,SK_BrokerID,SK_CustomerID,
	'Active',AccountDesc, TaxStatus,TRUE,3,(SELECT BatchDateColumn AS EndDATE FROM BatchDate2),'9999-12-31'
	FROM 
	Old2keys4 , inc2temph10 U;
---------------------------









	

	--INVALID TIER (NOT 1,2 OR 3)
	CREATE TEMPORARY TABLE inc2temph8 AS
	SELECT * FROM inc2temph6
	WHERE (C_TIER::INT != 1 AND C_TIER::INT != 2 AND C_TIER::INT != 3) OR C_TIER IS NULL;

	INSERT INTO DImessages(MessageDateAndTime, BatchID, MessageSource, MessageText, MessageType,MessageData)
	SELECT CURRENT_TIMESTAMP, 3, 'DimCustomer', 'Invalid customer tier', 'Alert',
	CONCAT('C_ID = ',C_ID, ', C_TIER = ',C_TIER)
	FROM
	inc2temph8;


	--INVALID DOB
	CREATE TEMPORARY TABLE inc2temph9 AS
	SELECT C_ID,C_DOB, BatchDateColumn FROM inc2temph6
	WHERE 
	C_DOB < (BatchDateColumn - INTERVAL '100 years') OR
	C_DOB > BatchDateColumn;

	INSERT INTO DImessages(MessageDateAndTime, BatchID, MessageSource, MessageText, MessageType,MessageData)
	SELECT CURRENT_TIMESTAMP, 3, 'DimCustomer', 'DOB out of range', 'Alert',
	CONCAT('C_ID = ',C_ID, ', C_DOB = ',C_DOB)
	FROM
	inc2temph9;
	

	
END;
$$ LANGUAGE 'plpgsql';
