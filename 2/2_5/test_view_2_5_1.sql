\timing


select count(gid), value from mess.view_2_5_1_quick group by value;

-- psql:view_2_5_1.sql:177: NOTICE:  Total number of points 35212 found for envelope with area 0.0138882551552681, POLYGON((10.6466824831826 59.3402438918609,10.6466824831826 59.4181898901846,10.8487296062088 59.4181898901846,10.8487296062088 59.3402438918609,10.6466824831826 59.3402438918609)) 
-- psql:view_2_5_1.sql:177: NOTICE:  4934 rows with value 100
-- psql:view_2_5_1.sql:177: NOTICE:  2968 rows with value 0
--  count | value 
-------+-------
--  27310 |  -100
--   2968 |     0
--   4934 |   100
-- Time: 1704.191 ms


select count(gid), value from mess.view_2_5_1 group by value;

-- psql:view_2_5_1.sql:180: NOTICE:  Total number of points 324662 found for envelope with area 459.581789379747, POLYGON((-1.02122478308795 57.671681751927,-1.02122478308795 71.5612971336863,32.0669332938663 71.5612971336863,32.0669332938663 57.671681751927,-1.02122478308795 57.671681751927)) 
-- psql:view_2_5_1.sql:180: NOTICE:  8584 rows with value 100
-- psql:view_2_5_1.sql:180: NOTICE:  7205 rows with value 0
--  count  | value 
--------+-------
--  308873 |  -100
--    7205 |     0
--    8584 |   100
-- Time: 84633.547 ms


