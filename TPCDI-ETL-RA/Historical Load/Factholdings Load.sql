/*Factholdings Load*/


DROP FUNCTION IF EXISTS FactholdingsLoad();
CREATE FUNCTION FactholdingsLoad()
RETURNS VOID AS $$
BEGIN

DROP TABLE IF EXISTS FHTemp1,FHTemp2;
--DELETE  FROM Factholdings where SK_CustomerID is not null;



	CREATE TEMPORARY TABLE FHTemp1 AS
	SELECT HH_H_T_ID, HH_T_ID, HH_BEFORE_QTY, HH_AFTER_QTY,
	SK_CustomerID,  SK_AccountID, SK_SecurityID, SK_CompanyID, SK_CloseDateID, SK_CloseTimeID,TradePrice
	FROM holdinghistory H, DimTrade D
	WHERE H.HH_T_ID = D.TradeID;
	--AND H.HH_T_ID =95096;



	INSERT INTO Factholdings(TradeID, CurrentTradeID, SK_CustomerID, SK_AccountID, 
	SK_SecurityID, SK_CompanyID, SK_DateID, SK_TimeID, CurrentPrice, CurrentHolding, BatchID)
	SELECT HH_H_T_ID, HH_T_ID, SK_CustomerID,  SK_AccountID, SK_SecurityID, SK_CompanyID, 
	SK_CloseDateID, SK_CloseTimeID, TradePrice, HH_AFTER_QTY,1
	FROM
	FHTemp1
	;
	--SELECT * FROM DIMTRADE WHERE TRADEID=95096

END;
$$ LANGUAGE 'plpgsql';
 --DELETE  FROM Factholdings WHERE TradeID IS NOT NULL;