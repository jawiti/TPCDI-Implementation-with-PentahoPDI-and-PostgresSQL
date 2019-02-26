
/*DimAccount History Update Load*/

DROP FUNCTION IF EXISTS DimAccountHistoryUpdateLoad();
CREATE FUNCTION DimAccountHistoryUpdateLoad()
RETURNS VOID AS $$
BEGIN

	DROP TABLE IF EXISTS Atemp2,Atemp3,Atemp4,T2A,T2B,UPtemp2,UPtemp1INACT,UPtemp2INACT,
	Atemp5,Atemp6,Atemp7,Atemp8,Atemp9,Atemp10,Atemp11,Atemp12,CloseAcctJoin,Atemp8C,
	NewOrAddAcct,UpdAcct,CloseAcct,UpdCust,InAct,Atemp8I,INACTJOINAcct,InAct2,InAct3,
	UPD1,UPD2,Atemp8U,T2Anew,ToUpdate,ToUpdate1,
	UPTemp1,UPTemp2,ITemp1,MM;





---------------------------------


	/*FOR UPDACCT*/
	CREATE TEMPORARY TABLE UpdAcct AS	
	SELECT ActionType, AccountID, AccountDesc, TaxStatus, CA_B_ID, C_ID, ActionTS
	FROM Accountall
	WHERE
	ActionType='UPDACCT' order by AccountID,ActionTS;



	

	CREATE TEMPORARY TABLE Atemp6 AS
	SELECT U.ActionType, D.AccountID, U.AccountDesc AS AccountDescNEW, U.TaxStatus,
	U.CA_B_ID, U.C_ID, U.ActionTS,	D.AccountDesc
	FROM UpdAcct U,DimAccount D
	WHERE
	U.AccountID=D.AccountID AND D.IsCurrent=true ;

	UPDATE Atemp6
	SET
	AccountDesc = AccountDescNEW
	WHERE 
	AccountDesc !=AccountDescNEW;
	

	
	/*CREATE TEMPORARY TABLE Atemp7 AS
	SELECT AccountID,IsCurrent,EndDate
	FROM DimAccount C
	WHERE EXISTS
	(SELECT AccountID
	FROM Atemp6 T where C.AccountID = T.AccountID AND C.IsCurrent=TRUE); 
	*/
	
	UPDATE DimAccount D SET
	EndDate=  (SELECT MAX(datevalue) AS EffectiveDate FROM DimDate),
	IsCurrent = False
	WHERE EXISTS
	(SELECT A.AccountID
	FROM Atemp6 A WHERE A.AccountID = D.AccountID AND D.IsCurrent=TRUE);


--SELECT * FROM DimAccount Where AccountID = 2365 ORDER BY EFFECTIVEDATE


	--GET SK_BrokerID FROM DimBroker
	CREATE TEMPORARY TABLE Atemp9 AS
	SELECT  ActionType, AccountID, AccountDesc, TaxStatus, CA_B_ID, C_ID ,ActionTS, D.SK_BrokerID
	FROM Atemp6 U LEFT OUTER JOIN DimBroker D ON
		 U.CA_B_ID = D.BrokerID AND
		  (U.ActionTS >= D.EffectiveDate AND U.ActionTS < D.EndDate);

	--GET SK_CustomerID FROM DimCustomer
	CREATE TEMPORARY TABLE Atemp10 AS
	SELECT  ActionType, AccountID, AccountDesc, TaxStatus, CA_B_ID, C_ID, ActionTS, SK_BrokerID, SK_CustomerID
	FROM Atemp9 A LEFT OUTER JOIN DimCustomer D ON
		 A.C_ID = D.CustomerID AND
		--D.Iscurrent=TRUE AND
		  (A.ActionTS >= D.EffectiveDate AND A.ActionTS < D.EndDate) ORDER BY AccountID;

		
