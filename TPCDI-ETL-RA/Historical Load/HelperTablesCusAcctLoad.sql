
DROP FUNCTION IF EXISTS HelperTablesCusAcctLoad();
CREATE FUNCTION HelperTablesCusAcctLoad()
RETURNS VOID AS $$
BEGIN


	DROP TABLE IF EXISTS temp1,temp2,temp3,temp4,temp5,temp6,temp7,temp8,temp9,temp10,
	UPDtemp1,UPDtemp2,UPDtemp3,UPDtemp4,UPDtemp5,UPDtemp6,UPDemp7,UPDtemp8,UPDtemp9,UPDtemp10,
	ADDtemp1,ADDtemp2,ADDtemp3,ADDtemp4,ADDtemp5,ADDtemp6,ADDemp7,ADDtemp8,ADDtemp9,ADDtemp10,test,audittable,
	customeridf,justforhelp, allactions,UPDCUSTtemp1, UPDCUSTtemp2, UPDCUSTtemp3, UPDCUSTtemp4,UPDCUSTtemp5,
	UPDCUSTtemp6,UPDCUSTtemp7,UPDACCTtemp1, UPDACCTtemp2, UPDACCTtemp3,INACTtemp1,INACTtemp2,INACTtemp2A,
	INACTtemp3,INACTtemp4,INACTtemp5,CLOSEACCTtemp1,CLOSEACCTtemp2;


	CREATE TABLE allActions (ActionType varchar(50),
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
		AccountID integer,
		AccountDesc varchar(50),
		TaxStatus integer,
		CA_B_ID integer,
		C_ID integer,	
		ActionTS timestamp 
						
	);



	

	INSERT INTO allActions(ActionType,CustomerID, TaxID, LastName, FirstName, MiddleInitial, Gender, Tier, DOB,
	AddressLine1, AddressLine2, PostalCode, City, State_Prov, Country, 
	Phone1C_CTRY_CODE,Phone1C_AREA_CODE,Phone1C_LOCAL,Phone1C_EXT,
	Phone2C_CTRY_CODE,Phone2C_AREA_CODE,Phone2C_LOCAL,Phone2C_EXT,
	Phone3C_CTRY_CODE,Phone3C_AREA_CODE,Phone3C_LOCAL,Phone3C_EXT,
	Email1, Email2,C_NAT_TX_ID,C_LCL_TX_ID,AccountID,AccountDesc,
	TaxStatus,CA_B_ID,ActionTS	)
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
		AccountID integer PATH 'Account/@CA_ID',
		AccountDesc varchar(50) PATH 'Account/CA_NAME',
		TaxStatus integer PATH 'Account/@CA_TAX_ST',
		CA_B_ID integer PATH 'Account/CA_B_ID',
		ActionTS TimeStamp PATH '../@ActionTS')
	)
	SELECT ActionType,CustomerID, TaxID, LastName, FirstName, MiddleInitial, UPPER(Gender) AS Gender, Tier, DOB,
	AddressLine1, AddressLine2, PostalCode, City, State_Prov, Country, 
	Phone1C_CTRY_CODE,Phone1C_AREA_CODE,Phone1C_LOCAL,Phone1C_EXT,
	Phone2C_CTRY_CODE,Phone2C_AREA_CODE,Phone2C_LOCAL,Phone2C_EXT,
	Phone3C_CTRY_CODE,Phone3C_AREA_CODE,Phone3C_LOCAL,Phone3C_EXT,
	Email1, Email2,C_NAT_TX_ID,C_LCL_TX_ID,AccountID,AccountDesc,
	TaxStatus,CA_B_ID,ActionTS	
		FROM CustomerInput;


				
		CREATE TABLE TEST (
		Sk_CustomerID integer,
		CustomerID integer,
		AccountID integer
			
		);
		CREATE TABLE temp3 (Seq integer,
		ActionType varchar(50),
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
			AccountID integer,
		AccountDesc varchar(50),
		TaxStatus integer,
		CA_B_ID integer,
		C_ID integer,		
		ActionTS timestamp 
						
);

