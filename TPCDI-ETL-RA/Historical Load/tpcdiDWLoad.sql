 /*tpcdiDWLoad*/

DROP FUNCTION IF EXISTS tpcdiDWLoad();
CREATE FUNCTION tpcdiDWLoad()
RETURNS VOID AS $$
BEGIN




	PERFORM FinewireMergeLoad();
	PERFORM HelperTablesLoad();	
	PERFORM taxrateLoad();
	PERFORM DimDateLoad();
	PERFORM ProspectLoad();
	PERFORM HelperTablesCusAcctLoad();
	PERFORM HelperTablesComSecLoad();		
	PERFORM DimBrokerLoad();
	PERFORM DimCustomer_AccountLoad();
	PERFORM DimCompany_SecurityLoad();
	Perform FinancialLoad();	
	PERFORM DimTimeLoad();
	PERFORM DimTradeLoad();
	PERFORM FactCashBalancesLoad();
	PERFORM FactholdingsLoad();
	PERFORM FactmarkethistoryLoad();	
	PERFORM FactwatchesLoad();


	
END;
$$ LANGUAGE 'plpgsql';

SELECT tpcdiDWLoad();