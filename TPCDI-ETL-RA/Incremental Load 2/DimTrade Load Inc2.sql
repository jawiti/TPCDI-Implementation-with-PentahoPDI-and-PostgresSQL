/*DimTrade Load Inc1*/


DROP FUNCTION IF EXISTS DimTradeLoadInc2();
CREATE FUNCTION DimTradeLoadInc2()
RETURNS VOID AS $$
BEGIN

	DROP TABLE IF EXISTS  Temptr2I1, Temptr2I2, Temptr2I3, Temptr2I4, Temptr2I5, Temptr2I6, Temptr2I7,
	 Temptr2I8, Temptr2I9;

	UPDATE Trade2 
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
	CREATE TEMPORARY TABLE Temptr2I1 AS
	SELECT CDC_FLAG, CDC_DSN, T_ID, T_DTS, T_ST_ID, T_TT_ID, T_IS_CASH, T_S_SYMB, T_QTY, T_BID_PRICE,
		T_CA_ID, T_EXEC_NAME, T_TRADE_PRICE, T_CHRG, T_COMM, T_TAX, S.ST_NAME AS Status
	FROM Trade2 C, StatusType S
	WHERE C.T_ST_ID = S.ST_ID;

	--type
	CREATE TEMPORARY TABLE Temptr2I2 AS
	SELECT CDC_FLAG, CDC_DSN, T_ID, T_DTS, T_ST_ID, T_TT_ID, T_IS_CASH, T_S_SYMB, T_QTY, T_BID_PRICE,
		T_CA_ID, T_EXEC_NAME, T_TRADE_PRICE, T_CHRG, T_COMM, T_TAX,Status,TT_NAME AS Type
	FROM Temptr2I1 C, TradeType S
	WHERE C.T_TT_ID = S.TT_ID;


	--SK_SecurityID, SK_CompanyID
	CREATE TEMPORARY TABLE Temptr2I3 AS
	SELECT CDC_FLAG, CDC_DSN, T_ID, T_DTS, T_ST_ID, T_TT_ID, T_IS_CASH, T_S_SYMB, T_QTY, T_BID_PRICE,
		T_CA_ID, T_EXEC_NAME, T_TRADE_PRICE, T_CHRG, T_COMM, T_TAX, C.Status, Type,
		S.SK_SecurityID,S.SK_CompanyID
	FROM Temptr2I2 C , DimSecurity S WHERE
	--S.Status='Active' AND
	S.IsCurrent=TRUE AND
	C.T_S_SYMB = S.Symbol;-- AND 
	--TH_DTS >= EffectiveDate AND
	--TH_DTS <= EndDate; 


	--SK_AccountID, SK_CustomerID, SK_BrokerID
	CREATE TEMPORARY TABLE Temptr2I4 AS
	SELECT CDC_FLAG, CDC_DSN, T_ID, T_DTS, T_ST_ID, T_TT_ID, T_IS_CASH, T_S_SYMB, T_QTY, T_BID_PRICE,
		T_CA_ID, T_EXEC_NAME, T_TRADE_PRICE, T_CHRG, T_COMM, T_TAX,C.Status,Type,
		SK_SecurityID,SK_CompanyID, S.SK_AccountID, S.SK_CustomerID, S.SK_BrokerID
	FROM Temptr2I3 C , DimAccount S 
	WHERE 
	S.IsCurrent=TRUE AND
	C.T_CA_ID = S.AccountID;-- AND
	--TH_DTS >= EffectiveDate AND
	--TH_DTS <= EndDate ;



	--SK_CreatedDateID
	CREATE TEMPORARY TABLE Temptr2I5 AS
	SELECT CDC_FLAG, CDC_DSN, T_ID, T_DTS, T_ST_ID, T_TT_ID, T_IS_CASH, T_S_SYMB, T_QTY, T_BID_PRICE,
		T_CA_ID, T_EXEC_NAME, T_TRADE_PRICE, T_CHRG, T_COMM, T_TAX,C.Status,Type,
		SK_SecurityID,SK_CompanyID, SK_AccountID, SK_CustomerID, SK_BrokerID,
		SK_DateID AS 	SK_CreateDateID
	FROM Temptr2I4 C , DimDate S 
	WHERE 
	date_trunc('day', C.T_DTS) = S.DateValue;


	-- SK_CreatedTimeID
	CREATE TEMPORARY TABLE Temptr2I6 AS
	SELECT CDC_FLAG, CDC_DSN, T_ID, T_DTS, T_ST_ID, T_TT_ID, T_IS_CASH, T_S_SYMB, T_QTY, T_BID_PRICE,
		T_CA_ID, T_EXEC_NAME, T_TRADE_PRICE, T_CHRG, T_COMM, T_TAX,C.Status,Type,
		SK_SecurityID,SK_CompanyID, SK_AccountID, SK_CustomerID, SK_BrokerID, SK_CreateDateID,
		SK_TimeID AS 	SK_CreateTimeID
	FROM Temptr2I5 C , DimTime S 
	WHERE 
	date_trunc('second', C.T_DTS::TIME) = S.TimeValue;


	--'I'
	CREATE TEMPORARY TABLE Temptr2I7 AS
	SELECT CDC_FLAG, CDC_DSN, T_ID, T_DTS, T_ST_ID, T_TT_ID, T_IS_CASH, T_S_SYMB, T_QTY, T_BID_PRICE,
		T_CA_ID, T_EXEC_NAME, T_TRADE_PRICE, T_CHRG, T_COMM, T_TAX,Status,Type,
		SK_SecurityID,SK_CompanyID, SK_AccountID, SK_CustomerID, SK_BrokerID, 
		SK_CreateDateID, SK_CreateTimeID
	FROM Temptr2I6 
	WHERE CDC_FLAG='I';



	INSERT INTO Dimtrade(TradeID, SK_BrokerID, SK_CreateDateID, SK_CreateTimeID, SK_CloseDateID, SK_CloseTimeID,
	 Status, DT_Type, CashFlag, SK_SecurityID, SK_CompanyID, Quantity, BidPrice, SK_CustomerID,
	 SK_AccountID , ExecutedBy, TradePrice, Fee, Commission, Tax, BatchID)
	SELECT T_ID, SK_BrokerID, SK_CreateDateID, SK_CreateTimeID, NULL, NULL,
	 Status, Type, T_IS_CASH, SK_SecurityID, SK_CompanyID, T_QTY, T_BID_PRICE, SK_CustomerID,
	  SK_AccountID, T_EXEC_NAME, T_TRADE_PRICE::NUMERIC, T_CHRG::NUMERIC, T_COMM::NUMERIC, 
	  T_TAX::NUMERIC, 3
	FROM
	Temptr2I7;

	INSERT INTO DImessages(MessageDateAndTime, BatchID, MessageSource, MessageText, MessageType,MessageData)
	SELECT CURRENT_TIMESTAMP, 3, 'DimTrade', 'Invalid trade commission', 'Alert',
	CONCAT('T_ID = ',T_ID, ', T_COMM = ',T_COMM::NUMERIC)
	FROM
	Temptr2I7 where
	T_COMM IS NOT NULL AND
	 T_COMM::NUMERIC >(T_TRADE_PRICE::NUMERIC * T_QTY);


	INSERT INTO DImessages(MessageDateAndTime, BatchID, MessageSource, MessageText, MessageType,MessageData)
	SELECT CURRENT_TIMESTAMP, 3, 'DimTrade', 'Invalid trade fee', 'Alert',
	CONCAT('T_ID = ',T_ID, ', T_CHRG = ',T_CHRG)
	FROM
	Temptr2I7 where
	  T_CHRG IS NOT NULL AND
	  T_CHRG::NUMERIC >(T_TRADE_PRICE::NUMERIC * T_QTY);









	--'U'
	CREATE TEMPORARY TABLE Temptr2I8 AS
	SELECT CDC_FLAG, CDC_DSN, T_ID, T_DTS, T_ST_ID, T_TT_ID, T_IS_CASH, T_S_SYMB, T_QTY, T_BID_PRICE,
	T_CA_ID, T_EXEC_NAME, T_TRADE_PRICE, T_CHRG, T_COMM, T_TAX,Status,Type,
	SK_SecurityID,SK_CompanyID, SK_AccountID, SK_CustomerID, SK_BrokerID, 
	SK_CreateDateID, SK_CreateTimeID
	FROM Temptr2I6 
	WHERE CDC_FLAG='U' and (T_ST_ID='CMPT' OR T_ST_ID='CNCL');

	UPDATE DimTrade
	SET
	SK_CloseDateID=(SELECT SK_CreateDateID FROM Temptr2I8 WHERE Temptr2I8.T_ID=DimTrade.TradeID ), 
	SK_CloseTimeID=(SELECT SK_CreateTimeID FROM Temptr2I8 WHERE Temptr2I8.T_ID=DimTrade.TradeID),
	Status=(SELECT Status FROM Temptr2I8 WHERE Temptr2I8.T_ID=DimTrade.TradeID ),
	BatchID=3
	WHERE EXISTS 
	(SELECT SK_CreateDateID FROM Temptr2I8 WHERE Temptr2I8.T_ID=DimTrade.TradeID );


	--FOR RECORDS WITH MORE THAN ONE 'U'
	CREATE TEMPORARY TABLE Temptr2I9 AS
	SELECT DISTINCT ON (T_ID)
	CDC_FLAG, CDC_DSN, T_ID, T_DTS, T_ST_ID, T_TT_ID, T_IS_CASH, T_S_SYMB, T_QTY, T_BID_PRICE,
	T_CA_ID, T_EXEC_NAME, T_TRADE_PRICE, T_CHRG, T_COMM, T_TAX,Status,Type,
	SK_SecurityID,SK_CompanyID, SK_AccountID, SK_CustomerID, SK_BrokerID, 
	SK_CreateDateID, SK_CreateTimeID
	FROM Temptr2I8
	ORDER  BY T_ID;


	--Delete 'U' records in DimTrade
	/*DELETE FROM Dimtrade
	USING Temptr2I8
	WHERE Dimtrade.TradeID = Temptr2I8.T_ID;

	--FOR RECORDS WITH MORE THAN ONE 'U'
	CREATE TEMPORARY TABLE Temptr2I9 AS
	SELECT DISTINCT ON (T_ID)
	CDC_FLAG, CDC_DSN, T_ID, T_DTS, T_ST_ID, T_TT_ID, T_IS_CASH, T_S_SYMB, T_QTY, T_BID_PRICE,
		T_CA_ID, T_EXEC_NAME, T_TRADE_PRICE, T_CHRG, T_COMM, T_TAX,Status,Type,
		SK_SecurityID,SK_CompanyID, SK_AccountID, SK_CustomerID, SK_BrokerID, 
		SK_CreateDateID, SK_CreateTimeID
	FROM Temptr2I8
	ORDER  BY T_ID;
 

	INSERT INTO Dimtrade(TradeID, SK_BrokerID, SK_CreateDateID, SK_CreateTimeID, SK_CloseDateID, SK_CloseTimeID,
	 Status, DT_Type, CashFlag, SK_SecurityID, SK_CompanyID, Quantity, BidPrice, SK_CustomerID,
	 SK_AccountID , ExecutedBy, TradePrice, Fee, Commission, Tax, BatchID)
	SELECT T_ID, SK_BrokerID, SK_CreateDateID, SK_CreateTimeID, NULL, NULL,
	 Status, Type, T_IS_CASH, SK_SecurityID, SK_CompanyID, T_QTY, T_BID_PRICE, SK_CustomerID,
	  SK_AccountID, T_EXEC_NAME, T_TRADE_PRICE::NUMERIC, T_CHRG::NUMERIC, T_COMM::NUMERIC, 
	  T_TAX::NUMERIC, 3
	FROM
	Temptr2I9;
	*/
	INSERT INTO DImessages(MessageDateAndTime, BatchID, MessageSource, MessageText, MessageType,MessageData)
	SELECT CURRENT_TIMESTAMP, 3, 'DimTrade', 'Invalid trade commission', 'Alert',
	CONCAT('T_ID = ',T_ID, ', T_COMM = ',T_COMM)
	FROM
	Temptr2I9 where
	T_COMM IS NOT NULL AND
	 T_COMM::NUMERIC >(T_TRADE_PRICE::NUMERIC * T_QTY);


	INSERT INTO DImessages(MessageDateAndTime, BatchID, MessageSource, MessageText, MessageType,MessageData)
	SELECT CURRENT_TIMESTAMP, 3, 'DimTrade', 'Invalid trade fee', 'Alert',
	CONCAT('T_ID = ',T_ID, ', T_CHRG = ',T_CHRG)
	FROM
	Temptr2I9 where
	  T_CHRG IS NOT NULL AND
	  T_CHRG::NUMERIC >(T_TRADE_PRICE::NUMERIC * T_QTY);


	END;
	$$ LANGUAGE 'plpgsql';

	--Select * from Trade1