/*CREATE  TABLE UPDtemp1 (Seq integer,
ActionType varchar(50),
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
		ActionTS timestamp ,
		 Phone1 varchar(30) DEFAULT NULL,
	Phone2 varchar(30) DEFAULT NULL,
	   Phone3 varchar(30) DEFAULT NULL,
	   Status varchar(10) DEFAULT 'Active',
	   MarketingNameplate varchar(100) DEFAULT NULL,
	   IsCustomer BOOLEAN DEFAULT TRUE,
	   BatchID INT DEFAULT 1
						
);

CREATE  TABLE UPDtemp2 (
ActionType varchar(50),
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
		Email1 varchar(50),
		Email2 varchar(50),
		ActionTS timestamp ,
		Phone1 varchar(30) DEFAULT NULL,
		Phone2 varchar(30) DEFAULT NULL,
		Phone3 varchar(30) DEFAULT NULL,
		Status varchar(10) DEFAULT 'Active',
		C_LCL_TX_ID varchar(50) ,
		MarketingNameplate varchar(100) DEFAULT NULL,
		NationalTaxRateDesc varchar(50),
		NationalTaxRate		numeric(6,5)		
);




CREATE  TABLE UPDtemp3 (
ActionType varchar(50),
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
		Email1 varchar(50),
		Email2 varchar(50),
		ActionTS timestamp ,
		Phone1 varchar(30) DEFAULT NULL,
		Phone2 varchar(30) DEFAULT NULL,
		Phone3 varchar(30) DEFAULT NULL,
		Status varchar(10) DEFAULT 'Active',
		C_LCL_TX_ID varchar(50) ,
		MarketingNameplate varchar(100) DEFAULT NULL,
		NationalTaxRateDesc varchar(50),
		NationalTaxRate		numeric(6,5),
		LocalTaxRateDesc 	varchar(50),	
		LocalTaxRate numeric(6,5)
);



CREATE  TABLE UPDtemp4 (
ActionType varchar(50),
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
		Email1 varchar(50),
		Email2 varchar(50),
		ActionTS timestamp ,
		Phone1 varchar(30) DEFAULT NULL,
		Phone2 varchar(30) DEFAULT NULL,
		Phone3 varchar(30) DEFAULT NULL,
		Status varchar(10) DEFAULT 'Active',
		C_LCL_TX_ID varchar(50) ,
		MarketingNameplate varchar(100) DEFAULT NULL,
		NationalTaxRateDesc varchar(100),
		NationalTaxRate		numeric(6,5),	
		LocalTaxRateDesc 	varchar(50),	
		LocalTaxRate numeric(6,5),
		AgencyID CHAR(30),  
		Income numeric(9),
						numericberCars numeric(2), 
						numericberChildren numeric(2),						
						Age numeric(3),
						CreditRating numeric(4),
						numericberCreditCards numeric(2), 
						NetWorth numeric(12)
);
*/
		CREATE  TABLE ADDtemp1 (
		ActionType varchar(50),
		AccountID integer,
		AccountDesc varchar(50),
		TaxStatus integer,
		CA_B_ID integer,
		C_ID integer,		
		ActionTS timestamp 	
						
		);


	CREATE  TABLE ADDtemp2
	(
	 ActionType varchar(50),
	 AccountID  INTEGER NOT NULL,
	 AccountDesc       varchar(50),
	 TaxStatus  INTEGER NOT NULL ,
	 CA_B_ID INTEGER, 
	 C_ID INTEGER,
	 ActionTS timestamp, 
	 SK_BrokerID  INTEGER 
	);

	CREATE  TABLE ADDtemp3
	(
	ActionType varchar(50),
	AccountID  INTEGER NOT NULL,
	AccountDesc       varchar(50),
	TaxStatus  INTEGER NOT NULL ,
	CA_B_ID INTEGER, 
	C_ID INTEGER,
	ActionTS timestamp, 
	SK_BrokerID  INTEGER,
	SK_CustomerID INTEGER
	);
		
	CREATE  TABLE UPDtemp5(
	SK_CustomerID_value INTEGER
	);

	CREATE  TABLE ADDtemp5(
	SK_AccountID_value INTEGER
	);






		CREATE  TABLE UPDCUSTtemp1 (Seq integer,
		ActionType varchar(50),
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
		ActionTS timestamp ,
		 Phone1 varchar(30) DEFAULT NULL,
		Phone2 varchar(30) DEFAULT NULL,
		Phone3 varchar(30) DEFAULT NULL,
		Status varchar(10) DEFAULT 'Active',
		MarketingNameplate varchar(100) DEFAULT NULL,
		IsCustomer BOOLEAN DEFAULT TRUE,
		BatchID INT DEFAULT 1
						
);





		CREATE  TABLE UPDCUSTtemp2 (Seq integer,
		ActionType varchar(50),
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
		Email1 varchar(50),
		Email2 varchar(50),
		NationalTaxRateDesc varchar(100),
		NationalTaxRate		numeric(6,5),	
		LocalTaxRateDesc 	varchar(50),	
		LocalTaxRate numeric(6,5),
		ActionTS timestamp ,
		 Phone1 varchar(30) DEFAULT NULL,
		Phone2 varchar(30) DEFAULT NULL,
		Phone3 varchar(30) DEFAULT NULL,
		Status varchar(10) DEFAULT 'Active',
		MarketingNameplate varchar(100) DEFAULT NULL,
		IsCustomer BOOLEAN DEFAULT TRUE,
		BatchID INT DEFAULT 1,
		TierNew varchar(50),
		AddressLine1New varchar(80) ,
		AddressLine2New varchar(80) ,
		PostalCodeNew varchar(12) ,
		CityNew varchar(25) ,
		State_ProvNew varchar(20) ,
		CountryNew varchar(24) ,		
		Email1New varchar(50),
		Email2New varchar(50),
		 Phone1New varchar(30) DEFAULT NULL,
		Phone2New varchar(30) DEFAULT NULL,
		Phone3New varchar(30) DEFAULT NULL
	
);





		CREATE  TABLE UPDCUSTtemp3 (ActionType varchar(50),
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
		Status VARCHAR(10),		
		Email1 varchar(50),
		Email2 varchar(50),
		NationalTaxRateDesc varchar(100),
		NationalTaxRate		numeric(6,5),	
		LocalTaxRateDesc 	varchar(50),	
		LocalTaxRate numeric(6,5),
		ActionTS timestamp ,
		 Phone1 varchar(30) DEFAULT NULL,
		Phone2 varchar(30) DEFAULT NULL,
		Phone3 varchar(30) DEFAULT NULL,
		MarketingNameplate varchar(100) DEFAULT NULL,
		IsCustomer BOOLEAN DEFAULT TRUE,
		BatchID INT DEFAULT 1
						
);



		CREATE  TABLE UPDCUSTtemp4 (
		ActionType varchar(50),
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
		Email1 varchar(50),
		Email2 varchar(50),
		ActionTS timestamp ,
		Phone1 varchar(30) DEFAULT NULL,
		Phone2 varchar(30) DEFAULT NULL,
		Phone3 varchar(30) DEFAULT NULL,
		Status varchar(10) DEFAULT 'Active',
		C_LCL_TX_ID varchar(50) ,
		MarketingNameplate varchar(100) DEFAULT NULL,
		NationalTaxRateDesc varchar(100),
		NationalTaxRate		numeric(6,5),	
		LocalTaxRateDesc 	varchar(50),	
		LocalTaxRate numeric(6,5),
		AgencyID CHAR(30),  
		Income numeric(9),
		numericberCars numeric(2), 
		numericberChildren numeric(2),						
		Age numeric(3),
		CreditRating numeric(4),
		numericberCreditCards numeric(2), 
		NetWorth numeric(12)
		);

		CREATE  TABLE UPDCUSTtemp6 (
		CustomerID integer,
		ActionTS timestamp ,
		Sk_CustomerID integer, 
		AccountID integer,
		SK_BrokerID integer,
		Status varchar(10),
		AccountDesc varchar(50),
		TaxStatus integer,
		EffectiveDate DATE
		);

		CREATE  TABLE UPDCUSTtemp7 (
		CustomerID integer,
		ActionTS timestamp ,
		Sk_CustomerID integer, 
		AccountID integer,
		SK_BrokerID integer,
		Status varchar(10),
		AccountDesc varchar(50),
		TaxStatus integer,
		EffectiveDate DATE
		);
				
		CREATE  TABLE UPDACCTtemp1 (Seq integer,
		ActionType varchar(50),
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
		AccountID integer,
		AccountDesc varchar(50),
		TaxStatus integer,
		CA_B_ID integer,
		ActionTS timestamp ,
		 Phone1 varchar(30) DEFAULT NULL,
		Phone2 varchar(30) DEFAULT NULL,
		Phone3 varchar(30) DEFAULT NULL,
		Status varchar(10) DEFAULT 'Active',
		MarketingNameplate varchar(100) DEFAULT NULL,
		IsCustomer BOOLEAN DEFAULT TRUE,
		BatchID INT DEFAULT 1
						
		);



		CREATE  TABLE UPDACCTtemp2 (
		ActionType varchar(50),
		AccountID integer, 
		SK_CustomerID INTEGER,
		AccountDesc varchar(50),
		AccountDescNew varchar(50), 
		TaxStatus integer,
		CA_B_ID INTEGER,
		 ActionTS Timestamp,
		 EffectiveDate DATE							
		);

		CREATE  TABLE UPDACCTtemp3 (
		ActionType varchar(50),
		AccountID integer, 
		SK_CustomerID INTEGER,
		AccountDesc varchar(50),
		AccountDescNew varchar(50), 
		TaxStatus integer,
		CA_B_ID INTEGER,
		Sk_BrokerID INTEGER,
		 ActionTS Timestamp,
		 EffectiveDate DATE							
		);


		CREATE  TABLE INACTtemp1 (Seq integer,
		ActionType varchar(50),
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
		AccountID integer,
		AccountDesc varchar(50),
		TaxStatus integer,
		CA_B_ID integer,
		ActionTS timestamp ,
		 Phone1 varchar(30) DEFAULT NULL,
		Phone2 varchar(30) DEFAULT NULL,
		Phone3 varchar(30) DEFAULT NULL,
		Status varchar(10) DEFAULT 'Active',
		MarketingNameplate varchar(100) DEFAULT NULL,
		IsCustomer BOOLEAN DEFAULT TRUE,
		BatchID INT DEFAULT 1
						
		);


		CREATE  TABLE INACTtemp2 (
		ActionType varchar(10),
		 ActionTS timestamp, 
		 CustomerID INTEGER,
		  Sk_CustomerID integer,
		   AccountID integer
		);

		/*
		CREATE  TABLE INACTtemp2A (
		 ActionTS timestamp, 
		 CustomerID INTEGER,
		  Sk_CustomerID integer,
		   AccountID integer
		);
		*/
		CREATE  TABLE INACTtemp3 (
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
		StateProv varchar(20) ,
		Country varchar(24) ,		
		Email1 varchar(50),
		Email2 varchar(50),
		NationalTaxRate numeric(6,5),
		NationalTaxRateDesc varchar(50),
		LocalTaxRateDesc varchar(50) ,
		LocalTaxRate numeric(6,5),
		AccountDesc varchar(50),
		AgencyID CHAR(30),
		TaxStatus integer,
		CA_B_ID integer,
		ActionTS timestamp ,
		 Phone1 varchar(30) DEFAULT NULL,
		Phone2 varchar(30) DEFAULT NULL,
		Phone3 varchar(30) DEFAULT NULL,
		CreditRating numeric(4),
		NetWorth numeric(12),
		MarketingNameplate varchar(100) DEFAULT NULL
	   
						
		);

		CREATE  TABLE INACTtemp4 (
		 CustomerID integer,
		ActionTS timestamp ,
		Sk_CustomerID integer, 
		AccountID integer,
		SK_BrokerID integer,
		Status varchar(10),
		AccountDesc varchar(50),
		TaxStatus integer
		);

		CREATE  TABLE INACTtemp5 (
		CustomerID integer,
		ActionTS timestamp ,
		Sk_CustomerID integer, 
		AccountID integer,
		SK_BrokerID integer,
		Status varchar(10),
		AccountDesc varchar(50),
		TaxStatus integer
		);

		CREATE  TABLE CLOSEACCTtemp1 (Seq integer,
		ActionType varchar(50),
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
		AccountID integer,
		AccountDesc varchar(50),
		TaxStatus integer,
		CA_B_ID integer,
		ActionTS timestamp ,
		 Phone1 varchar(30) DEFAULT NULL,
		Phone2 varchar(30) DEFAULT NULL,
		Phone3 varchar(30) DEFAULT NULL,
		Status varchar(10) DEFAULT 'Active',
		MarketingNameplate varchar(100) DEFAULT NULL,
		IsCustomer BOOLEAN DEFAULT TRUE,
		BatchID INT DEFAULT 1
						
		);
		CREATE  TABLE CLOSEACCTtemp2(
		ActionType varchar(50),
		AccountID integer,
		SK_CustomerID INTEGER,
		AccountDesc varchar(50),
		TaxStatus integer,
		CA_B_ID integer,
		Sk_BrokerID INTEGER,
		ActionTS timestamp ,
		EffectiveDate date
		);

	
END;
$$ LANGUAGE 'plpgsql';