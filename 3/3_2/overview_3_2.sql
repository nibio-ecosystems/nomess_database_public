-- drop view if exists mess.overview_3_2;

drop table if exists mess.overview_3_2;
create table mess.overview_3_2 as
  select a.gid as gid,(a.value)/1 as value from
    mess.view_3_2_1 a ;




