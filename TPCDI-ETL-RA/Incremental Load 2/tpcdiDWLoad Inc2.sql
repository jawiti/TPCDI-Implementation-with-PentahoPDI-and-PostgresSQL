/*tpcdiDWLoad*/

DROP FUNCTION IF EXISTS tpcdiDWLoadInc2();
CREATE FUNCTION tpcdiDWLoadInc2()
RETURNS VOID AS $$
BEGIN

	PERFORM HelperTablesLoadInc2();	
	PERFORM ProspectLoadInc2();
	PERFORM DimCustomerLoadInc12();
	PERFORM DimCustomerUpdateLoadInc2();
	PERFORM DimAccountLoadInc2();
	PERFORM DimAccountUpdateLoadInc2();
	PERFORM DimTradeLoadInc2();
	PERFORM FactCashBalancesLoadInc2();
	PERFORM FactholdingsLoadInc2();
	PERFORM FactmarkethistoryLoadInc2();	
	PERFORM FactwatchesLoadInc2();
	

	
END;
$$ LANGUAGE 'plpgsql';

SELECT tpcdiDWLoadInc2();