--select * from Atemp9 where AccountID=4
 

	ALTER TABLE Atemp10
	  ADD Status varchar(10) DEFAULT 'Active';

	

	CREATE TEMPORARY TABLE Atemp8 AS
		SELECT MAX(SK_AccountID) AS SK_AccountID_value FROM DimAccount;

	 --for tuples with no ca_b_id to get brokerid, we copy the brokerid of the previous version in dim account
	UPDATE Atemp10
	SET SK_BrokerID = (SELECT distinct DimAccount.SK_BrokerID
			 FROM DimAccount
			 WHERE DimAccount.AccountID = Atemp10.AccountID)
	WHERE Atemp10.SK_BrokerID IS NULL;

--select * from Atemp10
 --for tuples with no taxstatus, we copy the taxstatus of the previous version in dim account
	UPDATE Atemp10
	SET TaxStatus = (SELECT distinct DimAccount.TaxStatus
			 FROM DimAccount
			 WHERE DimAccount.AccountID = Atemp10.AccountID)
	WHERE Atemp10.TaxStatus IS NULL;

--SELECT * FROM DimAccount Where AccountID = 2365 ORDER BY EFFECTIVEDATE
	INSERT INTO DimAccount(SK_AccountID,AccountID,SK_BrokerID,SK_CustomerID,
	Status,AccountDesc, TaxStatus,IsCurrent,BatchID,EffectiveDate,EndDate)
	 SELECT U.SK_AccountID_value + row_number() over( order by U.SK_AccountID_value) as SK_AccountID,T.AccountID,SK_BrokerID,SK_CustomerID,
	Status,AccountDesc,TaxStatus,TRUE,1,ActionTS,'9999-12-31'
	FROM 
	Atemp10 T, Atemp8 U
	ORDER BY SK_AccountID ASC;


	CREATE TEMPORARY TABLE T2A AS
    SELECT *,
    lead(EffectiveDate) over (partition by AccountID order by EffectiveDate) as enddatenew,
    lead(iscurrent) over (partition by AccountID order by EffectiveDate) as iscurrentnew
    FROM DimAccount;-- where iscurrent=true;


UPDATE T2A SET
iscurrent=FALSE,
enddate= enddatenew
WHERE iscurrentnew is not null and enddatenew is not null;



DELETE FROM DimAccount WHERE SK_AccountID IS NOT NULL;


INSERT INTO DimAccount(SK_AccountID,AccountID,SK_BrokerID,SK_CustomerID,
	Status,AccountDesc, TaxStatus,IsCurrent,BatchID,EffectiveDate,EndDate)
	SELECT SK_AccountID,AccountID,SK_BrokerID,SK_CustomerID,
	Status,AccountDesc, TaxStatus,IsCurrent,BatchID,EffectiveDate,EndDate
	FROM T2A order by AccountID;


--SELECT * FROM DimAccount Where AccountID = 6 ORDER BY EFFECTIVEDATE
--SELECT * FROM DimAccount Where AccountID = 20 ORDER BY EFFECTIVEDATE


--SELECT * FROM DimAccount Where AccountID = 2365 ORDER BY EFFECTIVEDATE

	/*FOR ClOSEACCT*/
	CREATE TEMPORARY TABLE CloseAcct AS	
	SELECT ActionType, AccountID,  C_ID, ActionTS
	FROM Accountall
	WHERE
	ActionType='CLOSEACCT' order by AccountID;

	
CREATE TEMPORARY TABLE CloseAcctJoin AS
SELECT ActionType, D.AccountID,  C_ID, ActionTS,Status,AccountDesc, TaxStatus,SK_BrokerID,
SK_CustomerID
	FROM CloseAcct C, DimAccount D
	WHERE C.AccountID=D.AccountID AND
	D.Iscurrent=TRUE;

	

	UPDATE DimAccount D
	SET Status = 'Inactive'--,
	--IsCurrent=FALSE,
	--EndDate=(SELECT date_trunc('day', ActionTS)
        --    FROM CloseAcct
          --   WHERE CloseAcct.AccountID = D.AccountID)
	WHERE EXISTS 
	(SELECT AccountID FROM CloseAcct C WHERE D.AccountID=C.AccountID);-- AND D.Iscurrent=TRUE);

--SELECT * FROM DimAccount Where AccountID = 6 ORDER BY EFFECTIVEDATE
--SELECT * FROM DimAccount Where AccountID = 20 ORDER BY EFFECTIVEDATE
--SELECT * FROM DimAccount Where AccountID = 93 ORDER BY EFFECTIVEDATE


