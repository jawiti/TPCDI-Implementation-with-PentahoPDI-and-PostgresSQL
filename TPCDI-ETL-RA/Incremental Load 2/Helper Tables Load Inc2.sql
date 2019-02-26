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

DROP FUNCTION IF EXISTS HelperTablesLoadInc2();
CREATE FUNCTION HelperTablesLoadInc2()
RETURNS VOID AS $$
BEGIN

	DROP TABLE IF EXISTS Account2,BatchDate2,CashTransaction2,Customer2,DailyMarket2,HoldingHistory2,TempProspect2,
	Trade2,WatchHistory2;

		
	CREATE  TABLE Account2(
		CDC_FLAG CHAR(1) NOT NULL  CHECK (CDC_FLAG = 'I' OR CDC_FLAG = 'U'),
		CDC_DSN NUMERIC(12) NOT NULL,
		CA_ID NUMERIC(11) NOT NULL,
		CA_B_ID NUMERIC(11) NOT NULL,
		CA_C_ID NUMERIC(11) NOT NULL,
		CA_NAME CHAR(50),
		CA_TAX_ST NUMERIC(1),
		CA_ST_ID CHAR(4)
	);
	
	COPY Account2 FROM 'D:\TPC-DI_Staging_Area\data\Batch3\Account.txt' 
	( FORMAT text, ENCODING 'UTF8', DELIMITER '|');
	
	
	CREATE TABLE TempProspect2 ( AgencyID CHAR(30) NOT NULL UNIQUE,  
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
	COPY TempProspect2(AgencyID, LastName, FirstName,
	MiddleInitial, Gender, AddressLine1, AddressLine2, PostalCode, City, State, Country,
	Phone, Income, numericberCars, numericberChildren, MaritalStatus, Age, CreditRating,
	OwnOrRentFlag, Employer, numericberCreditCards, NetWorth)
	FROM 'D:\TPC-DI_Staging_Area\data\Batch3\Prospect.csv'  DELIMITER ',' CSV HEADER; 

--UPDATE TempProspect2
	--SET
	--AddressLine2=NULL
	--WHERE 
	--AddressLine2='';

	
	CREATE  TABLE BatchDate2(
		BatchDateColumn Date NOT NULL
	);
	
	COPY BatchDate2 FROM 'D:\TPC-DI_Staging_Area\data\Batch3\BatchDate.txt' 
	( FORMAT text, ENCODING 'UTF8' );



	CREATE  TABLE Customer2(
		CDC_FLAG CHAR(1) CHECK (CDC_FLAG = 'I' OR CDC_FLAG = 'U'),
		CDC_DSN NUMERIC(12) NOT NULL,
		C_ID NUMERIC(11) NOT NULL,
		C_TAX_ID CHAR(20) NOT NULL,
		C_ST_ID CHAR(4),
		C_L_NAME CHAR(25) Not NULL,
		C_F_NAME CHAR(20) Not NULL,
		C_M_NAME CHAR(1),
		C_GNDR CHAR(1),
		--C_TIER NUMERIC(1),
		C_TIER CHAR(1),
		C_DOB DATE Not NULL,
		C_ADLINE1 CHAR(80) Not NULL,
		C_ADLINE2 CHAR(80),
		C_ZIPCODE CHAR(12) Not NULL,
		C_CITY CHAR(25) Not NULL,
		C_STATE_PROV CHAR(20) Not NULL,
		C_CTRY CHAR(24),
		C_CTRY_1 CHAR(3),
		C_AREA_1 CHAR(3),
		C_LOCAL_1 CHAR(10),
		C_EXT_1 CHAR(5),
		C_CTRY_2 CHAR(3),
		C_AREA_2 CHAR(3),
		C_LOCAL_2 CHAR(10),
		C_EXT_2 CHAR(5),
		C_CTRY_3 CHAR(3),
		C_AREA_3 CHAR(3),
		C_LOCAL_3 CHAR(10),
		C_EXT_3 CHAR(5),
		C_EMAIL_1 CHAR(50),
		C_EMAIL_2 CHAR(50),
		C_LCL_TX_ID CHAR(4) Not NULL,
		C_NAT_TX_ID CHAR(4) Not NULL
	);

	COPY Customer2 FROM 'D:\TPC-DI_Staging_Area\data\Batch3\Customer.txt' 
	( FORMAT text, ENCODING 'UTF8', DELIMITER '|');


	UPDATE Customer2
	SET
	C_ADLINE2=NULL
	WHERE 
	C_ADLINE2='';

	UPDATE Customer2
	SET
	C_TIER=NULL
	WHERE 
	C_TIER='';

	
	CREATE  TABLE CashTransaction2(
	CDC_FLAG CHAR(1) CHECK (CDC_FLAG = 'I'),
		CDC_DSN NUMERIC(12) NOT NULL,
		CT_CA_ID CHAR(5) NOT NULL,
		CT_DTS DATE NOT NULL,
		CT_AMT NUMERIC(10,2) NOT NULL,
		CT_NAME CHAR(100) NOT NULL
	);

	
	COPY CashTransaction2 FROM 'D:\TPC-DI_Staging_Area\data\Batch3\CashTransaction.txt' 
	( FORMAT text, ENCODING 'UTF8', DELIMITER '|');

	CREATE  TABLE HoldingHistory2(
	CDC_FLAG CHAR(1) CHECK (CDC_FLAG = 'I'),
		CDC_DSN NUMERIC(12) NOT NULL,
		HH_H_T_ID INT NOT NULL,
		HH_T_ID INT NOT NULL,
		HH_BEFORE_QTY INT NOT NULL,
		HH_AFTER_QTY INT NOT NULL
	);
	
	COPY HoldingHistory2 FROM 'D:\TPC-DI_Staging_Area\data\Batch3\HoldingHistory.txt' 
	( FORMAT text, ENCODING 'UTF8', DELIMITER '|');
	



	CREATE  TABLE DailyMarket2(
	CDC_FLAG CHAR(1) CHECK (CDC_FLAG = 'I'),
		CDC_DSN NUMERIC(12) NOT NULL,
		DM_DATE DATE NOT NULL,
		DM_S_SYMB CHAR(15) NOT NULL,
		DM_CLOSE NUMERIC(8,2) NOT NULL,
		DM_HIGH NUMERIC(8,2) NOT NULL,
		DM_LOW NUMERIC(8,2) NOT NULL,
		DM_VOL NUMERIC(12) NOT NULL
	);
	
	COPY DailyMarket2 FROM 'D:\TPC-DI_Staging_Area\data\Batch3\DailyMarket.txt' 
	( FORMAT text, ENCODING 'UTF8', DELIMITER '|');


	CREATE  TABLE WatchHistory2(
	CDC_FLAG CHAR(1) CHECK (CDC_FLAG = 'I'),
		CDC_DSN NUMERIC(12) NOT NULL,
		W_C_ID INTEGER NOT NULL,
		W_S_SYMB CHAR(15) NOT NULL,
		W_DTS DATE NOT NULL,
		W_ACTION CHAR(4) NOT NULL	
	);
	
	COPY WatchHistory2 FROM 'D:\TPC-DI_Staging_Area\data\Batch3\WatchHistory.txt' 
	( FORMAT text, ENCODING 'UTF8', DELIMITER '|');



	CREATE  TABLE Trade2(
	CDC_FLAG CHAR(1) CHECK (CDC_FLAG = 'I' OR CDC_FLAG = 'U'),
	CDC_DSN NUMERIC(12) NOT NULL,
	T_ID NUMERIC(15) Not Null,
	T_DTS TIMESTAMP Not Null,
	T_ST_ID CHAR(4) Not Null,
	T_TT_ID CHAR(3) Not Null,
	T_IS_CASH BOOLEAN,
	T_S_SYMB CHAR(15) Not Null,
	T_QTY NUMERIC(6),
	T_BID_PRICE NUMERIC(8,2),
	T_CA_ID NUMERIC(11),
	T_EXEC_NAME CHAR(49) Not Null,
	T_TRADE_PRICE CHAR(10),
	T_CHRG CHAR(10),
	T_COMM CHAR(10),
	T_TAX  CHAR(10)	
	/*T_TRADE_PRICE NUMERIC(8,2),
	T_CHRG NUMERIC(10,2),
	T_COMM NUMERIC(10,2),
	T_TAX  NUMERIC(10,2)*/	
		);
	
	COPY Trade2 FROM 'D:\TPC-DI_Staging_Area\data\Batch3\Trade.txt' 
	( FORMAT text, ENCODING 'UTF8', DELIMITER '|');


	END;
$$ LANGUAGE 'plpgsql';
