/*DimTrade Load*/
--DROP FUNCTION IF EXISTS DimTradeLoad();
--CREATE FUNCTION DimTradeLoad()
--RETURNS VOID AS $$
--BEGIN

	DROP TABLE IF EXISTS T, temptrade,temptradehistory, Tempalltrade,Tempalltradenew,Tempalltradeupdate,
	 Temptr1, Temptr2, Temptr3, NewT,TT,temptradehistoryNEW, Temptr5A,Temptr5B,Temptr5C,Temptr5D, TJoined,
	Temptr4, Temptr5, Temptr6,Temptr7;


	CREATE TEMPORARY TABLE temptrade(
	--CDC_FLAG CHAR(1),
	--CDC_DSN NUMERIC(12) NOT NULL,
	T_ID NUMERIC(15) NOT NULL,
	T_DTS DATE NOT NULL,
	T_ST_ID CHAR(4) Not Null ,
	T_TT_ID CHAR(3) Not Null ,
	T_IS_CASH BOOLEAN ,
	T_S_SYMB CHAR(15) NOT NULL,
	T_QTY NUMERIC(6),
	T_BID_PRICE NUMERIC(8,2),
	T_CA_ID  INT Not Null ,
	T_EXEC_NAME CHAR(49) Not Null,
	T_TRADE_PRICE  numeric(8,2) Null,
	T_CHRG  numeric(10,2) Null,
	T_COMM numeric(10,2) Null ,
	T_TAX numeric(10,2) Null
	);
	
COPY temptrade FROM 'D:\TPC-DI_Staging_Area\data\Batch1\trade.txt' 
	( FORMAT text, ENCODING 'UTF8', DELIMITER '|', NULL '' );

CREATE TEMPORARY TABLE temptradehistory(
	TH_ID NUMERIC(15) NOT NULL,
	TH_DTS TIMESTAMP  NOT NULL,
	TH_ST_ID CHAR(4) Not Null
	);
	
COPY temptradehistory FROM 'D:\TPC-DI_Staging_Area\data\Batch1\tradehistory.txt' 
	( FORMAT text, ENCODING 'UTF8', DELIMITER '|' );


--
CREATE TEMPORARY TABLE T AS 
SELECT T_ID, T_DTS, T_ST_ID, T_TT_ID, T_IS_CASH, T_S_SYMB, T_QTY, T_BID_PRICE, T_CA_ID,T_EXEC_NAME,
T_TRADE_PRICE, T_CHRG, T_COMM, T_TAX,TH_ID, TH_DTS, TH_ST_ID
 FROM temptrade T,temptradehistory H
WHERE T.T_ID =H.TH_ID;

CREATE TEMPORARY TABLE TT AS 
SELECT T_ID, T_DTS, T_ST_ID, T_TT_ID, T_IS_CASH, T_S_SYMB, T_QTY, T_BID_PRICE, T_CA_ID,T_EXEC_NAME,
T_TRADE_PRICE, T_CHRG, T_COMM, T_TAX,TH_ID, TH_DTS, TH_ST_ID,
 ROW_NUMBER () OVER (PARTITION BY TH_ID ORDER BY TH_ID) AS Seq
 FROM T;

--FOR NEW ONLY
CREATE TEMPORARY TABLE Tempalltrade AS 
SELECT T_ID, T_DTS, T_ST_ID, T_TT_ID, T_IS_CASH, T_S_SYMB, T_QTY, T_BID_PRICE, T_CA_ID,T_EXEC_NAME,
T_TRADE_PRICE, T_CHRG, T_COMM, T_TAX,TH_ID, TH_DTS, TH_ST_ID,Seq
FROM TT WHERE Seq=1;

--FOR OLD
CREATE TEMPORARY TABLE Tempalltradeupdate AS 
SELECT T_ID, T_DTS, T_ST_ID, T_TT_ID, T_IS_CASH, T_S_SYMB, T_QTY, T_BID_PRICE, T_CA_ID,T_EXEC_NAME,
T_TRADE_PRICE, T_CHRG, T_COMM, T_TAX,TH_ID, TH_DTS, TH_ST_ID,Seq
FROM TT WHERE Seq>1 LIMIT 100;




