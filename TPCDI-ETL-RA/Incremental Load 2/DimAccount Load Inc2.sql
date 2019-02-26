/*DimAccount Load Inc1*/
DROP FUNCTION IF EXISTS DimAccountLoadInc2();
CREATE FUNCTION DimAccountLoadInc2()
RETURNS VOID AS $$
BEGIN

	DROP TABLE IF EXISTS inc2Atemp1,inc2Atemp2,inc2Atemp3,inc2Atemp4,inc2Atemp5,
	inc2AtempSur;
	


	
	/*FOR 'I'*/
	CREATE TEMPORARY TABLE inc2Atemp1 AS	
	SELECT CDC_FLAG, CDC_DSN,CA_ID, CA_B_ID,CA_C_ID, CA_NAME, CA_TAX_ST, CA_ST_ID
	FROM Account2
	WHERE
	CDC_FLAG='I' ;

		--GET SK_BrokerID FROM DimBroker
	CREATE TEMPORARY TABLE inc2Atemp2 AS
	SELECT  CDC_FLAG, CDC_DSN,CA_ID, CA_B_ID,CA_C_ID, CA_NAME, CA_TAX_ST, CA_ST_ID, D.SK_BrokerID
	FROM inc2Atemp1 U LEFT OUTER JOIN DimBroker D ON
		 U.CA_B_ID = D.BrokerID AND
		  D.IsCurrent=TRUE;

	--GET SK_CustomerID FROM DimCustomer
	CREATE TEMPORARY TABLE inc2Atemp3 AS
	SELECT CDC_FLAG, CDC_DSN,CA_ID, CA_B_ID, CA_C_ID, CA_NAME, CA_TAX_ST, CA_ST_ID, SK_BrokerID, SK_CustomerID
	FROM inc2Atemp2 A INNER JOIN DimCustomer D ON
		 A.CA_C_ID = D.CustomerID AND
		    D.IsCurrent=TRUE ORDER BY CA_C_ID;


	CREATE TEMPORARY TABLE inc2Atemp4 AS
	SELECT  CDC_FLAG, CDC_DSN,CA_ID, CA_B_ID,CA_C_ID, CA_NAME, CA_TAX_ST, CA_ST_ID, SK_BrokerID,
	 SK_CustomerID,	 ST_NAME as Status
	FROM inc2Atemp3 I INNER JOIN StatusType S ON
	--WHERE 
	I.CA_ST_ID = S.ST_ID;

	CREATE TEMPORARY TABLE inc2Atemp5 AS
	SELECT  CDC_FLAG, CDC_DSN,CA_ID, CA_B_ID,CA_C_ID, CA_NAME, CA_TAX_ST, CA_ST_ID, SK_BrokerID,
	 SK_CustomerID,	Status, BatchDateColumn
	FROM inc2Atemp4, BatchDate2;

	
	CREATE TEMPORARY TABLE inc2AtempSur AS
	SELECT MAX(SK_AccountID) AS SK_AccountID_value FROM DimAccount;

	
		INSERT INTO DimAccount(SK_AccountID,AccountID,SK_BrokerID,SK_CustomerID,
	Status,AccountDesc, TaxStatus,IsCurrent,BatchID,EffectiveDate,EndDate)
	SELECT  S.SK_AccountID_value + row_number() over( order by S.SK_AccountID_value) as SK_AccountID,
	 CA_ID,SK_BrokerID,SK_CustomerID,Status,CA_NAME, CA_TAX_ST,TRUE,3,BatchDateColumn,'9999-12-31'
	FROM 
	inc2Atemp5 A,  inc2AtempSur S
	order by  CA_ID asc;

	

	END;
	$$ LANGUAGE 'plpgsql';

	
	