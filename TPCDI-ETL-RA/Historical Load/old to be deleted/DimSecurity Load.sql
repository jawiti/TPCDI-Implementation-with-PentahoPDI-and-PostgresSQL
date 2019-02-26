/*DimSecurity Load*/

DROP FUNCTION IF EXISTS DimSecurityLoad();
CREATE FUNCTION DimSecurityLoad()
RETURNS VOID AS $$
BEGIN
DROP TABLE IF EXISTS  STemp1, STemp2, STemp3,STemp4, STemp5, STemp6, T2S, Upd1,Upd2;




--ADD Status from StatusType.txt
CREATE TEMPORARY TABLE STemp1 AS
SELECT PTS, RecType, Symbol, IssueType,C.Status AS FinwireStatus, S.ST_NAME AS Status, 
Name, ExID, ShOut, FirstTradeDate, FirstTradeExchg, Dividend, CoNameOrCIK
FROM SEC C, StatusType S
WHERE C.Status = S.ST_ID;



 ALTER TABLE STemp1
  ADD IsCurrent BOOLEAN DEFAULT TRUE,
	ADD BatchID INT DEFAULT 1,
  ADD EffectiveDate Date,
    ADD EndDate Date;

UPDATE  STemp1
SET 
EffectiveDate= to_date(PTS,'YYYYMMDD'),
EndDate = '9999-12-31';



CREATE TEMPORARY TABLE STemp2 AS
SELECT PTS, RecType, Symbol, IssueType,Status, Name, ExID, ShOut, FirstTradeDate, 
FirstTradeExchg, Dividend, CoNameOrCIK, IsCurrent, BatchID, EffectiveDate, EndDate
FROM STemp1
WHERE
LENGTH(CoNameOrCIK) >10;
--translate(CoNameOrCIK, '.1234567890', '.') is null;

CREATE TEMPORARY TABLE STemp3 AS
SELECT PTS, RecType, Symbol, IssueType,Status, Name, ExID, ShOut, FirstTradeDate, 
FirstTradeExchg, Dividend, CoNameOrCIK, IsCurrent, BatchID, EffectiveDate, EndDate
FROM STemp1
WHERE
LENGTH(CoNameOrCIK)=10;


CREATE TEMPORARY TABLE STemp4 AS
SELECT PTS, RecType, Symbol, IssueType,C.Status, C.Name, ExID, ShOut, FirstTradeDate, 
FirstTradeExchg, Dividend, CoNameOrCIK, C.IsCurrent, C.BatchID, C.EffectiveDate, C.EndDate, SK_CompanyID
FROM STemp2 C , DimCompany I
WHERE
--I.Status ='Active' AND
--I.IsCurrent=TRUE AND
(to_date(PTS,'YYYYMMDD') >= I.EffectiveDate AND to_date(PTS,'YYYYMMDD')<I.EndDate) AND
(C.CoNameOrCIK= I.Name)
ORDER BY SK_CompanyID ASC;


CREATE TEMPORARY TABLE STemp5 AS
SELECT PTS, RecType, Symbol, IssueType,C.Status, C.Name, ExID, ShOut, FirstTradeDate, 
FirstTradeExchg, Dividend, CoNameOrCIK, C.IsCurrent, C.BatchID, C.EffectiveDate, C.EndDate, SK_CompanyID
FROM STemp3 C, DimCompany I
WHERE
--I.Status ='Active' AND
--I.IsCurrent=TRUE AND
(to_date(PTS,'YYYYMMDD') >= I.EffectiveDate AND to_date(PTS,'YYYYMMDD')<I.EndDate) AND
--((C.CoNameOrCIK IS NOT NULL) AND (CAST (C.CoNameOrCIK AS INT) = I.CompanyID))
(CAST (C.CoNameOrCIK AS INT) = I.CompanyID)
ORDER BY SK_CompanyID ASC;




CREATE TEMPORARY TABLE STemp6 AS
SELECT * FROM STemp4
UNION
SELECT * FROM STemp5;






INSERT INTO DimSecurity(SK_SecurityID, Symbol, Issue, Status, Name, ExchangeID, SK_CompanyID, 
SharesOutstanding, FirstTrade, FirstTradeOnExchange, Dividend, IsCurrent, BatchID, EffectiveDate, EndDate)
SELECT row_number() over( order by 1) AS SK_SecurityID, Symbol, IssueType, Status, Name, ExID,
 SK_CompanyID, ShOut::int, to_date(FirstTradeDate,'YYYYMMDD'), to_date(FirstTradeExchg,'YYYYMMDD'),
  Dividend::NUMERIC, IsCurrent, BatchID, EffectiveDate,EndDate
FROM STemp6 ORDER BY Symbol;



--Set enddate and IsCurrent of all UPDATE tuples 
CREATE TEMPORARY TABLE T2S AS
    SELECT *,
    lead(EffectiveDate) over (partition by Symbol order by EffectiveDate) as enddatenew,
    lead(iscurrent) over (partition by Symbol order by EffectiveDate) as iscurrentnew
    FROM DimSecurity;-- where iscurrent=true;


UPDATE T2S SET
iscurrent=FALSE,
enddate= enddatenew
WHERE iscurrentnew is not null and enddatenew is not null;


DELETE FROM DimSecurity WHERE SK_SecurityID IS NOT NULL;



INSERT INTO DimSecurity(SK_SecurityID, Symbol, Issue, Status, Name, ExchangeID, SK_CompanyID, 
SharesOutstanding, FirstTrade, FirstTradeOnExchange, Dividend, IsCurrent, BatchID, EffectiveDate, EndDate)
	SELECT SK_SecurityID, Symbol, Issue, Status, Name, ExchangeID, SK_CompanyID, 
SharesOutstanding, FirstTrade, FirstTradeOnExchange, Dividend, IsCurrent, BatchID, EffectiveDate, EndDate
	FROM T2S;

--to update dim security upon dimcompany updates
/*CREATE TEMPORARY TABLE Upd1 AS
    SELECT Sk_CompanyID, CompanyID,EffectiveDate,EndDate,IsCurrent
    FROM ToUpadateDimSec;


  CREATE TEMPORARY TABLE Upd2 AS
SELECT  I.Sk_CompanyID, I.CompanyID,I.EffectiveDate,I.EndDate,I.IsCurrent,
SK_SecurityID, Symbol, Issue, S.Status, S.Name, S.ExchangeID, 
SharesOutstanding, FirstTrade, FirstTradeOnExchange, Dividend--,I.IsCurrent,S.IsCurrent,C.IsCurrent,S.BatchID
FROM Upd1 I , DimSecurity S , DimCompany C
WHERE
S.Sk_CompanyID = C.Sk_CompanyID AND
I.Sk_CompanyID = C.Sk_CompanyID ORDER BY CompanyID;

-- AND
 --i.Iscurrent=TRUE and s.iscurrent=true;



	Update DimSecurity D
	set 
	IsCurrent=False,
	 EndDate = (SELECT Upd1.EndDate
         FROM Upd1
         WHERE Upd1.SK_CompanyID = D.SK_CompanyID AND D.IsCurrent = true)
	WHERE EXISTS
	(select c.SK_CompanyID from DimSecurity a
	 join DimCompany c on a.SK_CompanyID = c.SK_CompanyID and 
	 c.EffectiveDate <= a.EffectiveDate and a.EndDate > c.EndDate and c.batchid=1 order by SK_CompanyID
	);

SELECT Upd1.EndDate
         FROM Upd1,DimSecurity
         WHERE Upd1.SK_CompanyID = DimSecurity.SK_CompanyID

*/
END;
$$ LANGUAGE 'plpgsql';