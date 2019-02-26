/*DimTrade Load Inc1*/


DROP FUNCTION IF EXISTS DimTradeLoadInc1();
CREATE FUNCTION DimTradeLoadInc1()
RETURNS VOID AS $$
BEGIN

	DROP TABLE IF EXISTS  TemptrI1, TemptrI2, TemptrI3, TemptrI4, TemptrI5, TemptrI6, TemptrI7,
	 TemptrI8, TemptrI9;

	--delete from dimtrade where tradeid is not null
	UPDATE Trade1 
	SET 
	T_TRADE_PRICE=NULL,
	T_CHRG=NULL,
	T_COMM=NULL,
	T_TAX=NULL
	WHERE 
	T_TRADE_PRICE = '' OR
	T_CHRG='' OR
	T_COMM='' OR
	T_TAX='';


		--status
	CREATE TEMPORARY TABLE TemptrI1 AS
	SELECT CDC_FLAG, CDC_DSN, T_ID, T_DTS, T_ST_ID, T_TT_ID, T_IS_CASH, T_S_SYMB, T_QTY, T_BID_PRICE,
		T_CA_ID, T_EXEC_NAME, T_TRADE_PRICE, T_CHRG, T_COMM, T_TAX, S.ST_NAME AS Status
	FROM Trade1 C, StatusType S
	WHERE C.T_ST_ID = S.ST_ID;

	--type
	CREATE TEMPORARY TABLE TemptrI2 AS
	SELECT CDC_FLAG, CDC_DSN, T_ID, T_DTS, T_ST_ID, T_TT_ID, T_IS_CASH, T_S_SYMB, T_QTY, T_BID_PRICE,
		T_CA_ID, T_EXEC_NAME, T_TRADE_PRICE, T_CHRG, T_COMM, T_TAX,Status,TT_NAME AS Type
	FROM TemptrI1 C, TradeType S
	WHERE C.T_TT_ID = S.TT_ID;


	--SK_SecurityID, SK_CompanyID
	CREATE TEMPORARY TABLE TemptrI3 AS
	SELECT CDC_FLAG, CDC_DSN, T_ID, T_DTS, T_ST_ID, T_TT_ID, T_IS_CASH, T_S_SYMB, T_QTY, T_BID_PRICE,
		T_CA_ID, T_EXEC_NAME, T_TRADE_PRICE, T_CHRG, T_COMM, T_TAX, C.Status, Type,
		S.SK_SecurityID,S.SK_CompanyID
	FROM TemptrI2 C , DimSecurity S WHERE
	--S.Status='Active' AND
	--S.IsCurrent=TRUE AND
	C.T_S_SYMB = S.Symbol AND 
	T_DTS >= EffectiveDate AND
	T_DTS <= EndDate; 


	--SK_AccountID, SK_CustomerID, SK_BrokerID
	CREATE TEMPORARY TABLE TemptrI4 AS
	SELECT CDC_FLAG, CDC_DSN, T_ID, T_DTS, T_ST_ID, T_TT_ID, T_IS_CASH, T_S_SYMB, T_QTY, T_BID_PRICE,
		T_CA_ID, T_EXEC_NAME, T_TRADE_PRICE, T_CHRG, T_COMM, T_TAX,C.Status,Type,
		SK_SecurityID,SK_CompanyID, S.SK_AccountID, S.SK_CustomerID, S.SK_BrokerID
	FROM TemptrI3 C , DimAccount S 
	WHERE 
	--S.IsCurrent=TRUE AND
	C.T_CA_ID = S.AccountID AND
	T_DTS >= EffectiveDate AND
	T_DTS <= EndDate ;



	--SK_CreatedDateID
	CREATE TEMPORARY TABLE TemptrI5 AS
	SELECT CDC_FLAG, CDC_DSN, T_ID, T_DTS, T_ST_ID, T_TT_ID, T_IS_CASH, T_S_SYMB, T_QTY, T_BID_PRICE,
	T_CA_ID, T_EXEC_NAME, T_TRADE_PRICE, T_CHRG, T_COMM, T_TAX,C.Status,Type,
	SK_SecurityID,SK_CompanyID, SK_AccountID, SK_CustomerID, SK_BrokerID,
	SK_DateID AS 	SK_CreateDateID
	FROM TemptrI4 C , DimDate S 
	WHERE 
	date_trunc('day', C.T_DTS) = S.DateValue;


	-- SK_CreatedTimeID
	CREATE TEMPORARY TABLE TemptrI6 AS
	SELECT CDC_FLAG, CDC_DSN, T_ID, T_DTS, T_ST_ID, T_TT_ID, T_IS_CASH, T_S_SYMB, T_QTY, T_BID_PRICE,
	T_CA_ID, T_EXEC_NAME, T_TRADE_PRICE, T_CHRG, T_COMM, T_TAX,C.Status,Type,
	SK_SecurityID,SK_CompanyID, SK_AccountID, SK_CustomerID, SK_BrokerID, SK_CreateDateID,
	SK_TimeID AS 	SK_CreateTimeID
	FROM TemptrI5 C , DimTime S 
	WHERE 
	date_trunc('second', C.T_DTS::TIME) = S.TimeValue;


	--'I'
	CREATE TEMPORARY TABLE TemptrI7 AS
	SELECT CDC_FLAG, CDC_DSN, T_ID, T_DTS, T_ST_ID, T_TT_ID, T_IS_CASH, T_S_SYMB, T_QTY, T_BID_PRICE,
	T_CA_ID, T_EXEC_NAME, T_TRADE_PRICE, T_CHRG, T_COMM, T_TAX,Status,Type,
	SK_SecurityID,SK_CompanyID, SK_AccountID, SK_CustomerID, SK_BrokerID, 
	SK_CreateDateID, SK_CreateTimeID
	FROM TemptrI6 
	WHERE CDC_FLAG='I';

	--select * from TemptrI7 where T_ID=650520

	INSERT INTO Dimtrade(TradeID, SK_BrokerID, SK_CreateDateID, SK_CreateTimeID, SK_CloseDateID, SK_CloseTimeID,
	 Status, DT_Type, CashFlag, SK_SecurityID, SK_CompanyID, Quantity, BidPrice, SK_CustomerID,
	 SK_AccountID , ExecutedBy, TradePrice, Fee, Commission, Tax, BatchID)
	SELECT T_ID, SK_BrokerID, SK_CreateDateID, SK_CreateTimeID, NULL, NULL,
	 Status, Type, T_IS_CASH, SK_SecurityID, SK_CompanyID, T_QTY, T_BID_PRICE, SK_CustomerID,
	  SK_AccountID, T_EXEC_NAME, T_TRADE_PRICE::NUMERIC, T_CHRG::NUMERIC, T_COMM::NUMERIC, 
	  T_TAX::NUMERIC, 2
	FROM
	TemptrI7;

	INSERT INTO DImessages(MessageDateAndTime, BatchID, MessageSource, MessageText, MessageType,MessageData)
	SELECT CURRENT_TIMESTAMP, 2, 'DimTrade', 'Invalid trade commission', 'Alert',
	CONCAT('T_ID = ',T_ID, ', T_COMM = ',T_COMM::NUMERIC)
	FROM
	TemptrI7 where
	T_COMM IS NOT NULL AND
	 T_COMM::NUMERIC >(T_TRADE_PRICE::NUMERIC * T_QTY);


	INSERT INTO DImessages(MessageDateAndTime, BatchID, MessageSource, MessageText, MessageType,MessageData)
	SELECT CURRENT_TIMESTAMP,2, 'DimTrade', 'Invalid trade fee', 'Alert',
	CONCAT('T_ID = ',T_ID, ', T_CHRG = ',T_CHRG)
	FROM
	TemptrI7 where
	  T_CHRG IS NOT NULL AND
	  T_CHRG::NUMERIC >(T_TRADE_PRICE::NUMERIC * T_QTY);





	--select * from dimtrade  where Tradeid=650520

	--select * from TemptrI6  where T_ID= 650520  
	--select * from TemptrI6  where T_ID= 619261  
	--'U'
	CREATE TEMPORARY TABLE TemptrI8 AS
	SELECT CDC_FLAG, CDC_DSN, T_ID, T_DTS, T_ST_ID, T_TT_ID, T_IS_CASH, T_S_SYMB, T_QTY, T_BID_PRICE,
	T_CA_ID, T_EXEC_NAME, T_TRADE_PRICE, T_CHRG, T_COMM, T_TAX,Status,Type,
	SK_SecurityID,SK_CompanyID, SK_AccountID, SK_CustomerID, SK_BrokerID, 
	SK_CreateDateID, SK_CreateTimeID
	FROM TemptrI6 
	WHERE CDC_FLAG='U' and (T_ST_ID='CMPT' OR T_ST_ID='CNCL');


	--select count(*), T_S_SYMB,T_ID from TemptrI8 group by T_S_SYMB,T_ID having count(*) >1
	--SELECT SK_CreateDateID FROM TemptrI8 WHERE TemptrI8.T_ID=1301054
	--select * from dimtrade where tradeid = 1301054
	--select * from TemptrI7 where T_ID = 1301054
	--SELECT DimTrade.TradeID FROM TemptrI8, DimTrade WHERE TemptrI8.T_ID=DimTrade.TradeID ORDER BY TradeID


	UPDATE DimTrade
	SET
	SK_CloseDateID=(SELECT DISTINCT SK_CreateDateID FROM TemptrI8 WHERE TemptrI8.T_ID=DimTrade.TradeID ), 
	SK_CloseTimeID=(SELECT DISTINCT SK_CreateTimeID FROM TemptrI8 WHERE TemptrI8.T_ID=DimTrade.TradeID),
	Status=(SELECT DISTINCT Status FROM TemptrI8 WHERE TemptrI8.T_ID=DimTrade.TradeID ),
	BatchID=2
	WHERE EXISTS 
	(SELECT SK_CreateDateID FROM TemptrI8 WHERE TemptrI8.T_ID=DimTrade.TradeID );

	--FOR RECORDS WITH MORE THAN ONE 'U'
	CREATE TEMPORARY TABLE TemptrI9 AS
	SELECT DISTINCT ON (T_ID)
	CDC_FLAG, CDC_DSN, T_ID, T_DTS, T_ST_ID, T_TT_ID, T_IS_CASH, T_S_SYMB, T_QTY, T_BID_PRICE,
		T_CA_ID, T_EXEC_NAME, T_TRADE_PRICE, T_CHRG, T_COMM, T_TAX,Status,Type,
		SK_SecurityID,SK_CompanyID, SK_AccountID, SK_CustomerID, SK_BrokerID, 
		SK_CreateDateID, SK_CreateTimeID
	FROM TemptrI8
	ORDER  BY T_ID;