/*

CREATE TEMPORARY TABLE TT AS 
SELECT TH_ID, TH_DTS, TH_ST_ID,
 ROW_NUMBER () OVER (PARTITION BY TH_ID ORDER BY TH_ID) AS Seq
 FROM temptradehistory;

 
--This table selects only the most recent tradehistory to avoid duplicates in Tempalltrade
CREATE TEMPORARY TABLE temptradehistoryNEW AS 
SELECT DISTINCT ON (TH_ID)
       TH_ID, TH_DTS, TH_ST_ID,Seq
FROM   TT
ORDER  BY TH_ID, TH_DTS DESC;


CREATE TEMPORARY TABLE Tempalltrade AS 
SELECT T_ID, T_DTS, T_ST_ID, T_TT_ID, T_IS_CASH, T_S_SYMB, T_QTY, T_BID_PRICE, T_CA_ID,T_EXEC_NAME,
T_TRADE_PRICE, T_CHRG, T_COMM, T_TAX,TH_ID, TH_DTS, TH_ST_ID
 FROM temptrade T,temptradehistoryNEW H
WHERE T.T_ID =H.TH_ID;
*/


/*
 
CREATE TEMPORARY TABLE Tempalltradenew AS 
SELECT T_ID, T_DTS, T_ST_ID, T_TT_ID, T_IS_CASH, T_S_SYMB, T_QTY, T_BID_PRICE, T_CA_ID,T_EXEC_NAME,
T_TRADE_PRICE, T_CHRG, T_COMM, T_TAX,TH_ID, TH_DTS, TH_ST_ID,Seq
FROM Tempalltrade WHERE Seq=1;

CREATE TEMPORARY TABLE Tempalltradeupdate AS 
SELECT T_ID, T_DTS, T_ST_ID, T_TT_ID, T_IS_CASH, T_S_SYMB, T_QTY, T_BID_PRICE, T_CA_ID,T_EXEC_NAME,
T_TRADE_PRICE, T_CHRG, T_COMM, T_TAX,TH_ID, TH_DTS, TH_ST_ID,Seq
FROM Tempalltrade WHERE Seq>1;
*/

ALTER TABLE Tempalltrade
--ADD COLUMN SK_CreateDateID NUMERIC(11),
--ADD COLUMN SK_CreateTimeID NUMERIC(11),
--ADD COLUMN SK_CloseDateID NUMERIC(11),
--ADD COLUMN SK_CloseTimeID NUMERIC(11),
ADD COLUMN Status char(10),
ADD COLUMN Type char(12),
ADD COLUMN SK_SecurityID INTEGER,
ADD COLUMN SK_CompanyID INTEGER,
ADD COLUMN  SK_AccountID INTEGER,
ADD COLUMN  SK_CustomerID INTEGER, 
ADD COLUMN  SK_BrokerID INTEGER
;


--status
CREATE TEMPORARY TABLE Temptr2 AS
SELECT T_ID, T_DTS, T_ST_ID, T_TT_ID, T_IS_CASH, T_S_SYMB, T_QTY, T_BID_PRICE, T_CA_ID,T_EXEC_NAME,
T_TRADE_PRICE, T_CHRG, T_COMM, T_TAX, S.ST_NAME AS Status,TH_ID, TH_DTS, TH_ST_ID
FROM Tempalltrade C, StatusType S
WHERE C.T_ST_ID = S.ST_ID;

--type
CREATE TEMPORARY TABLE Temptr3 AS
SELECT T_ID, T_DTS, T_ST_ID, T_TT_ID, T_IS_CASH, T_S_SYMB, T_QTY, T_BID_PRICE, T_CA_ID,T_EXEC_NAME,
T_TRADE_PRICE, T_CHRG, T_COMM, T_TAX, Status,TH_ID, TH_DTS,TH_ST_ID,TT_NAME AS Type
FROM Temptr2 C, TradeType S
WHERE C.T_TT_ID = S.TT_ID;


