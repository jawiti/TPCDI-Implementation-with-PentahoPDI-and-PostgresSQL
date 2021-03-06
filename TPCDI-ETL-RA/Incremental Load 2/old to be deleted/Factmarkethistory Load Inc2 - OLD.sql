﻿/*Factmarkethistory Inc1 Load*/
DROP FUNCTION IF EXISTS FactmarkethistoryLoadInc2();
CREATE FUNCTION FactmarkethistoryLoadInc2()
RETURNS VOID AS $$
BEGIN

DROP TABLE IF EXISTS FMHI2Temp1,FMHI2Temp2,FMHI2Temp3,FMHI2Temp4,FMHI2Temp5,FMHI2Temp6,FMHI2Temp7,FMHI2Temp8,FMHI2Temp9,
FMHI2Temp10,FMHI2Temp11,FMHI2Temp12;



--Get K_SecurityID, SK_CompanyID
CREATE TEMPORARY TABLE FMHI2Temp1 AS
SELECT DM_DATE, DM_S_SYMB, DM_CLOSE, DM_HIGH, DM_LOW, DM_VOL, SK_SecurityID, SK_CompanyID
FROM DailyMarket2 D, DimSecurity S
WHERE D.DM_S_SYMB = S.Symbol AND
S.IsCurrent = TRUE;
--DM_DATE >= EffectiveDate AND
--DM_DATE < EndDate;

--Get SK_DateID
CREATE TEMPORARY TABLE FMHI2Temp2 AS
SELECT DM_DATE, DM_S_SYMB, DM_CLOSE, DM_HIGH, DM_LOW, DM_VOL, SK_SecurityID, SK_CompanyID, SK_DateID
FROM FMHI2Temp1 D, DimDate S
WHERE D.DM_DATE = S.DateValue;


--Get max(DM_HIGH) and min(DM_LOW) for the last one year
CREATE TEMPORARY TABLE FMHI2Temp3 AS
SELECT DM_DATE, DM_S_SYMB, DM_CLOSE, DM_HIGH, DM_LOW, DM_VOL, SK_SecurityID, SK_CompanyID, SK_DateID,
       max(DM_HIGH) OVER (PARTITION BY DM_S_SYMB) as FiftyTwoWeekHigh,
       min(DM_LOW) OVER (PARTITION BY DM_S_SYMB) as FiftyTwoWeekLow
FROM FMHI2Temp2 
WHERE DM_DATE BETWEEN (DM_DATE - interval '1 year') AND DM_DATE;


CREATE TEMPORARY TABLE FMHI2Temp4 AS
SELECT distinct DM_HIGH,  MIN(DM_DATE) OVER (PARTITION BY DM_HIGH) as SK_FiftyTwoWeek
FROM FMHI2Temp2;


CREATE TEMPORARY TABLE FMHI2Temp5 AS
SELECT distinct DM_LOW,  MIN(DM_DATE) OVER (PARTITION BY DM_LOW) as SK_FiftyTwoWeekL
FROM FMHI2Temp2;

--Join to get FiftyTwoWeekHigh and SK_FiftyTwoWeek
CREATE TEMPORARY TABLE FMHI2Temp6 AS
SELECT DM_DATE, DM_S_SYMB, DM_CLOSE, F.DM_HIGH, DM_LOW, DM_VOL, SK_SecurityID, 
SK_CompanyID, SK_DateID, FiftyTwoWeekHigh, FiftyTwoWeekLow, SK_FiftyTwoWeek
FROM FMHI2Temp3 F LEFT OUTER JOIN FMHI2Temp4 T
ON
(F.FiftyTwoWeekHigh = T.DM_HIGH);

--Join to get FiftyTwoWeekLow and SK_FiftyTwoWeekL
CREATE TEMPORARY TABLE FMHI2Temp7 AS
SELECT DM_DATE, DM_S_SYMB, DM_CLOSE, F.DM_HIGH, F.DM_LOW, DM_VOL, SK_SecurityID, 
SK_CompanyID, SK_DateID, FiftyTwoWeekHigh, FiftyTwoWeekLow, SK_FiftyTwoWeek,SK_FiftyTwoWeekL
FROM FMHI2Temp6 F LEFT OUTER JOIN FMHI2Temp5 T
ON
(F.FiftyTwoWeekLow = T.DM_LOW);


