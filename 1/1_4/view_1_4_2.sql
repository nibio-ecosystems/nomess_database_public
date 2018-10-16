-- som beregner en verdi som kan brukes i  142: NUTRIENTS jordgruppe_nutrients etter en formel som er rimelig fornuftig.
-- (based on a mix of geological understanding and regressions with other data.)
 
--0=poor 
--2 and 3=medium 
--3=rich
---1 is NODATA type of classes (sea, glaciers, ..)
 
-- Regelen skal dekke alle mulige tilfeller (dvs -9 skal ikke forekomme).

-- 100 
--   WHEN jordart in (14,17,22,35,71,73,88,90,100,102,130 ,21,122,140,301,307,308,313,315,316 ) THEN 0

-- 0 default
--   WHEN jordart in (12,30,40,42,53,80,81,82,101 ,10,16)  THEN 1
--   WHEN jordart in (11,15,20,36,70,72 ,13)               THEN 2

-- -100
--   WHEN jordart in (31,41,43,50,54,55,60,120 ,304)       THEN 3

-- should not exist
--   WHEN jordart in (0,1)                                 THEN -1
--   ELSE -9
-- from REMOVED_LOSMASSE_FLATE

DROP TYPE mess.function_1_4_2_type cascade;

CREATE TYPE mess.function_1_4_2_type AS 
(		  	
	gid bigint,
	value integer
);


--DROP FUNCTION mess.function_1_4_2(p_in geometry) cascade ;


CREATE OR REPLACE FUNCTION mess.function_1_4_2(p_in geometry) 
returns setof mess.function_1_4_2_type AS $BODY$
DECLARE
	returnrec mess.function_1_4_2_type;
	boundary geometry;
	num_rows int;
	default_value int = 0;

BEGIN
	
	CREATE TEMP TABLE  geo_omr(
		gid bigint,
		value integer,
		geo geometry(geometry,25833)
		
	);


		
	-- default value is -100
	IF ST_IsEmpty(p_in) THEN
		INSERT INTO geo_omr(gid,value,geo)   		
		SELECT pt1.gid, default_value AS value, pt1.geom25833 as geo
		FROM mess.nor_pts AS pt1;
		GET DIAGNOSTICS num_rows = ROW_COUNT;

		SELECT ST_Envelope(ST_Extent(geom25833)) INTO boundary FROM mess.nor_pts;
	ELSE 
		
		INSERT INTO geo_omr(gid,value,geo)   		
		SELECT pt1.gid, default_value AS value, pt1.geom25833 as geo
		FROM mess.nor_pts AS pt1
		WHERE ST_Intersects(pt1.geom25833,p_in);
		GET DIAGNOSTICS num_rows = ROW_COUNT;
		SELECT p_in into boundary;
	END IF;

	
	RAISE NOTICE 'Total number of points % found for envelope with area %, % ', num_rows, ST_Area(boundary), ST_Astext(ST_Envelope(boundary));

		 	
	CREATE INDEX geoidx_geo_omr
	ON geo_omr
	USING gist(geo);


	-- Artype = skog = 30 is 100
	UPDATE geo_omr  pt
	SET value=100
	FROM (	SELECT
		pt1.gid AS gid
k		FROM 
		geo_omr AS pt1,
		REMOVED_LOSMASSE_FLATE AS data2
		WHERE 
		data2.geo && boundary AND -- 100% times faster with 
		ST_Intersects(data2.geo,pt1.geo) AND
		pt1.value = default_value AND -- only consider points not set default value 00
		data2.jordart in (14,17,22,35,71,73,88,90,100,102,130 ,21,122,140,301,307,308,313,315,316 )
	) AS r1
	WHERE pt.gid = r1.gid ;

	-- Artype 11 + 12 is -100 
	UPDATE geo_omr  pt
	SET value=-100
	FROM (	SELECT
		pt1.gid AS gid
		FROM 
		geo_omr AS pt1,
		REMOVED_LOSMASSE_FLATE AS data2
		WHERE 
		data2.geo && boundary AND -- 100% times faster with 
		ST_Intersects(data2.geo,pt1.geo) AND
		pt1.value = default_value AND -- only consider points not set default value 00
		data2.jordart in (31,41,43,50,54,55,60,120 ,304)       
	) AS r1
	WHERE pt.gid = r1.gid ;


	GET DIAGNOSTICS num_rows = ROW_COUNT;
	RAISE NOTICE '% rows with value 100', num_rows;

	
	FOR returnrec IN SELECT gid,value FROM geo_omr LOOP
        RETURN NEXT returnrec;
    	END LOOP;

    
	DROP TABLE geo_omr;



END;
$BODY$ LANGUAGE plpgsql;

drop table if exists mess.view_1_4_2;
CREATE table mess.view_1_4_2 AS
  	SELECT (r1).function_1_4_2.gid::bigint, (r1).function_1_4_2.value::integer
	FROM (
		select mess.function_1_4_2(ST_GeomFromText('POLYGON EMPTY'))
	) as r1;

CREATE OR REPLACE VIEW mess.view_1_4_2_quick AS
  	SELECT (r1).function_1_4_2.gid::bigint, (r1).function_1_4_2.value::integer
	FROM (
		select mess.function_1_4_2(ST_GeomFromText('SRID=25833;POLYGON((10.6558688136438 59.3402438918609,10.6466824831826 			59.4118779477458,10.8399481744994 59.4181898901846,10.8487296062088 59.3465379468792,10.6558688136438 59.3402438918609))'))
	) as r1;




-- testing
-- \timing
-- select count(gid), value from mess.view_1_4_2_quick group by value;
-- select count(gid), value from mess.view_1_4_2 group by value;