--SK_SecurityID, SK_CompanyID
CREATE TEMPORARY TABLE Temptr4 AS
SELECT T_ID, T_DTS, T_ST_ID, T_TT_ID, T_IS_CASH, T_S_SYMB, T_QTY, T_BID_PRICE, T_CA_ID,T_EXEC_NAME,
T_TRADE_PRICE, T_CHRG, T_COMM, T_TAX, C.Status,TH_ID, TH_DTS,TH_ST_ID,Type,S.SK_SecurityID,S.SK_CompanyID
FROM Temptr3 C , DimSecurity S WHERE
--S.Status='Active' AND
S.IsCurrent=TRUE AND
C.T_S_SYMB = S.Symbol AND 
TH_DTS >= EffectiveDate AND
TH_DTS <= EndDate; 


--SK_AccountID, SK_CustomerID, SK_BrokerID
CREATE TEMPORARY TABLE Temptr5 AS
SELECT T_ID, T_DTS, T_ST_ID, T_TT_ID, T_IS_CASH, T_S_SYMB, T_QTY, T_BID_PRICE, T_CA_ID,T_EXEC_NAME,
T_TRADE_PRICE, T_CHRG, T_COMM, T_TAX, C.Status,TH_ID, TH_DTS,TH_ST_ID,Type,SK_SecurityID,SK_CompanyID,
S.SK_AccountID, S.SK_CustomerID, S.SK_BrokerID
FROM Temptr4 C , DimAccount S 
WHERE 
S.IsCurrent=true and
C.T_CA_ID = S.AccountID AND
TH_DTS >= EffectiveDate AND
TH_DTS <= EndDate ;


ALTER TABLE Temptr5
ADD COLUMN SK_CreateDateID DATE,
ADD COLUMN SK_CreateTimeID TIME,
ADD COLUMN SK_CloseDateID DATE,
ADD COLUMN SK_CloseTimeID TIME;

/*
UPDATE Temptr5 SET
TH_DTS=regexp_replace(TH_DTS, '[-]', '', 'gi');

UPDATE Temptr5 SET
TH_DTS=regexp_replace(TH_DTS, '[:]', '', 'gi');
*/



UPDATE Temptr5
SET 
SK_CreateDateID=date_trunc('day', TH_DTS),
SK_CreateTimeID=date_trunc('second', TH_DTS),
SK_CloseDateID=NULL,
SK_CloseTimeID=NULL
WHERE 
(TH_ST_ID='SBMT'  AND (T_TT_ID='TMB' OR T_TT_ID='TMS')) OR TH_ST_ID = 'PNDG'; 

UPDATE Temptr5 
SET 
SK_CreateDateID=NULL,
SK_CreateTimeID=NULL,
SK_CloseDateID=date_trunc('day', TH_DTS),
SK_CloseTimeID=date_trunc('second', TH_DTS)
WHERE 
TH_ST_ID='CMPT' OR TH_ST_ID='CNCL';


CREATE TEMPORARY TABLE Temptr5A AS
SELECT T_ID, SK_BrokerID, SK_CreateDateID, SK_CreateTimeID, SK_CloseDateID, SK_CloseTimeID,
 Status, Type, T_IS_CASH, SK_SecurityID, SK_CompanyID, T_QTY, T_BID_PRICE, SK_CustomerID,
  SK_AccountID, T_EXEC_NAME, T_TRADE_PRICE, T_CHRG, T_COMM, 
  T_TAX, SK_DateID AS SK_CreateDateIDNEW
  FROM Temptr5 T LEFT OUTER JOIN DimDate D
ON
(T.SK_CreateDateID = D.Datevalue);



CREATE TEMPORARY TABLE Temptr5B AS
SELECT T_ID, SK_BrokerID, SK_CreateDateID, SK_CreateTimeID, SK_CloseDateID, SK_CloseTimeID,
 Status, Type, T_IS_CASH, SK_SecurityID, SK_CompanyID, T_QTY, T_BID_PRICE, SK_CustomerID,
  SK_AccountID, T_EXEC_NAME, T_TRADE_PRICE, T_CHRG, T_COMM, 
  T_TAX, SK_CreateDateIDNEW, SK_TimeID AS SK_CreateTimeIDNEW
  FROM Temptr5A T LEFT OUTER JOIN DimTime D
