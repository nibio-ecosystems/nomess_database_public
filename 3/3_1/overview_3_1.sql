drop table if exists mess.overview_3_1;
create  table mess.overview_3_1 as
  select a.gid as gid,(a.value)/1 as value from
    mess.view_3_1_1 a ;





