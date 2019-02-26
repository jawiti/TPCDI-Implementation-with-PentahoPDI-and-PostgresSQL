/*DimCompany_SecurityLoad*/

DROP FUNCTION IF EXISTS DimCompany_SecurityLoad();
CREATE FUNCTION DimCompany_SecurityLoad()
RETURNS VOID AS $$

	DECLARE
	Action Character Varying(10);
	ID INTEGER  := 1 ;
	COUNT INTEGER := 0;
	cnt INTEGER;
	BEGIN	


	DROP TABLE IF EXISTS   CSTemp1, CSTemp2, ADDSK_Val,ADDSECSK_Val,CTemp3 ;

	CREATE TEMPORARY TABLE CSTemp1 AS
	SELECT to_timestamp(PTS,'YYYYMMDD-HH24MISS') as PTS,RecType,CompanyName,CIK::INT,Status,IndustryID,SPrating,
	FoundingDate,AddrLine1,AddrLine2,PostalCode,City,StateProvince,Country,CEOname,Description,
	Symbol, IssueType,Name, ExID, ShOut, FirstTradeDate, FirstTradeExchg, Dividend, CoNameOrCIK
	FROM CMPSEC ORDER BY PTS;


	CREATE TEMPORARY TABLE CSTemp2 AS
	SELECT  row_number() over( order by 1) AS seq,PTS,RecType,CompanyName,CIK,Status,IndustryID,SPrating,
	FoundingDate,AddrLine1,AddrLine2,PostalCode,City,StateProvince,Country,CEOname,Description,
	Symbol, IssueType,Name, ExID, ShOut, FirstTradeDate, FirstTradeExchg, Dividend, CoNameOrCIK
	FROM CSTemp1 ORDER BY PTS;


	CREATE TEMPORARY TABLE ADDSK_Val AS
	SELECT MAX(SK_CompanyID) AS SK_CompanyID_value FROM DimCompany;

	UPDATE ADDSK_Val SET 
	SK_CompanyID_value=0
	WHERE 
	SK_CompanyID_value IS NULL;


		
	CREATE TEMPORARY TABLE ADDSECSK_Val AS
	SELECT MAX(SK_SecurityID) AS SK_SecurityID_value FROM DimSecurity;

	UPDATE ADDSECSK_Val SET 
	SK_SecurityID_value=0
	WHERE 
	SK_SecurityID_value IS NULL;

	
 	cnt := (SELECT COUNT(*) FROM CSTemp1);
 	

	 LOOP 
	 --EXIT WHEN ID > 6500 ; 
	EXIT WHEN ID > cnt ;  


	INSERT INTO CSTemp3 (seq,PTS,RecType,CompanyName,CIK,Status,IndustryID,SPrating,
	FoundingDate,AddrLine1,AddrLine2,PostalCode,City,StateProvince,Country,CEOname,Description,
	Symbol, IssueType,Name, ExID, ShOut, FirstTradeDate, FirstTradeExchg, Dividend, CoNameOrCIK)
	SELECT seq,PTS,RecType,CompanyName,CIK,Status,IndustryID,SPrating,
	FoundingDate,AddrLine1,AddrLine2,PostalCode,City,StateProvince,Country,CEOname,Description,
	Symbol, IssueType,Name, ExID, ShOut, FirstTradeDate, FirstTradeExchg, Dividend, CoNameOrCIK
	FROM CSTemp2 WHERE seq = (SELECT MIN(seq)
	FROM CSTemp2 AS seq1);

	SELECT RecType INTO Action FROM CSTemp3;

	
	-------------------------------------------------------------------------------------
       IF Action='CMP' THEN

	       
	--ADD Status from StatusType.txt
	INSERT INTO CSTemp4 (PTS,RecType,CompanyName,CIK,FinwireStatus,Status, IndustryID,SPrating,FoundingDate,AddrLine1,
	AddrLine2,PostalCode,City,StateProvince,Country,CEOname,Description)
	SELECT PTS,RecType,CompanyName,CIK,C.Status AS FinwireStatus, S.ST_NAME AS Status, IndustryID,SPrating,FoundingDate,AddrLine1,
	AddrLine2,PostalCode,City,StateProvince,Country,CEOname,Description
	FROM CSTemp3 C, StatusType S 
	WHERE C.Status = S.ST_ID order by CIK;

	--ADD IndustrID from Industry.txt
	INSERT INTO CSTemp5(PTS,RecType,CompanyName, CIK, Status, FinwireIndustryID, Industry,SPrating,
	FoundingDate,AddrLine1,AddrLine2,PostalCode,City,StateProvince,Country,CEOname,Description)
	SELECT PTS,RecType,CompanyName, CIK::INT, Status, 
	C.IndustryID AS FinwireIndustryID, I.IN_NAME AS Industry,
	SPrating,FoundingDate,AddrLine1,AddrLine2,PostalCode,City,
	StateProvince,Country,CEOname,Description
	FROM CSTemp4 C, Industry I
	WHERE C.IndustryID = I.IN_ID ORDER BY CIK ASC;


	  
	UPDATE  CSTemp5
	SET 
	isLowGrade=false
	WHERE
	substr(CSTemp5.SPrating, 1, 1)='A' OR substr(CSTemp5.SPrating, 1, 3)='BBB';

	UPDATE  CSTemp5
	SET
	EffectiveDate= Date_trunc('day', PTS),
	EndDate = '9999-12-31';

