SET VERIFY OFF;
SET SERVEROUTPUT ON;


CREATE OR REPLACE PACKAGE mypackSimulator AS

	
	PROCEDURE FCFS(RW IN number);
	PROCEDURE SCAN(RW IN number,ENDTrack IN number,STARTTrack IN number,Direction number);
	PROCEDURE C_SCAN(RW IN number,ENDTrack IN number,STARTTrack IN number,Direction number);
	PROCEDURE LOOK(RW IN number,Direction number);
	PROCEDURE C_LOOK(RW IN number,Direction number);
	
	FUNCTION Choice
    RETURN NUMBER;
	
END mypackSimulator;
/

CREATE OR REPLACE PACKAGE BODY mypackSimulator  AS



PROCEDURE FCFS(RW IN number)
IS
fcfsID number;
fcfsTrack number;
fcfsFlag number;
seekTime number:=0;
RWHead number;

BEGIN

    RWHead:=RW;
	FOR R IN(select id,track from FCFS_SSTF_FragmentServer)LOOP
		fcfsID:=R.id;
		fcfsTrack:=R.track;
		insert into sequenceTable@site1 values(RWHead,fcfsTrack,abs(fcfsTrack-RWHead));
		seekTime:=seekTime+abs(RWHead-fcfsTrack);
		RWHead:=fcfsTrack;
		update FCFS_SSTF_FragmentSite1@site1 set flag=1 where id=fcfsID;
	END LOOP;
	
	
	DBMS_OUTPUT.PUT_LINE('Seek time: '||seekTime);
	
END FCFS;





PROCEDURE SCAN(RW IN number,ENDTrack IN number,STARTTrack IN number,Direction number)
IS
LNextTrack number;
SNextTrack number;
seekTime number:=0;
RWHead number;
LEndingTrack number;
SstartingTrack number;
Dir number;

BEGIN

		RWHead:=RW;
		LEndingTrack:=ENDTrack;
		SstartingTrack:=STARTTrack;
		Dir:=Direction;
		
		IF Dir=1 THEN
        update largerThanH set flag=0;
		update smallerThanH@site1 set flag=0;
	
		FOR R IN (select track from largerThanH where flag=0) LOOP
		LNextTrack:=R.track;
		insert into sequenceTable@site1 values(RWHead,LNextTrack,(LNextTrack-RWHead));
		seekTime:=seekTime+ abs(LNextTrack-RWHead);
		RWHead:=LNextTrack;
		update largerThanH set flag=1 where track=RWHead;
		END LOOP;
		
		LNextTrack:=LEndingTrack;
		insert into sequenceTable@site1 values(RWHead,LNextTrack,(LNextTrack-RWHead));
		seekTime:=seekTime+ abs(LNextTrack-RWHead);
		RWHead:=LNextTrack;
		
		
		FOR R IN (select track from smallerThanH@site1 where flag=0)LOOP
		SNextTrack:=R.track;
		insert into sequenceTable@site1 values(RWHead,SNextTrack,(RWHead-SNextTrack));
		seekTime:=seekTime+abs(RWHead-SNextTrack);
		RWHead:=SNextTrack;
		update smallerThanH@site1 set flag=1 where track=RWHead;
		END LOOP;
		
		ELSIF Dir=2 THEN
			
		FOR R IN (select track from smallerThanH@site1 where flag=0)LOOP
		SNextTrack:=R.track;
		insert into sequenceTable@site1 values(RWHead,SNextTrack,abs(RWHead-SNextTrack));
		seekTime:=seekTime+abs(RWHead-SNextTrack);
		RWHead:=SNextTrack;
		update smallerThanH@site1 set flag=1 where track=RWHead;
		END LOOP;
		
		SNextTrack:=SstartingTrack;
		insert into sequenceTable@site1 values(RWHead,SNextTrack,abs(SNextTrack-RWHead));
		seekTime:=seekTime+ abs(SNextTrack-RWHead);
		RWHead:=SNextTrack;
		
		FOR R IN (select track from largerThanH where flag=0) LOOP
		LNextTrack:=R.track;
		insert into sequenceTable@site1 values(RWHead,LNextTrack,abs(LNextTrack-RWHead));
		seekTime:=seekTime+ abs(LNextTrack-RWHead);
		RWHead:=LNextTrack;
		update largerThanH set flag=1 where track=RWHead;
		END LOOP;
		
		ELSE
			DBMS_OUTPUT.PUT_LINE('PLEASE SPECIFY A DIRECTION.');
		
		
		END IF;
	
	
	
	DBMS_OUTPUT.PUT_LINE('Seek time: '||seekTime);
	
