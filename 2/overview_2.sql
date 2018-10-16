--drop view if exists mess.overview_2;

drop table if exists mess.overview_2;
create table mess.overview_2 as
  select a.gid as gid,(a.value+b.value)/2 as value from
    mess.overview_2_5 as a inner join mess.overview_2_4 as b using (gid);

--  select a.gid as gid,(a.value+b.value+c.value)/3 as value from
--    mess.overview_2_5 as a inner join mess.overview_2_4 as b using (gid) inner join mess.overview_2_3 as c using (gid);
--  -- view 2_3_1 and overview_2_3 are disabled, they take too long

select mess.data_normalise('mess.overview_2', 'value', -100, 100);

