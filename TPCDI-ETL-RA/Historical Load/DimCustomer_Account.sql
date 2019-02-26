/*DimCustomer Load*/



DROP FUNCTION IF EXISTS DimCustomer_AccountLoad();
CREATE FUNCTION DimCustomer_AccountLoad()
RETURNS VOID AS $$

	DECLARE
	Action Character Varying(10);
	ID INTEGER  := 1 ;
	COUNT INTEGER :=0;
	cnt INTEGER;
	BEGIN

	DROP TABLE IF EXISTS  UPDtemp1,temp1,temp2,msgTemp1,msgTemp2,
	NEWACCtemp1,NEWACCtemp2,NEWACCtemp3;
	


	CREATE TEMPORARY TABLE UPDtemp1 AS
	SELECT  ActionTS,ActionType,CustomerID, TaxID, LastName, FirstName, MiddleInitial, Gender, Tier, DOB,
	AddressLine1, AddressLine2, PostalCode, City, State_Prov, Country, 
	Phone1C_CTRY_CODE,Phone1C_AREA_CODE,Phone1C_LOCAL,Phone1C_EXT,
	Phone2C_CTRY_CODE,Phone2C_AREA_CODE,Phone2C_LOCAL,Phone2C_EXT,
	Phone3C_CTRY_CODE,Phone3C_AREA_CODE,Phone3C_LOCAL,Phone3C_EXT,
	Email1, Email2,C_NAT_TX_ID,C_LCL_TX_ID,AccountID,AccountDesc,
	TaxStatus,CA_B_ID
	FROM allActions WHERE ActionType='NEW'
	order by ActionTS ;


	ALTER TABLE UPDtemp1
	ADD COLUMN  Phone1 varchar(30) DEFAULT NULL,
	ADD COLUMN Phone2 varchar(30) DEFAULT NULL,
	ADD COLUMN Phone3 varchar(30) DEFAULT NULL,
	ADD COLUMN  Status varchar(10) DEFAULT 'Active',
	ADD COLUMN  MarketingNameplate varchar(100) DEFAULT NULL,
	ADD COLUMN   IsCustomer BOOLEAN DEFAULT TRUE,
	ADD COLUMN   BatchID INT DEFAULT 1;

	--------------SET PHONE NUMBERS----------------------

	  --Phone1 : CTRY_CODE IS NOT NULL, AREA_CODE IS NOT NULL, C_LOCAL IS NOT NULL
	UPDATE UPDtemp1
	SET Phone1 = CONCAT('+',Phone1C_CTRY_CODE,' (',Phone1C_AREA_CODE,') ',Phone1C_LOCAL)
	WHERE (Phone1C_CTRY_CODE IS NOT NULL) AND (Phone1C_AREA_CODE IS NOT NULL) AND (Phone1C_LOCAL IS NOT NULL);

	--Phone1 : CTRY_CODE IS  NULL, AREA_CODE IS NOT NULL, C_LOCAL IS NOT NULL
	UPDATE UPDtemp1
	SET Phone1 = CONCAT('(',Phone1C_AREA_CODE,') ',Phone1C_LOCAL)
	WHERE (Phone1C_CTRY_CODE IS  NULL) AND (Phone1C_AREA_CODE IS NOT NULL) AND (Phone1C_LOCAL IS NOT NULL);

	--Phone1 :  AREA_CODE IS  NULL, C_LOCAL IS NOT NULL
	UPDATE UPDtemp1
	SET Phone1 = Phone1C_LOCAL
	WHERE (Phone1C_AREA_CODE IS NULL) AND (Phone1C_LOCAL IS NOT NULL);


	--Phone1 :  ALL ABOVE APPLIED AND C_EXT IS NOT NULL
	UPDATE UPDtemp1
	SET Phone1 = CONCAT(Phone1,Phone1C_EXT)
	WHERE (Phone1 IS NOT NULL) AND (Phone1C_EXT IS NOT NULL);

	--Phone1 :  NON OF THE  ABOVE RULE HAVE BEEN APPLIED
	UPDATE UPDtemp1
	SET Phone1 = NULL
	WHERE Phone1 = '+ ()';

	UPDATE UPDtemp1
	SET 
	Phone1 =substr(Phone1, 6,LENGTH(Phone1))
	WHERE substr(Phone1, 1,4) = '+ ()'
	;
	UPDATE UPDtemp1
	SET 
	Phone1 =substr(Phone1, 3,LENGTH(Phone1))
	WHERE substr(Phone1, 1,3) = '+ ('
	;


	 --Phone2 : CTRY_CODE IS NOT NULL, AREA_CODE IS NOT NULL, C_LOCAL IS NOT NULL
	UPDATE UPDtemp1
	SET Phone2 = CONCAT('+',Phone2C_CTRY_CODE,' (',Phone2C_AREA_CODE,') ',Phone2C_LOCAL)
	WHERE (Phone2C_CTRY_CODE IS NOT NULL) AND (Phone2C_AREA_CODE IS NOT NULL) AND (Phone2C_LOCAL IS NOT NULL);

	--Phone2 : CTRY_CODE IS  NULL, AREA_CODE IS NOT NULL, C_LOCAL IS NOT NULL
	UPDATE UPDtemp1
	SET Phone2 = CONCAT('(',Phone2C_AREA_CODE,') ',Phone2C_LOCAL)
	WHERE (Phone2C_CTRY_CODE IS  NULL) AND (Phone2C_AREA_CODE IS NOT NULL) AND (Phone2C_LOCAL IS NOT NULL);

	--Phone2 :  AREA_CODE IS  NULL, C_LOCAL IS NOT NULL
	UPDATE UPDtemp1
	SET Phone2 = Phone2C_LOCAL
	WHERE (Phone2C_AREA_CODE IS NULL) AND (Phone2C_LOCAL IS NOT NULL);


	--Phone2 :  ALL ABOVE APPLIED AND C_EXT IS NOT NULL
	UPDATE UPDtemp1
	SET Phone2 = CONCAT(Phone2,Phone2C_EXT)
	WHERE (Phone2 IS NOT NULL) AND (Phone2C_EXT IS NOT NULL);

	--Phone2 :  NON OF THE  ABOVE RULE HAVE BEEN APPLIED
	UPDATE UPDtemp1
	SET Phone2 = NULL
	WHERE Phone2 = '+ ()';

	UPDATE UPDtemp1
	SET 
	Phone2 =substr(Phone2, 6,LENGTH(Phone2))
	WHERE substr(Phone2, 1,4) = '+ ()'
	;
	UPDATE UPDtemp1
	SET 
	Phone2 =substr(Phone2, 3,LENGTH(Phone2))
	WHERE substr(Phone2, 1,3) = '+ ('
	;



	 --Phone3 : CTRY_CODE IS NOT NULL, AREA_CODE IS NOT NULL, C_LOCAL IS NOT NULL
	UPDATE UPDtemp1
	SET Phone3 = CONCAT('+',Phone3C_CTRY_CODE,' (',Phone3C_AREA_CODE,') ',Phone3C_LOCAL)
	WHERE (Phone3C_CTRY_CODE IS NOT NULL) AND (Phone3C_AREA_CODE IS NOT NULL) AND (Phone3C_LOCAL IS NOT NULL);

	--Phone3 : CTRY_CODE IS  NULL, AREA_CODE IS NOT NULL, C_LOCAL IS NOT NULL
	UPDATE UPDtemp1
	SET Phone3 = CONCAT('(',Phone3C_AREA_CODE,') ',Phone3C_LOCAL)
	WHERE (Phone3C_CTRY_CODE IS  NULL) AND (Phone3C_AREA_CODE IS NOT NULL) AND (Phone3C_LOCAL IS NOT NULL);

	--Phone3 :  AREA_CODE IS  NULL, C_LOCAL IS NOT NULL
	UPDATE UPDtemp1
	SET Phone3 = Phone3C_LOCAL
	WHERE (Phone3C_AREA_CODE IS NULL) AND (Phone3C_LOCAL IS NOT NULL);


	--Phone3 :  ALL ABOVE APPLIED AND C_EXT IS NOT NULL
	UPDATE UPDtemp1
	SET Phone3 = CONCAT(Phone3,Phone3C_EXT)
	WHERE (Phone3 IS NOT NULL) AND (Phone3C_EXT IS NOT NULL);

	--Phone3 :  NON OF THE  ABOVE RULE HAVE BEEN APPLIED
	UPDATE UPDtemp1
	SET Phone3 = NULL
	WHERE Phone3 = '+ ()';


	UPDATE UPDtemp1
	SET 
	Phone3 =substr(Phone3, 6,LENGTH(Phone3))
	WHERE substr(Phone3, 1,4) = '+ ()'
	;
	UPDATE UPDtemp1
	SET 
	Phone3 =substr(Phone3, 3,LENGTH(Phone3))
	WHERE substr(Phone3, 1,3) = '+ ('
	;

	--trim trailing spaces
	UPDATE UPDtemp1
	SET 
	Phone1=TRIM(BOTH '          ' FROM Phone1),
	Phone2= TRIM(BOTH '          ' FROM Phone2),
	Phone3= TRIM(BOTH '          ' FROM Phone3)
	;



	--GENDER
	UPDATE UPDtemp1
	SET GENDER = 'U'
	WHERE (GENDER <> 'F' AND GENDER <> 'M') OR GENDER IS NULL;



	--TAXRATE
	CREATE TEMPORARY TABLE  UPDtemp2 AS
	SELECT  ActionType,CustomerID, TaxID, Status,LastName, FirstName, MiddleInitial, Gender, Tier, DOB,
	AddressLine1, AddressLine2, PostalCode, City, State_Prov, Country, Phone1, Phone2, Phone3,
	Email1, Email2,ActionTS, MarketingNameplate, 
	TX_NAME as NationalTaxRateDesc, TX_RATE as NationalTaxRate,C_LCL_TX_ID
	FROM UPDtemp1 JOIN TaxRate ON
	--WHERE
	 C_NAT_TX_ID = TX_ID;

	CREATE TEMPORARY TABLE UPDtemp3 AS
	SELECT  ActionType,CustomerID, TaxID, Status,LastName, FirstName, MiddleInitial, Gender, Tier, DOB,
	AddressLine1, AddressLine2, PostalCode, City, State_Prov, Country, Phone1, Phone2, Phone3,
	Email1, Email2,ActionTS, MarketingNameplate,NationalTaxRateDesc,NationalTaxRate,
	 TX_NAME as LocalTaxRateDesc, TX_RATE as LocalTaxRate
	FROM UPDtemp2  JOIN TaxRate ON
	--WHERE 
	C_LCL_TX_ID = TX_ID;

	--AGENCYID,CREDITRATING,NETWORTH
	CREATE TEMPORARY TABLE UPDtemp4 AS
	SELECT 	T.ActionType, T.CustomerID, T.TaxID, T.Status,T.LastName, T.FirstName, T.MiddleInitial, T.Gender,
	T.Tier, T.DOB,	T.AddressLine1, T.AddressLine2, T.PostalCode, T.City, T.State_Prov, T.Country, T.Phone1, 
	T.Phone2, T.Phone3, T.Email1, T.Email2, T.ActionTS, T.MarketingNameplate, T.NationalTaxRateDesc, T.NationalTaxRate,  T.LocalTaxRateDesc,
	T.LocalTaxRate, P.AgencyID, P.CreditRating, P.NetWorth,P.numericberChildren, 
	P.Age, P.Income, P.numericberCars, P.numericberCreditCards
	FROM   UPDtemp3 T LEFT OUTER JOIN Prospect P ON

	(
	TRIM(BOTH ' ' FROM UPPER(T.LastName)) = TRIM(BOTH ' ' FROM UPPER(P.LastName)) AND 
	TRIM(BOTH ' ' FROM UPPER(T.FirstName)) = TRIM(BOTH ' ' FROM UPPER(P.FirstName)) AND 
	TRIM(BOTH ' ' FROM UPPER(T.AddressLine1)) = TRIM(BOTH ' ' FROM UPPER(P.AddressLine1)) AND 
	--LATER FIND OUT WHY IF AddressLine2 IS ADDED, SOME TUPLES DO NOT GET A MATCHING TempProspect ATTRIBUTES
	TRIM(BOTH ' ' FROM UPPER(T.AddressLine2)) = TRIM(BOTH ' ' FROM UPPER(P.AddressLine2)) AND 
	TRIM(BOTH ' ' FROM UPPER(T.PostalCode)) = TRIM(BOTH ' ' FROM UPPER(P.PostalCode)));



	
	--Calculate marketingNameplate
	UPDATE UPDtemp4
	SET MarketingNameplate = CONCAT(MarketingNameplate, '+', 'HighValue')
	WHERE NetWorth>1000000 OR Income > 200000;

	UPDATE UPDtemp4
	SET MarketingNameplate = CONCAT(MarketingNameplate , '+','Expenses')
	WHERE numericberChildren>3 OR numericberCreditCards > 5;

	UPDATE UPDtemp4
	SET MarketingNameplate = CONCAT(MarketingNameplate, '+', 'Boomer')
	WHERE Age>45;

	UPDATE UPDtemp4
	SET MarketingNameplate = CONCAT(MarketingNameplate, '+', 'MoneyAlert')
	WHERE Income<50000 OR CreditRating < 600 OR NetWorth<100000;

	UPDATE UPDtemp4
	SET MarketingNameplate = CONCAT(MarketingNameplate, '+', 'Spender')
	WHERE numericberCars>3 OR numericberCreditCards > 7;

	UPDATE UPDtemp4
	SET MarketingNameplate = CONCAT(MarketingNameplate, '+', 'Inherited')
	WHERE Age<25 AND NetWorth>1000000;

	UPDATE UPDtemp4
	SET MarketingNameplate = btrim(MarketingNameplate, '+');




	INSERT INTO DimCustomer(SK_CustomerID,CustomerID, TaxID, Status,LastName, FirstName, MiddleInitial,
	Gender, Tier, DOB, AddressLine1, AddressLine2, PostalCode, City, StateProv, Country,
	Phone1, Phone2, Phone3,Email1, Email2,NationalTaxRateDesc,
	NationalTaxRate,LocalTaxRateDesc,LocalTaxRate,AgencyID, CreditRating, NetWorth,MarketingNameplate,
	IsCurrent,BatchID,EffectiveDate,EndDate)
	SELECT row_number() over( order by 1) AS SK_CustomerID, 
	CustomerID, TaxID, Status,LastName, FirstName, MiddleInitial,
	Gender, Tier::int, DOB, AddressLine1, AddressLine2, PostalCode, City, State_Prov, Country,
	Phone1, Phone2, Phone3,Email1, Email2,NationalTaxRateDesc,
	NationalTaxRate,LocalTaxRateDesc,LocalTaxRate,AgencyID, CreditRating, NetWorth,MarketingNameplate,
	TRUE,1,ActionTS,'9999-12-31'
	FROM 
	UPDtemp4 ;



	--FOR DIMACCOUNT
	CREATE TEMPORARY TABLE NEWACCtemp1 AS
	SELECT ActionType, AccountID, AccountDesc, TaxStatus, CA_B_ID, CustomerID, ActionTS
	 FROM UPDtemp1;

	
	--GET SK_BrokerID FROM DimBroker
	CREATE TEMPORARY TABLE NEWACCtemp2 AS
	SELECT  ActionType, AccountID, AccountDesc, TaxStatus, CA_B_ID, CustomerID ,ActionTS, 
	SK_BrokerID
	FROM NEWACCtemp1 N JOIN DimBroker  D ON
	(N.CA_B_ID = D.BrokerID AND
	(N.ActionTS >= D.EffectiveDate AND N.ActionTS <= D.EndDate));


	--GET SK_CustomerID FROM DimCustomer
	CREATE TEMPORARY TABLE NEWACCtemp3 AS
	SELECT  ActionType, AccountID, AccountDesc, TaxStatus, CA_B_ID, D.CustomerID, ActionTS, 
	SK_BrokerID, SK_CustomerID
	FROM NEWACCtemp2 A JOIN DimCustomer D ON
	(--D.IsCurrent=TRUE AND
	 A.CustomerID = D.CustomerID
	AND (A.ActionTS >= D.EffectiveDate AND A.ActionTS <= D.EndDate));

  


	INSERT INTO DimAccount(SK_AccountID,AccountID,SK_BrokerID,SK_CustomerID,
	Status,AccountDesc, TaxStatus,IsCurrent,BatchID,EffectiveDate,EndDate)
	SELECT  row_number() over( order by 1) AS  SK_AccountID, 
	AccountID,SK_BrokerID,SK_CustomerID,
	'Active',AccountDesc, TaxStatus,TRUE,1,ActionTS,'9999-12-31'
	FROM 
	NEWACCtemp3;

	








