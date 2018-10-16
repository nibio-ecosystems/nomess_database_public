-- test that code runs

\timing


select count(gid), value from mess.view_2_5_2_quick group by value;

--psql:2/2_5/view_2_5_2.sql:172: NOTICE:  Total number of points 35212 found for envelope with area 0.0138882551552681, POLYGON((10.6466824831826 59.3402438918609,10.6466824831826 59.4181898901846,10.8487296062088 59.4181898901846,10.8487296062088 59.3402438918609,10.6466824831826 59.3402438918609)) 
--psql:2/2_5/view_2_5_2.sql:172: NOTICE:  56 rows with value 100
--psql:2/2_5/view_2_5_2.sql:172: NOTICE:  13482 rows with value -100
-- count | value 
-------+-------
-- 13482 |  -100
-- 21674 |     0
--    56 |   100

-- Time: 1918.117 ms


select count(gid), value from mess.view_2_5_2 group by value;

--psql:2/2_5/view_2_5_2.sql:175: NOTICE:  Total number of points 324662 found for envelope with area 459.581789379747, POLYGON((-1.02122478308795 57.671681751927,-1.02122478308795 71.5612971336863,32.0669332938663 71.5612971336863,32.0669332938663 57.671681751927,-1.02122478308795 57.671681751927)) 
--psql:2/2_5/view_2_5_2.sql:175: NOTICE:  87 rows with value 100
--psql:2/2_5/view_2_5_2.sql:175: NOTICE:  14262 rows with value -100
-- count  | value 
--------+-------
--  14262 |  -100
-- 310313 |     0
--     87 |   100
--(3 rows)

--Time: 18502.783 ms


