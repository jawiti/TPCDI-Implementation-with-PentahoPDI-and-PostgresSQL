/*Factmarkethistory Load*/

DROP FUNCTION IF EXISTS FactmarkethistoryLoad();
CREATE FUNCTION FactmarkethistoryLoad()
RETURNS VOID AS $$
BEGIN

DROP TABLE IF EXISTS FMHTemp1,FMHTemp2,FMHTemp3,FMHTemp4,FMHTemp5,FMHTemp6,FMHTemp7,FMHTemp8,FMHTemp9,
FMHTemp10,FMHTemp11,FMHTemp12;
--DELETE  FROM Factmarkethistory where SK_SecurityID is not null;



CREATE TEMPORARY TABLE FMHTemp1 AS
SELECT DM_DATE, DM_S_SYMB, DM_CLOSE, DM_HIGH, DM_LOW, DM_VOL, SK_SecurityID, SK_CompanyID
FROM DailyMarket D, DimSecurity S
WHERE D.DM_S_SYMB = S.Symbol AND
DM_DATE >= EffectiveDate AND
DM_DATE < EndDate;


CREATE TEMPORARY TABLE FMHTemp2 AS
SELECT DM_DATE, DM_S_SYMB, DM_CLOSE, DM_HIGH, DM_LOW, DM_VOL, SK_SecurityID, SK_CompanyID, SK_DateID
FROM FMHTemp1 D, DimDate S
WHERE D.DM_DATE = S.DateValue;




CREATE TEMPORARY TABLE FMHTemp3 AS
SELECT DM_DATE, DM_S_SYMB, DM_CLOSE, DM_HIGH, DM_LOW, DM_VOL, SK_SecurityID, SK_CompanyID, SK_DateID,
       max(DM_HIGH) OVER (PARTITION BY DM_S_SYMB) as FiftyTwoWeekHigh,
       min(DM_LOW) OVER (PARTITION BY DM_S_SYMB) as FiftyTwoWeekLow
FROM FMHTemp2 
WHERE DM_DATE BETWEEN (DM_DATE - interval '1 year') AND DM_DATE;



CREATE TEMPORARY TABLE FMHTemp4 AS
SELECT distinct DM_HIGH,  MIN(DM_DATE) OVER (PARTITION BY DM_HIGH) as SK_FiftyTwoWeek
FROM FMHTemp2;


CREATE TEMPORARY TABLE FMHTemp5 AS
SELECT distinct DM_LOW,  MIN(DM_DATE) OVER (PARTITION BY DM_LOW) as SK_FiftyTwoWeekL
FROM FMHTemp2;


CREATE TEMPORARY TABLE FMHTemp6 AS
SELECT DM_DATE, DM_S_SYMB, DM_CLOSE, F.DM_HIGH, DM_LOW, DM_VOL, SK_SecurityID, 
SK_CompanyID, SK_DateID, FiftyTwoWeekHigh, FiftyTwoWeekLow, SK_FiftyTwoWeek
FROM FMHTemp3 F LEFT OUTER JOIN FMHTemp4 T
ON
(F.FiftyTwoWeekHigh = T.DM_HIGH);


CREATE TEMPORARY TABLE FMHTemp7 AS
SELECT DM_DATE, DM_S_SYMB, DM_CLOSE, F.DM_HIGH, F.DM_LOW, DM_VOL, SK_SecurityID, 
SK_CompanyID, SK_DateID, FiftyTwoWeekHigh, FiftyTwoWeekLow, SK_FiftyTwoWeek,SK_FiftyTwoWeekL
FROM FMHTemp6 F LEFT OUTER JOIN FMHTemp5 T
ON
(F.FiftyTwoWeekLow = T.DM_LOW);



/*ALTER TABLE FMHTemp7
ADD COLUMN PERatio numeric(8,2),
ADD COLUMN Yield numeric(5,2)
;*/

/*CREATE TEMPORARY TABLE FMHTemp8 AS
SELECT SUM(EPS::NUMERIC) AS SumOfEPS, CoNameOrCIK 
FROM FIN
GROUP BY CoNameOrCIK ORDER BY CoNameOrCIK;
*/

