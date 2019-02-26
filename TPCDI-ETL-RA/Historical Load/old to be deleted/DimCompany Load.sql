/*DimCompany Load*/
DROP FUNCTION IF EXISTS DimCompanyLoad();
CREATE FUNCTION DimCompanyLoad()
RETURNS VOID AS $$
BEGIN
DROP TABLE IF EXISTS   CTemp1, CTemp2, CTemp3, T2C, ToUpadateDimSec;



--ADD Status from StatusType.txt
CREATE TEMPORARY TABLE CTemp1 AS
SELECT PTS,RecType,CompanyName,CIK,C.Status AS FinwireStatus, S.ST_NAME AS Status, IndustryID,SPrating,FoundingDate,AddrLine1,
AddrLine2,PostalCode,City,StateProvince,Country,CEOname,Description
FROM CMP C, StatusType S 
WHERE C.Status = S.ST_ID order by CIK;

--ADD IndustrID from Industry.txt
CREATE TEMPORARY TABLE CTemp2 AS
SELECT PTS,RecType,CompanyName, CIK, Status, 
C.IndustryID AS FinwireIndustryID, I.IN_NAME AS Industry,
SPrating,FoundingDate,AddrLine1,AddrLine2,PostalCode,City,
StateProvince,Country,CEOname,Description
FROM CTemp1 C, Industry I
WHERE C.IndustryID = I.IN_ID ORDER BY CIK ASC;


	ALTER TABLE CTemp2
  ADD isLowGrade BOOLEAN DEFAULT TRUE,
  ADD IsCurrent BOOLEAN DEFAULT TRUE,
	ADD BatchID INT DEFAULT 1,
  ADD EffectiveDate Date,
    ADD EndDate Date;

  
UPDATE  CTemp2
SET 
isLowGrade=false
WHERE
substr(CTemp2.SPrating, 1, 1)='A' OR substr(CTemp2.SPrating, 1, 3)='BBB';

UPDATE  CTemp2
SET
EffectiveDate= to_date(PTS,'YYYYMMDD'),
EndDate = '9999-12-31';

INSERT INTO DimCompany(SK_CompanyID, CompanyID, Status, Name, Industry, SPrating, isLowGrade, CEO, 
AddressLine1, AddressLine2, PostalCode, City, StateProv, Country, Description, FoundingDate,
 IsCurrent, BatchID, EffectiveDate, EndDate)
SELECT row_number() over( order by 1) AS SK_CompanyID, CIK::int, Status, CompanyName, Industry, SPrating,
isLowGrade, CEOname, AddrLine1,AddrLine2,PostalCode,City, StateProvince,Country,Description,
to_date(FoundingDate,'YYYYMMDD'),  IsCurrent, BatchID, EffectiveDate,EndDate
FROM CTemp2;





--Set enddate and IsCurrent of all UPDATES tuples 
CREATE TEMPORARY TABLE T2C AS
    SELECT *,
    lead(EffectiveDate) over (partition by companyid order by EffectiveDate) as enddatenew,
    lead(iscurrent) over (partition by companyid order by EffectiveDate) as iscurrentnew
    FROM DimCompany;-- where iscurrent=true;


  
/*INSERT INTO ToUpadateDimSec(Sk_CompanyID, CompanyID,EffectiveDate,EndDate,IsCurrent)
SELECT Sk_CompanyID, CompanyID,EffectiveDate,EndDate,IsCurrentNew
FROM T2C
WHERE 
EndDateNew IS NOT NULL ORDER BY CompanyID,EffectiveDate;*/


UPDATE T2C SET
iscurrent=FALSE,
enddate= enddatenew
WHERE iscurrentnew is not null and enddatenew is not null;



DELETE FROM DimCompany WHERE SK_CompanyID IS NOT NULL;


INSERT INTO DimCompany(SK_CompanyID, CompanyID, Status, Name, Industry, SPrating, isLowGrade, CEO, 
AddressLine1, AddressLine2, PostalCode, City, StateProv, Country, Description, FoundingDate,
 IsCurrent, BatchID, EffectiveDate, EndDate)
	SELECT SK_CompanyID, CompanyID, Status, Name, Industry, SPrating, isLowGrade, CEO, 
AddressLine1, AddressLine2, PostalCode, City, StateProv, Country, Description, FoundingDate,
 IsCurrent, BatchID, EffectiveDate, EndDate
	FROM T2C;



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