-------------------------------------------------------------------------------------


	CREATE TEMPORARY TABLE temp1 AS
	SELECT  ActionTS,ActionType,CustomerID, TaxID, LastName, FirstName, MiddleInitial, Gender, Tier, DOB,
	AddressLine1, AddressLine2, PostalCode, City, State_Prov, Country, 
	Phone1C_CTRY_CODE,Phone1C_AREA_CODE,Phone1C_LOCAL,Phone1C_EXT,
	Phone2C_CTRY_CODE,Phone2C_AREA_CODE,Phone2C_LOCAL,Phone2C_EXT,
	Phone3C_CTRY_CODE,Phone3C_AREA_CODE,Phone3C_LOCAL,Phone3C_EXT,
	Email1, Email2,C_NAT_TX_ID,C_LCL_TX_ID,AccountID,AccountDesc,
	TaxStatus,CA_B_ID
	FROM allActions WHERE ActionType<>'NEW'
	order by ActionTS ;

	
	cnt := (SELECT COUNT(*) FROM temp1);
	



	CREATE TEMPORARY TABLE temp2 AS
	SELECT  row_number() over( order by 1) AS seq,ActionTS,ActionType,CustomerID, TaxID, LastName, FirstName, MiddleInitial, Gender, Tier, DOB,
	AddressLine1, AddressLine2, PostalCode, City, State_Prov, Country, 
	Phone1C_CTRY_CODE,Phone1C_AREA_CODE,Phone1C_LOCAL,Phone1C_EXT,
	Phone2C_CTRY_CODE,Phone2C_AREA_CODE,Phone2C_LOCAL,Phone2C_EXT,
	Phone3C_CTRY_CODE,Phone3C_AREA_CODE,Phone3C_LOCAL,Phone3C_EXT,
	Email1, Email2,C_NAT_TX_ID,C_LCL_TX_ID,AccountID,AccountDesc,
	TaxStatus,CA_B_ID
	FROM temp1 order by ActionTS;

	INSERT INTO UPDtemp5(SK_CustomerID_value)
	SELECT MAX(SK_CustomerID) AS SK_CustomerID_value FROM DimCustomer;

	UPDATE UPDtemp5 SET 
	SK_CustomerID_value=0
	WHERE 
	SK_CustomerID_value IS NULL;

	INSERT INTO ADDtemp5(SK_AccountID_value)
	SELECT MAX(SK_AccountID) AS SK_AccountID_value FROM DimAccount;
		
	UPDATE ADDtemp5 SET 
	SK_AccountID_value=0
	WHERE 
	SK_AccountID_value IS NULL;  

	LOOP 
	EXIT WHEN ID > cnt ; 
	-- SELECT 24570 ActionType INTO Action FROM temp2 
	  --WHERE seq = ID;
        
       -- IF ID < 24571 THEN
    
	
	INSERT INTO temp3(seq,ActionType,CustomerID, TaxID, LastName, FirstName, MiddleInitial, Gender, Tier, DOB,
	AddressLine1, AddressLine2, PostalCode, City, State_Prov, Country, 
	Phone1C_CTRY_CODE,Phone1C_AREA_CODE,Phone1C_LOCAL,Phone1C_EXT,
	Phone2C_CTRY_CODE,Phone2C_AREA_CODE,Phone2C_LOCAL,Phone2C_EXT,
	Phone3C_CTRY_CODE,Phone3C_AREA_CODE,Phone3C_LOCAL,Phone3C_EXT,
	Email1, Email2,C_NAT_TX_ID,C_LCL_TX_ID,AccountID,AccountDesc,
	TaxStatus,CA_B_ID,ActionTS	)
	SELECT seq,ActionType,CustomerID, TaxID, LastName, FirstName, MiddleInitial, Gender, Tier, DOB,
	AddressLine1, AddressLine2, PostalCode, City, State_Prov, Country, 
	Phone1C_CTRY_CODE,Phone1C_AREA_CODE,Phone1C_LOCAL,Phone1C_EXT,
	Phone2C_CTRY_CODE,Phone2C_AREA_CODE,Phone2C_LOCAL,Phone2C_EXT,
	Phone3C_CTRY_CODE,Phone3C_AREA_CODE,Phone3C_LOCAL,Phone3C_EXT,
	Email1, Email2,C_NAT_TX_ID,C_LCL_TX_ID,AccountID,AccountDesc,
	TaxStatus,CA_B_ID,ActionTS
	FROM temp2
	WHERE seq = (SELECT MIN(seq)
        FROM temp2 AS seq1);
	
	SELECT ActionType INTO Action FROM temp3;




	-------------------------------------------------------------------------------------
   /*    IF Action='NEW' THEN

       ---START
      INSERT INTO UPDtemp1 (seq,ActionType,CustomerID, TaxID, LastName, FirstName, MiddleInitial, Gender, Tier, DOB,
	AddressLine1, AddressLine2, PostalCode, City, State_Prov, Country, 
	Phone1C_CTRY_CODE,Phone1C_AREA_CODE,Phone1C_LOCAL,Phone1C_EXT,
	Phone2C_CTRY_CODE,Phone2C_AREA_CODE,Phone2C_LOCAL,Phone2C_EXT,
	Phone3C_CTRY_CODE,Phone3C_AREA_CODE,Phone3C_LOCAL,Phone3C_EXT,
	Email1, Email2,C_NAT_TX_ID,C_LCL_TX_ID,ActionTS)
	SELECT seq,ActionType,CustomerID, TaxID, LastName, FirstName, MiddleInitial, Gender, Tier, DOB,
	AddressLine1, AddressLine2, PostalCode, City, State_Prov, Country, 
	Phone1C_CTRY_CODE,Phone1C_AREA_CODE,Phone1C_LOCAL,Phone1C_EXT,
	Phone2C_CTRY_CODE,Phone2C_AREA_CODE,Phone2C_LOCAL,Phone2C_EXT,
	Phone3C_CTRY_CODE,Phone3C_AREA_CODE,Phone3C_LOCAL,Phone3C_EXT,
	Email1, Email2,C_NAT_TX_ID,C_LCL_TX_ID,ActionTS FROM temp3;

	
	--------------SET PHONE NUMBERS----------------------

  --Phone1 : CTRY_CODE IS NOT NULL, AREA_CODE IS NOT NULL, C_LOCAL IS NOT NULL
UPDATE UPDtemp1
SET Phone1 = CONCAT('+',Phone1C_CTRY_CODE,' (',Phone1C_AREA_CODE,') ',Phone1C_LOCAL)
WHERE (Phone1C_CTRY_CODE IS NOT NULL) AND (Phone1C_AREA_CODE IS NOT NULL) AND (Phone1C_LOCAL IS NOT NULL);

--Phone1 : CTRY_CODE IS  NULL, AREA_CODE IS NOT NULL, C_LOCAL IS NOT NULL
UPDATE UPDtemp1
SET Phone1 = CONCAT('(',Phone1C_AREA_CODE,') ',Phone1C_LOCAL)
WHERE (Phone1C_CTRY_CODE IS  NULL) AND (Phone1C_AREA_CODE IS NOT NULL) AND (Phone1C_LOCAL IS NOT NULL);

--Phone1 :  AREA_CODE IS  NULL, C_LOCAL IS NOT NULL
UPDATE UPDtemp1
SET Phone1 = Phone1C_LOCAL
WHERE (Phone1C_AREA_CODE IS NULL) AND (Phone1C_LOCAL IS NOT NULL);


--Phone1 :  ALL ABOVE APPLIED AND C_EXT IS NOT NULL
UPDATE UPDtemp1
SET Phone1 = CONCAT(Phone1,Phone1C_EXT)
WHERE (Phone1 IS NOT NULL) AND (Phone1C_EXT IS NOT NULL);

--Phone1 :  NON OF THE  ABOVE RULE HAVE BEEN APPLIED
UPDATE UPDtemp1
SET Phone1 = NULL
WHERE Phone1 = '+ ()';

UPDATE UPDtemp1
SET 
Phone1 =substr(Phone1, 6,LENGTH(Phone1))
WHERE substr(Phone1, 1,4) = '+ ()'
;
UPDATE UPDtemp1
SET 
Phone1 =substr(Phone1, 3,LENGTH(Phone1))
WHERE substr(Phone1, 1,3) = '+ ('
;


 --Phone2 : CTRY_CODE IS NOT NULL, AREA_CODE IS NOT NULL, C_LOCAL IS NOT NULL
UPDATE UPDtemp1
SET Phone2 = CONCAT('+',Phone2C_CTRY_CODE,' (',Phone2C_AREA_CODE,') ',Phone2C_LOCAL)
WHERE (Phone2C_CTRY_CODE IS NOT NULL) AND (Phone2C_AREA_CODE IS NOT NULL) AND (Phone2C_LOCAL IS NOT NULL);

--Phone2 : CTRY_CODE IS  NULL, AREA_CODE IS NOT NULL, C_LOCAL IS NOT NULL
UPDATE UPDtemp1
SET Phone2 = CONCAT('(',Phone2C_AREA_CODE,') ',Phone2C_LOCAL)
WHERE (Phone2C_CTRY_CODE IS  NULL) AND (Phone2C_AREA_CODE IS NOT NULL) AND (Phone2C_LOCAL IS NOT NULL);

--Phone2 :  AREA_CODE IS  NULL, C_LOCAL IS NOT NULL
UPDATE UPDtemp1
SET Phone2 = Phone2C_LOCAL
WHERE (Phone2C_AREA_CODE IS NULL) AND (Phone2C_LOCAL IS NOT NULL);


--Phone2 :  ALL ABOVE APPLIED AND C_EXT IS NOT NULL
UPDATE UPDtemp1
SET Phone2 = CONCAT(Phone2,Phone2C_EXT)
WHERE (Phone2 IS NOT NULL) AND (Phone2C_EXT IS NOT NULL);

--Phone2 :  NON OF THE  ABOVE RULE HAVE BEEN APPLIED
UPDATE UPDtemp1
SET Phone2 = NULL
WHERE Phone2 = '+ ()';

UPDATE UPDtemp1
SET 
Phone2 =substr(Phone2, 6,LENGTH(Phone2))
WHERE substr(Phone2, 1,4) = '+ ()'
;
UPDATE UPDtemp1
SET 
Phone2 =substr(Phone2, 3,LENGTH(Phone2))
WHERE substr(Phone2, 1,3) = '+ ('
;



 --Phone3 : CTRY_CODE IS NOT NULL, AREA_CODE IS NOT NULL, C_LOCAL IS NOT NULL
UPDATE UPDtemp1
SET Phone3 = CONCAT('+',Phone3C_CTRY_CODE,' (',Phone3C_AREA_CODE,') ',Phone3C_LOCAL)
WHERE (Phone3C_CTRY_CODE IS NOT NULL) AND (Phone3C_AREA_CODE IS NOT NULL) AND (Phone3C_LOCAL IS NOT NULL);

--Phone3 : CTRY_CODE IS  NULL, AREA_CODE IS NOT NULL, C_LOCAL IS NOT NULL
UPDATE UPDtemp1
SET Phone3 = CONCAT('(',Phone3C_AREA_CODE,') ',Phone3C_LOCAL)
WHERE (Phone3C_CTRY_CODE IS  NULL) AND (Phone3C_AREA_CODE IS NOT NULL) AND (Phone3C_LOCAL IS NOT NULL);

--Phone3 :  AREA_CODE IS  NULL, C_LOCAL IS NOT NULL
UPDATE UPDtemp1
SET Phone3 = Phone3C_LOCAL
WHERE (Phone3C_AREA_CODE IS NULL) AND (Phone3C_LOCAL IS NOT NULL);


--Phone3 :  ALL ABOVE APPLIED AND C_EXT IS NOT NULL
UPDATE UPDtemp1
SET Phone3 = CONCAT(Phone3,Phone3C_EXT)
WHERE (Phone3 IS NOT NULL) AND (Phone3C_EXT IS NOT NULL);

--Phone3 :  NON OF THE  ABOVE RULE HAVE BEEN APPLIED
UPDATE UPDtemp1
SET Phone3 = NULL
WHERE Phone3 = '+ ()';


UPDATE UPDtemp1
SET 
Phone3 =substr(Phone3, 6,LENGTH(Phone3))
WHERE substr(Phone3, 1,4) = '+ ()'
;
UPDATE UPDtemp1
SET 
Phone3 =substr(Phone3, 3,LENGTH(Phone3))
WHERE substr(Phone3, 1,3) = '+ ('
;

--trim trailing spaces
UPDATE UPDtemp1
SET 
Phone1=TRIM(BOTH '          ' FROM Phone1),
Phone2= TRIM(BOTH '          ' FROM Phone2),
Phone3= TRIM(BOTH '          ' FROM Phone3)
;



--GENDER
UPDATE UPDtemp1
SET GENDER = 'U'
WHERE (GENDER <> 'F' AND GENDER <> 'M') OR GENDER IS NULL;



--TAXRATE
	INSERT INTO UPDtemp2 (ActionType,CustomerID, TaxID, Status,LastName, FirstName, MiddleInitial, Gender, Tier, DOB,
	AddressLine1, AddressLine2, PostalCode, City, State_Prov, Country, Phone1, Phone2, Phone3,
	Email1, Email2,ActionTS, MarketingNameplate, 
	NationalTaxRateDesc, NationalTaxRate,C_LCL_TX_ID)
	SELECT  ActionType,CustomerID, TaxID, Status,LastName, FirstName, MiddleInitial, Gender, Tier, DOB,
	AddressLine1, AddressLine2, PostalCode, City, State_Prov, Country, Phone1, Phone2, Phone3,
	Email1, Email2,ActionTS, MarketingNameplate, 
	TX_NAME as NationalTaxRateDesc, TX_RATE as NationalTaxRate,C_LCL_TX_ID
	FROM UPDtemp1 JOIN TaxRate ON
	--WHERE
	 C_NAT_TX_ID = TX_ID;

	INSERT INTO UPDtemp3 ( ActionType,CustomerID, TaxID, Status,LastName, FirstName, MiddleInitial, Gender, Tier, DOB,
	AddressLine1, AddressLine2, PostalCode, City, State_Prov, Country, Phone1, Phone2, Phone3,
	Email1, Email2,ActionTS, MarketingNameplate,NationalTaxRateDesc,NationalTaxRate,
	LocalTaxRateDesc, LocalTaxRate)
	SELECT  ActionType,CustomerID, TaxID, Status,LastName, FirstName, MiddleInitial, Gender, Tier, DOB,
	AddressLine1, AddressLine2, PostalCode, City, State_Prov, Country, Phone1, Phone2, Phone3,
	Email1, Email2,ActionTS, MarketingNameplate,NationalTaxRateDesc,NationalTaxRate,
	 TX_NAME as LocalTaxRateDesc, TX_RATE as LocalTaxRate
	FROM UPDtemp2  JOIN TaxRate ON
	--WHERE 
	C_LCL_TX_ID = TX_ID;

	--AGENCYID,CREDITRATING,NETWORTH
	INSERT INTO  UPDtemp4 (ActionType, CustomerID, TaxID, Status,LastName, FirstName, MiddleInitial, Gender,
	Tier, DOB,	AddressLine1, AddressLine2, PostalCode, City, State_Prov, Country, Phone1, 
	Phone2, Phone3, Email1, Email2, ActionTS, MarketingNameplate, NationalTaxRateDesc, NationalTaxRate,  LocalTaxRateDesc,
	LocalTaxRate, AgencyID, CreditRating, NetWorth,numericberChildren, 
	Age, Income, numericberCars, numericberCreditCards)
	SELECT 	T.ActionType, T.CustomerID, T.TaxID, T.Status,T.LastName, T.FirstName, T.MiddleInitial, T.Gender,
	T.Tier, T.DOB,	T.AddressLine1, T.AddressLine2, T.PostalCode, T.City, T.State_Prov, T.Country, T.Phone1, 
	T.Phone2, T.Phone3, T.Email1, T.Email2, T.ActionTS, T.MarketingNameplate, T.NationalTaxRateDesc, T.NationalTaxRate,  T.LocalTaxRateDesc,
	T.LocalTaxRate, P.AgencyID, P.CreditRating, P.NetWorth,P.numericberChildren, 
	P.Age, P.Income, P.numericberCars, P.numericberCreditCards
	FROM   UPDtemp3 T LEFT OUTER JOIN Prospect P ON

	(
	TRIM(BOTH ' ' FROM UPPER(T.LastName)) = TRIM(BOTH ' ' FROM UPPER(P.LastName)) AND 
	TRIM(BOTH ' ' FROM UPPER(T.FirstName)) = TRIM(BOTH ' ' FROM UPPER(P.FirstName)) AND 
	TRIM(BOTH ' ' FROM UPPER(T.AddressLine1)) = TRIM(BOTH ' ' FROM UPPER(P.AddressLine1)) AND 
	--LATER FIND OUT WHY IF AddressLine2 IS ADDED, SOME TUPLES DO NOT GET A MATCHING TempProspect ATTRIBUTES
	TRIM(BOTH ' ' FROM UPPER(T.AddressLine2)) = TRIM(BOTH ' ' FROM UPPER(P.AddressLine2)) AND 
	TRIM(BOTH ' ' FROM UPPER(T.PostalCode)) = TRIM(BOTH ' ' FROM UPPER(P.PostalCode)));


--ALTER TABLE UPDtemp4
--ADD COLUMN MarketingNameplate VARCHAR;


	
--Calculate marketingNameplate
UPDATE UPDtemp4
SET MarketingNameplate = CONCAT(MarketingNameplate, '+', 'HighValue')
WHERE NetWorth>1000000 OR Income > 200000;

UPDATE UPDtemp4
SET MarketingNameplate = CONCAT(MarketingNameplate , '+','Expenses')
WHERE numericberChildren>3 OR numericberCreditCards > 5;

UPDATE UPDtemp4
SET MarketingNameplate = CONCAT(MarketingNameplate, '+', 'Boomer')
WHERE Age>45;

UPDATE UPDtemp4
SET MarketingNameplate = CONCAT(MarketingNameplate, '+', 'MoneyAlert')
WHERE Income<50000 OR CreditRating < 600 OR NetWorth<100000;

UPDATE UPDtemp4
SET MarketingNameplate = CONCAT(MarketingNameplate, '+', 'Spender')
WHERE numericberCars>3 OR numericberCreditCards > 7;

UPDATE UPDtemp4
SET MarketingNameplate = CONCAT(MarketingNameplate, '+', 'Inherited')
WHERE Age<25 AND NetWorth>1000000;

UPDATE UPDtemp4
SET MarketingNameplate = btrim(MarketingNameplate, '+');




INSERT INTO DimCustomer(SK_CustomerID,CustomerID, TaxID, Status,LastName, FirstName, MiddleInitial,
	 Gender, Tier, DOB, AddressLine1, AddressLine2, PostalCode, City, StateProv, Country,
	  Phone1, Phone2, Phone3,Email1, Email2,NationalTaxRateDesc,
	  NationalTaxRate,LocalTaxRateDesc,LocalTaxRate,AgencyID, CreditRating, NetWorth,MarketingNameplate,
	  IsCurrent,BatchID,EffectiveDate,EndDate)
	SELECT U.SK_CustomerID_value+1 as SK_CustomerID, 
	CustomerID, TaxID, Status,LastName, FirstName, MiddleInitial,
	 Gender, Tier::int, DOB, AddressLine1, AddressLine2, PostalCode, City, State_Prov, Country,
	  Phone1, Phone2, Phone3,Email1, Email2,NationalTaxRateDesc,
	  NationalTaxRate,LocalTaxRateDesc,LocalTaxRate,AgencyID, CreditRating, NetWorth,MarketingNameplate,
	  TRUE,1,ActionTS,'9999-12-31'
	FROM 
	UPDtemp4 , UPDtemp5 U;


TRUNCATE  UPDtemp1,UPDtemp2,UPDtemp3,UPDtemp4;--,UPDtemp5;

UPDATE UPDtemp5 SET 
SK_CustomerID_value=SK_CustomerID_value+1
WHERE 
SK_CustomerID_value IS not NULL;


	--DELETE FROM temp2 WHERE seq = (SELECT MIN(seq)
      -- FROM temp3 AS seq1);        
	-- DELETE FROM temp3 where seq is not null;      




--FOR DIMACCOUNT
INSERT INTO ADDtemp1 (ActionType, AccountID, AccountDesc, TaxStatus, CA_B_ID, C_ID, ActionTS)
	SELECT ActionType, AccountID, AccountDesc, TaxStatus, CA_B_ID, CustomerID, ActionTS
	 FROM temp3;

	
	--GET SK_BrokerID FROM DimBroker
	INSERT INTO ADDtemp2 (ActionType, AccountID, AccountDesc, TaxStatus, CA_B_ID, C_ID ,ActionTS, 
	SK_BrokerID)
	SELECT  ActionType, AccountID, AccountDesc, TaxStatus, CA_B_ID, C_ID ,ActionTS, 
	SK_BrokerID
	FROM ADDtemp1 N JOIN DimBroker  D ON
		 (N.CA_B_ID = D.BrokerID AND
		  (N.ActionTS >= D.EffectiveDate AND N.ActionTS <= D.EndDate));


	--GET SK_CustomerID FROM DimBroker
	INSERT INTO ADDtemp3 (ActionType, AccountID, AccountDesc, TaxStatus, CA_B_ID, C_ID ,ActionTS, 
	SK_BrokerID, SK_CustomerID)
	SELECT  ActionType, AccountID, AccountDesc, TaxStatus, CA_B_ID, C_ID, ActionTS, 
	SK_BrokerID, SK_CustomerID
	FROM ADDtemp2 A JOIN DimCustomer D ON
	(--D.IsCurrent=TRUE AND
	 A.C_ID = D.CustomerID
	AND (A.ActionTS >= D.EffectiveDate AND A.ActionTS <= D.EndDate));


	--INSERT INTO ADDtemp5(SK_AccountID_value)
	--SELECT MAX(SK_AccountID) AS SK_AccountID_value FROM DimAccount;
	
	--UPDATE ADDtemp5 SET 
	--SK_AccountID_value=0
	--WHERE 
	--SK_AccountID_value IS NULL;  


	INSERT INTO DimAccount(SK_AccountID,AccountID,SK_BrokerID,SK_CustomerID,
	Status,AccountDesc, TaxStatus,IsCurrent,BatchID,EffectiveDate,EndDate)
	SELECT  U.SK_AccountID_value + 1 as SK_AccountID, 
	AccountID,SK_BrokerID,SK_CustomerID,
	'Active',AccountDesc, TaxStatus,TRUE,1,ActionTS,'9999-12-31'
	FROM 
	ADDtemp3 , ADDtemp5 U;

	TRUNCATE  ADDtemp1,ADDtemp2,ADDtemp3;--,ADDtemp5;
	

UPDATE ADDtemp5 SET 
SK_AccountID_value=SK_AccountID_value+1
WHERE 
SK_AccountID_value IS not NULL;


*/