END SCAN;



PROCEDURE C_SCAN(RW IN number,ENDTrack IN number,STARTTrack IN number,Direction number)
IS
LNextTrack number;
SNextTrack number;
seekTime number:=0;
RWHead number;
LEndingTrack number;
SstartingTrack number;
Dir number;

BEGIN

		RWHead:=RW;
		LEndingTrack:=ENDTrack;
		SstartingTrack:=STARTTrack;
		Dir:=Direction;
		
		IF Dir=1 THEN
        update largerThanH set flag=0;
		update smallerThanHTemp@site1 set flag=0;
	
		FOR R IN (select track from largerThanH where flag=0) LOOP
		LNextTrack:=R.track;
		insert into sequenceTable@site1 values(RWHead,LNextTrack,abs(LNextTrack-RWHead));
		seekTime:=seekTime+abs(LNextTrack-RWHead);
		RWHead:=LNextTrack;
		update largerThanH set flag=1 where track=RWHead;
		END LOOP;
		
		LNextTrack:=LEndingTrack;
		insert into sequenceTable@site1 values(RWHead,LNextTrack,abs(LNextTrack-RWHead));
		seekTime:=seekTime+ abs(LNextTrack-RWHead);
		RWHead:=LNextTrack;
		
		SNextTrack:=SstartingTrack;
		insert into sequenceTable@site1 values(RWHead,SNextTrack,abs(RWHead-SNextTrack));
		seekTime:=seekTime+ abs(RWHead-SNextTrack);
		RWHead:=SNextTrack;
		
		
		FOR R IN (select track from smallerThanHTemp@site1 where flag=0)LOOP
		SNextTrack:=R.track;
		insert into sequenceTable@site1 values(RWHead,SNextTrack,abs(RWHead-SNextTrack));
		seekTime:=seekTime+ abs(RWHead-SNextTrack);
		RWHead:=SNextTrack;
		update smallerThanHTemp@site1 set flag=1 where track=RWHead;
		END LOOP;
		
		ELSIF Dir=2 THEN
		
		FOR R IN (select track from smallerThanH@site1 where flag=0)LOOP
		SNextTrack:=R.track;
		insert into sequenceTable@site1 values(RWHead,SNextTrack,abs(RWHead-SNextTrack));
		seekTime:=seekTime+abs(RWHead-SNextTrack);
		RWHead:=SNextTrack;
		update smallerThanH@site1 set flag=1 where track=RWHead;
		END LOOP;
		
		SNextTrack:=SstartingTrack;
		insert into sequenceTable@site1 values(RWHead,SNextTrack,abs(RWHead-SNextTrack));
		seekTime:=seekTime+ abs(RWHead-SNextTrack);
		RWHead:=SNextTrack;
		
		LNextTrack:=LEndingTrack;
		insert into sequenceTable@site1 values(RWHead,LNextTrack,abs(LNextTrack-RWHead));
		seekTime:=seekTime+ abs(LNextTrack-RWHead);
		RWHead:=LNextTrack;
		
		FOR R IN (select track from largerThanHDesc where flag=0) LOOP
		LNextTrack:=R.track;
		insert into sequenceTable@site1 values(RWHead,LNextTrack,abs(LNextTrack-RWHead));
		seekTime:=seekTime+abs(LNextTrack-RWHead);
		RWHead:=LNextTrack;
		update largerThanHDesc set flag=1 where track=RWHead;
		END LOOP;
		
		
		ELSE
			DBMS_OUTPUT.PUT_LINE('PLEASE SPECIFY A DIRECTION.');
		
		END IF;
	
	
	DBMS_OUTPUT.PUT_LINE('Seek time: '||seekTime);
	
END C_SCAN;


PROCEDURE LOOK(RW IN number,Direction number)
IS
LNextTrack number;
SNextTrack number;
seekTime number:=0;
RWHead number;
Dir number;

