/*Factwatches Load*/


DROP FUNCTION IF EXISTS FactwatchesLoadInc1();
CREATE FUNCTION FactwatchesLoadInc1()
RETURNS VOID AS $$
BEGIN

	DROP TABLE IF EXISTS FWHITemp1,FWHITemp2,FWHITemp3,FWHITemp4,FWHITemp5,
	FCWHITemp1, FCWHITemp2, FCWHITemp3, FWHITempTtl, FWHITempTt2 ,FWHITempTt3, T,TT,TTT,UnChanged,Changed;
	--DELETE  FROM Factwatches where SK_SecurityID is not null;


	--FOR ACT
	CREATE TEMPORARY TABLE FWHITemp1 AS
	SELECT W_C_ID, W_S_SYMB, W_DTS, W_ACTION, SK_CustomerID
	FROM WatchHistory1 W, DimCustomer D
	WHERE 
	W.W_C_ID = D.CustomerID AND
	W.W_ACTION ='ACTV' AND
	--D.IsCurrent=TRUE ;
	W_DTS >= D.EffectiveDate AND
	W_DTS < EndDate;


	CREATE TEMPORARY TABLE FWHITemp2 AS
	SELECT W_C_ID, W_S_SYMB, W_DTS, W_ACTION, SK_CustomerID, SK_SecurityID
	FROM FWHITemp1 T, DimSecurity D
	WHERE T.W_S_SYMB = D.Symbol AND
	--D.IsCurrent=TRUE; 
	W_DTS >= D.EffectiveDate AND
	W_DTS < EndDate;

	--Find surrogate key SK_DateID_DatePlaced
	CREATE TEMPORARY TABLE FWHITemp3 AS
	SELECT W_C_ID, W_S_SYMB, W_DTS, W_ACTION, SK_CustomerID, SK_SecurityID, SK_DateID AS SK_DateID_DatePlaced
	FROM FWHITemp2 T, DimDate D
	WHERE T.W_DTS = D.DateValue;


	 ALTER TABLE FWHITemp3
	ADD  SK_DateID_DateRemoved INTEGER DEFAULT NULL;


	--FOR CNCL
	CREATE TEMPORARY TABLE FCWHITemp1 AS
	SELECT W_C_ID, W_S_SYMB, W_DTS, W_ACTION, SK_CustomerID
	FROM WatchHistory1 W, DimCustomer D
	WHERE 
	W.W_C_ID = D.CustomerID AND
	W.W_ACTION ='CNCL' AND
	--D.IsCurrent=TRUE;
	W_DTS >= D.EffectiveDate AND
	W_DTS < EndDate;


	CREATE TEMPORARY TABLE FCWHITemp2 AS
	SELECT W_C_ID, W_S_SYMB, W_DTS, W_ACTION, SK_CustomerID, SK_SecurityID
	FROM FCWHITemp1 T, DimSecurity D
	WHERE T.W_S_SYMB = D.Symbol AND
	--D.IsCurrent=TRUE;
	W_DTS >= D.EffectiveDate AND
	W_DTS < EndDate;



	CREATE TEMPORARY TABLE FCWHITemp3 AS
	SELECT W_C_ID, W_S_SYMB, W_DTS, W_ACTION, SK_CustomerID, SK_SecurityID, SK_DateID AS SK_DateID_DateRemoved
	FROM FCWHITemp2 T, DimDate D
	WHERE T.W_DTS = D.DateValue;

	ALTER TABLE FCWHITemp3
	ADD  SK_DateID_DatePlaced INTEGER DEFAULT NULL;

	--select * from FWHITemp3
	--select * from WatchHistory where W_S_SYMB='AAAAAAAAAAAAEMM' and W_C_ID=1655
	--CREATE TEMPORARY TABLE ALLWatches AS

	--JOIN NEW WITH UPDATE
	CREATE TEMPORARY TABLE FWHITempTt2 AS
	SELECT F.W_C_ID, F.W_S_SYMB, F.W_DTS, F.W_ACTION,F.SK_DateID_DatePlaced ,
	F.SK_CustomerID, F.SK_SecurityID, C.SK_DateID_DateRemoved
	FROM FWHITemp3 F LEFT OUTER JOIN FCWHITemp3 C
	ON
	(
	F.W_C_ID = C.W_C_ID AND
	F.W_S_SYMB = C.W_S_SYMB
	);


	--SELECT count(*) from Factwatches where SK_DATEID_DATEREMOVED is not null

	INSERT INTO Factwatches( SK_CustomerID, SK_SecurityID,SK_DateID_DatePlaced, SK_DateID_DateRemoved, BatchID)
	SELECT SK_CustomerID, SK_SecurityID, SK_DateID_DatePlaced, SK_DateID_DateRemoved,2
	FROM
	FWHITempTt2;


	/*UPDATE Factwatches F
	SET SK_DateID_DateRemoved=(SELECT SK_DateID_DateRemoved FROM FCWHITemp3 WHERE 
			FCWHITemp3.SK_CustomerID= F.SK_CustomerID AND FCWHITemp3.SK_SecurityID= F.SK_SecurityID)
	WHERE EXISTS
	(SELECT SK_DateID_DateRemoved FROM FCWHITemp3 T WHERE 
			T.SK_CustomerID= F.SK_CustomerID AND T.SK_SecurityID= F.SK_SecurityID);
	*/


	--TO HANDLE CHANGED SK_CustomerID,SK_SecurityID
	CREATE TEMPORARY TABLE T AS
	SELECT T.SK_DateID_DateRemoved,T.W_C_ID, T.W_S_SYMB, T.W_DTS,T.W_ACTION,
	D.SK_CustomerID,S.SK_SecurityID, S.SYMBOL, D.CUSTOMERID FROM 
	FCWHITemp3 T , DIMCUSTOMER D , DIMSECURITY S WHERE 
			T.SK_CustomerID= D.SK_CustomerID AND 
			T.SK_SecurityID= S.SK_SecurityID;

	CREATE TEMPORARY TABLE TT AS
	SELECT F.SK_DateID_DateRemoved,F.SK_CustomerID,F.SK_SecurityID, S.SYMBOL, D.CUSTOMERID FROM 
	Factwatches F ,DIMCUSTOMER D , DIMSECURITY S WHERE 
			F.SK_CustomerID= D.SK_CustomerID AND 
			F.SK_SecurityID= S.SK_SecurityID ;

	--DROP TABLE TTT,UnChanged,Changed

	CREATE TEMPORARY TABLE TTT AS
	SELECT T.SK_DateID_DateRemoved,T.W_C_ID, T.W_S_SYMB, T.W_DTS,T.W_ACTION,
	T.SK_CustomerID,T.SK_SecurityID,
	TT.SK_CustomerID AS SK_CustomerID_Factwatches
	,TT.SK_SecurityID AS SK_SecurityID_FactWatches, 
	T.SYMBOL, T.CUSTOMERID 
	FROM 
	T, TT WHERE
	T.CustomerID= TT.CustomerID AND 
	T.SYMBOL= TT.SYMBOL ;

	--Unchanged surrogate keys
	CREATE TEMPORARY TABLE UnChanged AS
	SELECT * FROM TTT WHERE
	SK_CustomerID=SK_CustomerID_Factwatches AND 
	SK_SecurityID=SK_SecurityID_FactWatches;
	 
	--Changed surrogate keys
	CREATE TEMPORARY TABLE Changed AS
	SELECT * FROM TTT WHERE
	SK_CustomerID <> SK_CustomerID_Factwatches OR
	SK_SecurityID <> SK_SecurityID_FactWatches;

	--Update Unchanged surrogate keys
	UPDATE Factwatches F
	SET SK_DateID_DateRemoved=(SELECT SK_DateID_DateRemoved FROM UnChanged WHERE 
	UnChanged.SK_CustomerID= F.SK_CustomerID AND UnChanged.SK_SecurityID= F.SK_SecurityID),
	BatchID=2
	WHERE EXISTS
	(SELECT SK_DateID_DateRemoved FROM UnChanged T WHERE 
	T.SK_CustomerID= F.SK_CustomerID AND T.SK_SecurityID= F.SK_SecurityID);


	--Update Changed surrogate keys
	UPDATE Factwatches F
	SET SK_DateID_DateRemoved=(SELECT SK_DateID_DateRemoved FROM Changed WHERE 
	Changed.SK_CustomerID_Factwatches= F.SK_CustomerID AND 
	Changed.SK_SecurityID_FactWatches= F.SK_SecurityID),
	BatchID=2
	WHERE EXISTS
	(SELECT SK_DateID_DateRemoved FROM Changed T WHERE 
	T.SK_CustomerID_Factwatches= F.SK_CustomerID AND
	T.SK_SecurityID_FactWatches= F.SK_SecurityID);



	/*	SELECT T.SK_DateID_DateRemoved,T.W_C_ID, T.W_S_SYMB, T.W_DTS,T.W_ACTION,
	F.SK_CustomerID,F.SK_SecurityID
	 FROM TTT T, Factwatches F WHERE 
		T.SK_CustomerID= F.SK_CustomerID AND T.SK_SecurityID= F.SK_SecurityID*/

			
END;
$$ LANGUAGE 'plpgsql';
