-- "Initial implementation for: 3 Provisioning   Fiber 1    Productive Forest 311"
-- AR5 has whole norway coverage so we may safely assume -100 for areas that don't match the criteria. 
-- Definitions via Knut. Can be replaced or added to by Wenche's definition.

-- "artype" = 30 AND "arskogbon"   IN (12,13,14,15)	: 100
-- Default value other combinations 			: -100
-- No map values 					: -100

drop table if exists mess.view_3_1_1;
CREATE  table mess.view_3_1_1 as
  	select 	pt.gid as gid, 
                (select -100+200*(count(*)>0)::int as value from REMOVED_AR5 as poly where 
                 st_intersects(poly.geo, pt.geom4258) and poly.artype=30 and poly.arskogbon in (12,13,14,15)) 
        from mess.nor_pts as pt;


