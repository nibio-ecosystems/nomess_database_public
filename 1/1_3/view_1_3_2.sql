-- "Graeme's initial implementation for: 1 Supporting   Water Cycling 13    Water 132"
-- AR5 has whole norway coverage so we may safely assume -100 for areas that don't match the criteria. 

drop table if exists mess.view_1_3_2;
CREATE  table mess.view_1_3_2 as
  	select 	pt.gid as gid, 
                (select -100+200*(count(*)>0)::int as value from REMOVED_AR5_KOMM_FLATE as poly where 
                 st_intersects(poly.geo, pt.geom4258) and poly.artype=80) 
        from mess.nor_pts as pt;

alter table mess.view_1_3_2 add constraint key_1_3_2 primary key (gid);

