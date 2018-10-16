-- example of how WMS can be used to provide immediate guidance to web users

drop table if exists mess.overview_carbon_wms;

create table mess.overview_carbon_wms as 
  select a.gid as gid, a.geom3857 as geom,
         b.value as value, c.color as color,
	 case when b.value<0 then 'This area scored badly for carbon sequestration. Click <A HREF="http://www.esa.org/esa/wp-content/uploads/2012/12/carbonsequestrationinsoils.pdf">here</A> to find out more about carbon sequestration for this type of area.'
	                   else 'No comments.' 
 	 end as comment
  from
         mess.nor_pts a inner join mess.overview_carbon b using (gid),
         mess.wms_color c
  where  b.value = c.value;

create index overview_carbon_wms_gid_idx on mess.overview_carbon_wms (gid);
create index overview_carbon_wms_geom_idx on mess.overview_carbon_wms using gist(geom);
vacuum  analyze mess.overview_carbon_wms;
grant select on mess.overview_carbon_wms to USERNAME_REMOVED;

