/*Factwatches Load*/


DROP FUNCTION IF EXISTS FactwatchesLoadInc2();
CREATE FUNCTION FactwatchesLoadInc2()
RETURNS VOID AS $$
BEGIN

	DROP TABLE IF EXISTS FWHI2Temp1,FWHI2Temp2,FWHI2Temp3,FWHI2Temp4,FWHI2Temp5,
	FCWHITemp1, FCWHITemp2,FCWHITemp3, FWHI2TempTtl, FWHI2TempTt2 ,FWHI2TempTt3,T2,TT2,TTT2,UnChanged2,Changed2;
	--DELETE  FROM Factwatches where SK_SecurityID is not null;


	--FOR ACT
	CREATE TEMPORARY TABLE FWHI2Temp1 AS
	SELECT W_C_ID, W_S_SYMB, W_DTS, W_ACTION, SK_CustomerID
	FROM WatchHistory2 W, DimCustomer D
	WHERE 
	W.W_C_ID = D.CustomerID AND
	W.W_ACTION ='ACTV' AND
	D.IsCurrent=TRUE ;
	--W_DTS >= D.EffectiveDate AND
	--W_DTS < EndDate;


	CREATE TEMPORARY TABLE FWHI2Temp2 AS
	SELECT W_C_ID, W_S_SYMB, W_DTS, W_ACTION, SK_CustomerID, SK_SecurityID
	FROM FWHI2Temp1 T, DimSecurity D
	WHERE T.W_S_SYMB = D.Symbol AND
	D.IsCurrent=TRUE; 
	--W_DTS >= D.EffectiveDate AND
	--W_DTS < EndDate;

	--Find surrogate key SK_DateID_DatePlaced
	CREATE TEMPORARY TABLE FWHI2Temp3 AS
	SELECT W_C_ID, W_S_SYMB, W_DTS, W_ACTION, SK_CustomerID, SK_SecurityID, SK_DateID AS SK_DateID_DatePlaced
	FROM FWHI2Temp2 T, DimDate D
	WHERE T.W_DTS = D.DateValue;


	 ALTER TABLE FWHI2Temp3
	ADD  SK_DateID_DateRemoved INTEGER DEFAULT NULL;


	--FOR CNCL
	CREATE TEMPORARY TABLE FCWHITemp1 AS
	SELECT W_C_ID, W_S_SYMB, W_DTS, W_ACTION, SK_CustomerID
	FROM WatchHistory2 W, DimCustomer D
	WHERE 
	W.W_C_ID = D.CustomerID AND
	W.W_ACTION ='CNCL' AND
	D.IsCurrent=TRUE;
	--W_DTS >= D.EffectiveDate AND
	--W_DTS < EndDate;


	CREATE TEMPORARY TABLE FCWHITemp2 AS
	SELECT W_C_ID, W_S_SYMB, W_DTS, W_ACTION, SK_CustomerID, SK_SecurityID
	FROM FCWHITemp1 T, DimSecurity D
	WHERE T.W_S_SYMB = D.Symbol AND
	D.IsCurrent=TRUE;
	--W_DTS >= D.EffectiveDate AND
	--W_DTS < EndDate;



	CREATE TEMPORARY TABLE FCWHITemp3 AS
	SELECT W_C_ID, W_S_SYMB, W_DTS, W_ACTION, SK_CustomerID, SK_SecurityID, SK_DateID AS SK_DateID_DateRemoved
	FROM FCWHITemp2 T, DimDate D
	WHERE T.W_DTS = D.DateValue;

	ALTER TABLE FCWHITemp3
	ADD  SK_DateID_DatePlaced INTEGER DEFAULT NULL;



	--JOIN NEW WITH UPDATE
	CREATE TEMPORARY TABLE FWHI2TempTt2 AS
	SELECT F.W_C_ID, F.W_S_SYMB, F.W_DTS, F.W_ACTION,F.SK_DateID_DatePlaced ,
	F.SK_CustomerID, F.SK_SecurityID, C.SK_DateID_DateRemoved
	FROM FWHI2Temp3 F LEFT OUTER JOIN FCWHITemp3 C
	ON
	(
	F.W_C_ID = C.W_C_ID AND
	F.W_S_SYMB = C.W_S_SYMB
	);


	--SELECT count(*) from FWHI2TempTtl where SK_DATEID_DATEREMOVED is not null

	--Find surrogate key SK_DateID_DateRemoved
	/*CREATE TEMPORARY TABLE FWHI2TempTt2 AS
	SELECT F.W_C_ID, F.W_S_SYMB, F.W_DTS, F.W_ACTION,F.SK_DateID_DatePlaced ,
	F.SK_CustomerID, F.SK_SecurityID,
	SK_DateID AS SK_DateID_DateRemoved
	  FROM FWHI2TempTtl F LEFT OUTER JOIN DimDate D
	ON
	(F.SK_DateID_DateRemoved = D.Datevalue);*/



	INSERT INTO Factwatches( SK_CustomerID, SK_SecurityID,SK_DateID_DatePlaced, SK_DateID_DateRemoved, BatchID)
	SELECT SK_CustomerID, SK_SecurityID, SK_DateID_DatePlaced, SK_DateID_DateRemoved,3
	FROM
	FWHI2TempTt2;





	CREATE TEMPORARY TABLE T2 AS
	SELECT T.SK_DateID_DateRemoved,T.W_C_ID, T.W_S_SYMB, T.W_DTS,T.W_ACTION,
	D.SK_CustomerID,S.SK_SecurityID, S.SYMBOL, D.CUSTOMERID FROM 
	FCWHITemp3 T , DIMCUSTOMER D , DIMSECURITY S WHERE 
			T.SK_CustomerID= D.SK_CustomerID AND 
			T.SK_SecurityID= S.SK_SecurityID;

	CREATE TEMPORARY TABLE TT2 AS
	SELECT F.SK_DateID_DateRemoved,F.SK_CustomerID,F.SK_SecurityID, S.SYMBOL, D.CUSTOMERID FROM 
	Factwatches F ,DIMCUSTOMER D , DIMSECURITY S WHERE 
			F.SK_CustomerID= D.SK_CustomerID AND 
			F.SK_SecurityID= S.SK_SecurityID ;

	CREATE TEMPORARY TABLE TTT2 AS
	SELECT T2.SK_DateID_DateRemoved,T2.W_C_ID, T2.W_S_SYMB, T2.W_DTS,T2.W_ACTION,
	T2.SK_CustomerID,T2.SK_SecurityID,
	TT2.SK_CustomerID AS SK_CustomerID_Factwatches
	,TT2.SK_SecurityID AS SK_SecurityID_FactWatches, 
	T2.SYMBOL, T2.CUSTOMERID 
	FROM 
	T2, TT2 WHERE
	T2.CustomerID= TT2.CustomerID AND 
	T2.SYMBOL= TT2.SYMBOL ;

	--Unchanged surrogate keys
	CREATE TEMPORARY TABLE UnChanged2 AS
	SELECT * FROM TTT2 WHERE
	SK_CustomerID=SK_CustomerID_Factwatches AND 
	SK_SecurityID=SK_SecurityID_FactWatches;
	 
	--Changed surrogate keys
	CREATE TEMPORARY TABLE Changed2 AS
	SELECT * FROM TTT2 WHERE
	SK_CustomerID <> SK_CustomerID_Factwatches OR
	SK_SecurityID <> SK_SecurityID_FactWatches;



	--Update Unchanged surrogate keys
	UPDATE Factwatches F
	SET SK_DateID_DateRemoved=(SELECT SK_DateID_DateRemoved FROM UnChanged2 WHERE 
			UnChanged2.SK_CustomerID= F.SK_CustomerID AND UnChanged2.SK_SecurityID= F.SK_SecurityID),
			BatchID=3
	WHERE EXISTS
	(SELECT SK_DateID_DateRemoved FROM UnChanged2 T WHERE 
			T.SK_CustomerID= F.SK_CustomerID AND T.SK_SecurityID= F.SK_SecurityID);


	--Update Changed surrogate keys
	UPDATE Factwatches F
	SET SK_DateID_DateRemoved=(SELECT SK_DateID_DateRemoved FROM Changed2 WHERE 
	Changed2.SK_CustomerID_Factwatches= F.SK_CustomerID AND 
	Changed2.SK_SecurityID_FactWatches= F.SK_SecurityID),
	BatchID=3
	WHERE EXISTS
	(SELECT SK_DateID_DateRemoved FROM Changed2 T WHERE 
	T.SK_CustomerID_Factwatches= F.SK_CustomerID AND
	T.SK_SecurityID_FactWatches= F.SK_SecurityID);



	
END;
$$ LANGUAGE 'plpgsql';
