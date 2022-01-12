SET VERIFY OFF;
SET SERVEROUTPUT ON;


@C:\Users\Naba\Desktop\4.1\Moontaha\DDS\Lab\Lab5\DiskSchedulingWithDDS\DiskSchedulingAlgorithms.sql


DECLARE

totalTracks number;
rwHead number;
startingTrack number;
endingTrack number;

total_track_in_requestQ number;
Lid largerThanH.id%TYPE:=0;
Ltrack largerThanH.track%TYPE;
Lflag largerThanH.flag%TYPE:=0;
S_id largerThanH.id%TYPE:=0;
S_track largerThanH.track%TYPE;
S_flag largerThanH.flag%TYPE:=0;
Sid largerThanH.id%TYPE;
Strack largerThanH.track%TYPE;
Sflag largerThanH.flag%TYPE:=0;
F_ID number;
F_track number;
F_flag number:=0;

DLid number:=0;
DLtrack number;
Dflag number:=0;

choiceReturn number;

directionIP number;

BEGIN

	select totaltrackInput,rwheadInput,directionInput into totalTracks,rwHead,directionIP from UserInput@site1 where id=1;
	--DBMS_OUTPUT.PUT_LINE(totalTracks||' '||rwHead||' '||directionIP);
	
	select count(rqId) into total_track_in_requestQ from requestQueue@site1;
	DBMS_OUTPUT.PUT_LINE('total_track_in_requestQ: '||total_track_in_requestQ);
	
	FOR R IN(select rqId,trackNo from requestQueue@site1 order by trackNo) LOOP
		Ltrack:=R.trackNo;
		S_track:=R.trackNo;
		IF Ltrack>rwHead THEN
			Lid:=R.rqId;
			insert into largerThanH values(Lid,Ltrack,Lflag);
		ELSE
			S_id:=R.rqId;
			insert into smallerThanHTemp@site1 values(S_id,S_track,S_flag);
		END IF;
	
	END LOOP;
	
	FOR I IN (select * from largerThanH order by track desc)LOOP
		
		DLid:=I.id;
		DLtrack:=I.track;
		insert into largerThanHDesc values(DLid,DLtrack,Dflag);
		
	END LOOP;
	
	
	FOR I IN (select * from smallerThanHTemp@site1 order by track desc)LOOP
		
		Sid:=I.id;
		Strack:=I.track;
		insert into smallerThanH@site1 values(Sid,Strack,Sflag);
		
	END LOOP;
	
	FOR R IN(select rqId,trackNo from requestQueue@site1) LOOP
		F_ID:=R.rqId;
		F_track:=R.trackNo;
		insert into FCFS_SSTF_FragmentServer values(F_ID,F_track);
		insert into FCFS_SSTF_FragmentSite1@site1 values(F_ID,F_flag);		
	
	END LOOP;
	
	startingTrack:=0;
	endingTrack:=totalTracks-1;
	DBMS_OUTPUT.PUT_LINE('startingTrack: '||startingTrack||'  endingTrack: '||endingTrack);
	
	
	
	choiceReturn:=mypackSimulator.Choice;
	
	
	
	
	IF choiceReturn=1 THEN
		DBMS_OUTPUT.PUT_LINE('----FCFS----');
		mypackSimulator.FCFS(rwHead);
	
	ELSIF choiceReturn=2 THEN
		DBMS_OUTPUT.PUT_LINE('----SCAN----');
		mypackSimulator.SCAN(rwHead,endingTrack,startingTrack,directionIP);
	ELSIF choiceReturn=3 THEN
		DBMS_OUTPUT.PUT_LINE('----C-SCAN----');
		mypackSimulator.C_SCAN(rwHead,endingTrack,startingTrack,directionIP);
	ELSIF choiceReturn=4 THEN
		DBMS_OUTPUT.PUT_LINE('----LOOK----');
		mypackSimulator.LOOK(rwHead,directionIP);
	ELSIF choiceReturn=5 THEN
		DBMS_OUTPUT.PUT_LINE('----C-LOOK----');
		mypackSimulator.C_LOOK(rwHead,directionIP);
	
	ELSE
		DBMS_OUTPUT.PUT_LINE('PLEASE ENTER a choice');
	END IF;
	
	

END;
/


--select * from largerThanH;
--select * from largerThanHDesc;
--select * from smallerThanH@site1;

select * from myview@site1;

--select * from UserInput@site1;

commit;





