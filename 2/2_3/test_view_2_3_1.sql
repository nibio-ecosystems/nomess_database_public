

\timing

  	
--select  ST_AsEWKT(st_transform(ST_Envelope(ST_Collect(geom25833)),4258)) from 
--(select  ST_SetSRID(ST_Point(x,y), 25833) as geom25833 from generate_series(253000,264000,50) AS x CROSS JOIN generate_series(6586000,6594000,50) AS y) as p;

-- select mess.function_2_3_1(ST_GeomFromText('SRID=4258;POLYGON((10.6558688136438 59.3402438918609,10.6466824831826 59.4118779477458,10.8399481744994 59.4181898901846,10.8487296062088 59.3465379468792,10.6558688136438 59.3402438918609))'));




select count(gid), value from mess.view_2_3_1_quick group by value;
-- count | value 
-------+-------
--   386 |  -100
-- 29395 |     0
--  5431 |   100
--Time: 2198.093 ms


select count(gid), value from mess.view_2_3_1 group by value;
--count  | value 
--------+-------
--    446 |  -100
-- 318249 |     0
--   5967 |   100
--Time: 408091.455 ms


