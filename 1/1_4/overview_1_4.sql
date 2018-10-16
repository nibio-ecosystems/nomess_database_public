drop table if exists mess.overview_1_4;
create table mess.overview_1_4 as
  select a.gid as gid,a.value as value from
    mess.view_1_4_2 a ;

alter table mess.overview_1_4 add constraint key_1_4 primary key (gid);