ON
(T.SK_CreateTimeID = D.Timevalue);


CREATE TEMPORARY TABLE Temptr5C AS
SELECT T_ID, SK_BrokerID, SK_CreateDateID, SK_CreateTimeID, SK_CloseDateID, SK_CloseTimeID,
 Status, Type, T_IS_CASH, SK_SecurityID, SK_CompanyID, T_QTY, T_BID_PRICE, SK_CustomerID,
  SK_AccountID, T_EXEC_NAME, T_TRADE_PRICE, T_CHRG, T_COMM, 
  T_TAX,SK_CreateDateIDNEW, SK_CreateTimeIDNEW, SK_DateID AS SK_CloseDateIDNEW
  FROM Temptr5B T LEFT OUTER JOIN DimDate D
ON
(T.SK_CloseDateID = D.Datevalue);


CREATE TEMPORARY TABLE Temptr5D AS
SELECT T_ID, SK_BrokerID, SK_CreateDateID, SK_CreateTimeID, SK_CloseDateID, SK_CloseTimeID,
 Status, Type, T_IS_CASH, SK_SecurityID, SK_CompanyID, T_QTY, T_BID_PRICE, SK_CustomerID,
  SK_AccountID, T_EXEC_NAME, T_TRADE_PRICE, T_CHRG, T_COMM, 
  T_TAX, SK_CreateDateIDNEW, SK_CreateTimeIDNEW, SK_CloseDateIDNEW, SK_TimeID AS SK_CloseTimeIDNEW
  FROM Temptr5C T LEFT OUTER JOIN DimTime D
ON
(T.SK_CloseTimeID = D.Timevalue);



INSERT INTO Dimtrade(TradeID, SK_BrokerID, SK_CreateDateID, SK_CreateTimeID, SK_CloseDateID, SK_CloseTimeID,
 Status, DT_Type, CashFlag, SK_SecurityID, SK_CompanyID, Quantity, BidPrice, SK_CustomerID,
 SK_AccountID , ExecutedBy, TradePrice, Fee, Commission, Tax, BatchID)
SELECT T_ID, SK_BrokerID, SK_CreateDateIDNEW, SK_CreateTimeIDNEW, SK_CloseDateIDNEW, SK_CloseTimeIDNEW,
 Status, Type, T_IS_CASH, SK_SecurityID, SK_CompanyID, T_QTY, T_BID_PRICE, SK_CustomerID,
  SK_AccountID, T_EXEC_NAME, T_TRADE_PRICE, T_CHRG, T_COMM, 
  T_TAX, 1
FROM
Temptr5D;

--FOR TRADE UPDATE
CREATE TEMPORARY TABLE TJoined AS 
SELECT T_ID, T_DTS, T_ST_ID, T_TT_ID, T_IS_CASH, T_S_SYMB, T_QTY, T_BID_PRICE, T_CA_ID,T_EXEC_NAME,
T_TRADE_PRICE, T_CHRG, T_COMM, T_TAX,TH_ID, TH_DTS, TH_ST_ID,Seq
FROM Tempalltradeupdate , DimTrade 
WHERE T_ID = TradeID;


INSERT INTO DImessages(MessageDateAndTime, BatchID, MessageSource, MessageText, MessageType,MessageData)
	SELECT CURRENT_TIMESTAMP, 1, 'DimTrade', 'Invalid Trade Commision', 'Alert',
	CONCAT('T_ID = ',TradeID, ', T_COMM = ',Commission)
	FROM
	Dimtrade where
	Commission IS NOT NULL AND
	 Commission >(TradePrice * Quantity);


INSERT INTO DImessages(MessageDateAndTime, BatchID, MessageSource, MessageText, MessageType,MessageData)
	SELECT CURRENT_TIMESTAMP, 1, 'DimTrade', 'Invalid Trade Fee', 'Alert',
	CONCAT('T_ID = ',TradeID, ', T_CHRG = ',Fee)
	FROM
	Dimtrade where
	  Fee IS NOT NULL AND
	  Fee >(TradePrice * Quantity);


--END;
--$$ LANGUAGE 'plpgsql';

--SELECT * FROM Dimtrade WHERE SK_CloseDateID=20140711