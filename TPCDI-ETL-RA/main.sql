 /*tpcdiDWLoad*/

DROP FUNCTION IF EXISTS mainDWLoad();
CREATE FUNCTION mainDWLoad()
RETURNS VOID AS $$
BEGIN



--Our Implementation
	----Part 1
	--PERFORM CreateSchema();
	--PERFORM BatchValidationInitial();
	--PERFORM tpcdiDWLoad();
	--PERFORM BatchValidationHistorical();
	--PERFORM tpcdiDWLoadInc1();
	--PERFORM BatchValidationInc1();
	--PERFORM tpcdiDWLoadInc2();
	--PERFORM BatchValidationInc2();
	----PERFORM AutomatedAudit();

	
END;
$$ LANGUAGE 'plpgsql';

SELECT mainDWLoad();