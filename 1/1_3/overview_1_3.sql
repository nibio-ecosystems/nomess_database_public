drop table if exists mess.overview_1_3;
create table mess.overview_1_3 as
  select a.gid as gid,(a.value+b.value)/2 as value from
    mess.view_1_3_1 a inner join mess.view_1_3_2 b using (gid);

alter table mess.overview_1_3 add constraint key_1_3 primary key (gid);

