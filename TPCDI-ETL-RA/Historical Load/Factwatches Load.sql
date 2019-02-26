/*Factwatches Load*/


DROP FUNCTION IF EXISTS FactwatchesLoad();
CREATE FUNCTION FactwatchesLoad()
RETURNS VOID AS $$
BEGIN

	DROP TABLE IF EXISTS FWHTemp1,FWHTemp2,FWHTemp3,FWHTemp4,FWHTemp5,
	FCWHTemp1, FCWHTemp2,FCWHTemp3, FWHTempTtl, FWHTempTt2 ,FWHTempTt3;
	--DELETE  FROM Factwatches where SK_SecurityID is not null;


	--FOR ACT
	CREATE TEMPORARY TABLE FWHTemp1 AS
	SELECT W_C_ID, W_S_SYMB, W_DTS, W_ACTION, SK_CustomerID
	FROM WatchHistory W, DimCustomer D
	WHERE 
	W.W_C_ID = D.CustomerID AND
	W.W_ACTION ='ACTV' AND
	--D.IsCurrent=TRUE AND
	W_DTS >= D.EffectiveDate AND
	W_DTS < EndDate;


	CREATE TEMPORARY TABLE FWHTemp2 AS
	SELECT W_C_ID, W_S_SYMB, W_DTS, W_ACTION, SK_CustomerID, SK_SecurityID
	FROM FWHTemp1 T, DimSecurity D
	WHERE T.W_S_SYMB = D.Symbol AND
	--D.IsCurrent=TRUE AND
	W_DTS >= D.EffectiveDate AND
	W_DTS < EndDate;


	CREATE TEMPORARY TABLE FWHTemp3 AS
	SELECT W_C_ID, W_S_SYMB, W_DTS, W_ACTION, SK_CustomerID, SK_SecurityID, SK_DateID AS SK_DateID_DatePlaced
	FROM FWHTemp2 T, DimDate D
	WHERE T.W_DTS = D.DateValue;

	 ALTER TABLE FWHTemp3
	ADD  SK_DateID_DateRemoved INTEGER DEFAULT NULL;

	--FOR CNCL
	CREATE TEMPORARY TABLE FCWHTemp1 AS
	SELECT W_C_ID, W_S_SYMB, W_DTS, W_ACTION, SK_CustomerID
	FROM WatchHistory W, DimCustomer D
	WHERE 
	W.W_C_ID = D.CustomerID AND
	W.W_ACTION ='CNCL' AND
	--D.IsCurrent=TRUE AND
	W_DTS >= D.EffectiveDate AND
	W_DTS < EndDate;


	CREATE TEMPORARY TABLE FCWHTemp2 AS
	SELECT W_C_ID, W_S_SYMB, W_DTS, W_ACTION, SK_CustomerID, SK_SecurityID
	FROM FCWHTemp1 T, DimSecurity D
	WHERE T.W_S_SYMB = D.Symbol AND
	--D.IsCurrent=TRUE AND
	W_DTS >= D.EffectiveDate AND
	W_DTS < EndDate;



	CREATE TEMPORARY TABLE FCWHTemp3 AS
	SELECT W_C_ID, W_S_SYMB, W_DTS, W_ACTION, SK_CustomerID, SK_SecurityID, SK_DateID AS SK_DateID_DateRemoved
	FROM FCWHTemp2 T, DimDate D
	WHERE T.W_DTS = D.DateValue;

	ALTER TABLE FCWHTemp3
	ADD  SK_DateID_DatePlaced INTEGER DEFAULT NULL;

	--select * from FCWHTemp3
	--select * from FWHTemp3 where W_C_ID=29 and W_S_SYMB='AAAAAAAAAAAAADO'

	/*CREATE TEMPORARY TABLE FWHTempTt2 AS
	SELECT W_C_ID, W_S_SYMB, W_DTS, W_ACTION, SK_CustomerID, SK_SecurityID, 
	SK_DateID_DatePlaced, SK_DateID_DateRemoved FROM FWHTemp3
	UNION
	SELECT W_C_ID, W_S_SYMB, W_DTS, W_ACTION, SK_CustomerID, SK_SecurityID, 
	SK_DateID_DatePlaced, SK_DateID_DateRemoved FROM FCWHTemp3;*/

	--JOIN NEW WITH UPDATE
	CREATE TEMPORARY TABLE FWHTempTt2 AS
	SELECT F.W_C_ID, F.W_S_SYMB, F.W_DTS, F.W_ACTION,F.SK_DateID_DatePlaced ,
	F.SK_CustomerID, F.SK_SecurityID, C.SK_DateID_DateRemoved
	FROM FWHTemp3 F LEFT OUTER JOIN FCWHTemp3 C
	ON
	(
	F.W_C_ID = C.W_C_ID AND
	F.W_S_SYMB = C.W_S_SYMB
	);

	--SELECT count(*) from FWHTempTt2 where SK_DATEID_DATEREMOVED is not null

	--JOIN NEW WITH UPDATE
	/*CREATE TEMPORARY TABLE FWHTempTtl AS
	SELECT F.W_C_ID, F.W_S_SYMB, F.W_DTS, F.W_ACTION,F.SK_DateID_DatePlaced ,
	F.SK_CustomerID, F.SK_SecurityID,
	--C.SK_CustomerID, C.SK_SecurityID ,
	 C.W_DTS AS SK_DateID_DateRemoved
	FROM FWHTemp3 F LEFT OUTER JOIN FCWHTemp2 C
	ON
	(
	F.SK_CustomerID = C.SK_CustomerID AND
	F.SK_SecurityID = C.SK_SecurityID
	);*/


	/*CREATE TEMPORARY TABLE FWHTempTt2 AS
	SELECT F.W_C_ID, F.W_S_SYMB, F.W_DTS, F.W_ACTION,F.SK_DateID_DatePlaced ,
	F.SK_CustomerID, F.SK_SecurityID,
	SK_DateID AS SK_DateID_DateRemoved
	  FROM FWHTempTtl F LEFT OUTER JOIN DimDate D
	ON
	(F.SK_DateID_DateRemoved = D.Datevalue);*/



	INSERT INTO Factwatches( SK_CustomerID, SK_SecurityID,SK_DateID_DatePlaced, SK_DateID_DateRemoved, BatchID)
	SELECT SK_CustomerID, SK_SecurityID, SK_DateID_DatePlaced, SK_DateID_DateRemoved,1
	FROM
	FWHTempTt2;

	--SELECT * FROM WatchHistory WHERE W_C_ID=2 ORDER BY W_DTS
END;
$$ LANGUAGE 'plpgsql';
 --SELECT count(*) FROM FWHTemp3 WHERE W_ACTION='ACTV';