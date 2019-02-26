/*DimAccount Load*/


DROP FUNCTION IF EXISTS DimAccountLoad();
CREATE FUNCTION DimAccountLoad()
RETURNS VOID AS $$
BEGIN

	DROP TABLE IF EXISTS Atemp2,Atemp3,Atemp4,
	Atemp5,Atemp6,Atemp7,Atemp8,Atemp9,Atemp10,Atemp11,Atemp12,
	NewOrAddAcct,UpdAcct,CloseAcct,UpdCust,InAct,
	UPTemp1,UPTemp2,ITemp1;

		
	


	/*FOR NEW OR ADDACCT*/
	CREATE TEMPORARY TABLE NewOrAddAcct AS	
	SELECT ActionType, AccountID, AccountDesc, TaxStatus, CA_B_ID, C_ID, ActionTS
	FROM Accountall
	WHERE
	ActionType='NEW'  OR ActionType='ADDACCT';

	--GET SK_BrokerID FROM DimBroker
	CREATE TEMPORARY TABLE Atemp2 AS
	SELECT  ActionType, AccountID, AccountDesc, TaxStatus, CA_B_ID, C_ID ,ActionTS, 
	SK_BrokerID
	FROM NewOrAddAcct N LEFT OUTER JOIN DimBroker  D ON
		 (N.CA_B_ID = D.BrokerID AND
		  (N.ActionTS >= D.EffectiveDate AND N.ActionTS <= D.EndDate));


	--GET SK_CustomerID FROM DimBroker
	CREATE TEMPORARY TABLE Atemp3 AS
	SELECT  ActionType, AccountID, AccountDesc, TaxStatus, CA_B_ID, C_ID, ActionTS, 
	SK_BrokerID, SK_CustomerID
	FROM Atemp2 A LEFT OUTER JOIN DimCustomer D ON
	(D.IsCurrent=TRUE
	AND A.C_ID = D.CustomerID
	AND (A.ActionTS >= D.EffectiveDate AND A.ActionTS <= D.EndDate));



	--ALTER TABLE Atemp3
	---  ADD Status varchar(10) DEFAULT 'Active';



	INSERT INTO DimAccount(SK_AccountID,AccountID,SK_BrokerID,SK_CustomerID,
	Status,AccountDesc, TaxStatus,IsCurrent,BatchID,EffectiveDate,EndDate)
	SELECT  row_number() over( order by 1) as SK_AccountID, AccountID,SK_BrokerID,SK_CustomerID,
	'Active',AccountDesc, TaxStatus,TRUE,1,ActionTS,'9999-12-31'
	FROM 
	Atemp3 order by  AccountID asc;
	



	END;
	$$ LANGUAGE 'plpgsql';

	
	--SELECT * FROM UpdAcct WHERE ACCOUNTID=44;
	--SELECT * FROM Atemp12 WHERE ACCOUNTID=44;
	--SELECT * FROM DimAccount;
	--SELECT * FROM Atemp10 WHERE ACCOUNTID=153;