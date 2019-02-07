/* Creation of a new schema
based on information from:
https://stackoverflow.com/questions/33527917/i-am-trying-to-create-new-schema-in-oracle-sql-developer
(Accessed: 2018-12-12)

Script has to be implemented as SYSDBA as you need Database-Administrator (DBA) Privileges !
*/

-- Create role with specific privileges:
CREATE ROLE schema_user;
-- Grant user system privileges to this role:
GRANT
    CREATE SESSION,
    CREATE TABLE,
    CREATE SEQUENCE,
    CREATE VIEW,
    CREATE PROCEDURE
TO schema_user;

-- Create user:
CREATE USER BK IDENTIFIED BY oracle;
-- Apply privileges from role "schema_user" to user "BK":
GRANT schema_user TO BK;
GRANT UNLIMITED TABLESPACE TO BK; -- Otherwise the import of the data into the tables will fail!

-- Verify schema creation:
SELECT username, account_status FROM dba_users WHERE username = 'BK';