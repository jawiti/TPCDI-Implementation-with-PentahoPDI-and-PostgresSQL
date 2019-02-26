/* FactholdingsLoadInc1 */

DROP FUNCTION IF EXISTS FactholdingsLoadInc2();
CREATE FUNCTION FactholdingsLoadInc2()
RETURNS VOID AS $$
BEGIN

	DROP TABLE IF EXISTS FHI2Temp1;



	CREATE TEMPORARY TABLE FHI2Temp1 AS
	SELECT HH_H_T_ID, HH_T_ID, HH_BEFORE_QTY, HH_AFTER_QTY,
	SK_CustomerID,  SK_AccountID, SK_SecurityID, SK_CompanyID, SK_CloseDateID, SK_CloseTimeID,TradePrice
	FROM holdinghistory2 H, DimTrade D
	WHERE H.HH_T_ID = D.TradeID;



	INSERT INTO Factholdings(TradeID, CurrentTradeID, SK_CustomerID, SK_AccountID, 
	SK_SecurityID, SK_CompanyID, SK_DateID, SK_TimeID, CurrentPrice, CurrentHolding, BatchID)
	SELECT HH_H_T_ID, HH_T_ID, SK_CustomerID,  SK_AccountID, SK_SecurityID, SK_CompanyID, 
	SK_CloseDateID, SK_CloseTimeID, TradePrice, HH_AFTER_QTY,3
	FROM
	FHI2Temp1
	;


END;
$$ LANGUAGE 'plpgsql';
 --SELECT * FROM Factholdings;