--IF THERE WAS AN UPDATE
	INSERT INTO CompKeys(Sk_CompanyID, CompanyID)
	SELECT D.Sk_CompanyID, D.CompanyID 
	FROM 
	DimCompany D, CSTemp5 C
	WHERE 
	D.IsCurrent=TRUE AND
	D.CompanyID=C.CIK;

	

	UPDATE DimCompany D SET
	--Status=  'Inactive',
	IsCurrent=FALSE,
	EndDate=(SELECT  PTS
               FROM CSTemp5
              WHERE CSTemp5.CIK = D.CompanyID)	
	WHERE EXISTS
	(SELECT CIK
	FROM CSTemp5 I where D.CompanyID = I.CIK AND D.IsCurrent=TRUE
	AND D.EffectiveDate<>date_trunc('day', PTS));

	

	INSERT INTO DimCompany(SK_CompanyID, CompanyID, Status, Name, Industry, SPrating, isLowGrade, CEO, 
	AddressLine1, AddressLine2, PostalCode, City, StateProv, Country, Description, FoundingDate,
	 IsCurrent, BatchID, EffectiveDate, EndDate)
	SELECT U.SK_CompanyID_value + 1 as SK_CompanyID, CIK::int, Status, CompanyName, Industry, SPrating,
	isLowGrade, CEOname, AddrLine1,AddrLine2,PostalCode,City, StateProvince,Country,Description,
	to_date(FoundingDate,'YYYYMMDD'),  IsCurrent, BatchID, EffectiveDate,EndDate
	FROM CSTemp5, ADDSK_Val U ;


	UPDATE ADDSK_Val SET 
	SK_CompanyID_value=SK_CompanyID_value+1
	WHERE 
	SK_CompanyID_value IS not NULL;


	INSERT INTO CSTemp6(SK_CompanyIDOLD, CompanyID,SK_CompanyID,EffectiveDate)
	SELECT C.SK_CompanyID,C.CompanyID,D.SK_CompanyID,D.EffectiveDate
	FROM
	DimCompany D, CompKeys C
	WHERE D.CompanyID = C.CompanyID
	AND D.IsCurrent = TRUE;


	
	
	INSERT INTO CSTemp7(Symbol, SK_CompanyID, CompanyID, SK_CompanyIDOLD,EffectiveDate)
	SELECT DISTINCT Symbol, C.SK_CompanyID, C.CompanyID, C.SK_CompanyIDOLD,C.EffectiveDate
	FROM
	DimSecurity D, CSTemp6 C
	WHERE D.SK_CompanyID = C.SK_CompanyIDOLD;-- and 
	--D.IsCurrent=TRUE;
	
	INSERT INTO CSTemp8(Symbol, Issue, Status, Name, ExchangeID, SharesOutstanding, FirstTrade, 
	FirstTradeOnExchange, Dividend,SK_CompanyID,EffectiveDate,DimSecEff,CompanyID)
	SELECT D.Symbol, Issue, Status, Name, ExchangeID,SharesOutstanding, FirstTrade,
	 FirstTradeOnExchange, Dividend, C.SK_CompanyID,C.EffectiveDate, D.EffectiveDate, C.CompanyID
	FROM
	DimSecurity D, CSTemp7 C
	WHERE D.Symbol = C.Symbol and 
	D.IsCurrent=TRUE;



	UPDATE DimSecurity D SET
	--Status=  'Inactive',
	IsCurrent=FALSE	,
	EndDate=(SELECT  EffectiveDate
	FROM CSTemp8
	WHERE CSTemp8.Symbol = D.Symbol)	
	WHERE EXISTS
	(SELECT Symbol
	FROM CSTemp8 I where D.Symbol = I.Symbol AND D.IsCurrent=TRUE
	AND D.EffectiveDate<>I.EffectiveDate);


	UPDATE DimSecurity D SET
	SK_CompanyID=(SELECT  M.SK_CompanyID
	FROM DimCompany M, CSTemp8 C
	WHERE M.CompanyID = C.CompanyID 
	AND D.Symbol = C.Symbol
	AND M.IsCurrent=TRUE)	
	WHERE EXISTS
	(SELECT Symbol
	FROM CSTemp8 I where D.Symbol = I.Symbol AND D.IsCurrent=TRUE
	AND D.EffectiveDate=I.EffectiveDate);

	     

	COUNT=(SELECT COUNT(*) FROM CSTemp8);
	
	    
	INSERT INTO DimSecurity(SK_SecurityID, Symbol, Issue, Status, Name, ExchangeID, SK_CompanyID, 
	SharesOutstanding, FirstTrade, FirstTradeOnExchange, Dividend, IsCurrent, BatchID, EffectiveDate, EndDate)
	SELECT U.SK_SecurityID_value +  row_number() over( order by U.SK_SecurityID_value) AS SK_SecurityID, Symbol, Issue, Status, Name, ExchangeID,
	SK_CompanyID,SharesOutstanding, FirstTrade, FirstTradeOnExchange, Dividend,
	'TRUE', 1, EffectiveDate,'9999-12-31'
	FROM CSTemp8, ADDSECSK_Val U
	WHERE
	CSTemp8.EffectiveDate<>CSTemp8.DimSecEff;


	UPDATE ADDSECSK_Val SET 
	SK_SecurityID_value=SK_SecurityID_value + Count
	WHERE 
	SK_SecurityID_value IS not NULL;

	TRUNCATE  CSTemp4,CSTemp5,CSTemp6,CSTemp7,CSTemp8,CompKeys;
	     

	

		-------------------------------------------------------------------------------------
	ELSIF Action='SEC' THEN

		
	--ADD Status from StatusType.txt
	INSERT INTO STemp1 (PTS, RecType, Symbol, IssueType,FinwireStatus, Status, 
	Name, ExID, ShOut, FirstTradeDate, FirstTradeExchg, Dividend, CoNameOrCIK)
	SELECT PTS, RecType, Symbol, IssueType,C.Status AS FinwireStatus, S.ST_NAME AS Status, 
	Name, ExID, ShOut, FirstTradeDate, FirstTradeExchg, Dividend, CoNameOrCIK
	FROM CSTemp3 C, StatusType S
	WHERE C.Status = S.ST_ID;

	UPDATE  STemp1
	SET 
	EffectiveDate= Date_trunc('day', PTS),
	EndDate = '9999-12-31';



	INSERT INTO STemp2 (PTS, RecType, Symbol, IssueType,Status, Name, ExID, ShOut, FirstTradeDate, 
	FirstTradeExchg, Dividend, CoNameOrCIK, IsCurrent, BatchID, EffectiveDate, EndDate)
	SELECT PTS, RecType, Symbol, IssueType,Status, Name, ExID, ShOut, FirstTradeDate, 
	FirstTradeExchg, Dividend, CoNameOrCIK, IsCurrent, BatchID, EffectiveDate, EndDate
	FROM STemp1
	WHERE
	LENGTH(CoNameOrCIK) >10;
	--translate(CoNameOrCIK, '.1234567890', '.') is null;

	INSERT INTO  STemp3 (PTS, RecType, Symbol, IssueType,Status, Name, ExID, ShOut, FirstTradeDate, 
	FirstTradeExchg, Dividend, CoNameOrCIK, IsCurrent, BatchID, EffectiveDate, EndDate)
	SELECT PTS, RecType, Symbol, IssueType,Status, Name, ExID, ShOut, FirstTradeDate, 
	FirstTradeExchg, Dividend, CoNameOrCIK, IsCurrent, BatchID, EffectiveDate, EndDate
	FROM STemp1
	WHERE
	LENGTH(CoNameOrCIK)=10;


	INSERT INTO STemp4 (PTS, RecType, Symbol, IssueType,Status, Name, ExID, ShOut, FirstTradeDate, 
	FirstTradeExchg, Dividend, CoNameOrCIK, IsCurrent, BatchID, EffectiveDate, EndDate, SK_CompanyID)
	SELECT PTS, RecType, Symbol, IssueType,C.Status, C.Name, ExID, ShOut, FirstTradeDate, 
	FirstTradeExchg, Dividend, CoNameOrCIK, C.IsCurrent, C.BatchID, C.EffectiveDate, C.EndDate, SK_CompanyID
	FROM STemp2 C , DimCompany I
	WHERE
	--I.Status ='Active' AND
	--I.IsCurrent=TRUE AND
	(Date_trunc('day', PTS) >= I.EffectiveDate AND Date_trunc('day', PTS)<I.EndDate) AND
	(C.CoNameOrCIK= I.Name)
	ORDER BY SK_CompanyID ASC;


	INSERT INTO STemp5 (PTS, RecType, Symbol, IssueType,Status, Name, ExID, ShOut, FirstTradeDate, 
	FirstTradeExchg, Dividend, CoNameOrCIK, IsCurrent, BatchID, EffectiveDate, EndDate, SK_CompanyID)
	SELECT PTS, RecType, Symbol, IssueType,C.Status, C.Name, ExID, ShOut, FirstTradeDate, 
	FirstTradeExchg, Dividend, CoNameOrCIK, C.IsCurrent, C.BatchID, C.EffectiveDate, C.EndDate, SK_CompanyID
	FROM STemp3 C, DimCompany I
	WHERE
	--I.Status ='Active' AND
	--I.IsCurrent=TRUE AND
	(Date_trunc('day', PTS) >= I.EffectiveDate AND Date_trunc('day', PTS)<I.EndDate) AND
	--((C.CoNameOrCIK IS NOT NULL) AND (CAST (C.CoNameOrCIK AS INT) = I.CompanyID))
	(CAST (C.CoNameOrCIK AS INT) = I.CompanyID)
	ORDER BY SK_CompanyID ASC;




	INSERT INTO STemp6 (PTS, RecType, Symbol, IssueType,Status, Name, ExID, ShOut, FirstTradeDate, 
	FirstTradeExchg, Dividend, CoNameOrCIK, IsCurrent, BatchID, EffectiveDate, EndDate, SK_CompanyID)
	SELECT PTS, RecType, Symbol, IssueType,Status, Name, ExID, ShOut, FirstTradeDate, 
	FirstTradeExchg, Dividend, CoNameOrCIK, IsCurrent, BatchID, EffectiveDate, EndDate, SK_CompanyID
	FROM STemp4
	UNION
	SELECT PTS, RecType, Symbol, IssueType,Status, Name, ExID, ShOut, FirstTradeDate, 
	FirstTradeExchg, Dividend, CoNameOrCIK, IsCurrent, BatchID, EffectiveDate, EndDate, SK_CompanyID
	FROM STemp5;


	UPDATE DimSecurity D SET
	--Status=  'Inactive',
	IsCurrent=FALSE	,
	EndDate=(SELECT  PTS
	FROM STemp6
	WHERE STemp6.Symbol = D.Symbol)	
	WHERE EXISTS
	(SELECT Symbol
	FROM STemp6 I where D.Symbol = I.Symbol AND D.IsCurrent=TRUE
	AND D.EffectiveDate<>date_trunc('day', PTS));


	INSERT INTO DimSecurity(SK_SecurityID, Symbol, Issue, Status, Name, ExchangeID, SK_CompanyID, 
	SharesOutstanding, FirstTrade, FirstTradeOnExchange, Dividend, IsCurrent, BatchID, EffectiveDate, EndDate)
	SELECT U.SK_SecurityID_value + 1  AS SK_SecurityID, Symbol, IssueType, Status, Name, ExID,
	SK_CompanyID, ShOut::int, to_date(FirstTradeDate,'YYYYMMDD'), to_date(FirstTradeExchg,'YYYYMMDD'),
	Dividend::NUMERIC, IsCurrent, BatchID, EffectiveDate,EndDate
	FROM STemp6, ADDSECSK_Val U ORDER BY Symbol;


	UPDATE ADDSECSK_Val SET 
	SK_SecurityID_value=SK_SecurityID_value+1
	WHERE 
	SK_SecurityID_value IS not NULL;

	TRUNCATE  STemp1,STemp2,STemp3,STemp4,STemp5,STemp6;

	END IF;

	
			
	DELETE FROM CSTemp2 WHERE seq = (SELECT MIN(seq) FROM CSTemp3 AS seq1);             
	DELETE FROM CSTemp3 where seq is not null;
	Action='';	      
	ID=ID+1;

		
	       
	END LOOP ; 