-------------------------------------------------------------------------------------

	
	--ELS
	IF Action='ADDACCT' THEN

	

	INSERT INTO ADDtemp1 (ActionType, AccountID, AccountDesc, TaxStatus, CA_B_ID, C_ID, ActionTS)
	SELECT ActionType, AccountID, AccountDesc, TaxStatus, CA_B_ID, CustomerID, ActionTS
	 FROM temp3;

	
	--GET SK_BrokerID FROM DimBroker
	INSERT INTO ADDtemp2 (ActionType, AccountID, AccountDesc, TaxStatus, CA_B_ID, C_ID ,ActionTS, 
	SK_BrokerID)
	SELECT  ActionType, AccountID, AccountDesc, TaxStatus, CA_B_ID, C_ID ,ActionTS, 
	SK_BrokerID
	FROM ADDtemp1 N JOIN DimBroker  D ON
	(N.CA_B_ID = D.BrokerID AND
	(N.ActionTS >= D.EffectiveDate AND N.ActionTS <= D.EndDate));


	--GET SK_CustomerID FROM DimBroker
	INSERT INTO ADDtemp3 (ActionType, AccountID, AccountDesc, TaxStatus, CA_B_ID, C_ID ,ActionTS, 
	SK_BrokerID, SK_CustomerID)
	SELECT  ActionType, AccountID, AccountDesc, TaxStatus, CA_B_ID, C_ID, ActionTS, 
	SK_BrokerID, SK_CustomerID
	FROM ADDtemp2 A JOIN DimCustomer D ON
	(--D.IsCurrent=TRUE AND
	 A.C_ID = D.CustomerID
	AND (A.ActionTS >= D.EffectiveDate AND A.ActionTS <= D.EndDate));


	

	INSERT INTO DimAccount(SK_AccountID,AccountID,SK_BrokerID,SK_CustomerID,
	Status,AccountDesc, TaxStatus,IsCurrent,BatchID,EffectiveDate,EndDate)
	SELECT  U.SK_AccountID_value + 1 as SK_AccountID, 
	AccountID,SK_BrokerID,SK_CustomerID,
	'Active',AccountDesc, TaxStatus,TRUE,1,ActionTS,'9999-12-31'
	FROM 
	ADDtemp3 , ADDtemp5 U;

	TRUNCATE  ADDtemp1,ADDtemp2,ADDtemp3;--,ADDtemp5;
	
	--DELETE FROM temp2 WHERE seq = (SELECT MIN(seq)
     --  FROM temp3 AS seq1);
        
	-- DELETE FROM temp3 where seq is not null;     


	UPDATE ADDtemp5 SET 
	SK_AccountID_value=SK_AccountID_value+1
	WHERE 
	SK_AccountID_value IS not NULL;






