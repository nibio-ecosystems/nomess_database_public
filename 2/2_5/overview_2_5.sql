-- drop view if exists mess.overview_2_5;

drop table if exists mess.overview_2_5;
create table mess.overview_2_5 as
  select a.gid as gid,(a.value+b.value)/2 as value from
    mess.view_2_5_1 a inner join mess.view_2_5_2 b using (gid);





