/* Financial Load */

DROP FUNCTION IF EXISTS FinancialLoad();
CREATE FUNCTION FinancialLoad()
RETURNS VOID AS $$
BEGIN

	DROP TABLE IF EXISTS   FinTemp1,FinTemp2,FinTemp3,FinTemp4,FinTemp5;
	DELETE  FROM Financial WHERE SK_CompanyID IS NOT NULL;

	CREATE TEMPORARY TABLE FinTemp1 AS
	SELECT  PTS, RecType, Year, Quarter, QtrStartDate, Revenue, Earnings, EPS,
	DillutedEPS, Margin, Inventory, Assets, Liabilities, ShOut, DillutedShOut, CoNameOrCIK
	FROM Fin
	WHERE
	LENGTH(CoNameOrCIK) >10;


	CREATE TEMPORARY TABLE FinTemp2 AS
	SELECT  PTS, RecType, Year, Quarter, QtrStartDate, Revenue, Earnings, EPS,
	DillutedEPS, Margin, Inventory, Assets, Liabilities, ShOut, DillutedShOut, CoNameOrCIK
	FROM Fin
	WHERE
	LENGTH(CoNameOrCIK) =10;



	CREATE TEMPORARY TABLE FinTemp3 AS
	SELECT PTS, RecType, Year, Quarter, QtrStartDate, Revenue, Earnings, EPS,
	DillutedEPS, Margin, Inventory, Assets, Liabilities, ShOut, DillutedShOut, CoNameOrCIK, SK_CompanyID
	FROM FinTemp1 F, DimCompany D
	WHERE 
	--D.Status = 'Active' AND
	(D.EffectiveDate <= to_date(PTS,'YYYYMMDD') AND to_date(PTS,'YYYYMMDD')<D.EndDate) AND
	F.CoNameOrCIK = D.Name;  
	--OR F.CoNameOrCIK =D.CompanyID;

	CREATE TEMPORARY TABLE FinTemp4 AS
	SELECT PTS, RecType, Year, Quarter, QtrStartDate, Revenue, Earnings, EPS,
	DillutedEPS, Margin, Inventory, Assets, Liabilities, ShOut, DillutedShOut, CoNameOrCIK, SK_CompanyID
	FROM FinTemp2 F, DimCompany D
	WHERE 
	--D.Status = 'Active' AND
	(D.EffectiveDate <= to_date(PTS,'YYYYMMDD') AND to_date(PTS,'YYYYMMDD')<D.EndDate) AND
	CAST (F.CoNameOrCIK AS INT) =D.CompanyID;


	CREATE TEMPORARY TABLE FinTemp5 AS
	SELECT * FROM FinTemp3
	UNION
	SELECT * FROM FinTemp4;


	INSERT INTO Financial(SK_CompanyID, FI_YEAR, FI_QTR, FI_QTR_START_DATE, FI_REVENUE, FI_NET_EARN,
	 FI_BASIC_EPS, FI_DILUT_EPS, FI_MARGIN, FI_INVENTORY, FI_ASSETS, FI_LIABILITY, FI_OUT_BASIC,
	 FI_OUT_DILUT)
	 SELECT SK_CompanyID, Year::NUMERIC(4), Quarter::NUMERIC(1), QtrStartDate::DATE, Revenue::NUMERIC(15,2), 
	 Earnings::NUMERIC(15,2), EPS::NUMERIC(10,2), DillutedEPS::NUMERIC(10,2),  Margin::NUMERIC(10,2),
	 Inventory::NUMERIC(15,2), Assets::NUMERIC(15,2), Liabilities::NUMERIC(15,2), 
	 ShOut::NUMERIC(12), DillutedShOut::NUMERIC(12)
	 FROM 
	 FinTemp5;
	 
END;
$$ LANGUAGE 'plpgsql';

--SELECT SK_CompanyID, COUNT(*) FROM Financial GROUP BY SK_CompanyID;