-------------------------------------------------------------------------------------

	 
	ELSIF Action='UPDCUST' THEN
	--INSERT INTO TEST(CustomerID,ActionType)
       --SELECT  CustomerID,ActionType
	-- FROM temp3;

	INSERT INTO UPDCUSTtemp1 (seq,ActionType,CustomerID, TaxID, LastName, FirstName, MiddleInitial, Gender, Tier, DOB,
	AddressLine1, AddressLine2, PostalCode, City, State_Prov, Country, 
	Phone1C_CTRY_CODE,Phone1C_AREA_CODE,Phone1C_LOCAL,Phone1C_EXT,
	Phone2C_CTRY_CODE,Phone2C_AREA_CODE,Phone2C_LOCAL,Phone2C_EXT,
	Phone3C_CTRY_CODE,Phone3C_AREA_CODE,Phone3C_LOCAL,Phone3C_EXT,
	Email1, Email2,C_NAT_TX_ID,C_LCL_TX_ID,ActionTS)
	SELECT seq,ActionType,CustomerID, TaxID, LastName, FirstName, MiddleInitial, Gender, Tier, DOB,
	AddressLine1, AddressLine2, PostalCode, City, State_Prov, Country, 
	Phone1C_CTRY_CODE,Phone1C_AREA_CODE,Phone1C_LOCAL,Phone1C_EXT,
	Phone2C_CTRY_CODE,Phone2C_AREA_CODE,Phone2C_LOCAL,Phone2C_EXT,
	Phone3C_CTRY_CODE,Phone3C_AREA_CODE,Phone3C_LOCAL,Phone3C_EXT,
	Email1, Email2,C_NAT_TX_ID,C_LCL_TX_ID,ActionTS FROM temp3;


        INSERT INTO Customerkeys(Sk_CustomerID,CustomerID)
        SELECT D.Sk_CustomerID,I.CustomerID
        FROM Dimcustomer D, UPDCUSTtemp1 I
        WHERE
        D.CustomerID = I.CustomerID AND
        D.IsCurrent =TRUE;

	--SELECT * FROM Customerkeys;
	

		--Calculate values for Phone 1
	  --Phone1 : CTRY_CODE IS NOT NULL, AREA_CODE IS NOT NULL, C_LOCAL IS NOT NULL
	UPDATE UPDCUSTtemp1
	SET Phone1 = CONCAT('+',Phone1C_CTRY_CODE,' (',Phone1C_AREA_CODE,') ',Phone1C_LOCAL)
	WHERE (Phone1C_CTRY_CODE IS NOT NULL) AND (Phone1C_AREA_CODE IS NOT NULL) AND (Phone1C_LOCAL IS NOT NULL);

	--Phone1 : CTRY_CODE IS  NULL, AREA_CODE IS NOT NULL, C_LOCAL IS NOT NULL
	UPDATE UPDCUSTtemp1
	SET Phone1 = CONCAT('(',Phone1C_AREA_CODE,') ',Phone1C_LOCAL)
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
	WHERE Phone1 = '+ ()';

	UPDATE UPDCUSTtemp1
	SET 
	Phone1 =substr(Phone1, 6,LENGTH(Phone1))
	WHERE substr(Phone1, 1,4) = '+ ()'
	;
	UPDATE UPDCUSTtemp1
	SET 
	Phone1 =substr(Phone1, 3,LENGTH(Phone1))
	WHERE substr(Phone1, 1,3) = '+ ('
	;


	--Calculate values for Phone 2
	 --Phone2 : CTRY_CODE IS NOT NULL, AREA_CODE IS NOT NULL, C_LOCAL IS NOT NULL
	UPDATE UPDCUSTtemp1
	SET Phone2 = CONCAT('+',Phone2C_CTRY_CODE,' (',Phone2C_AREA_CODE,') ',Phone2C_LOCAL)
	WHERE (Phone2C_CTRY_CODE IS NOT NULL) AND (Phone2C_AREA_CODE IS NOT NULL) AND (Phone2C_LOCAL IS NOT NULL);

	--Phone2 : CTRY_CODE IS  NULL, AREA_CODE IS NOT NULL, C_LOCAL IS NOT NULL
	UPDATE UPDCUSTtemp1
	SET Phone2 = CONCAT('(',Phone2C_AREA_CODE,') ',Phone2C_LOCAL)
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
	WHERE Phone2 = '+ ()';

	UPDATE UPDCUSTtemp1
	SET 
	Phone2 =substr(Phone2, 6,LENGTH(Phone2))
	WHERE substr(Phone2, 1,4) = '+ ()'
	;
	UPDATE UPDCUSTtemp1
	SET 
	Phone2 =substr(Phone2, 3,LENGTH(Phone2))
	WHERE substr(Phone2, 1,3) = '+ ('
	;




	--Calculate values for Phone 3
	 --Phone3 : CTRY_CODE IS NOT NULL, AREA_CODE IS NOT NULL, C_LOCAL IS NOT NULL
	UPDATE UPDCUSTtemp1
	SET Phone3 = CONCAT('+',Phone3C_CTRY_CODE,' (',Phone3C_AREA_CODE,') ',Phone3C_LOCAL)
	WHERE (Phone3C_CTRY_CODE IS NOT NULL) AND (Phone3C_AREA_CODE IS NOT NULL) AND (Phone3C_LOCAL IS NOT NULL);

	--Phone3 : CTRY_CODE IS  NULL, AREA_CODE IS NOT NULL, C_LOCAL IS NOT NULL
	UPDATE UPDCUSTtemp1
	SET Phone3 = CONCAT('(',Phone3C_AREA_CODE,') ',Phone3C_LOCAL)
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
	WHERE Phone3 = '+ ()';


	UPDATE UPDCUSTtemp1
	SET 
	Phone3 =substr(Phone3, 6,LENGTH(Phone3))
	WHERE substr(Phone3, 1,4) = '+ ()'
	;
	UPDATE UPDCUSTtemp1
	SET 
	Phone3 =substr(Phone3, 3,LENGTH(Phone3))
	WHERE substr(Phone3, 1,3) = '+ ('
	;

	--trim trailing spaces
	UPDATE UPDCUSTtemp1
	SET 
	Phone1=TRIM(BOTH '          ' FROM Phone1),
	Phone2= TRIM(BOTH '          ' FROM Phone2),
	Phone3= TRIM(BOTH '          ' FROM Phone3)
	;


	INSERT INTO UPDCUSTtemp2 (TaxID ,Status,LastName, FirstName, MiddleInitial,Gender,dob,Tier,
	NationalTaxRateDesc, NationalTaxRate, LocalTaxRateDesc,LocalTaxRate,
	ActionType,CustomerID,ActionTS, 
	AddressLine1, AddressLine2, PostalCode, City, State_Prov, Country, 
	Phone1, Phone2, Phone3,Email1, Email2,
	TierNew,AddressLine1New , AddressLine2New, PostalCodeNew,
	CityNew,  State_ProvNew, CountryNew, 
	Phone1New, Phone2New,Phone3New,
	Email1New,Email2New)
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

	--UPDATE Utemp2T
	--SET
	--Tier = TierNew
	--WHERE Tier != TierNew;-- OR Tier IS NULL;

	UPDATE UPDCUSTtemp2
	SET
	AddressLine1 = AddressLine1New
	WHERE AddressLine1 != AddressLine1New;

	UPDATE UPDCUSTtemp2 
	SET
	AddressLine2 = AddressLine2New
	WHERE AddressLine2 != AddressLine2New;

	UPDATE UPDCUSTtemp2 
	SET
	PostalCode = PostalCodeNew
	WHERE PostalCode != PostalCodeNew;

	UPDATE UPDCUSTtemp2 
	SET
	City = CityNew
	WHERE City != CityNew;

	UPDATE UPDCUSTtemp2 
	SET
	Country = CountryNew
	WHERE Country != CountryNew;

	UPDATE UPDCUSTtemp2 
	SET
	State_Prov = State_ProvNew
	WHERE State_Prov != State_ProvNew;

	UPDATE UPDCUSTtemp2
	SET
	Phone1 = Phone1New
	WHERE Phone1 != Phone1New;

	UPDATE UPDCUSTtemp2 
	SET
	Phone2 = Phone2New
	WHERE Phone2 != Phone2New;

	UPDATE UPDCUSTtemp2 
	SET
	Phone3 = Phone3New
	WHERE Phone3 != Phone3New;

	UPDATE UPDCUSTtemp2 
	SET
	Email1 = Email1New
	WHERE Email1 != Email1New;


	UPDATE UPDCUSTtemp2 
	SET
	Email2 = Email2New
	WHERE Email2 != Email2New;

	--DROP SOME COLUMNS
	INSERT INTO  UPDCUSTtemp3(TaxID ,Status,LastName, FirstName, MiddleInitial,Gender,dob,Tier,
	NationalTaxRateDesc, NationalTaxRate, LocalTaxRateDesc, LocalTaxRate,
	ActionType, CustomerID, ActionTS, 
	 AddressLine1 ,  AddressLine2, PostalCode,
	 City,  State_Prov, Country, 
	Phone1, Phone2, Phone3,
	Email1, Email2)
	SELECT TaxID ,Status,LastName, FirstName, MiddleInitial,Gender,dob,Tier,
	NationalTaxRateDesc, NationalTaxRate, LocalTaxRateDesc, LocalTaxRate,
	ActionType, CustomerID, ActionTS, 
	 AddressLine1 ,  AddressLine2, PostalCode,
	 City,  State_Prov, Country, 
	Phone1, Phone2, Phone3,
	Email1, Email2
	FROM UPDCUSTtemp2;





