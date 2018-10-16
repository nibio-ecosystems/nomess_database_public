drop table if exists mess.overview_4;

create table mess.overview_4 as
  select a.gid as gid,(a.value)/1 as value from
    mess.overview_4_3 a ;

select mess.data_normalise('mess.overview_4', 'value', -100, 100);

