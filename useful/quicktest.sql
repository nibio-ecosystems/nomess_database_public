\timing
-- can be used to set up a quick WMS (webmap) test of a sub-layer XYZ  
-- currently view_3_1_1

drop table if exists mess.quicktest_wms;

create table mess.quicktest_wms as 
  select a.gid as gid, a.geom25833 as geom,
         b.value as value, c.color as color 
  from
         mess.nor_pts a join mess.view_3_1_1 b using (gid),
         mess.wms_color c
  where  b.value = c.value;

create index quick_gid on mess.quicktest_wms (gid);
create index quick_geom on mess.quicktest_wms using gist(geom);

grant select on mess.quicktest_wms to USERNAME_REMOVED;

