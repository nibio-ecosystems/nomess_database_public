drop table if exists mess.overview_wms, mess.overview;
          
create table mess.overview as 
  select n.gid as gid, 
         ((a.value + b.value + c.value + d.value)/4)::int as value 
  from
      mess.nor_pts n inner join 
      mess.overview_1 as a using (gid) inner join
      mess.overview_2 as b using (gid) inner join
      mess.overview_3 as c using (gid) inner join
      mess.overview_4 as d using (gid);

select mess.data_normalise('mess.overview', 'value', -100, 100);
create index overview_gid_idx on mess.overview (gid);
vacuum analyze mess.overview;

--

create table mess.overview_wms as 
  select a.gid as gid, a.geom3857 as geom,
         b.value as value, c.color as color 
  from
         mess.nor_pts a inner join mess.overview b using (gid),
         mess.wms_color c, (select max(value) as maxv from mess.overview) d, 
                           (select min(value) as minv from mess.overview) e
  where  b.value = c.value;

create index overview_wms_gid_idx on mess.overview_wms (gid);
create index overview_wms_geom_idx on mess.overview_wms using gist(geom);
vacuum  analyze mess.overview_wms;
grant select on mess.overview_wms, mess.overview to USERNAME_REMOVED;