--SELECT TemptrI8.T_ID FROM TemptrI8,DimTrade WHERE TemptrI8.T_ID=DimTrade.TradeID and dimtrade.batchid=2

--Delete 'U' records in DimTrade
/*DELETE FROM Dimtrade
USING TemptrI8
WHERE Dimtrade.TradeID = TemptrI8.T_ID;

--FOR RECORDS WITH MORE THAN ONE 'U'
CREATE TEMPORARY TABLE TemptrI9 AS
SELECT DISTINCT ON (T_ID)
CDC_FLAG, CDC_DSN, T_ID, T_DTS, T_ST_ID, T_TT_ID, T_IS_CASH, T_S_SYMB, T_QTY, T_BID_PRICE,
	T_CA_ID, T_EXEC_NAME, T_TRADE_PRICE, T_CHRG, T_COMM, T_TAX,Status,Type,
	SK_SecurityID,SK_CompanyID, SK_AccountID, SK_CustomerID, SK_BrokerID, 
	SK_CreateDateID, SK_CreateTimeID
FROM TemptrI8
ORDER  BY T_ID;
 

INSERT INTO Dimtrade(TradeID, SK_BrokerID, SK_CreateDateID, SK_CreateTimeID, SK_CloseDateID, SK_CloseTimeID,
 Status, DT_Type, CashFlag, SK_SecurityID, SK_CompanyID, Quantity, BidPrice, SK_CustomerID,
 SK_AccountID , ExecutedBy, TradePrice, Fee, Commission, Tax, BatchID)
SELECT T_ID, SK_BrokerID, SK_CreateDateID, SK_CreateTimeID, NULL, NULL,
 Status, Type, T_IS_CASH, SK_SecurityID, SK_CompanyID, T_QTY, T_BID_PRICE, SK_CustomerID,
  SK_AccountID, T_EXEC_NAME, T_TRADE_PRICE::NUMERIC, T_CHRG::NUMERIC, T_COMM::NUMERIC, 
  T_TAX::NUMERIC, 2
FROM
TemptrI9;
*/




	INSERT INTO DImessages(MessageDateAndTime, BatchID, MessageSource, MessageText, MessageType,MessageData)
	SELECT CURRENT_TIMESTAMP, 2, 'DimTrade', 'Invalid trade commission', 'Alert',
	CONCAT('T_ID = ',T_ID, ', T_COMM = ',T_COMM)
	FROM
	TemptrI9 where
	T_COMM IS NOT NULL AND
	 T_COMM::NUMERIC >(T_TRADE_PRICE::NUMERIC * T_QTY);


	INSERT INTO DImessages(MessageDateAndTime, BatchID, MessageSource, MessageText, MessageType,MessageData)
	SELECT CURRENT_TIMESTAMP, 2, 'DimTrade', 'Invalid trade fee', 'Alert',
	CONCAT('T_ID = ',T_ID, ', T_CHRG = ',T_CHRG)
	FROM
	TemptrI9 where
	  T_CHRG IS NOT NULL AND
	  T_CHRG::NUMERIC >(T_TRADE_PRICE::NUMERIC * T_QTY);


	END;
	$$ LANGUAGE 'plpgsql';

	--Select * from Trade1