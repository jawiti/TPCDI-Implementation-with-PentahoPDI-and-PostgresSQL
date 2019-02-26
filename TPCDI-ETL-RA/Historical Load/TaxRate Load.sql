/*TaxRate Load*/
DROP FUNCTION IF EXISTS taxrateLoad();
CREATE FUNCTION taxrateLoad()
RETURNS VOID AS $$
BEGIN
	

	COPY TaxRate FROM 'D:\TPC-DI_Staging_Area\data\Batch1\TaxRate.txt' 
	( FORMAT text, DELIMITER('|'), ENCODING 'WIN1252' );

	-- Put a NULL value in place of ''
	--UPDATE TempCities SET State = NULL where State = '';
END;
$$ LANGUAGE 'plpgsql';