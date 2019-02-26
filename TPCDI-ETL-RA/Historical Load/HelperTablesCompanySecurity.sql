	/*HelperTablesCompanySecurity*/


	DROP FUNCTION IF EXISTS HelperTablesComSecLoad();
	CREATE FUNCTION HelperTablesComSecLoad()
	RETURNS VOID AS $$
	BEGIN



	DROP TABLE IF EXISTS CSTemp3,CSTemp4,CSTemp5,CSTemp6,CSTemp7,CSTemp8,
	STemp1,STemp2,STemp3,STemp4,STemp5,STemp6,CompKeys;



	CREATE TABLE CSTemp3(
	seq integer,
	PTS TIMESTAMP NOT NULL ,
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



	CREATE TABLE CSTemp4
	(
	PTS TIMESTAMP NOT NULL ,
	RecType CHAR(3) NOT NULL ,
	CompanyName CHAR(60),
	CIK CHAR(10) ,
	FinwireStatus CHAR(10),
	Status CHAR(10)  ,
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
	Description CHAR(150) 
	);



	CREATE TABLE CSTemp5
	(
	PTS TIMESTAMP NOT NULL ,
	RecType CHAR(3) NOT NULL ,
	CompanyName CHAR(60),
	CIK INTEGER ,
	Status CHAR(10)  ,
	FinwireIndustryID CHAR(2),
	Industry CHAR(50) ,
	SPrating CHAR(4) ,
	FoundingDate CHAR(8) ,
	AddrLine1 CHAR(80)  ,
	AddrLine2 CHAR(80), 
	PostalCode CHAR(12)  ,
	City CHAR(25)  ,
	StateProvince CHAR(20)  ,
	Country CHAR(24), 
	CEOname CHAR(46)  ,
	Description CHAR(150),
	 isLowGrade BOOLEAN DEFAULT TRUE,
        IsCurrent BOOLEAN DEFAULT TRUE,
	BatchID INT DEFAULT 1,
	EffectiveDate Date,
	EndDate Date 
	);

	--DROP TABLE CSTemp6	
	CREATE TABLE CSTemp6
	(
	SK_CompanyIDOLD INTEGER, 
	CompanyID INTEGER,
	SK_CompanyID INTEGER,
	EffectiveDate DATE
	);

	--DROP TABLE CSTemp7
	CREATE TABLE CSTemp7
	(
	Symbol CHAR(15) Not NULL,
	SK_CompanyIDOLD INTEGER, 
	CompanyID INTEGER,
	SK_CompanyID INTEGER,
	EffectiveDate DATE
	);

	--DROP TABLE CSTemp8	
	CREATE TABLE CSTemp8
	(
	Symbol CHAR(15) Not NULL,
	Issue CHAR(6) Not NULL,
	Status CHAR(10) Not NULL,
	Name CHAR(70) Not NULL,
	ExchangeID CHAR(6) Not NULL,
	SK_CompanyID INTEGER Not NULL,
	SK_CompanyIDOLD INTEGER ,
	SharesOutstanding INTEGER Not NULL,
	FirstTrade DATE Not NULL,
	FirstTradeOnExchange DATE Not NULL,
	Dividend INTEGER Not NULL,
	EffectiveDate DATE,
	DimSecEff DATE,
	CompanyID INTEGER
	);


	
	CREATE TABLE STemp1
	(
	PTS TIMESTAMP NOT NULL ,
	RecType CHAR(3) NOT NULL ,
	Symbol CHAR(15)  ,
	IssueType CHAR(6) ,
	FinwireStatus CHAR(10),
	Status CHAR(10)  ,		
	Name CHAR(70)  ,
	ExID CHAR(6) ,
	ShOut CHAR(13) ,
	FirstTradeDate CHAR(8), 
	FirstTradeExchg CHAR(8)  ,
	Dividend CHAR(12)  ,
	CoNameOrCIK CHAR(60),
	IsCurrent BOOLEAN DEFAULT TRUE,
	BatchID INT DEFAULT 1,
	EffectiveDate Date,
	EndDate Date 
	);


	CREATE TABLE STemp2
	(

	PTS TIMESTAMP NOT NULL ,
	RecType CHAR(3) NOT NULL ,
	Symbol CHAR(15)  ,
	IssueType CHAR(6) ,
	FinwireStatus CHAR(10),
	Status CHAR(10)  ,		
	Name CHAR(70)  ,
	ExID CHAR(6) ,
	ShOut CHAR(13) ,
	FirstTradeDate CHAR(8), 
	FirstTradeExchg CHAR(8)  ,
	Dividend CHAR(12)  ,
	CoNameOrCIK CHAR(60),
	IsCurrent BOOLEAN DEFAULT TRUE,
	BatchID INT DEFAULT 1,
	EffectiveDate Date,
	EndDate Date 
	);

	CREATE TABLE STemp3
	(

	PTS TIMESTAMP NOT NULL ,
	RecType CHAR(3) NOT NULL ,
	Symbol CHAR(15)  ,
	IssueType CHAR(6) ,
	FinwireStatus CHAR(10),
	Status CHAR(10)  ,		
	Name CHAR(70)  ,
	ExID CHAR(6) ,
	ShOut CHAR(13) ,
	FirstTradeDate CHAR(8), 
	FirstTradeExchg CHAR(8)  ,
	Dividend CHAR(12)  ,
	CoNameOrCIK CHAR(60),
	IsCurrent BOOLEAN DEFAULT TRUE,
	BatchID INT DEFAULT 1,
	EffectiveDate Date,
	EndDate Date 
	);

	CREATE TABLE STemp4
	(

	PTS TIMESTAMP NOT NULL ,
	RecType CHAR(3) NOT NULL ,
	Symbol CHAR(15)  ,
	IssueType CHAR(6) ,
	FinwireStatus CHAR(10),
	Status CHAR(10)  ,		
	Name CHAR(70)  ,
	ExID CHAR(6) ,
	ShOut CHAR(13) ,
	FirstTradeDate CHAR(8), 
	FirstTradeExchg CHAR(8)  ,
	Dividend CHAR(12)  ,
	CoNameOrCIK CHAR(60),
	IsCurrent BOOLEAN DEFAULT TRUE,
	BatchID INT DEFAULT 1,
	EffectiveDate Date,
	EndDate Date,
	Sk_CompanyID INTEGER 
	);

	CREATE TABLE STemp5
	(

	PTS TIMESTAMP NOT NULL ,
	RecType CHAR(3) NOT NULL ,
	Symbol CHAR(15)  ,
	IssueType CHAR(6) ,
	FinwireStatus CHAR(10),
	Status CHAR(10)  ,		
	Name CHAR(70)  ,
	ExID CHAR(6) ,
	ShOut CHAR(13) ,
	FirstTradeDate CHAR(8), 
	FirstTradeExchg CHAR(8)  ,
	Dividend CHAR(12)  ,
	CoNameOrCIK CHAR(60),
	IsCurrent BOOLEAN DEFAULT TRUE,
	BatchID INT DEFAULT 1,
	EffectiveDate Date,
	EndDate Date,
	Sk_CompanyID INTEGER 
	);

	CREATE TABLE STemp6
	(

	PTS TIMESTAMP NOT NULL ,
	RecType CHAR(3) NOT NULL ,
	Symbol CHAR(15)  ,
	IssueType CHAR(6) ,
	FinwireStatus CHAR(10),
	Status CHAR(10)  ,		
	Name CHAR(70)  ,
	ExID CHAR(6) ,
	ShOut CHAR(13) ,
	FirstTradeDate CHAR(8), 
	FirstTradeExchg CHAR(8)  ,
	Dividend CHAR(12)  ,
	CoNameOrCIK CHAR(60),
	IsCurrent BOOLEAN DEFAULT TRUE,
	BatchID INT DEFAULT 1,
	EffectiveDate Date,
	EndDate Date,
	Sk_CompanyID INTEGER 
	);



	
	--drop tABLE CompKeys
	CREATE TABLE CompKeys
	(Sk_CompanyID INTEGER,
	 CompanyID INTEGER
	);


	 END;
	$$ LANGUAGE 'plpgsql';