--CREATE TEMPORARY TABLE Atemp8C AS
--		SELECT MAX(SK_AccountID) AS SK_AccountID_value FROM DimAccount;

/*
INSERT INTO DimAccount(SK_AccountID,AccountID,SK_BrokerID,SK_CustomerID,
	Status,AccountDesc, TaxStatus,IsCurrent,BatchID,EffectiveDate,EndDate)
	 SELECT U.SK_AccountID_value + row_number() over( order by U.SK_AccountID_value) as SK_AccountID,
	 T.AccountID,SK_BrokerID,SK_CustomerID,
	Status,AccountDesc,TaxStatus,TRUE,1,ActionTS,'9999-12-31'
	FROM 
	CloseAcctJoin T, Atemp8C U
	ORDER BY SK_AccountID ASC;

*/

---------------------------------------------------------------
--NEW SURROGATE KEYS



--JOIN Customerkeys TO DimCustomer
--for only UPDCUST to set new SK_CustomerID
/*CREATE TEMPORARY TABLE ToUpdateSk_CustmerID AS
SELECT * FROM DimAccount;

	
	CREATE TEMPORARY TABLE UPtemp1 AS
	SELECT D.SK_CustomerID AS SK_CustomerIDNEW, D.CustomerID,
	U.CustomerID AS CustomerIDfromKeys, U.SK_CustomerID AS SK_CustomerIDOLD
	 FROM DimCustomer D, Customerkeys U
	WHERE 
	D.CustomerID=U.CustomerID AND
	D.IsCurrent = TRUE
	ORDER BY D.CustomerID ASC;

	


UPDATE DimAccount D
SET SK_CustomerID = (SELECT SK_CustomerIDNEW
                 FROM UPtemp1
                 WHERE UPtemp1.SK_CustomerIDOLD = D.SK_CustomerID)
FROM UPtemp1
WHERE D.SK_CustomerID = UPtemp1.SK_CustomerIDOLD;
*/


--JOIN Customerkeysinact TO DimCustomer
--SET NEW SK_CUSTOMERID for only INACT 
	/*CREATE TEMPORARY TABLE UPtemp1INACT AS
	SELECT D.SK_CustomerID AS SK_CustomerIDNEW, D.CustomerID,
	U.CustomerID AS CustomerIDfromKeys, U.SK_CustomerID AS SK_CustomerIDOLD
	 FROM DimCustomer D, Customerkeysinact U
	WHERE 
	D.CustomerID=U.CustomerID AND
	D.IsCurrent = TRUE
	ORDER BY D.CustomerID ASC;





UPDATE DimAccount D
SET SK_CustomerID = (SELECT SK_CustomerIDNEW
                 FROM UPtemp1INACT
                 WHERE UPtemp1INACT.SK_CustomerIDOLD = D.SK_CustomerID)
FROM UPtemp1INACT
WHERE D.SK_CustomerID = UPtemp1INACT.SK_CustomerIDOLD AND D.Iscurrent=TRUE;*/

--SELECT * FROM DimAccount Where AccountID = 6 ORDER BY EFFECTIVEDATE
--SELECT * FROM DimAccount Where AccountID = 20 ORDER BY EFFECTIVEDATE
--SELECT * FROM DimAccount Where AccountID = 2365 ORDER BY EFFECTIVEDATE


----------------------------------------------------------------------------
	/*FOR UPDCUST*/
	CREATE TEMPORARY TABLE UpdCust AS	
	SELECT ActionType, AccountID,  C_ID, ActionTS
	FROM Accountall
	WHERE
	ActionType='UPDCUST' order by C_ID;

	
