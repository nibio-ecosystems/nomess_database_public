drop table if exists mess.overview_1_6;
create table mess.overview_1_6 as
  select a.gid as gid, a.value as value 
	from mess.view_1_6_1 a;

alter table mess.overview_1_6 add constraint key_1_6 primary key (gid);

