/*DimDate Load*/
DROP FUNCTION IF EXISTS DimDateLoad();
CREATE FUNCTION DimDateLoad()
RETURNS VOID AS $$
BEGIN
	


	COPY DimDate FROM 'D:\TPC-DI_Staging_Area\data\Batch1\Date.txt' 
	( FORMAT text, DELIMITER('|'), ENCODING 'WIN1252' );
END;
$$ LANGUAGE 'plpgsql';