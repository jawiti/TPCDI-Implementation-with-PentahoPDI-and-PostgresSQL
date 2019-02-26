An Implementation of ETL workflows in the TPCDI specification document with relational algebra - Postgres SQL
Note:
1. The main.sql file has functions to run all three loads of the dataset. After running the main.sql file, 
the automatedaudit.sql file is run to populate the audit table of the datawarehouse. Then the two visibility
files are run as well. Finally, the tpcdi_audit queries are run to show the results of the validation. 
2. The file paths to the source files need to be changed.