CREATE TEMPORARY TABLE UPD1 AS	
	SELECT  ActionType, ActionTS, C_ID, D.Sk_CustomerID, D.CustomerID, I.AccountID,
	 S.Sk_CustomerID AS Sk_CustomerIDOLD
	FROM UpdCust I, DimCustomer D, CustomerKeys S
	WHERE
	I.C_ID = D.CustomerID AND 
	I.ActionTS >= D.EffectiveDate AND I.ActionTS < D.EndDate AND
	S.CustomerID=D.CustomerID
	--D.IsCurrent=TRUE 
	 ORDER BY C_ID;


	 CREATE TEMPORARY TABLE UPD2 AS	
	SELECT ActionType,  ActionTS,C_ID, I.Sk_CustomerID,I.Sk_CustomerIDOLD, I.CustomerID, A.AccountID,
	SK_BrokerID,A.Status,A.AccountDesc,A.TaxStatus
	FROM  UPD1 I, DimAccount A
	WHERE
	I.Sk_CustomerIDOLD = A.Sk_CustomerID AND
	A.IsCurrent=TRUE 
	 ORDER BY CustomerID;


--SELECT * FROM customerkeys Where CustomerID=2004


--SELECT * FROM DIMACCOUNT Where AccountID = 2365 ORDER BY EFFECTIVEDATE
	--SELECT * FROM UPD2 Where AccountID = 2365 ORDER BY ACTIONTS
UPDATE DimAccount D SET
	Status=  'Inactive',
	IsCurrent=FALSE,
	EndDate=(SELECT min(date_trunc('day', ActionTS))
                FROM UPD2
             WHERE UPD2.AccountID = D.AccountID)
            -- EndDate =(SELECT batchdatecolumn
            -- FROM Batchdate)
	WHERE EXISTS
	(SELECT AccountID
	FROM UPD2 I where D.AccountID = I.AccountID AND D.IsCurrent=TRUE);

--DROP TABLE UPD2;

ALTER TABLE UPD2
ADD  Iscurrent BOOLEAN default TRUE,
ADD EndDate DATE default '9999-12-31';

--DROP TABLE T2Anew;

CREATE TEMPORARY TABLE T2Anew AS
    SELECT *,
    lead(ActionTS) over (partition by AccountID order by ActionTS) as enddatenew,
    lead(iscurrent) over (partition by AccountID order by ActionTS) as iscurrentnew
    FROM UPD2;

UPDATE T2Anew SET
enddatenew= '9999-12-31'
WHERE iscurrentnew is null;


UPDATE T2Anew SET
iscurrentnew=FALSE
WHERE iscurrentnew =TRUE;

UPDATE T2Anew SET
iscurrentnew=TRUE
WHERE iscurrentnew IS NULL;
--SELECT * FROM T2Anew  ORDER BY AccountID, ActionTS;


--SELECT * FROM DimAccount Where AccountID = 6 ORDER BY EFFECTIVEDATE
--SELECT * FROM DimAccount Where AccountID = 20 ORDER BY EFFECTIVEDATE
--SELECT * FROM DimAccount Where AccountID = 93 ORDER BY EFFECTIVEDATE


	
CREATE TEMPORARY TABLE Atemp8U AS
		SELECT MAX(SK_AccountID) AS SK_AccountID_value FROM DimAccount;


INSERT INTO DimAccount(SK_AccountID,AccountID,SK_BrokerID,SK_CustomerID,
	Status,AccountDesc, TaxStatus,IsCurrent,BatchID,EffectiveDate,EndDate)
	 SELECT U.SK_AccountID_value + row_number() over( order by U.SK_AccountID_value) as SK_AccountID,
	 T.AccountID,SK_BrokerID,SK_CustomerID,
	Status,AccountDesc,TaxStatus,iscurrentnew,1,date_trunc('day', ActionTS),enddatenew
	FROM 
	T2Anew T, Atemp8U U
	ORDER BY SK_CustomerID ASC;



	
--SELECT * FROM DimAccount Where AccountID = 6 ORDER BY EFFECTIVEDATE
--SELECT * FROM DimAccount Where AccountID = 20 ORDER BY EFFECTIVEDATE