--AGENCYID,CREDITRATING,NETWORTH
	INSERT INTO  UPDCUSTtemp4 (ActionType, CustomerID, TaxID, Status,LastName, FirstName, MiddleInitial, Gender,
	Tier, DOB,	AddressLine1, AddressLine2, PostalCode, City, State_Prov, Country, Phone1, 
	Phone2, Phone3, Email1, Email2, ActionTS, MarketingNameplate, NationalTaxRateDesc, NationalTaxRate,  LocalTaxRateDesc,
	LocalTaxRate, AgencyID, CreditRating, NetWorth,numericberChildren, 
	Age, Income, numericberCars, numericberCreditCards)
	SELECT 	T.ActionType, T.CustomerID, T.TaxID, T.Status,T.LastName, T.FirstName, T.MiddleInitial, T.Gender,
	T.Tier, T.DOB,	T.AddressLine1, T.AddressLine2, T.PostalCode, T.City, T.State_Prov, T.Country, T.Phone1, 
	T.Phone2, T.Phone3, T.Email1, T.Email2, T.ActionTS, T.MarketingNameplate, T.NationalTaxRateDesc, T.NationalTaxRate,  T.LocalTaxRateDesc,
	T.LocalTaxRate, P.AgencyID, P.CreditRating, P.NetWorth,P.numericberChildren, 
	P.Age, P.Income, P.numericberCars, P.numericberCreditCards
	FROM   UPDCUSTtemp3 T LEFT OUTER JOIN Prospect P ON

	(
	TRIM(BOTH ' ' FROM UPPER(T.LastName)) = TRIM(BOTH ' ' FROM UPPER(P.LastName)) AND 
	TRIM(BOTH ' ' FROM UPPER(T.FirstName)) = TRIM(BOTH ' ' FROM UPPER(P.FirstName)) AND 
	TRIM(BOTH ' ' FROM UPPER(T.AddressLine1)) = TRIM(BOTH ' ' FROM UPPER(P.AddressLine1)) AND 
	--LATER FIND OUT WHY IF AddressLine2 IS ADDED, SOME TUPLES DO NOT GET A MATCHING TempProspect ATTRIBUTES
	TRIM(BOTH ' ' FROM UPPER(T.AddressLine2)) = TRIM(BOTH ' ' FROM UPPER(P.AddressLine2)) AND 
	TRIM(BOTH ' ' FROM UPPER(T.PostalCode)) = TRIM(BOTH ' ' FROM UPPER(P.PostalCode)));


		
	--Calculate marketingNameplate
	UPDATE UPDCUSTtemp4
	SET MarketingNameplate = CONCAT(MarketingNameplate, '+', 'HighValue')
	WHERE NetWorth>1000000 OR Income > 200000;

	UPDATE UPDCUSTtemp4
	SET MarketingNameplate = CONCAT(MarketingNameplate , '+','Expenses')
	WHERE numericberChildren>3 OR numericberCreditCards > 5;

	UPDATE UPDCUSTtemp4
	SET MarketingNameplate = CONCAT(MarketingNameplate, '+', 'Boomer')
	WHERE Age>45;

	UPDATE UPDCUSTtemp4
	SET MarketingNameplate = CONCAT(MarketingNameplate, '+', 'MoneyAlert')
	WHERE Income<50000 OR CreditRating < 600 OR NetWorth<100000;

	UPDATE UPDCUSTtemp4
	SET MarketingNameplate = CONCAT(MarketingNameplate, '+', 'Spender')
	WHERE numericberCars>3 OR numericberCreditCards > 7;

	UPDATE UPDCUSTtemp4
	SET MarketingNameplate = CONCAT(MarketingNameplate, '+', 'Inherited')
	WHERE Age<25 AND NetWorth>1000000;

	UPDATE UPDCUSTtemp4
	SET MarketingNameplate = btrim(MarketingNameplate, '+');





	-- Retire matching tuples in DimCustomer
	UPDATE DimCustomer SET
	EndDate=  (SELECT ActionTS AS EndDate FROM 
	UPDCUSTtemp1 WHERE UPDCUSTtemp1.CustomerID = DimCustomer.CustomerID AND
	 DimCustomer.IsCurrent=TRUE),
	IsCurrent = False
	WHERE EXISTS
	(SELECT UPDCUSTtemp1.CustomerID
	FROM UPDCUSTtemp1 WHERE UPDCUSTtemp1.CustomerID = DimCustomer.CustomerID AND
	 DimCustomer.IsCurrent=TRUE);



	--ALTER TABLE DimAccount 
	--ADD CONSTRAINT dimaccount_sk_customerid_fkey FOREIGN KEY (SK_CustomerID) REFERENCES DimCustomer (SK_CustomerID);






	--INSERT INTO UPDtemp5(SK_CustomerID_value)
	--SELECT MAX(SK_CustomerID) AS SK_CustomerID_value FROM DimCustomer;


	INSERT INTO DimCustomer(SK_CustomerID,CustomerID, TaxID, Status,LastName, FirstName, MiddleInitial,
	 Gender, Tier, DOB, AddressLine1, AddressLine2, PostalCode, City, StateProv, Country,
	 Phone1, Phone2, Phone3,Email1, Email2,NationalTaxRateDesc,
	 NationalTaxRate,LocalTaxRateDesc,LocalTaxRate,AgencyID, CreditRating, NetWorth,MarketingNameplate,
	 IsCurrent,BatchID,EffectiveDate,EndDate)
	SELECT U.SK_CustomerID_value+1 as SK_CustomerID, 
	CustomerID, TaxID, Status,LastName, FirstName, MiddleInitial,
	Gender, Tier::int, DOB, AddressLine1, AddressLine2, PostalCode, City, State_Prov, Country,
	 Phone1, Phone2, Phone3,Email1, Email2,NationalTaxRateDesc,
	 NationalTaxRate,LocalTaxRateDesc,LocalTaxRate,AgencyID, CreditRating, NetWorth,MarketingNameplate,
	 TRUE,1,ActionTS,'9999-12-31'
	FROM 
	UPDCUSTtemp4 , UPDtemp5 U;

	UPDATE UPDtemp5 SET 
	SK_CustomerID_value=SK_CustomerID_value+1
	WHERE 
	SK_CustomerID_value IS not NULL;



	INSERT INTO UPDCUSTtemp6 (CustomerID, ActionTS, Sk_CustomerID,AccountID,
	SK_BrokerID,Status,AccountDesc,TaxStatus,EffectiveDate)
	SELECT U.CustomerID, U.ActionTS, D.Sk_CustomerID, A.AccountID,
	A.SK_BrokerID,A.Status,A.AccountDesc,A.TaxStatus,A.EffectiveDate
	 FROM UPDCUSTtemp1 U, CustomerKeys D, DimAccount A
	 WHERE
	 U.CustomerID = D.CustomerID AND
	 D.Sk_CustomerID =A.Sk_CustomerID AND
	A.IsCurrent=TRUE;

	



	UPDATE DimAccount D SET
	--Status=  'Inactive',   ---commented
	IsCurrent=FALSE,
	--EndDate=(SELECT date_trunc('day', ActionTS)
	EndDate=(SELECT  ActionTS
                FROM UPDCUSTtemp6
            WHERE UPDCUSTtemp6.AccountID = D.AccountID)
	WHERE EXISTS
	(SELECT AccountID
	FROM UPDCUSTtemp6 I where D.AccountID = I.AccountID AND D.IsCurrent=TRUE
	AND EffectiveDate<> date_trunc('day', ActionTS));



	--update surrogate key for accounts with updates that occured on the same day
	UPDATE DimAccount D SET	
	Sk_CustomerID=(SELECT  C.Sk_CustomerID
        FROM DimCustomer C, UPDCUSTtemp6 U
        WHERE C.CustomerID =  U.CustomerID AND C.IsCurrent=TRUE
        AND U.EffectiveDate = date_trunc('day', ActionTS))
	WHERE EXISTS
	(SELECT AccountID
	FROM UPDCUSTtemp6 I where D.AccountID = I.AccountID AND D.IsCurrent=TRUE
	AND EffectiveDate = date_trunc('day', ActionTS));

	

	INSERT INTO UPDCUSTtemp7 (CustomerID, ActionTS,AccountID,SK_BrokerID,Status,
	AccountDesc,TaxStatus,Sk_CustomerID,EffectiveDate)
	SELECT U.CustomerID, U.ActionTS, U.AccountID,
	U.SK_BrokerID,U.Status,U.AccountDesc,U.TaxStatus, D.Sk_CustomerID, U.EffectiveDate
	FROM UPDCUSTtemp6 U, DimCustomer D
	WHERE 
	U.CustomerID = D.CustomerID AND
	D.Iscurrent=TRUE;

	COUNT=(SELECT COUNT(*) FROM UPDCUSTtemp7);

	INSERT INTO DimAccount(SK_AccountID,AccountID,SK_BrokerID,SK_CustomerID,
	Status,AccountDesc, TaxStatus,IsCurrent,BatchID,EffectiveDate,EndDate)
	SELECT  U.SK_AccountID_value +  row_number() over( order by U.SK_AccountID_value)
	 as SK_AccountID, 
	AccountID,SK_BrokerID,SK_CustomerID,
	Status,AccountDesc, TaxStatus,TRUE,1,ActionTS,'9999-12-31'  --took out 'Active'
	FROM 
	UPDCUSTtemp7 , ADDtemp5 U
	WHERE EffectiveDate<>date_trunc('day', ActionTS);

	
	

	UPDATE ADDtemp5 SET 
	SK_AccountID_value=SK_AccountID_value+ COUNT
	WHERE 
	SK_AccountID_value IS not NULL;






	TRUNCATE  UPDCUSTtemp1,UPDCUSTtemp2,UPDCUSTtemp3,UPDCUSTtemp4,UPDCUSTtemp6,UPDCUSTtemp7;
	--DELETE FROM temp2 WHERE seq = (SELECT MIN(seq)
	--FROM temp3 AS seq1);
        
	-- DELETE FROM temp3 where seq is not null;     









-------------------------------------------------------------------------------------
	ELSIF Action='UPDACCT' THEN

		--INSERT INTO TEST(CustomerID,ActionType)
      -- SELECT  CustomerID,ActionType
	-- FROM temp3;

	INSERT INTO UPDACCTtemp1 (seq,ActionType,CustomerID, TaxID, LastName, FirstName, MiddleInitial, Gender, Tier, DOB,
	AddressLine1, AddressLine2, PostalCode, City, State_Prov, Country, 
	Phone1C_CTRY_CODE,Phone1C_AREA_CODE,Phone1C_LOCAL,Phone1C_EXT,
	Phone2C_CTRY_CODE,Phone2C_AREA_CODE,Phone2C_LOCAL,Phone2C_EXT,
	Phone3C_CTRY_CODE,Phone3C_AREA_CODE,Phone3C_LOCAL,Phone3C_EXT,
	Email1, Email2,C_NAT_TX_ID,C_LCL_TX_ID,AccountID,AccountDesc,
	TaxStatus,CA_B_ID,ActionTS)
	SELECT seq,ActionType,CustomerID, TaxID, LastName, FirstName, MiddleInitial, Gender, Tier, DOB,
	AddressLine1, AddressLine2, PostalCode, City, State_Prov, Country, 
	Phone1C_CTRY_CODE,Phone1C_AREA_CODE,Phone1C_LOCAL,Phone1C_EXT,
	Phone2C_CTRY_CODE,Phone2C_AREA_CODE,Phone2C_LOCAL,Phone2C_EXT,
	Phone3C_CTRY_CODE,Phone3C_AREA_CODE,Phone3C_LOCAL,Phone3C_EXT,
	Email1, Email2,C_NAT_TX_ID,C_LCL_TX_ID,AccountID,AccountDesc,
	TaxStatus,CA_B_ID,ActionTS FROM temp3;
	

	
	INSERT INTO UPDACCTtemp2(ActionType, AccountID,SK_CustomerID, AccountDesc,AccountDescNew, TaxStatus,
	  CA_B_ID,ActionTS,EffectiveDate)
	SELECT U.ActionType, D.AccountID,C.SK_CustomerID, U.AccountDesc , D.AccountDesc AS AccountDescNEW,
	D.TaxStatus, U.CA_B_ID,U.ActionTS,D.EffectiveDate	
	FROM UPDACCTtemp1 U,DimAccount D, DimCustomer C
	WHERE
	U.AccountID=D.AccountID AND 
	U.CustomerID = C.CustomerID AND
	 D.IsCurrent=TRUE AND 
	 C.IsCurrent = TRUE;

	UPDATE UPDACCTtemp2
	SET
	AccountDesc = AccountDescNEW
	WHERE 
	AccountDesc !=AccountDescNEW;

	
	INSERT INTO UPDACCTtemp3(ActionType, AccountID,SK_CustomerID, AccountDesc,AccountDescNew, TaxStatus,
	  CA_B_ID,Sk_BrokerID,ActionTS,EffectiveDate)
	 SELECT  ActionType, AccountID,SK_CustomerID, AccountDesc,AccountDescNew, TaxStatus,
	  CA_B_ID,Sk_BrokerID,ActionTS, U.EffectiveDate
	FROM UPDACCTtemp2 U LEFT OUTER JOIN DimBroker D
	ON (
	U.CA_B_ID=D.BrokerID AND  
	(U.ActionTS >= D.EffectiveDate AND U.ActionTS < D.EndDate));

	 --for tuples with no ca_b_id to get brokerid, we copy the brokerid of the previous version in dim account
	--UPDACCT sometimes have ca_b_id but sometimes it is null
	UPDATE UPDACCTtemp3
	SET SK_BrokerID = (SELECT distinct DimAccount.SK_BrokerID
			 FROM DimAccount
			 WHERE DimAccount.AccountID = UPDACCTtemp3.AccountID AND DimAccount.IsCurrent=TRUE )
	WHERE UPDACCTtemp3.SK_BrokerID IS NULL;
	
	--select * from dimaccount
	
	UPDATE DimAccount D SET
	EndDate=  (SELECT ActionTS FROM UPDACCTtemp3 where 
	UPDACCTtemp3.AccountID = D.AccountID AND D.IsCurrent=TRUE),
	IsCurrent = False
	WHERE EXISTS
	(SELECT A.AccountID
	FROM UPDACCTtemp3 A WHERE A.AccountID = D.AccountID AND D.IsCurrent=TRUE
	AND EffectiveDate<>date_trunc('day', ActionTS));



	INSERT INTO DimAccount(SK_AccountID,AccountID,SK_BrokerID,SK_CustomerID,
	Status,AccountDesc, TaxStatus,IsCurrent,BatchID,EffectiveDate,EndDate)
	 SELECT U.SK_AccountID_value + 1 as SK_AccountID,AccountID,SK_BrokerID,SK_CustomerID,
	'Active',AccountDesc,TaxStatus,TRUE,1,ActionTS,'9999-12-31'
	FROM 
	UPDACCTtemp3 T, ADDtemp5 U
	WHERE EffectiveDate<>date_trunc('day', ActionTS)
	ORDER BY SK_AccountID ASC;

	
	UPDATE ADDtemp5 SET 
	SK_AccountID_value=SK_AccountID_value+1
	WHERE 
	SK_AccountID_value IS not NULL;

	
	--DELETE FROM temp2 WHERE seq = (SELECT MIN(seq)
     --  FROM temp3 AS seq1);
        
	-- DELETE FROM temp3 where seq is not null;     

	TRUNCATE  UPDACCTtemp1,UPDACCTtemp2,UPDACCTtemp3;




	-------------------------------------------------------------------------------------
	ELSIF Action='INACT' THEN

	INSERT INTO INACTtemp1 (seq,ActionType,CustomerID, TaxID, LastName, FirstName, MiddleInitial, Gender, Tier, DOB,
	AddressLine1, AddressLine2, PostalCode, City, State_Prov, Country, 
	Phone1C_CTRY_CODE,Phone1C_AREA_CODE,Phone1C_LOCAL,Phone1C_EXT,
	Phone2C_CTRY_CODE,Phone2C_AREA_CODE,Phone2C_LOCAL,Phone2C_EXT,
	Phone3C_CTRY_CODE,Phone3C_AREA_CODE,Phone3C_LOCAL,Phone3C_EXT,
	Email1, Email2,C_NAT_TX_ID,C_LCL_TX_ID,AccountID,AccountDesc,
	TaxStatus,CA_B_ID,ActionTS)
	SELECT seq,ActionType,CustomerID, TaxID, LastName, FirstName, MiddleInitial, Gender, Tier, DOB,
	AddressLine1, AddressLine2, PostalCode, City, State_Prov, Country, 
	Phone1C_CTRY_CODE,Phone1C_AREA_CODE,Phone1C_LOCAL,Phone1C_EXT,
	Phone2C_CTRY_CODE,Phone2C_AREA_CODE,Phone2C_LOCAL,Phone2C_EXT,
	Phone3C_CTRY_CODE,Phone3C_AREA_CODE,Phone3C_LOCAL,Phone3C_EXT,
	Email1, Email2,C_NAT_TX_ID,C_LCL_TX_ID,AccountID,AccountDesc,
	TaxStatus,CA_B_ID,ActionTS FROM temp3;



	INSERT INTO Customerkeysinact(Sk_CustomerID,CustomerID)
        SELECT D.Sk_CustomerID,I.CustomerID
        FROM Dimcustomer D, INACTtemp1 I
        WHERE
        D.CustomerID = I.CustomerID AND
        D.IsCurrent =TRUE;

        

	INSERT INTO INACTtemp2 ( ActionType, ActionTS, CustomerID, Sk_CustomerID)	
	SELECT  ActionType, ActionTS, D.CustomerID, D.Sk_CustomerID
	FROM INACTtemp1 I, DimCustomer D
	WHERE
	I.CustomerID = D.CustomerID AND 
	D.IsCurrent=TRUE ;


     /* INSERT INTO INACTtemp2A (  ActionTS, CustomerID, Sk_CustomerID, AccountID)	
	SELECT  DISTINCT ActionTS, I.CustomerID, A.Sk_CustomerID, A.AccountID
	FROM INACTtemp2 I, DimAccount A
	WHERE
	I.Sk_CustomerID = A.Sk_CustomerID AND
	A.IsCurrent=TRUE ;
*/

	INSERT INTO  INACTtemp3 (CustomerID, TaxID,LastName, FirstName, MiddleInitial,
	Gender, Tier, DOB, AddressLine1, AddressLine2, PostalCode, City, StateProv, Country,
	Phone1, Phone2, Phone3,Email1, Email2,NationalTaxRateDesc,
	NationalTaxRate,LocalTaxRateDesc,LocalTaxRate,AgencyID, CreditRating, NetWorth,MarketingNameplate,
	ActionTS)
	SELECT I.CustomerID, TaxID,LastName, FirstName, MiddleInitial,
	Gender, Tier, DOB, AddressLine1, AddressLine2, PostalCode, City, StateProv, Country,
	Phone1, Phone2, Phone3,Email1, Email2,NationalTaxRateDesc,
	NationalTaxRate,LocalTaxRateDesc,LocalTaxRate,AgencyID, CreditRating, NetWorth,MarketingNameplate,
	I.ActionTS
	FROM INACTtemp2 I, DimCustomer D
	WHERE I.CustomerID = D.CustomerID AND
	D.IsCurrent=TRUE;




	--ALTER TABLE DimAccount
	 --DROP CONSTRAINT  IF EXISTS   dimaccount_sk_customerid_fkey;
	
	UPDATE DimCustomer D SET
	Status=  'Inactive',
	IsCurrent=FALSE	
	,EndDate=(SELECT  ActionTS
               FROM INACTtemp1
              WHERE INACTtemp1.CustomerID = D.CustomerID)
	WHERE EXISTS
	(SELECT CustomerID
	FROM INACTtemp1 I where D.CustomerID = I.CustomerID AND D.IsCurrent=TRUE);

	--ALTER TABLE DimAccount 
	--ADD CONSTRAINT dimaccount_sk_customerid_fkey FOREIGN KEY (SK_CustomerID) REFERENCES DimCustomer (SK_CustomerID);



	--COUNT=(SELECT COUNT(*) FROM INACTtemp3);


	
	INSERT INTO DimCustomer(SK_CustomerID,CustomerID, TaxID, Status,LastName, FirstName, MiddleInitial,
	 Gender, Tier, DOB, AddressLine1, AddressLine2, PostalCode, City, StateProv, Country,
	  Phone1, Phone2, Phone3,Email1, Email2,NationalTaxRateDesc,
	  NationalTaxRate,LocalTaxRateDesc,LocalTaxRate,AgencyID, CreditRating, NetWorth,MarketingNameplate,
	  IsCurrent,BatchID,EffectiveDate,EndDate)
	SELECT U.SK_CustomerID_value +  1 as SK_CustomerID,
	CustomerID, TaxID, 'Inactive',LastName, FirstName, MiddleInitial,
	 Gender, Tier::INT, DOB, AddressLine1, AddressLine2, PostalCode, City, StateProv, Country,
	  Phone1, Phone2, Phone3,Email1, Email2,NationalTaxRateDesc,
	  NationalTaxRate,LocalTaxRateDesc,LocalTaxRate,AgencyID, CreditRating, NetWorth,MarketingNameplate,
	  TRUE,1,ActionTS,'9999-12-31'
	FROM INACTtemp3, UPDtemp5 U;

	UPDATE UPDtemp5 SET 
	SK_CustomerID_value=SK_CustomerID_value+1
	WHERE 
	SK_CustomerID_value IS not NULL;




	--UPDATE ACCOUNT
	INSERT INTO INACTtemp4 (CustomerID, ActionTS, Sk_CustomerID,AccountID,SK_BrokerID,Status,AccountDesc,TaxStatus)
	SELECT U.CustomerID, U.ActionTS, D.Sk_CustomerID, A.AccountID,
	A.SK_BrokerID,A.Status,A.AccountDesc,A.TaxStatus
	 FROM INACTtemp2 U, CustomerKeysinact D, DimAccount A
	 WHERE
	 U.CustomerID = D.CustomerID AND
	 D.Sk_CustomerID =A.Sk_CustomerID AND
	A.IsCurrent=TRUE;



	UPDATE DimAccount D SET
	Status=  'Inactive',	
	IsCurrent=FALSE	,
	EndDate=(SELECT  ActionTS
        FROM INACTtemp4
        WHERE INACTtemp4.AccountID = D.AccountID)
	WHERE EXISTS
	(SELECT AccountID
	FROM INACTtemp4 I where D.AccountID = I.AccountID AND D.IsCurrent=TRUE);


	INSERT INTO INACTtemp5 (CustomerID, ActionTS,AccountID,SK_BrokerID,Status,
	AccountDesc,TaxStatus,Sk_CustomerID)
	SELECT U.CustomerID, U.ActionTS, U.AccountID,
	U.SK_BrokerID,U.Status,U.AccountDesc,U.TaxStatus, D.Sk_CustomerID
	FROM INACTtemp4 U, DimCustomer D
	WHERE 
	U.CustomerID = D.CustomerID AND
	D.Iscurrent=TRUE;

	


	COUNT=(SELECT COUNT(*) FROM INACTtemp4);

	INSERT INTO DimAccount(SK_AccountID,AccountID,SK_BrokerID,SK_CustomerID,
	Status,AccountDesc, TaxStatus,IsCurrent,BatchID,EffectiveDate,EndDate)
	SELECT  U.SK_AccountID_value +  row_number() over( order by U.SK_AccountID_value)
	 as SK_AccountID, AccountID,SK_BrokerID,SK_CustomerID,
	'Inactive',AccountDesc, TaxStatus,TRUE,1,ActionTS,'9999-12-31'
	FROM 
	INACTtemp5 , ADDtemp5 U;


	UPDATE ADDtemp5 SET 
	SK_AccountID_value=SK_AccountID_value + COUNT
	WHERE 
	SK_AccountID_value IS not NULL;


	TRUNCATE  INACTtemp1,INACTtemp2,INACTtemp3,INACTtemp4,INACTtemp5;
	

	 
	-------------------------------------------------------------------------------------
	ELSIF Action='CLOSEACCT' THEN

	INSERT INTO CLOSEACCTtemp1 (seq,ActionType,CustomerID, TaxID, LastName, FirstName, MiddleInitial, Gender, Tier, DOB,
	AddressLine1, AddressLine2, PostalCode, City, State_Prov, Country, 
	Phone1C_CTRY_CODE,Phone1C_AREA_CODE,Phone1C_LOCAL,Phone1C_EXT,
	Phone2C_CTRY_CODE,Phone2C_AREA_CODE,Phone2C_LOCAL,Phone2C_EXT,
	Phone3C_CTRY_CODE,Phone3C_AREA_CODE,Phone3C_LOCAL,Phone3C_EXT,
	Email1, Email2,C_NAT_TX_ID,C_LCL_TX_ID,AccountID,AccountDesc,
	TaxStatus,CA_B_ID,ActionTS)
	SELECT seq,ActionType,CustomerID, TaxID, LastName, FirstName, MiddleInitial, Gender, Tier, DOB,
	AddressLine1, AddressLine2, PostalCode, City, State_Prov, Country, 
	Phone1C_CTRY_CODE,Phone1C_AREA_CODE,Phone1C_LOCAL,Phone1C_EXT,
	Phone2C_CTRY_CODE,Phone2C_AREA_CODE,Phone2C_LOCAL,Phone2C_EXT,
	Phone3C_CTRY_CODE,Phone3C_AREA_CODE,Phone3C_LOCAL,Phone3C_EXT,
	Email1, Email2,C_NAT_TX_ID,C_LCL_TX_ID,AccountID,AccountDesc,
	TaxStatus,CA_B_ID,ActionTS FROM temp3;


	INSERT INTO CLOSEACCTtemp2(ActionType, AccountID,SK_CustomerID, AccountDesc, TaxStatus,
	  CA_B_ID,Sk_BrokerID,ActionTS,EffectiveDate)
	SELECT U.ActionType, D.AccountID,C.SK_CustomerID, D.AccountDesc ,
	D.TaxStatus, U.CA_B_ID,D.Sk_BrokerID,U.ActionTS,D.EffectiveDate	
	FROM CLOSEACCTtemp1 U,DimAccount D, DimCustomer C
	WHERE
	U.AccountID=D.AccountID AND 
	U.CustomerID=C.CustomerID AND
	D.IsCurrent=TRUE AND
	C.IsCurrent = TRUE;

	

	
	/*INSERT INTO CLOSEACCTtemp3(ActionType, AccountID,SK_CustomerID, AccountDesc, TaxStatus,
	  CA_B_ID,Sk_BrokerID,ActionTS,EffectiveDate)
	 SELECT  ActionType, AccountID,SK_CustomerID, AccountDesc, TaxStatus,
	  CA_B_ID,Sk_BrokerID,ActionTS, U.EffectiveDate
	FROM UPDACCTtemp2 U,DimBroker D
	WHERE
	U.CA_B_ID=D.BrokerID AND  
	(U.ActionTS >= D.EffectiveDate AND U.ActionTS < D.EndDate);*/


	
	UPDATE DimAccount D SET
	Status=  'Inactive',
	IsCurrent=FALSE	,
	EndDate=(SELECT  ActionTS
        FROM CLOSEACCTtemp2
         WHERE CLOSEACCTtemp2.AccountID = D.AccountID)	
	WHERE EXISTS
	(SELECT AccountID
	FROM CLOSEACCTtemp2 I where D.AccountID = I.AccountID AND D.IsCurrent=TRUE
	AND EffectiveDate<>date_trunc('day', ActionTS));



	INSERT INTO DimAccount(SK_AccountID,AccountID,SK_BrokerID,SK_CustomerID,
	Status,AccountDesc, TaxStatus,IsCurrent,BatchID,EffectiveDate,EndDate)
	 SELECT U.SK_AccountID_value + 1 as SK_AccountID,AccountID,SK_BrokerID,SK_CustomerID,
	'Inactive',AccountDesc,TaxStatus,TRUE,1,ActionTS,'9999-12-31'
	FROM 
	CLOSEACCTtemp2 T, ADDtemp5 U
	WHERE EffectiveDate<>date_trunc('day', ActionTS)
	ORDER BY SK_AccountID ASC;

	
	UPDATE ADDtemp5 SET 
	SK_AccountID_value=SK_AccountID_value+1
	WHERE 
	SK_AccountID_value IS not NULL;


	TRUNCATE  CLOSEACCTtemp1,CLOSEACCTtemp2;
	
	END IF;

	

	DELETE FROM temp2 WHERE seq = (SELECT MIN(seq)
	FROM temp3 AS seq1);        
	DELETE FROM temp3 where seq is not null;
	Action='';	      
	ID=ID+1;
       
        END LOOP ; 


--INVALID TIER (NOT 1,2 OR 3)
	CREATE TEMPORARY TABLE msgTemp1 AS
	SELECT DISTINCT CustomerID,Tier FROM DimCustomer
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




