clear screen;

drop table largerThanH;

create table largerThanH(id number,track number,flag number);

commit;

drop table largerThanHDesc;

create table largerThanHDesc(id number,track number,flag number);

commit;


drop table FCFS_SSTF_FragmentServer;

create table FCFS_SSTF_FragmentServer(id number,track number);


commit;

select * from requestQueue@site1;
select * from largerThanH;
select * from FCFS_SSTF_FragmentServer;

 @C:\Users\Naba\Desktop\4.1\Moontaha\DDS\Lab\Lab5\DiskSchedulingWithDDS\170104099\Triggers.sql
 
 @C:\Users\Naba\Desktop\4.1\Moontaha\DDS\Lab\Lab5\DiskSchedulingWithDDS\170104099\input.sql