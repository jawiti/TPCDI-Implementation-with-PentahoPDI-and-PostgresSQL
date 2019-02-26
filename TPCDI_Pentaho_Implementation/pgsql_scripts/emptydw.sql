DELETE FROM accountkeys
where accountid is not null;

DELETE FROM dimaccount
WHERE accountid is not null;

DELETE FROM customerkeys
 WHERE customerid is not null;

DELETE FROM dimcustomer 
WHERE customerid is not null;

DELETE FROM brokerkeys
where brokerid is not null;

DELETE FROM dimbroker
WHERE BrokerID is not null;

DELETE FROM dimessages
WHERE messagesource != 'Prospect';

DELETE FROM Prospect 
WHERE AgencyID is not null;

DELETE FROM dimdate
where SK_DateID is not null;

DELETE FROM TAXRATE 
WHERE TX_ID is not null;


DELETE FROM companykeys
where companyid is not null;

DELETE FROM dimcompany
WHERE SK_companyid is not null;
delete from dimessages WHERE messagesource = 'DimCompany';


DELETE FROM securitykeys
where sk_securityid is not null;

DELETE FROM dimsecurity
WHERE SK_securityid is not null;





DELETE FROM dimtrade
where tradeid is not null;

  
delete from dimtradeforexperiment where tradeid is not null


DELETE FROM factcashbalances 
WHERE SK_AccountID is not null;

DELETE FROM factHOLDINGS
WHERE TRADEID is not null;

DELETE FROM factmarkethistory 
WHERE SK_DateID is not null;

DELETE FROM factmarkethistoryforexperiment 
WHERE SK_DateID is not null;


DELETE FROM factwatches
WHERE SK_CustomerID is not null;