BEGIN

		RWHead:=RW;
		Dir:=Direction;
		
		IF Dir=1 THEN
		
        update largerThanH set flag=0;
		update smallerThanH@site1 set flag=0;
	
		FOR R IN (select track from largerThanH where flag=0) LOOP
		LNextTrack:=R.track;
		insert into sequenceTable@site1 values(RWHead,LNextTrack,abs(LNextTrack-RWHead));
		seekTime:=seekTime+ abs(LNextTrack-RWHead);
		RWHead:=LNextTrack;
		update largerThanH set flag=1 where track=RWHead;
		END LOOP;
		
		
		
		FOR R IN (select track from smallerThanH@site1 where flag=0)LOOP
		SNextTrack:=R.track;
		insert into sequenceTable@site1 values(RWHead,SNextTrack,abs(RWHead-SNextTrack));
		seekTime:=seekTime+abs(RWHead-SNextTrack);
		RWHead:=SNextTrack;
		update smallerThanH@site1 set flag=1 where track=RWHead;
		END LOOP;
		
		ELSIF Dir=2 THEN
		
		FOR R IN (select track from smallerThanH@site1 where flag=0)LOOP
		SNextTrack:=R.track;
		insert into sequenceTable@site1 values(RWHead,SNextTrack,abs(RWHead-SNextTrack));
		seekTime:=seekTime+abs(RWHead-SNextTrack);
		RWHead:=SNextTrack;
		update smallerThanH@site1 set flag=1 where track=RWHead;
		END LOOP;
		
		FOR R IN (select track from largerThanH where flag=0) LOOP
		LNextTrack:=R.track;
		insert into sequenceTable@site1 values(RWHead,LNextTrack,abs(LNextTrack-RWHead));
		seekTime:=seekTime+ abs(LNextTrack-RWHead);
		RWHead:=LNextTrack;
		update largerThanH set flag=1 where track=RWHead;
		END LOOP;
		
		ELSE
			DBMS_OUTPUT.PUT_LINE('PLEASE SPECIFY A DIRECTION.');
		
		END IF;
		
	
	
	DBMS_OUTPUT.PUT_LINE('Seek time: '||seekTime);
	
END LOOK;


PROCEDURE C_LOOK(RW IN number,Direction number)
IS
LNextTrack number;
SNextTrack number;
seekTime number:=0;
RWHead number;
Dir number;

BEGIN

		RWHead:=RW;
		Dir:=Direction;
		
		IF Dir=1 THEN
		
        update largerThanH set flag=0;
		update smallerThanHTemp@site1 set flag=0;
	
		FOR R IN (select track from largerThanH where flag=0) LOOP
		LNextTrack:=R.track;
		insert into sequenceTable@site1 values(RWHead,LNextTrack,abs(LNextTrack-RWHead));
		seekTime:=seekTime+abs(LNextTrack-RWHead);
		RWHead:=LNextTrack;
		update largerThanH set flag=1 where track=RWHead;
		END LOOP;
		
		
		
		
		FOR R IN (select track from smallerThanHTemp@site1 where flag=0)LOOP
		SNextTrack:=R.track;
		insert into sequenceTable@site1 values(RWHead,SNextTrack,abs(RWHead-SNextTrack));
		seekTime:=seekTime+ abs(RWHead-SNextTrack);
		RWHead:=SNextTrack;
		update smallerThanHTemp@site1 set flag=1 where track=RWHead;
		END LOOP;
		
		ELSIF Dir=2 THEN
		
		FOR R IN (select track from smallerThanH@site1 where flag=0)LOOP
		SNextTrack:=R.track;
		insert into sequenceTable@site1 values(RWHead,SNextTrack,abs(RWHead-SNextTrack));
		seekTime:=seekTime+abs(RWHead-SNextTrack);
		RWHead:=SNextTrack;
		update smallerThanH@site1 set flag=1 where track=RWHead;
		END LOOP;
		
		FOR R IN (select track from largerThanHDesc where flag=0) LOOP
		LNextTrack:=R.track;
		insert into sequenceTable@site1 values(RWHead,LNextTrack,abs(LNextTrack-RWHead));
		seekTime:=seekTime+abs(LNextTrack-RWHead);
		RWHead:=LNextTrack;
		update largerThanHDesc set flag=1 where track=RWHead;
		END LOOP;
		
		ELSE
			DBMS_OUTPUT.PUT_LINE('PLEASE SPECIFY A DIRECTION.');
		
		END IF;
	
	
	
	DBMS_OUTPUT.PUT_LINE('Seek time: '||seekTime);
	
END C_LOOK;
		

FUNCTION Choice
RETURN NUMBER
IS
choice number;
retChoice number:=0;
BEGIN

	select choiceInput into choice from UserInput@site1 where id=1;
	
	IF choice=1 THEN
		retChoice:=1;
		
	ELSIF choice=2 THEN
		retChoice:=2;
		
	ELSIF choice=3 THEN
		retChoice:=3;
		
	ELSIF choice=4 THEN
		retChoice:=4;
		
	ELSIF choice=5 THEN
		retChoice:=5;
		
	ELSE
		retChoice:=0;
	END IF;
	
	return retChoice;

END Choice;




END mypackSimulator;
/	



