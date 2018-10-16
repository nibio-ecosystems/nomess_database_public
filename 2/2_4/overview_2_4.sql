-- drop view if exists mess.overview_2_4;

drop table if exists mess.overview_2_4;
create table mess.overview_2_4 as
  select a.gid as gid,(a.value+b.value)/2 as value from
    mess.view_2_4_1 a inner join mess.view_2_4_2 b using (gid);





