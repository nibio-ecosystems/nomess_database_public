--drop view if exists mess.overview_3;

drop table if exists mess.overview_3;
create table mess.overview_3 as
  select a.gid as gid,(a.value+b.value)/2 as value from
    mess.overview_3_1 as a inner join mess.overview_3_2 as b using (gid);

select mess.data_normalise('mess.overview_3', 'value', -100, 100);

