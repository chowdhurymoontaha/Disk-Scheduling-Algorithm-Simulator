clear screen;

drop table requestQueue;

create table requestQueue(rqId number,trackNo number);

insert into requestQueue values(1,82);
insert into requestQueue values(2,170);
insert into requestQueue values(3,43);
insert into requestQueue values(4,140);
insert into requestQueue values(5,24);
insert into requestQueue values(6,16);
insert into requestQueue values(7,190);


commit;

drop table UserInput;

create table UserInput(id number,totaltrackInput number,rwheadInput number,choiceInput number,directionInput number);


commit;




drop table smallerThanHTemp;

create table smallerThanHTemp(id number,track number,flag number);


commit;

drop table smallerThanH;

create table smallerThanH(id number,track number,flag number);


commit;


drop table FCFS_SSTF_FragmentSite1;

create table FCFS_SSTF_FragmentSite1(id number,flag number);

commit;

drop table sequenceTable;

create table sequenceTable(currentTrack number, nextTrack number,distance number);


commit;

select * from smallerThanHTemp;

select * from smallerThanH;
select * from sequenceTable;
select * from FCFS_SSTF_FragmentSite1;

clear screen;
create or replace view myview (view_From,view_To,view_SeekTime) as
select V.currentTrack,V.nextTrack,V.distance from sequenceTable V;

select * from myview;


SET SERVEROUTPUT ON;

CREATE OR REPLACE TRIGGER Success
AFTER INSERT
ON UserInput
DECLARE
BEGIN
	DBMS_OUTPUT.PUT_LINE('Your data successfully collected');
END;
/

@C:\Users\chowd\OneDrive\Desktop\DDSproject\Site2.sql