SET VERIFY OFF;
SET SERVEROUTPUT ON;


ACCEPT X NUMBER PROMPT "ENTER TOTAL NUMBER OF TRACKS= "
ACCEPT Y NUMBER PROMPT "CURRENT READ/WRITE HEAD= "
ACCEPT Z NUMBER PROMPT "Enter your choice : 1->FCFS 2->SCAN 3->C_SCAN 4->LOOk 5->C_LOOK "

ACCEPT D NUMBER PROMPT "start from direction_ 1)Larger 2)Smaller = "

DECLARE

totalTracks number:=&X;
rwHead number:=&Y;
choice number:=&Z;
directionIP number:=&D;
id number:=1;
NegativeInput EXCEPTION;
InvalidRWhead EXCEPTION;
InvaildChoice EXCEPTION;
InvalidDirection EXCEPTION;
BEGIN

	IF (totalTracks < 0) or (rwHead<0) or (choice<0) or (directionIP<0) THEN
		RAISE NegativeInput;
	END IF;
	
	IF rwHead > (totalTracks-1) THEN
		RAISE InvalidRWhead;
	END IF;
	
	IF(choice<1) or (choice>5) THEN
		RAISE InvaildChoice;
	END IF;
	
	IF (directionIP<1) or (directionIP>2) THEN
		RAISE InvalidDirection;
	END IF;
	
	insert into UserInput values(id,totalTracks,rwHead,choice,directionIP);
	id:=id+1;
	
	
	
	
	EXCEPTION
	WHEN NegativeInput THEN
		
		DBMS_OUTPUT.PUT_LINE('Given:');
		DBMS_OUTPUT.PUT_LINE('Read Write head:'||rwHead);
		DBMS_OUTPUT.PUT_LINE('Total number of tracks:'||totalTracks);
		IF(totalTracks < 0)THEN
			DBMS_OUTPUT.PUT_LINE('Total number of Tracks cannot be -ve');
			totalTracks:=totalTracks*(-1);
		END IF;	
		IF (rwHead<0) THEN
			DBMS_OUTPUT.PUT_LINE('Read Write head cannot be -ve');
			rwHead:=rwHead*(-1);
			
		END IF;
		IF (choice<0) THEN
			DBMS_OUTPUT.PUT_LINE('Choice cannot be -ve');
			choice:=choice*(-1);
			
		END IF;
		IF (directionIP<0) THEN
			DBMS_OUTPUT.PUT_LINE('Direction cannot be -ve');
			directionIP:=directionIP*(-1);
			
		END IF;
		insert into UserInput values(id,totalTracks,rwHead,choice,directionIP);
		id:=id+1;
	WHEN InvalidRWhead THEN
		DBMS_OUTPUT.PUT_LINE('Read Write head cannot be out of disk range !');
	WHEN InvaildChoice THEN
		DBMS_OUTPUT.PUT_LINE('Choice can be from 1 to 5 !');
	WHEN InvalidDirection THEN
		DBMS_OUTPUT.PUT_LINE('Direction can be 1 orr 2 !');
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('Unknown Error occured.');


END;
/
--select * from UserInput where id=1;

commit;

select * from myview;