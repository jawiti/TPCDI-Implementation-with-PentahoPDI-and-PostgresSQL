/* FactholdingsLoadInc1 */

DROP FUNCTION IF EXISTS FactholdingsLoadInc1();
CREATE FUNCTION FactholdingsLoadInc1()
RETURNS VOID AS $$
BEGIN

	DROP TABLE IF EXISTS FHITemp1;


	CREATE TEMPORARY TABLE FHITemp1 AS
	SELECT HH_H_T_ID, HH_T_ID, HH_BEFORE_QTY, HH_AFTER_QTY,
	SK_CustomerID,  SK_AccountID, SK_SecurityID, SK_CompanyID, SK_CloseDateID, SK_CloseTimeID,TradePrice
	FROM holdinghistory1 H, DimTrade D
	WHERE H.HH_T_ID = D.TradeID;

	--delete from Factholdings where batchid = 2;

	INSERT INTO Factholdings(TradeID, CurrentTradeID, SK_CustomerID, SK_AccountID, 
	SK_SecurityID, SK_CompanyID, SK_DateID, SK_TimeID, CurrentPrice, CurrentHolding, BatchID)
	SELECT HH_H_T_ID, HH_T_ID, SK_CustomerID,  SK_AccountID, SK_SecurityID, SK_CompanyID, 
	SK_CloseDateID, SK_CloseTimeID, TradePrice, HH_AFTER_QTY,2
	FROM
	FHITemp1
	;
	--select * from dimtrade where tradeid=650520

END;
$$ LANGUAGE 'plpgsql';
 --SELECT * FROM Factholdings;