--Calculate SumOfEPS of each company in Fin to get PERatio
CREATE TEMPORARY TABLE FMHTemp8 AS
SELECT SUM(EPS::NUMERIC) AS SumOfEPS, CoNameOrCIK, name, SK_Companyid
FROM FIN F, DimCompany D
where 
F.conameorcik = D.name
GROUP BY CoNameOrCIK, name, SK_Companyid ORDER BY CoNameOrCIK;



CREATE TEMPORARY TABLE FMHTemp9 AS
SELECT DM_DATE, DM_S_SYMB, DM_CLOSE, F.DM_HIGH, F.DM_LOW, DM_VOL, SK_SecurityID, 
F.SK_CompanyID, SK_DateID, FiftyTwoWeekHigh, FiftyTwoWeekLow, SK_FiftyTwoWeek,
SK_FiftyTwoWeekL, DM_CLOSE/SumOfEPS AS PERatio
FROM
FMHTemp7 F LEFT OUTER JOIN FMHTemp8 T
ON
(F.SK_CompanyID = T.SK_CompanyID);


CREATE TEMPORARY TABLE FMHTemp10 AS
SELECT DM_DATE, DM_S_SYMB, DM_CLOSE, F.DM_HIGH, F.DM_LOW, DM_VOL, F.SK_SecurityID, 
F.SK_CompanyID, SK_DateID, FiftyTwoWeekHigh, FiftyTwoWeekLow, SK_FiftyTwoWeek,
SK_FiftyTwoWeekL, PERatio, Dividend, (Dividend/DM_CLOSE)*100 AS Yield
FROM FMHTemp9 F LEFT OUTER JOIN DimSecurity D
ON
(F.DM_S_SYMB = D.Symbol AND
DM_DATE >= EffectiveDate AND
DM_DATE < EndDate
);

CREATE TEMPORARY TABLE FMHTemp11 AS
SELECT DM_DATE, DM_S_SYMB, DM_CLOSE, F.DM_HIGH, F.DM_LOW, DM_VOL, F.SK_SecurityID, 
F.SK_CompanyID, F.SK_DateID, FiftyTwoWeekHigh, FiftyTwoWeekLow, SK_FiftyTwoWeek,
SK_FiftyTwoWeekL, PERatio, Dividend, Yield, D.SK_DateID AS SK_FiftyTwoWeekNEW
  FROM FMHTemp10 F LEFT OUTER JOIN DimDate D
ON
(F.SK_FiftyTwoWeek = D.Datevalue);


CREATE TEMPORARY TABLE FMHTemp12 AS
SELECT DM_DATE, DM_S_SYMB, DM_CLOSE, F.DM_HIGH, F.DM_LOW, DM_VOL, F.SK_SecurityID, 
F.SK_CompanyID, F.SK_DateID, FiftyTwoWeekHigh, FiftyTwoWeekLow, SK_FiftyTwoWeek,
SK_FiftyTwoWeekL, PERatio, Dividend, Yield, SK_FiftyTwoWeekNEW, D.SK_DateID AS SK_FiftyTwoWeekLNEW
  FROM FMHTemp11 F LEFT OUTER JOIN DimDate D
ON
(F.SK_FiftyTwoWeekL = D.Datevalue);


INSERT INTO Factmarkethistory( SK_SecurityID, SK_CompanyID, SK_DateID, PERatio, Yield, FiftyTwoWeekHigh,
SK_FiftyTwoWeek, FiftyTwoWeekLow, SK_FiftyTwoWeekL, ClosePrice,  DayHigh, DayLow, Volume, BatchID)
SELECT SK_SecurityID, SK_CompanyID, SK_DateID, PERatio, Yield, FiftyTwoWeekHigh,
SK_FiftyTwoWeekNEW, FiftyTwoWeekLow, SK_FiftyTwoWeekLNEW, DM_CLOSE, DM_HIGH, DM_LOW, DM_VOL, 1
FROM
FMHTemp12;

INSERT INTO DImessages(MessageDateAndTime, BatchID, MessageSource, MessageText, MessageType,MessageData)
	SELECT CURRENT_TIMESTAMP, 1, 'FactMarketHistory', 'No earnings for company', 'Alert',
	CONCAT('DM_S_SYMB = ',DM_S_SYMB)
	FROM
	FMHTemp12 
	WHERE
	PERatio IS NULL;
END;
$$ LANGUAGE 'plpgsql';
