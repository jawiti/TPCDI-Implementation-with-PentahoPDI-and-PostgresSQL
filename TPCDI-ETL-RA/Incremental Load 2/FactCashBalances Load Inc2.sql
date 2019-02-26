/*FactCashBalancesLoadInc1 */


DROP FUNCTION IF EXISTS FactCashBalancesLoadInc2();
CREATE FUNCTION FactCashBalancesLoadInc2()
RETURNS VOID AS $$
BEGIN

	DROP TABLE IF EXISTS FCI2Temp1,FCI2Temp2;


	CREATE TEMPORARY TABLE FCI2Temp1 AS
	SELECT CT_CA_ID, CT_DTS, CT_AMT, CT_NAME, SK_CustomerID, SK_AccountID
	FROM CashTransaction2 C, DimAccount D 
	WHERE
	D.Iscurrent = TRUE AND
	C.CT_CA_ID::int = D.AccountID; --AND 
	--CT_DTS >= EffectiveDate AND
	--CT_DTS < EndDate


	---SK_DateID
	CREATE TEMPORARY TABLE FCI2Temp2 AS
	SELECT CT_CA_ID, CT_DTS, CT_AMT, CT_NAME, SK_CustomerID, SK_AccountID, SK_DateID
	FROM FCI2Temp1 C,DimDate D WHERE
	C.CT_DTS= D.DateValue;

	--SELECT * FROM FCTemp2 ORDER BY CT_CA_ID LIMIT 1000;

	INSERT INTO FactCashBalances(SK_CustomerID, SK_AccountID, SK_DateID, Cash, BatchID)
	SELECT SK_CustomerID, SK_AccountID,SK_DateID,CT_AMT,3
	FROM
	FCI2Temp2 ORDER BY SK_CustomerID, SK_AccountID, SK_DateID;


END;
$$ LANGUAGE 'plpgsql';
 