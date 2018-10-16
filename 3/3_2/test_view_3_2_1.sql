\timing
  	
--select  ST_AsEWKT(st_transform(ST_Envelope(ST_Collect(geom25833)),4258)) from 
--(select  ST_SetSRID(ST_Point(x,y), 25833) as geom25833 from generate_series(253000,264000,50) AS x CROSS JOIN generate_series(6586000,6594000,50) AS y) as p;

-- select mess.function_3_2_1(ST_GeomFromText('SRID=4258;POLYGON((10.6558688136438 59.3402438918609,10.6466824831826 59.4118779477458,10.8399481744994 59.4181898901846,10.8487296062088 59.3465379468792,10.6558688136438 59.3402438918609))'));

select count(gid), value from mess.view_3_2_1_quick group by value;

--NOTICE:  Max area is 10000 
--NOTICE:  Total number of points 35212 found for envelope with area 0.0138882551552681, POLYGON((10.6466824831826 59.3402438918609,10.6466824831826 59.4181898901846,10.8487296062088 59.4181898901846,10.8487296062088 59.3402438918609,10.6466824831826 59.3402438918609)) 
--NOTICE:  12549 rows with value 100
--NOTICE:  10178 rows with value 0
-- count | value 
-------+-------
-- 12485 |  -100
-- 10178 |     0
-- 12549 |   100
-- Time: 12926.009 ms

select count(gid), value from mess.view_3_2_1 group by value;

--NOTICE:  Max area is 10000 
--NOTICE:  Total number of points 324662 found for envelope with area 459.581789379747, POLYGON((-1.02122478308795 57.671681751927,-1.02122478308795 71.5612971336863,32.0669332938663 71.5612971336863,32.0669332938663 57.671681751927,-1.02122478308795 57.671681751927)) 

--NOTICE:  14153 rows with value 100
--NOTICE:  12951 rows with value 0
-- count  | value 
--------+-------
-- 297558 |  -100
--  12951 |     0
--  14153 |   100
--Time: 31645.759 ms

