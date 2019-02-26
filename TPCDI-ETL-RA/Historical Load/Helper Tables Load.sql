/* Helper Tables*/
DROP FUNCTION IF EXISTS xml_import(filename text);
CREATE FUNCTION xml_import(filename text)
RETURNS xml VOLATILE LANGUAGE plpgsql AS 
$$
	DECLARE
        content bytea;
        loid oid;
        lfd integer;
        lsize integer;
	BEGIN
        loid := lo_import(filename);
        lfd := lo_open(loid,262144);
        lsize := lo_lseek(lfd,0,2);
        perform lo_lseek(lfd,0,0);
        content := loread(lfd,lsize);
        perform lo_close(lfd);
        perform lo_unlink(loid);
 
        RETURN xmlparse(document convert_from(content,'LATIN1'));
    END;
$$;

DROP FUNCTION IF EXISTS HelperTablesLoad();
CREATE FUNCTION HelperTablesLoad()
RETURNS VOID AS $$
BEGIN
	DROP TABLE IF EXISTS BatchDate,StatusType,Industry,TradeType,CashTransaction,HoldingHistory,DailyMarket,
	WatchHistory,CMP,FIN,SEC,tempall,TempProspect,customermgmt,Accountall,CMPSEC;


	CREATE TABLE CustomerMgmt AS
	SELECT xml_import('D:\TPC-DI_Staging_Area\data\Batch1\CustomerMgmt.xml') AS data;

	
	CREATE  TABLE Accountall (
	ActionType varchar(50),
	AccountID integer,
	AccountDesc varchar(50),
	TaxStatus integer,
	CA_B_ID integer,
	C_ID integer,
	ActionTS date
	);

	INSERT INTO Accountall(ActionType, AccountID, AccountDesc, TaxStatus, CA_B_ID, C_ID, ActionTS)
	WITH AccountInput AS (
	SELECT xmltable.*
	FROM CustomerMgmt,
	XMLTABLE('//Customer' PASSING data COLUMNS
	ActionType varchar(50) PATH '../@ActionType',
	AccountID integer PATH 'Account/@CA_ID',
	AccountDesc varchar(50) PATH 'Account/CA_NAME',
	TaxStatus integer PATH 'Account/@CA_TAX_ST',
	CA_B_ID integer PATH 'Account/CA_B_ID',
	C_ID integer PATH '@C_ID',
	ActionTS date PATH '../@ActionTS')
	)
	SELECT ActionType, AccountID, AccountDesc, TaxStatus, CA_B_ID, C_ID, ActionTS
	FROM AccountInput ;


	
	CREATE TABLE TempProspect ( AgencyID CHAR(30) NOT NULL UNIQUE,  
	LastName CHAR(30) NOT NULL,
	FirstName CHAR(30) NOT NULL,
	MiddleInitial CHAR(1),
	Gender CHAR(1),
	AddressLine1 CHAR(80),
	AddressLine2 CHAR(80),
	PostalCode CHAR(12),
	City CHAR(25) NOT NULL,
	State CHAR(20) NOT NULL,
	Country CHAR(24),
	Phone CHAR(30), 
	Income numeric(9),
	numericberCars numeric(2), 
	numericberChildren numeric(2), 
	MaritalStatus CHAR(1), 
	Age numeric(3),
	CreditRating numeric(4),
	OwnOrRentFlag CHAR(1), 
	Employer CHAR(30),
	numericberCreditCards numeric(2), 
	NetWorth numeric(12)						
	);
	SET DATESTYLE TO POSTGRES,US;
	COPY TempProspect(AgencyID, LastName, FirstName,
	MiddleInitial, Gender, AddressLine1, AddressLine2, PostalCode, City, State, Country,
	Phone, Income, numericberCars, numericberChildren, MaritalStatus, Age, CreditRating,
	OwnOrRentFlag, Employer, numericberCreditCards, NetWorth)
	FROM 'D:\TPC-DI_Staging_Area\data\Batch1\Prospect.csv'  DELIMITER ',' CSV HEADER; 


	CREATE TABLE tempall (ActionType varchar(50),
	CustomerID integer,
	TaxID varchar(20),
	LastName varchar(30),
	FirstName varchar(30),
	MiddleInitial varchar(1),
	Gender varchar(1),
	Tier varchar(50),
	DOB date ,
	AddressLine1 varchar(80) ,
	AddressLine2 varchar(80) ,
	PostalCode varchar(12) ,
	City varchar(25) ,
	State_Prov varchar(20) ,
	Country varchar(24) ,		
	Phone1C_CTRY_CODE varchar(30) , 
	Phone1C_AREA_CODE varchar(30) ,
	Phone1C_LOCAL varchar(30) ,
	Phone1C_EXT varchar(30) ,
	Phone2C_CTRY_CODE varchar(30),
	Phone2C_AREA_CODE varchar(30) ,
	Phone2C_LOCAL varchar(30) ,
	Phone2C_EXT varchar(30) ,
	Phone3C_CTRY_CODE varchar(30) ,
	Phone3C_AREA_CODE varchar(30) ,
	Phone3C_LOCAL varchar(30) ,
	Phone3C_EXT varchar(30),
	Email1 varchar(50),
	Email2 varchar(50),
	C_NAT_TX_ID varchar(50),
	C_LCL_TX_ID varchar(50) ,
	ActionTS date 
	);



	

	INSERT INTO tempall(ActionType,CustomerID, TaxID, LastName, FirstName, MiddleInitial, Gender, Tier, DOB,
	AddressLine1, AddressLine2, PostalCode, City, State_Prov, Country, 
	Phone1C_CTRY_CODE,Phone1C_AREA_CODE,Phone1C_LOCAL,Phone1C_EXT,
	Phone2C_CTRY_CODE,Phone2C_AREA_CODE,Phone2C_LOCAL,Phone2C_EXT,
	Phone3C_CTRY_CODE,Phone3C_AREA_CODE,Phone3C_LOCAL,Phone3C_EXT,
	Email1, Email2,C_NAT_TX_ID,C_LCL_TX_ID,ActionTS	)
   	WITH CustomerInput AS (
	SELECT xmltable.*
	FROM CustomerMgmt,
	XMLTABLE('//Customer' PASSING data COLUMNS
	ActionType varchar(50) PATH '../@ActionType',
	CustomerID integer PATH '@C_ID',
	TaxID varchar(20) PATH '@C_TAX_ID',
	LastName varchar(30) PATH 'Name/C_L_NAME',
	FirstName varchar(30) PATH 'Name/C_F_NAME',
	MiddleInitial varchar(1) PATH 'Name/C_M_NAME',
	Gender varchar(1) Path '@C_GNDR',
	Tier varchar(50) PATH '@C_TIER',--make it integer
	DOB date PATH '@C_DOB',	
	AddressLine1 varchar(80) Path 'Address/C_ADLINE1',
	AddressLine2 varchar(80) Path 'Address/C_ADLINE2',
	PostalCode varchar(12) Path 'Address/C_ZIPCODE',
	City varchar(25) Path 'Address/C_CITY',
	State_Prov varchar(20) Path 'Address/C_STATE_PROV',
	Country varchar(24) Path 'Address/C_CTRY',		
	Phone1C_CTRY_CODE varchar(30) PATH 'ContactInfo/C_PHONE_1/C_CTRY_CODE', 
	Phone1C_AREA_CODE varchar(30) PATH 'ContactInfo/C_PHONE_1/C_AREA_CODE', 
	Phone1C_LOCAL varchar(30) PATH 'ContactInfo/C_PHONE_1/C_LOCAL', 
	Phone1C_EXT varchar(30) PATH 'ContactInfo/C_PHONE_1/C_EXT',
	Phone2C_CTRY_CODE varchar(30) PATH 'ContactInfo/C_PHONE_2/C_CTRY_CODE',
	Phone2C_AREA_CODE varchar(30) PATH 'ContactInfo/C_PHONE_2/C_AREA_CODE',
	Phone2C_LOCAL varchar(30) PATH 'ContactInfo/C_PHONE_2/C_LOCAL',
	Phone2C_EXT varchar(30) PATH 'ContactInfo/C_PHONE_2/C_EXT',
	Phone3C_CTRY_CODE varchar(30) PATH 'ContactInfo/C_PHONE_3/C_CTRY_CODE',
	Phone3C_AREA_CODE varchar(30) PATH 'ContactInfo/C_PHONE_3/C_AREA_CODE',
	Phone3C_LOCAL varchar(30) PATH 'ContactInfo/C_PHONE_3/C_LOCAL',
	Phone3C_EXT varchar(30) PATH 'ContactInfo/C_PHONE_3/C_EXT',
	Email1 varchar(50) PATH 'ContactInfo/C_PRIM_EMAIL',
	Email2 varchar(50) PATH 'ContactInfo/C_ALT_EMAIL',
	C_NAT_TX_ID varchar(50) PATH 'TaxInfo/C_NAT_TX_ID',
	C_LCL_TX_ID varchar(50) PATH 'TaxInfo/C_LCL_TX_ID',
	ActionTS date PATH '../@ActionTS')
	)
	SELECT ActionType,CustomerID, TaxID, LastName, FirstName, MiddleInitial, UPPER(Gender) AS Gender, Tier, DOB,
	AddressLine1, AddressLine2, PostalCode, City, State_Prov, Country, 
	Phone1C_CTRY_CODE,Phone1C_AREA_CODE,Phone1C_LOCAL,Phone1C_EXT,
	Phone2C_CTRY_CODE,Phone2C_AREA_CODE,Phone2C_LOCAL,Phone2C_EXT,
	Phone3C_CTRY_CODE,Phone3C_AREA_CODE,Phone3C_LOCAL,Phone3C_EXT,
	Email1, Email2,C_NAT_TX_ID,C_LCL_TX_ID,ActionTS	
	FROM CustomerInput;

	/*UPDATE tempall
	SET
	AddressLine2=NULL
	WHERE 
	AddressLine2='';*/
	
	CREATE  TABLE BatchDate(
	BatchDateColumn Date NOT NULL
	);
	
	COPY BatchDate FROM 'D:\TPC-DI_Staging_Area\data\Batch1\BatchDate.txt' 
	( FORMAT text, ENCODING 'UTF8' );


	CREATE  TABLE StatusType(
		ST_ID CHAR(4) NOT NULL,
		ST_NAME CHAR(10) NOT NULL
	);
	
	COPY StatusType FROM 'D:\TPC-DI_Staging_Area\data\Batch1\StatusType.txt' 
	( FORMAT text, ENCODING 'UTF8', DELIMITER '|');


	CREATE  TABLE Industry(
	IN_ID CHAR(2) NOT NULL,
	IN_NAME CHAR(50) NOT NULL,
	IN_SC_ID CHAR(4) NOT NULL
	);
	
	COPY Industry FROM 'D:\TPC-DI_Staging_Area\data\Batch1\Industry.txt' 
	( FORMAT text, ENCODING 'UTF8', DELIMITER '|');


	CREATE  TABLE TradeType(
	TT_ID CHAR(3) NOT NULL,
	TT_NAME CHAR(12) NOT NULL,
	TT_IS_SELL NUMERIC(1) NOT NULL,
	TT_IS_MRKT NUMERIC(1) NOT NULL
	);
	
	COPY TradeType FROM 'D:\TPC-DI_Staging_Area\data\Batch1\TradeType.txt' 
	( FORMAT text, ENCODING 'UTF8', DELIMITER '|');


	CREATE  TABLE CashTransaction(
	CT_CA_ID CHAR(5) NOT NULL,
	CT_DTS DATE NOT NULL,
	CT_AMT NUMERIC(10,2) NOT NULL,
	CT_NAME CHAR(100) NOT NULL
	);
	
	COPY CashTransaction FROM 'D:\TPC-DI_Staging_Area\data\Batch1\CashTransaction.txt' 
	( FORMAT text, ENCODING 'UTF8', DELIMITER '|');

	CREATE  TABLE HoldingHistory(
	HH_H_T_ID INT NOT NULL,
	HH_T_ID INT NOT NULL,
	HH_BEFORE_QTY INT NOT NULL,
	HH_AFTER_QTY INT NOT NULL
	);
	
	COPY HoldingHistory FROM 'D:\TPC-DI_Staging_Area\data\Batch1\HoldingHistory.txt' 
	( FORMAT text, ENCODING 'UTF8', DELIMITER '|');
	



	CREATE  TABLE DailyMarket(
	DM_DATE DATE NOT NULL,
	DM_S_SYMB CHAR(15) NOT NULL,
	DM_CLOSE NUMERIC(8,2) NOT NULL,
	DM_HIGH NUMERIC(8,2) NOT NULL,
	DM_LOW NUMERIC(8,2) NOT NULL,
	DM_VOL NUMERIC(12) NOT NULL
	);
	
	COPY DailyMarket FROM 'D:\TPC-DI_Staging_Area\data\Batch1\DailyMarket.txt' 
	( FORMAT text, ENCODING 'UTF8', DELIMITER '|');


	CREATE  TABLE WatchHistory(
	W_C_ID INTEGER NOT NULL,
	W_S_SYMB CHAR(15) NOT NULL,
	W_DTS DATE NOT NULL,
	W_ACTION CHAR(4) NOT NULL	
	);
	
	COPY WatchHistory FROM 'D:\TPC-DI_Staging_Area\data\Batch1\WatchHistory.txt' 
	( FORMAT text, ENCODING 'UTF8', DELIMITER '|');



	--CMP
	CREATE TABLE CMP(
			PTS CHAR(15) NOT NULL ,
	RecType CHAR(3) NOT NULL ,
	CompanyName CHAR(60) NOT NULL ,
	CIK CHAR(10) NOT NULL ,
	Status CHAR(4) NOT NULL ,
	IndustryID CHAR(2) NOT NULL ,
	SPrating CHAR(4) NOT NULL ,
	FoundingDate CHAR(8) ,
	AddrLine1 CHAR(80) NOT NULL ,
	AddrLine2 CHAR(80), 
	PostalCode CHAR(12) NOT NULL ,
	City CHAR(25) NOT NULL ,
	StateProvince CHAR(20) NOT NULL ,
	Country CHAR(24), 
	CEOname CHAR(46) NOT NULL ,
	Description CHAR(150) NOT NULL 
	);
		
	INSERT INTO CMP(PTS,RecType,CompanyName,CIK,Status,IndustryID,SPrating,FoundingDate,AddrLine1,
	AddrLine2,PostalCode,City,StateProvince,Country,CEOname,Description)
	SELECT substr(alldata,1,15), substr(alldata,16,3),substr(alldata,19,60),
	substr(alldata,79,10),substr(alldata,89,4),substr(alldata,93,2),substr(alldata,95,4),
	substr(alldata,99,8),substr(alldata,107,80),substr(alldata,187,80),
	substr(alldata,267,12),substr(alldata,279,25),substr(alldata,304,20),
	substr(alldata,324,24),substr(alldata,348,46),substr(alldata,394,150)
	FROM CMPFile where substr(alldata,16,3)='CMP';




	--FIN
	CREATE TABLE FIN(
	PTS CHAR(15) NOT NULL ,
	RecType CHAR(3) NOT NULL ,
	Year CHAR(4) NOT NULL ,
	Quarter CHAR(1) NOT NULL ,
	QtrStartDate CHAR(8) NOT NULL ,
	PostingDate CHAR(8) NOT NULL ,
	Revenue CHAR(17) NOT NULL ,
	Earnings CHAR(17) NOT NULL ,
	EPS CHAR(12) NOT NULL ,
	DillutedEPS CHAR(12) NOT NULL, 
	Margin CHAR(12) NOT NULL ,
	Inventory CHAR(17) NOT NULL ,
	Assets CHAR(17) NOT NULL ,
	Liabilities CHAR(17), 
	ShOut CHAR(13) NOT NULL ,
	DillutedShOut CHAR(13) NOT NULL,
	CoNameOrCIK CHAR(60) NOT NULL
		);

	INSERT INTO FIN(PTS,RecType,Year, Quarter, QtrStartDate, PostingDate, Revenue, Earnings, EPS,
	DillutedEPS, Margin, Inventory, Assets, Liabilities, ShOut, DillutedShOut, CoNameOrCIK)
	SELECT substr(alldata,1,15), substr(alldata,16,3),substr(alldata,19,4),
	substr(alldata,23,1),substr(alldata,24,8),substr(alldata,32,8),substr(alldata,40,17),
	substr(alldata,57,17),substr(alldata,74,12),substr(alldata,86,12),
	substr(alldata,98,12),substr(alldata,110,17),substr(alldata,127,17),
	substr(alldata,144,17),substr(alldata,161,13),substr(alldata,174,13),substr(alldata,187,60)
	FROM CMPFile where substr(alldata,16,3)='FIN';



	--SEC
	CREATE TABLE SEC(
			PTS CHAR(15) NOT NULL ,
	RecType CHAR(3) NOT NULL ,
	Symbol CHAR(15) NOT NULL ,
	IssueType CHAR(6) NOT NULL ,
	Status CHAR(4) NOT NULL ,
	Name CHAR(70) NOT NULL ,
	ExID CHAR(6) NOT NULL ,
	ShOut CHAR(13) NOT NULL ,
	FirstTradeDate CHAR(8) NOT NULL, 
	FirstTradeExchg CHAR(8) NOT NULL ,
	Dividend CHAR(12) NOT NULL ,
	CoNameOrCIK CHAR(60) NOT NULL 
		);


	INSERT INTO SEC(PTS, RecType, Symbol, IssueType, Status, 
	Name, ExID, ShOut, FirstTradeDate, FirstTradeExchg, Dividend, CoNameOrCIK)
	SELECT substr(alldata,1,15), substr(alldata,16,3),substr(alldata,19,15),
	substr(alldata,34,6),substr(alldata,40,4),substr(alldata,44,70),substr(alldata,114,6),
	substr(alldata,120,13),substr(alldata,133,8),substr(alldata,141,8),
	substr(alldata,149,12),substr(alldata,161,60)
	FROM CMPFile where substr(alldata,16,3)='SEC';

	--DROP TABLE CMPSEC
	CREATE TABLE CMPSEC(
			PTS CHAR(15) NOT NULL ,
	RecType CHAR(3) NOT NULL ,
	CompanyName CHAR(60),
	CIK CHAR(10) ,
	Status CHAR(4)  ,
	IndustryID CHAR(2) ,
	SPrating CHAR(4) ,
	FoundingDate CHAR(8) ,
	AddrLine1 CHAR(80)  ,
	AddrLine2 CHAR(80), 
	PostalCode CHAR(12)  ,
	City CHAR(25)  ,
	StateProvince CHAR(20)  ,
	Country CHAR(24), 
	CEOname CHAR(46)  ,
	Description CHAR(150) ,
	Symbol CHAR(15)  ,
	IssueType CHAR(6) ,
	Name CHAR(70)  ,
	ExID CHAR(6) ,
	ShOut CHAR(13) ,
	FirstTradeDate CHAR(8), 
	FirstTradeExchg CHAR(8)  ,
	Dividend CHAR(12)  ,
	CoNameOrCIK CHAR(60) 
		);

	INSERT INTO CMPSEC(PTS,RecType,CompanyName,CIK,Status,IndustryID,SPrating,FoundingDate,AddrLine1,
	AddrLine2,PostalCode,City,StateProvince,Country,CEOname,Description)
	SELECT substr(alldata,1,15), substr(alldata,16,3),substr(alldata,19,60),
	substr(alldata,79,10),substr(alldata,89,4),substr(alldata,93,2),substr(alldata,95,4),
	substr(alldata,99,8),substr(alldata,107,80),substr(alldata,187,80),
	substr(alldata,267,12),substr(alldata,279,25),substr(alldata,304,20),
	substr(alldata,324,24),substr(alldata,348,46),substr(alldata,394,150)
	FROM CMPFile where substr(alldata,16,3)='CMP';

	INSERT INTO CMPSEC(PTS, RecType, Symbol, IssueType, Status, 
	Name, ExID, ShOut, FirstTradeDate, FirstTradeExchg, Dividend, CoNameOrCIK)
	SELECT substr(alldata,1,15), substr(alldata,16,3),substr(alldata,19,15),
	substr(alldata,34,6),substr(alldata,40,4),substr(alldata,44,70),substr(alldata,114,6),
	substr(alldata,120,13),substr(alldata,133,8),substr(alldata,141,8),
	substr(alldata,149,12),substr(alldata,161,60)
	FROM CMPFile where substr(alldata,16,3)='SEC';


END;
$$ LANGUAGE 'plpgsql';
