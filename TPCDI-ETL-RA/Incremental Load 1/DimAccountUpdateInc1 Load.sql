/*DimAccountUpdate Load Inc1*/


DROP FUNCTION IF EXISTS DimAccountUpdateLoadInc1();
CREATE FUNCTION DimAccountUpdateLoadInc1()
RETURNS VOID AS $$
BEGIN

	DROP TABLE IF EXISTS incAtempU1,incAtempU2,incAtempU3,incAtempU4, incAtempU5,incAtempU6,incAtempU7,
	incAtempU8,incAtempU9,incAtempUSur;
	


	/*FOR 'I'*/
	CREATE TEMPORARY TABLE incAtempU1 AS	
	SELECT CDC_FLAG, CDC_DSN,CA_ID, CA_B_ID,CA_C_ID, CA_NAME, CA_TAX_ST, CA_ST_ID
	FROM Account1
	WHERE
	CDC_FLAG='U'; 


	-- Retire matching tuples in DimCustomer
	UPDATE DimAccount SET
	EndDate=  (SELECT BatchDateColumn AS EndDATE FROM BatchDate1),
	IsCurrent = False
	WHERE EXISTS
	(SELECT incAtempU1.CA_ID
	FROM incAtempU1 WHERE incAtempU1.CA_ID = DimAccount.AccountID AND DimAccount.IsCurrent=TRUE);


	--GET SK_BrokerID FROM DimBroker
	CREATE TEMPORARY TABLE incAtempU2 AS
	SELECT  CDC_FLAG, CDC_DSN,CA_ID, CA_B_ID,CA_C_ID, CA_NAME, CA_TAX_ST, CA_ST_ID, D.SK_BrokerID
	FROM incAtempU1 U INNER JOIN DimBroker D ON
	U.CA_B_ID = D.BrokerID AND
	D.IsCurrent=TRUE;

	--GET SK_CustomerID FROM DimCustomer
	CREATE TEMPORARY TABLE incAtempU3 AS
	SELECT CDC_FLAG, CDC_DSN,CA_ID, CA_B_ID,CA_C_ID, CA_NAME, CA_TAX_ST, CA_ST_ID, SK_BrokerID, SK_CustomerID
	FROM incAtempU2 A INNER JOIN DimCustomer D ON
	A.CA_C_ID = D.CustomerID AND
	D.IsCurrent=TRUE;


	CREATE TEMPORARY TABLE incAtempU4 AS
	SELECT  CDC_FLAG, CDC_DSN,CA_ID, CA_B_ID,CA_C_ID, CA_NAME, CA_TAX_ST, CA_ST_ID, SK_BrokerID,
	 SK_CustomerID,	 ST_NAME as Status
	FROM incAtempU3 I INNER JOIN StatusType S ON
	--WHERE 
	I.CA_ST_ID = S.ST_ID;

	CREATE TEMPORARY TABLE incAtempU5 AS
	SELECT  CDC_FLAG, CDC_DSN,CA_ID, CA_B_ID,CA_C_ID, CA_NAME, CA_TAX_ST, CA_ST_ID, SK_BrokerID,
	 SK_CustomerID,	Status, BatchDateColumn
	FROM incAtempU4, BatchDate1;

	
	CREATE TEMPORARY TABLE incAtempUSur AS
	SELECT MAX(SK_AccountID) AS SK_AccountID_value FROM DimAccount;

	
	INSERT INTO DimAccount(SK_AccountID,AccountID,SK_BrokerID,SK_CustomerID,
	Status,AccountDesc, TaxStatus,IsCurrent,BatchID,EffectiveDate,EndDate)
	SELECT  S.SK_AccountID_value + row_number() over( order by S.SK_AccountID_value) as SK_AccountID,
	 CA_ID,SK_BrokerID,SK_CustomerID,Status,CA_NAME, CA_TAX_ST,TRUE,2,BatchDateColumn,'9999-12-31'
	FROM 
	incAtempU5 A,  incAtempUSur S
	order by  CA_ID asc;

	--UPDATE DimAccount for Updated DimCustomer

	--Select tuples with actiontype = 'UPDATE' into temp1
	/*CREATE TEMPORARY TABLE incAtempU6 AS
	SELECT CDC_FLAG, CDC_DSN, C_ID, C_TAX_ID, C_ST_ID, C_L_NAME, C_F_NAME, C_M_NAME, C_GNDR,
		C_TIER,C_DOB, C_ADLINE1, C_ADLINE2, C_ZIPCODE, C_CITY, C_STATE_PROV, C_CTRY,
		C_CTRY_1, C_AREA_1, C_LOCAL_1, C_EXT_1, C_CTRY_2, C_AREA_2, C_LOCAL_2, C_EXT_2,
		C_CTRY_3, C_AREA_3, C_LOCAL_3, C_EXT_3, C_EMAIL_1, C_EMAIL_2, C_LCL_TX_ID, C_NAT_TX_ID
	 FROM Customer1 where CDC_FLAG='U' ;


	 CREATE TEMPORARY TABLE incAtempU7 AS
	SELECT DISTINCT CDC_FLAG,  D.Sk_CustomerID,A.AccountID, CDC_DSN, C_ID, C_TAX_ID, C_ST_ID, C_L_NAME, C_F_NAME, C_M_NAME, C_GNDR,
		C_TIER,C_DOB, C_ADLINE1, C_ADLINE2, C_ZIPCODE, C_CITY, C_STATE_PROV, C_CTRY,
		C_CTRY_1, C_AREA_1, C_LOCAL_1, C_EXT_1, C_CTRY_2, C_AREA_2, C_LOCAL_2, C_EXT_2,
		C_CTRY_3, C_AREA_3, C_LOCAL_3, C_EXT_3, C_EMAIL_1, C_EMAIL_2, C_LCL_TX_ID, C_NAT_TX_ID
	 FROM incAtempU6 i, DimCustomer D, DimAccount A
	 where 
	 I.C_ID = D.CustomerID AND
	  D.Sk_CustomerID = A.Sk_CustomerID;

	  
	  CREATE TEMPORARY TABLE incAtempU8 AS
	SELECT A.AccountID,SK_BrokerID,A.SK_CustomerID,
	Status,AccountDesc, TaxStatus,IsCurrent,BatchID,EffectiveDate,EndDate
	 FROM incAtempU7 i, DimAccount A
	 where 
	  I.AccountID = A.AccountID AND 
	  A.IsCurrent=TRUE;


	  --Close existing
	UPDATE DimAccount SET
	EndDate=  (SELECT BatchDateColumn AS EndDATE FROM BatchDate1),
	IsCurrent = False
	WHERE EXISTS
	(SELECT incAtempU8.AccountID
	FROM incAtempU8 WHERE incAtempU8.AccountID = DimAccount.AccountID AND DimAccount.IsCurrent=TRUE);
	  

	  --insert new
	CREATE TEMPORARY TABLE incAtempU9 AS
	SELECT MAX(SK_AccountID) AS SK_AccountID_value FROM DimAccount;

	
		INSERT INTO DimAccount(SK_AccountID,AccountID,SK_BrokerID,SK_CustomerID,
	Status,AccountDesc, TaxStatus,IsCurrent,BatchID,EffectiveDate,EndDate)
	SELECT  S.SK_AccountID_value + row_number() over( order by S.SK_AccountID_value) as SK_AccountID,
	 AccountID,SK_BrokerID,SK_CustomerID,Status,AccountDesc, TaxStatus,TRUE,2,B.BatchDateColumn,'9999-12-31'
	FROM 
	incAtempU8 A,  incAtempU9 S, BatchDate1 B
	order by  AccountID asc;*/

	END;
	$$ LANGUAGE 'plpgsql';

	--SELECT * FROM DimAccount WHERE AccountID=2448 ORDER BY EffectiveDate;
	