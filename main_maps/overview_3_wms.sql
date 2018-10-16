
drop table if exists mess.overview_3_wms;

create table mess.overview_3_wms as 
  select a.gid as gid, a.geom3857 as geom,
         b.value as value, c.color as color 
  from
         mess.nor_pts a inner join mess.overview_3 b using (gid),
         mess.wms_color c
  where  b.value = c.value;

create index overview_3_wms_gid_idx on mess.overview_3_wms (gid);
create index overview_3_wms_geom_idx on mess.overview_3_wms using gist(geom);
vacuum  analyze mess.overview_3_wms;
grant select on mess.overview_3_wms to USERNAME_REMOVED;


