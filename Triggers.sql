SET SERVEROUTPUT ON;

CREATE OR REPLACE TRIGGER serverTablelargerThanH 
AFTER INSERT 
ON largerThanH
DECLARE
BEGIN
	DBMS_OUTPUT.PUT_LINE('Data inserted from server in largerThanH table in ascending order');
END;
/

CREATE OR REPLACE TRIGGER serverTablelargerThanH2
BEFORE INSERT 
ON largerThanH
DECLARE
BEGIN
	DBMS_OUTPUT.PUT_LINE('Server is trying to insert data in largerThanH table');
END;
/
