/*FactCashBalancesLoadInc1 */


DROP FUNCTION IF EXISTS FactCashBalancesLoadInc1();
CREATE FUNCTION FactCashBalancesLoadInc1()
RETURNS VOID AS $$
BEGIN

	DROP TABLE IF EXISTS FCITemp1,FCITemp2;


	CREATE TEMPORARY TABLE FCITemp1 AS
	SELECT CT_CA_ID, CT_DTS, CT_AMT, CT_NAME, SK_CustomerID, SK_AccountID
	FROM CashTransaction1 C, DimAccount D 
	WHERE
	D.Iscurrent = TRUE AND
	C.CT_CA_ID::int = D.AccountID; --AND 
	--CT_DTS >= EffectiveDate AND
	--CT_DTS < EndDate


	---SK_DateID
	CREATE TEMPORARY TABLE FCITemp2 AS
	SELECT CT_CA_ID, CT_DTS, CT_AMT, CT_NAME, SK_CustomerID, SK_AccountID, SK_DateID
	FROM FCITemp1 C,DimDate D WHERE
	C.CT_DTS= D.DateValue;

	--SELECT * FROM FCTemp2 ORDER BY CT_CA_ID LIMIT 1000;

	INSERT INTO FactCashBalances(SK_CustomerID, SK_AccountID, SK_DateID, Cash, BatchID)
	SELECT SK_CustomerID, SK_AccountID,SK_DateID,CT_AMT,2
	FROM
	FCITemp2 ORDER BY SK_CustomerID, SK_AccountID, SK_DateID;


END;
$$ LANGUAGE 'plpgsql';
 