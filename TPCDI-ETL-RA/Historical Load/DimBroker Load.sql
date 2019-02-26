/*DimBroker Load*/

DROP FUNCTION IF EXISTS DimBrokerLoad();
CREATE FUNCTION DimBrokerLoad()
RETURNS VOID AS $$
BEGIN

	Drop table if exists HRcsv,BatchDate1,Btemp,Btemp1,Btemp2,Btemp3,Btemp4;
	--DELETE FROM DimBroker WHERE BrokerID IS NOT NULL;



	CREATE TABLE HRcsv ( 
	EmployeeID integer NOT NULL,
	ManagerID integer NOT NULL,
	EmployeeFirstName CHAR(30) NOT NULL,
	EmployeeLastName CHAR(30) NOT NULL,
	EmployeeMI CHAR(1),
	EmployeeJobCode numeric(3),
	EmployeeBranch CHAR(30),
	EmployeeOffice CHAR(10) ,
	EmployeePhone CHAR(14)						
	);

	--Insert data from csv
	SET DATESTYLE TO POSTGRES,US;
	COPY HRcsv(EmployeeID, ManagerID, EmployeeFirstName,EmployeeLastName,EmployeeMI,EmployeeJobCode,
	EmployeeBranch, EmployeeOffice, EmployeePhone)
	FROM 'D:\TPC-DI_Staging_Area\data\Batch1\HR.csv'  DELIMITER ',' CSV HEADER; 


	CREATE TEMPORARY TABLE Btemp AS
	SELECT * 
	FROM HRcsv
	WHERE EmployeeJobCode=314;


	ALTER TABLE Btemp
	ADD IsCustomer BOOLEAN,
	ADD BatchID INT,
	ADD EndDate INT;


	Create TEMPORARY TABLE Btemp1 AS
	SELECT MIN(datevalue) AS EffectiveDate FROM DimDate;


	Create TEMPORARY TABLE Btemp2 AS
	SELECT *
	FROM Btemp RIGHT OUTER JOIN Btemp1 ON
	EffectiveDate IS NOT NULL;

	  
	INSERT INTO DimBroker(SK_BrokerID,BrokerID,ManagerID,FirstName,LastName,
	MiddleInitial,Branch,Office,Phone,IsCurrent,BatchID,EffectiveDate,EndDate)
	SELECT row_number() over( order by 1) as SK_BrokerID, EmployeeID, ManagerID, EmployeeFirstName,EmployeeLastName,
	EmployeeMI,EmployeeBranch, EmployeeOffice, EmployeePhone,TRUE,1,EffectiveDate,'9999-12-31'
	FROM Btemp2
	ORDER BY SK_BrokerID ASC;


END;
$$ LANGUAGE 'plpgsql';