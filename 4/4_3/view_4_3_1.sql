-- water testing

DROP TYPE mess.function_4_3_1_type cascade;

CREATE TYPE mess.function_4_3_1_type AS 
(		  	
	gid bigint,
	value integer
);


-- DROP FUNCTION mess.function_4_3_1(p_in geometry) cascade ;


CREATE OR REPLACE FUNCTION mess.function_4_3_1(p_in geometry) 
returns setof mess.function_4_3_1_type AS $BODY$
DECLARE
	returnrec mess.function_4_3_1_type;
	boundary geometry;
	expandby int := 250; -- this should perhaps be bigger will not get box by 2000 x 2000 meter
	default_value int := -100;
	max_area int ; 
	max_area_big int ; 
	num_rows int;

BEGIN
	max_area = (expandby * 2) * (expandby * 2);
	RAISE NOTICE 'Max area for small box is  % ', max_area;

	max_area_big = ((expandby*2) * 2) * ((expandby*2) * 2);
	RAISE NOTICE 'Max area for big box is  % ', max_area_big;

	
	CREATE TEMP TABLE  geo_omr(
		gid bigint,
		value integer,
		geo geometry(geometry,4258),
		outer_box geometry(geometry,4258)
		
	);


		
	-- default value is -100
	IF ST_IsEmpty(p_in) THEN
		INSERT INTO geo_omr(gid,value,geo,outer_box)   		
		SELECT pt1.gid, default_value AS value, 
		ST_Transform(ST_Expand(geom25833,expandby),4258)  as geo,
		ST_Transform(ST_Expand(geom25833,(expandby*2)),4258)  as outer_box
		FROM mess.nor_pts AS pt1;
		GET DIAGNOSTICS num_rows = ROW_COUNT;
		SELECT ST_Envelope(ST_Extent(geom4258)) INTO boundary FROM mess.nor_pts;
	ELSE 
		
		INSERT INTO geo_omr(gid,value,geo,outer_box)   		
		SELECT pt1.gid, default_value AS value, 
		ST_Transform(ST_Expand(geom25833,expandby),4258)  as geo,
		ST_Transform(ST_Expand(geom25833,(expandby*2)),4258)  as outer_box 
		FROM mess.nor_pts AS pt1
		WHERE ST_Intersects(pt1.geom4258,p_in);
		GET DIAGNOSTICS num_rows = ROW_COUNT;
		SELECT p_in into boundary;
	END IF;

	
	RAISE NOTICE 'Total number of points % found for envelope with area %, % ', num_rows, ST_Area(boundary), ST_Astext(ST_Envelope(boundary));

		 	
	CREATE INDEX geoidx_geo_omr
	ON geo_omr
	USING gist(geo);


	-- set close to water
	UPDATE geo_omr  pt
        SET value=100
        FROM (  SELECT
                pt1.gid AS gid
                FROM 
                geo_omr AS pt1,
                REMOVED_AR50_FLATE AS data2
                WHERE 
                data2.geo && boundary AND -- 100% times faster with 
                ST_Intersects(data2.geo,pt1.geo) AND
                pt1.value = default_value AND -- only consider points not set default value 00
                data2.artype IN (80,81)
        ) AS r1
        WHERE pt.gid = r1.gid ;


	-- set pretty to water
	UPDATE geo_omr  pt
        SET value=0
        FROM (  SELECT
                pt1.gid AS gid
                FROM 
                geo_omr AS pt1,
                REMOVED_AR50_FLATE AS data2
                WHERE 
                data2.geo && boundary AND -- 100% times faster with 
                ST_Intersects(data2.geo,pt1.outer_box) AND
                pt1.value = default_value AND -- only consider points not set default value 00
                data2.artype IN (80,81)
        ) AS r1
        WHERE pt.gid = r1.gid ;

		
	FOR returnrec IN SELECT gid,value FROM geo_omr LOOP
        RETURN NEXT returnrec;
    	END LOOP;

    
	DROP TABLE geo_omr;



END;
$BODY$ LANGUAGE plpgsql;

drop table if exists mess.view_4_3_1;

CREATE table mess.view_4_3_1 AS
  	SELECT (r1).function_4_3_1.gid::bigint, (r1).function_4_3_1.value::integer
	FROM (
		select mess.function_4_3_1(ST_GeomFromText('POLYGON EMPTY'))
	) as r1;

CREATE OR REPLACE VIEW mess.view_4_3_1_quick AS
  	SELECT (r1).function_4_3_1.gid::bigint, (r1).function_4_3_1.value::integer
	FROM (
		select mess.function_4_3_1(ST_GeomFromText('SRID=4258;POLYGON((10.6558688136438 59.3402438918609,10.6466824831826 59.4118779477458,10.8399481744994 59.4181898901846,10.8487296062088 59.3465379468792,10.6558688136438 59.3402438918609))'))
	) as r1;