-------------------------------------------------------------------
/*FOR INACT*/

	CREATE TEMPORARY TABLE InAct AS	
	SELECT ActionType, AccountID,  C_ID, ActionTS
	FROM Accountall
	WHERE
	ActionType='INACT' ORDER BY C_ID;


	CREATE TEMPORARY TABLE InAct2 AS	
	SELECT DISTINCT ActionType, ActionTS,  C_ID, D.Sk_CustomerID, D.CustomerID, I.AccountID
	FROM InAct I, DimCustomer D
	WHERE
	I.C_ID = D.CustomerID AND 
	D.IsCurrent=TRUE 
	 ORDER BY C_ID;


	 CREATE TEMPORARY TABLE InAct3 AS	
	SELECT ActionType, ActionTS,  C_ID,  I.Sk_CustomerID, I.CustomerID, A.AccountID,
	SK_BrokerID,A.Status,A.AccountDesc,A.TaxStatus
	FROM InAct2 I, DimAccount A
	WHERE
	I.Sk_CustomerID = A.Sk_CustomerID AND
	A.IsCurrent=TRUE 
	 ORDER BY C_ID;

--SELECT * FROM DimAccount Where AccountID = 6 ORDER BY EFFECTIVEDATE
--SELECT * FROM DimAccount Where AccountID = 20 ORDER BY EFFECTIVEDATE

--SELECT * FROM DimAccount Where AccountID = 2 ORDER BY EFFECTIVEDATE
--SELECT * FROM DimAccount Where AccountID = 93 ORDER BY EFFECTIVEDATE

	
UPDATE DimAccount D SET
	Status=  'Inactive'--,
	--IsCurrent=FALSE--,--it makes tuples inactive but true if commented
	--EndDate=(SELECT date_trunc('day', ActionTS)
           --    FROM InAct3
          --   WHERE InAct3.AccountID = D.AccountID)
        -- EndDate =(SELECT batchdatecolumn
        --     FROM Batchdate)
	WHERE EXISTS
	(SELECT AccountID
	FROM InAct3 I where D.AccountID = I.AccountID AND D.IsCurrent=TRUE);

	
	--CREATE TEMPORARY TABLE Atemp8I AS
	--SELECT MAX(SK_AccountID) AS SK_AccountID_value FROM DimAccount;


	--INSERT INTO DimAccount(SK_AccountID,AccountID,SK_BrokerID,SK_CustomerID,
	--Status,AccountDesc, TaxStatus,IsCurrent,BatchID,EffectiveDate,EndDate)
	-- SELECT U.SK_AccountID_value + row_number() over( order by U.SK_AccountID_value) as SK_AccountID,T.AccountID,SK_BrokerID,SK_CustomerID,
	--Status,AccountDesc,TaxStatus,TRUE,1,ActionTS,'9999-12-31'
	--FROM 
	--InAct3 T, Atemp8I U, Batchdate B
	--ORDER BY SK_AccountID ASC;

--DROP TABLE ToUpdate
--all updacc that came before updcust
/*CREATE TEMPORARY TABLE UPtemp1 AS
select SK_AccountID, A.AccountID, A.SK_CustomerID, CustomerID,ActionTS 
from 
DimAccount A ,DimCustomer D , UpdCust S
WHERE
A.SK_CustomerID = D.SK_CustomerID and 
 S.C_ID = D.CustomerID AND
	--c.EffectiveDate <= a.EffectiveDate and 
	A.EndDate > D.EndDate 	
	  ORDER BY AccountID;
--DROP TABLE ToUpdate
CREATE TEMPORARY TABLE ToUpdate AS
select  U.SK_AccountID, U.AccountID, D.SK_CustomerID AS SK_CustomerIDNEW,
U.SK_CustomerID AS SK_CustomerIDOLD, U.CustomerID,U.ActionTS,D.EffectiveDate,D.EndDate
FROM UPtemp1 U, DimCustomer D
WHERE 
U.ActionTS>=D.EffectiveDate AND
 U.ActionTS<D.EndDate AND 
U.CustomerID=D.CustomerID 	 
 ORDER BY AccountID;




UPDATE DimAccount D
SET SK_CustomerID = U.SK_CustomerIDNEW
FROM
 ToUpdate U
WHERE
 D.SK_AccountID = U.SK_AccountID AND
 D.SK_CustomerID=U.SK_CustomerIDOLD;-- AND 
 -- U.EffectiveDate<=D.EffectiveDate AND 
  --D.EndDate>U.EndDate;
*/
	

	END;
	$$ LANGUAGE 'plpgsql';