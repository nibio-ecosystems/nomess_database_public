drop table if exists mess.overview_carbon;
create table mess.overview_carbon as
  select a.gid as gid,(a.value+b.value)/2 as value from
    mess.overview_2_4 as a inner join mess.overview_2_5 as b using (gid);

select mess.data_normalise('mess.overview_carbon', 'value', -100, 100);

