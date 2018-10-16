drop table if exists mess.overview_1;

create table mess.overview_1 as
  select a.gid as gid,(a.value+b.value+c.value)/3 as value from
    mess.overview_1_3 a inner join mess.overview_1_4 as b using (gid) inner join mess.overview_1_6 as c using (gid);

select mess.data_normalise('mess.overview_1', 'value', -100, 100);
