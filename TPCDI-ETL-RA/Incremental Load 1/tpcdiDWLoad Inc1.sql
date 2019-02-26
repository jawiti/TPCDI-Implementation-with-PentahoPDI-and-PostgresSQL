/*tpcdiDWLoad*/

DROP FUNCTION IF EXISTS tpcdiDWLoadInc1();
CREATE FUNCTION tpcdiDWLoadInc1()
RETURNS VOID AS $$
BEGIN


	PERFORM HelperTablesLoadInc1();	
	PERFORM ProspectLoadInc1();
	PERFORM DimCustomerLoadInc11();
	PERFORM DimCustomerUpdateLoadInc1();
	PERFORM DimAccountLoadInc1();
	PERFORM DimAccountUpdateLoadInc1();
	PERFORM DimTradeLoadInc1();
	PERFORM FactCashBalancesLoadInc1();
	PERFORM FactholdingsLoadInc1();
	PERFORM FactmarkethistoryLoadInc1();	
	PERFORM FactwatchesLoadInc1();
	

	
END;
$$ LANGUAGE 'plpgsql';

SELECT tpcdiDWLoadInc1();