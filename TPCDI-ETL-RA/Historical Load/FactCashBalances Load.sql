/*FactCashBalances Load*/


DROP FUNCTION IF EXISTS FactCashBalancesLoad();
CREATE FUNCTION FactCashBalancesLoad()
RETURNS VOID AS $$
BEGIN

	DROP TABLE IF EXISTS FCTemp1,FCTemp2;
	DELETE  FROM FactCashBalances where SK_CustomerID is not null;



	CREATE TEMPORARY TABLE FCTemp1 AS
	SELECT CT_CA_ID, CT_DTS, CT_AMT, CT_NAME, SK_CustomerID, SK_AccountID
	FROM CashTransaction C, DimAccount D 
	WHERE
	--D.Iscurrent = TRUE AND
	C.CT_CA_ID::int = D.AccountID AND 
	CT_DTS >= EffectiveDate AND
	CT_DTS < EndDate
	;

	---CONTINUE
	CREATE TEMPORARY TABLE FCTemp2 AS
	SELECT CT_CA_ID, CT_DTS, CT_AMT, CT_NAME, SK_CustomerID, SK_AccountID, SK_DateID
	FROM FCTemp1 C,DimDate D WHERE
	C.CT_DTS= D.DateValue;

	--SELECT * FROM FCTemp2 ORDER BY CT_CA_ID LIMIT 1000;

	INSERT INTO FactCashBalances(SK_CustomerID, SK_AccountID, SK_DateID, Cash, BatchID)
	SELECT SK_CustomerID, SK_AccountID,SK_DateID,CT_AMT,1
	FROM
	FCTemp2 ORDER BY SK_CustomerID, SK_AccountID, SK_DateID;


END;
$$ LANGUAGE 'plpgsql';
 