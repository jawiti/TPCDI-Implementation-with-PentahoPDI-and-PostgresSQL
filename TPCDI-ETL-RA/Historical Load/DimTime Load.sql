/*DimTime Load*/


DROP FUNCTION IF EXISTS DimTimeLoad();
CREATE FUNCTION DimTimeLoad()
RETURNS VOID AS $$
BEGIN



	DROP TABLE IF EXISTS temptime;
	DELETE  FROM DimTime where SK_TimeID is not null;
	CREATE TEMPORARY TABLE temptime(
	SK_TimeID INTEGER Not NULL,
	TimeValue TIME Not NULL,
	HourID numeric(2) Not NULL,
	HourDesc CHAR(20) Not NULL,
	MinuteID numeric(2) Not NULL,
	MinuteDesc CHAR(20) Not NULL,
	SecondID numeric(2) Not NULL,
	SecondDesc CHAR(20) Not NULL,
	MarketHoursFlag BOOLEAN,
	OfficeHoursFlag BOOLEAN
	);
	
	COPY temptime FROM 'D:\TPC-DI_Staging_Area\data\Batch1\time.txt' 
	( FORMAT text, ENCODING 'UTF8', DELIMITER '|' );


	INSERT INTO DimTime(SK_TimeID,TimeValue,HourID,HourDesc,MinuteID,MinuteDesc,SecondID,
	SecondDesc,MarketHoursFlag,OfficeHoursFlag)
	SELECT SK_TimeID,TimeValue,HourID,HourDesc,MinuteID,MinuteDesc,SecondID,
	SecondDesc,MarketHoursFlag,OfficeHoursFlag
	FROM
	temptime;

	END;
$$ LANGUAGE 'plpgsql';
 
