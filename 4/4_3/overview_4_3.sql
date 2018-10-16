drop table if exists mess.overview_4_3;
create table mess.overview_4_3 as
  select a.gid as gid,(a.value+b.value)/2 as value from
    mess.view_4_3_1 a inner join mess.view_4_3_2 b using (gid);

--  temporarily disabled
--  select a.gid as gid,(a.value+b.value+c.value)/3 as value from
--                      inner join mess.view_4_3_3 c using (gid);

alter table mess.overview_4_3 add constraint key_4_3 primary key (gid);

