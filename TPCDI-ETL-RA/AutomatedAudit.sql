/*AutomatedAudit*/

--DROP FUNCTION IF EXISTS AutomatedAudit();
--CREATE FUNCTION AutomatedAudit()
--RETURNS VOID AS $$
--BEGIN

--LOAD AUDIT TABLE FROM MERGED CSV

--BATCH1
COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\CashTransaction_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\CustomerMgmt_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\DailyMarket_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\Date_audit.csv'  DELIMITER ',' CSV HEADER; 


--finwire audit
COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1967Q1_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1967Q2_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1967Q3_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1967Q4_audit.csv'  DELIMITER ',' CSV HEADER;


COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1968Q1_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1968Q2_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1968Q3_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1968Q4_audit.csv'  DELIMITER ',' CSV HEADER;



COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1969Q1_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1969Q2_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1969Q3_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1969Q4_audit.csv'  DELIMITER ',' CSV HEADER;


COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1970Q1_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1970Q2_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1970Q3_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1970Q4_audit.csv'  DELIMITER ',' CSV HEADER;


COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1971Q1_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1971Q2_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1971Q3_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1971Q4_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1972Q1_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1972Q2_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1972Q3_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1972Q4_audit.csv'  DELIMITER ',' CSV HEADER;


COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1973Q1_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1973Q2_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1973Q3_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1973Q4_audit.csv'  DELIMITER ',' CSV HEADER;



COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1974Q1_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1974Q2_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1974Q3_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1974Q4_audit.csv'  DELIMITER ',' CSV HEADER;



COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1975Q1_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1975Q2_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1975Q3_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1975Q4_audit.csv'  DELIMITER ',' CSV HEADER;



COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1976Q1_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1976Q2_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1976Q3_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1976Q4_audit.csv'  DELIMITER ',' CSV HEADER;



COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1977Q1_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1977Q2_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1977Q3_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1977Q4_audit.csv'  DELIMITER ',' CSV HEADER;


COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1978Q1_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1978Q2_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1978Q3_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1978Q4_audit.csv'  DELIMITER ',' CSV HEADER;


COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1979Q1_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1979Q2_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1979Q3_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1979Q4_audit.csv'  DELIMITER ',' CSV HEADER;




COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1980Q1_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1980Q2_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1980Q3_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1980Q4_audit.csv'  DELIMITER ',' CSV HEADER;


COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1981Q1_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1981Q2_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1981Q3_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1981Q4_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1982Q1_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1982Q2_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1982Q3_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1982Q4_audit.csv'  DELIMITER ',' CSV HEADER;


COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1983Q1_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1983Q2_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1983Q3_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1983Q4_audit.csv'  DELIMITER ',' CSV HEADER;



COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1984Q1_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1984Q2_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1984Q3_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1984Q4_audit.csv'  DELIMITER ',' CSV HEADER;



COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1985Q1_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1985Q2_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1985Q3_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1985Q4_audit.csv'  DELIMITER ',' CSV HEADER;



COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1986Q1_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1986Q2_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1986Q3_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1986Q4_audit.csv'  DELIMITER ',' CSV HEADER;



COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1987Q1_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1987Q2_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1987Q3_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1987Q4_audit.csv'  DELIMITER ',' CSV HEADER;


COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1988Q1_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1988Q2_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1988Q3_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1988Q4_audit.csv'  DELIMITER ',' CSV HEADER;


COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1989Q1_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1989Q2_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1989Q3_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1989Q4_audit.csv'  DELIMITER ',' CSV HEADER;




COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1990Q1_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1990Q2_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1990Q3_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1990Q4_audit.csv'  DELIMITER ',' CSV HEADER;


COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1991Q1_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1991Q2_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1991Q3_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1991Q4_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1992Q1_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1992Q2_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1992Q3_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1992Q4_audit.csv'  DELIMITER ',' CSV HEADER;


COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1993Q1_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1993Q2_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1993Q3_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1993Q4_audit.csv'  DELIMITER ',' CSV HEADER;



COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1994Q1_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1994Q2_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1994Q3_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1994Q4_audit.csv'  DELIMITER ',' CSV HEADER;



COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1995Q1_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1995Q2_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1995Q3_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1995Q4_audit.csv'  DELIMITER ',' CSV HEADER;



COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1996Q1_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1996Q2_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1996Q3_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1996Q4_audit.csv'  DELIMITER ',' CSV HEADER;



COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1997Q1_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1997Q2_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1997Q3_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1997Q4_audit.csv'  DELIMITER ',' CSV HEADER;


COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1998Q1_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1998Q2_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1998Q3_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1998Q4_audit.csv'  DELIMITER ',' CSV HEADER;


COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1999Q1_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1999Q2_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1999Q3_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE1999Q4_audit.csv'  DELIMITER ',' CSV HEADER;






COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2000Q1_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2000Q2_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2000Q3_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2000Q4_audit.csv'  DELIMITER ',' CSV HEADER;


COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2001Q1_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2001Q2_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2001Q3_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2001Q4_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2002Q1_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2002Q2_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2002Q3_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2002Q4_audit.csv'  DELIMITER ',' CSV HEADER;


COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2003Q1_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2003Q2_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2003Q3_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2003Q4_audit.csv'  DELIMITER ',' CSV HEADER;



COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2004Q1_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2004Q2_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2004Q3_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2004Q4_audit.csv'  DELIMITER ',' CSV HEADER;



COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2005Q1_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2005Q2_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2005Q3_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2005Q4_audit.csv'  DELIMITER ',' CSV HEADER;



COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2006Q1_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2006Q2_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2006Q3_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2006Q4_audit.csv'  DELIMITER ',' CSV HEADER;



COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2007Q1_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2007Q2_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2007Q3_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2007Q4_audit.csv'  DELIMITER ',' CSV HEADER;


COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2008Q1_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2008Q2_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2008Q3_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2008Q4_audit.csv'  DELIMITER ',' CSV HEADER;


COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2009Q1_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2009Q2_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2009Q3_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2009Q4_audit.csv'  DELIMITER ',' CSV HEADER;




COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2010Q1_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2010Q2_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2010Q3_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2010Q4_audit.csv'  DELIMITER ',' CSV HEADER;


COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2011Q1_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2011Q2_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2011Q3_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2011Q4_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2012Q1_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2012Q2_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2012Q3_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2012Q4_audit.csv'  DELIMITER ',' CSV HEADER;


COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2013Q1_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2013Q2_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2013Q3_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2013Q4_audit.csv'  DELIMITER ',' CSV HEADER;



COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2014Q1_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2014Q2_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2014Q3_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2014Q4_audit.csv'  DELIMITER ',' CSV HEADER;



COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2015Q1_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2015Q2_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2015Q3_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2015Q4_audit.csv'  DELIMITER ',' CSV HEADER;



COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2016Q1_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2016Q2_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2016Q3_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2016Q4_audit.csv'  DELIMITER ',' CSV HEADER;



COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2017Q1_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2017Q2_audit.csv'  DELIMITER ',' CSV HEADER; 

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\FINWIRE2017Q3_audit.csv'  DELIMITER ',' CSV HEADER;


COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\HoldingHistory_audit.csv'  DELIMITER ',' CSV HEADER;


COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\HR_audit.csv'  DELIMITER ',' CSV HEADER;


COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\Industry_audit.csv'  DELIMITER ',' CSV HEADER;


COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\Prospect_audit.csv'  DELIMITER ',' CSV HEADER;


COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\StatusType_audit.csv'  DELIMITER ',' CSV HEADER;


COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\TaxRate_audit.csv'  DELIMITER ',' CSV HEADER;


COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\Time_audit.csv'  DELIMITER ',' CSV HEADER;


COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\Trade_audit.csv'  DELIMITER ',' CSV HEADER;


COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\TradeHistory_audit.csv'  DELIMITER ',' CSV HEADER;


COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\TradeType_audit.csv'  DELIMITER ',' CSV HEADER;


COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1\WatchHistory_audit.csv'  DELIMITER ',' CSV HEADER;





--BATCH2
COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch2\Account_audit.csv'  DELIMITER ',' CSV HEADER;


COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch2\CashTransaction_audit.csv'  DELIMITER ',' CSV HEADER;


COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch2\Customer_audit.csv'  DELIMITER ',' CSV HEADER;


COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch2\DailyMarket_audit.csv'  DELIMITER ',' CSV HEADER;


COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch2\HoldingHistory_audit.csv'  DELIMITER ',' CSV HEADER;


COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch2\Prospect_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch2\Trade_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch2\WatchHistory_audit.csv'  DELIMITER ',' CSV HEADER;







--BATCH3
COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch3\Account_audit.csv'  DELIMITER ',' CSV HEADER;


COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch3\CashTransaction_audit.csv'  DELIMITER ',' CSV HEADER;


COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch3\Customer_audit.csv'  DELIMITER ',' CSV HEADER;


COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch3\DailyMarket_audit.csv'  DELIMITER ',' CSV HEADER;


COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch3\HoldingHistory_audit.csv'  DELIMITER ',' CSV HEADER;


COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch3\Prospect_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch3\Trade_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch3\WatchHistory_audit.csv'  DELIMITER ',' CSV HEADER;



--outside
COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch1_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch2_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Batch3_audit.csv'  DELIMITER ',' CSV HEADER;

COPY Audit(dataset, batchid, date, attribute, value, dvalue)
FROM 'D:\TPC-DI_Staging_Area\data\Generator_audit.csv'  DELIMITER ',' CSV HEADER;


--VISIBILITY 1
--PERFORM visibility1();


--AUDIT QUERY
--PERFORM tpcdi_Audit();




--END;
--$$ LANGUAGE 'plpgsql';