--Calculate SumOfEPS of each company in Fin to get PERatio
CREATE TEMPORARY TABLE FMHI2Temp8 AS
SELECT SUM(EPS::NUMERIC) AS SumOfEPS, CoNameOrCIK, name, SK_Companyid
FROM FIN F, DimCompany D
where 
F.conameorcik = D.name
GROUP BY CoNameOrCIK, name, SK_Companyid ORDER BY CoNameOrCIK;


--Divide DM_CLOSE by SumOfEPS to get PERatio
CREATE TEMPORARY TABLE FMHI2Temp9 AS
SELECT DM_DATE, DM_S_SYMB, DM_CLOSE, F.DM_HIGH, F.DM_LOW, DM_VOL, SK_SecurityID, 
F.SK_CompanyID, SK_DateID, FiftyTwoWeekHigh, FiftyTwoWeekLow, SK_FiftyTwoWeek,
SK_FiftyTwoWeekL,SumOfEPS, DM_CLOSE/SumOfEPS AS PERatio
FROM
FMHI2Temp7 F LEFT OUTER JOIN FMHI2Temp8 T
ON
(F.SK_CompanyID = T.SK_Companyid)ORDER BY SK_Companyid;


CREATE TEMPORARY TABLE FMHI2Temp10 AS
SELECT DM_DATE, DM_S_SYMB, DM_CLOSE, F.DM_HIGH, F.DM_LOW, DM_VOL, F.SK_SecurityID, 
F.SK_CompanyID, SK_DateID, FiftyTwoWeekHigh, FiftyTwoWeekLow, SK_FiftyTwoWeek,
SK_FiftyTwoWeekL, PERatio, Dividend, (Dividend/DM_CLOSE)*100 AS Yield
FROM FMHI2Temp9 F LEFT OUTER JOIN DimSecurity D
ON
(F.DM_S_SYMB = D.Symbol AND
D.IsCurrent=TRUE);
--DM_DATE >= EffectiveDate AND
--DM_DATE < EndDate


CREATE TEMPORARY TABLE FMHI2Temp11 AS
SELECT DM_DATE, DM_S_SYMB, DM_CLOSE, F.DM_HIGH, F.DM_LOW, DM_VOL, F.SK_SecurityID, 
F.SK_CompanyID, F.SK_DateID, FiftyTwoWeekHigh, FiftyTwoWeekLow, SK_FiftyTwoWeek,
SK_FiftyTwoWeekL, PERatio, Dividend, Yield, D.SK_DateID AS SK_FiftyTwoWeekNEW
  FROM FMHI2Temp10 F LEFT OUTER JOIN DimDate D
ON
(F.SK_FiftyTwoWeek = D.Datevalue);


CREATE TEMPORARY TABLE FMHI2Temp12 AS
SELECT DM_DATE, DM_S_SYMB, DM_CLOSE, F.DM_HIGH, F.DM_LOW, DM_VOL, F.SK_SecurityID, 
F.SK_CompanyID, F.SK_DateID, FiftyTwoWeekHigh, FiftyTwoWeekLow, SK_FiftyTwoWeek,
SK_FiftyTwoWeekL, PERatio, Dividend, Yield, SK_FiftyTwoWeekNEW, D.SK_DateID AS SK_FiftyTwoWeekLNEW
  FROM FMHI2Temp11 F LEFT OUTER JOIN DimDate D
ON
(F.SK_FiftyTwoWeekL = D.Datevalue);


INSERT INTO Factmarkethistory( SK_SecurityID, SK_CompanyID, SK_DateID, PERatio, Yield, FiftyTwoWeekHigh,
SK_FiftyTwoWeek, FiftyTwoWeekLow, SK_FiftyTwoWeekL, ClosePrice,  DayHigh, DayLow, Volume, BatchID)
SELECT SK_SecurityID, SK_CompanyID, SK_DateID, PERatio, Yield, FiftyTwoWeekHigh,
SK_FiftyTwoWeekNEW, FiftyTwoWeekLow, SK_FiftyTwoWeekLNEW, DM_CLOSE, DM_HIGH, DM_LOW, DM_VOL, 3
FROM
FMHI2Temp12;

INSERT INTO DImessages(MessageDateAndTime, BatchID, MessageSource, MessageText, MessageType,MessageData)
	SELECT CURRENT_TIMESTAMP, 3, 'FactMarketHistory', 'No earnings for company', 'Alert',
	CONCAT('DM_S_SYMB = ',DM_S_SYMB)
	FROM
	FMHI2Temp12 
	WHERE
	PERatio IS NULL;
END;
$$ LANGUAGE 'plpgsql';