CREATE TEMPORARY TABLE CTemp3 AS
	SELECT * FROM DimCompany
	WHERE 
	SPrating != 'AAA' AND SPrating != 'AA+' AND SPrating != 'AA-' 
	AND SPrating != 'A+' AND SPrating != 'A-' AND SPrating != 'BBB+' AND SPrating != 'BBB-' 
	AND SPrating != 'BB+' AND SPrating != 'BB-' AND SPrating != 'B+' AND SPrating != 'B-'
	AND SPrating != 'CCC+' AND SPrating != 'CCC-'  AND SPrating != 'CC' 
	AND SPrating != 'C' AND SPrating != 'D';


INSERT INTO DImessages(MessageDateAndTime, BatchID, MessageSource, MessageText, MessageType,MessageData)
	SELECT CURRENT_TIMESTAMP, 1, 'DimCompany', 'InvalidSPRating', 'Alert',
	CONCAT('CO_ID = ',CompanyID, ', CO_SP_RATE = ',SPrating)
	FROM
	CTemp3;

	UPDATE DimCompany
	SET 
	SPrating=NULL,
	isLowGrade=NULL
	WHERE 
	SPrating != 'AAA' AND SPrating != 'AA+' AND SPrating != 'AA-' 
	AND SPrating != 'A+' AND SPrating != 'A-' AND SPrating != 'BBB+' AND SPrating != 'BBB-' 
	AND SPrating != 'BB+' AND SPrating != 'BB-' AND SPrating != 'B+' AND SPrating != 'B-'
	AND SPrating != 'CCC+' AND SPrating != 'CCC-'  AND SPrating != 'CC' 
	AND SPrating != 'C' AND SPrating != 'D';






	   
	END;
	$$ LANGUAGE 'plpgsql';