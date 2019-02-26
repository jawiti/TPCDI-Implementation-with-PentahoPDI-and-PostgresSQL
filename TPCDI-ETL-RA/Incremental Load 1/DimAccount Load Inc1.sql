/*DimAccount Load Inc1*/
DROP FUNCTION IF EXISTS DimAccountLoadInc1();
CREATE FUNCTION DimAccountLoadInc1()
RETURNS VOID AS $$
BEGIN

	DROP TABLE IF EXISTS incAtemp1,incAtemp2,incAtemp3,incAtemp4,incAtemp5,
	incAtempSur;
	


	
	/*FOR 'I'*/
	CREATE TEMPORARY TABLE incAtemp1 AS	
	SELECT CDC_FLAG, CDC_DSN,CA_ID, CA_B_ID,CA_C_ID, CA_NAME, CA_TAX_ST, CA_ST_ID
	FROM Account1
	WHERE
	CDC_FLAG='I' ;

		--GET SK_BrokerID FROM DimBroker
	CREATE TEMPORARY TABLE incAtemp2 AS
	SELECT  CDC_FLAG, CDC_DSN,CA_ID, CA_B_ID,CA_C_ID, CA_NAME, CA_TAX_ST, CA_ST_ID, D.SK_BrokerID
	FROM incAtemp1 U INNER JOIN DimBroker D ON
		 U.CA_B_ID = D.BrokerID AND
		  D.IsCurrent=TRUE;

	--GET SK_CustomerID FROM DimCustomer
	CREATE TEMPORARY TABLE incAtemp3 AS
	SELECT CDC_FLAG, CDC_DSN,CA_ID, CA_B_ID, CA_C_ID, CA_NAME, CA_TAX_ST, CA_ST_ID, SK_BrokerID, SK_CustomerID
	FROM incAtemp2 A INNER JOIN DimCustomer D ON
		 A.CA_C_ID = D.CustomerID AND
		    D.IsCurrent=TRUE ORDER BY CA_C_ID;


	CREATE TEMPORARY TABLE incAtemp4 AS
	SELECT  CDC_FLAG, CDC_DSN,CA_ID, CA_B_ID,CA_C_ID, CA_NAME, CA_TAX_ST, CA_ST_ID, SK_BrokerID,
	 SK_CustomerID,	 ST_NAME as Status
	FROM incAtemp3 I INNER JOIN StatusType S ON
	--WHERE 
	I.CA_ST_ID = S.ST_ID;

	CREATE TEMPORARY TABLE incAtemp5 AS
	SELECT  CDC_FLAG, CDC_DSN,CA_ID, CA_B_ID,CA_C_ID, CA_NAME, CA_TAX_ST, CA_ST_ID, SK_BrokerID,
	 SK_CustomerID,	Status, BatchDateColumn
	FROM incAtemp4, BatchDate1;

	
	CREATE TEMPORARY TABLE incAtempSur AS
	SELECT MAX(SK_AccountID) AS SK_AccountID_value FROM DimAccount;

	
	INSERT INTO DimAccount(SK_AccountID,AccountID,SK_BrokerID,SK_CustomerID,
	Status,AccountDesc, TaxStatus,IsCurrent,BatchID,EffectiveDate,EndDate)
	SELECT  S.SK_AccountID_value + row_number() over( order by S.SK_AccountID_value) as SK_AccountID,
	 CA_ID,SK_BrokerID,SK_CustomerID,Status,CA_NAME, CA_TAX_ST,TRUE,2,BatchDateColumn,'9999-12-31'
	FROM 
	incAtemp5 A,  incAtempSur S
	order by  CA_ID asc;

	

	END;
	$$ LANGUAGE 'plpgsql';

	
	