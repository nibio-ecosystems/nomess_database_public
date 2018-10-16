-- "A implementation for : 2	Regulating	Climate /Carbon content	25	Forest	251	AR5"
-- REMOVED_AR5_KOMM_FLATE

-- særs høg + høg   (high quality)			: 100
-- poly.artype=30 and arskogbon in (14,15)

-- middels bonitet  (average quality)			: 0
-- poly.artype=30 and arskogbon = 13 

-- lav bonitet+ uproduktiv 				: -100
-- low productivity/unproductive 

-- Default value other combinations 			: -100
-- No map values (this map) 				: -100


-- drop view if exists mess.view_2_5_1 cascade;
-- drop FUNCTION if exists mess.function_2_5_1( p geometry);

DROP TYPE mess.function_2_5_1_type CASCADE;

CREATE TYPE mess.function_2_5_1_type AS 
(		  	
	gid bigint,
	value integer
);

-- DROP FUNCTION mess.function_2_5_1(p_in geometry) cascade;

CREATE OR REPLACE FUNCTION mess.function_2_5_1(p_in geometry) 
returns setof mess.function_2_5_1_type AS $BODY$
DECLARE
	returnrec mess.function_2_5_1_type;
	boundary geometry;
	num_rows int;
	default_value int = 0;


BEGIN
	
	CREATE TEMP TABLE  geo_omr(
		gid bigint,
		value integer,
		valid_area_point boolean ,
		geo geometry(geometry,4258)
	);


		
	-- default value is -100
	IF ST_IsEmpty(p_in) THEN
		INSERT INTO geo_omr(gid,value,geo)   		
		SELECT pt1.gid, default_value AS value, pt1.geom4258 as geo
		FROM mess.nor_pts AS pt1;
		GET DIAGNOSTICS num_rows = ROW_COUNT;

		SELECT ST_Envelope(ST_Extent(geom4258)) INTO boundary FROM mess.nor_pts;
	ELSE 
		
		INSERT INTO geo_omr(gid,value,geo)   		
		SELECT pt1.gid, default_value AS value, pt1.geom4258 as geo
		FROM mess.nor_pts AS pt1
		WHERE ST_Intersects(pt1.geom4258,p_in);
		GET DIAGNOSTICS num_rows = ROW_COUNT;

		SELECT p_in into boundary;
	END IF;


	RAISE NOTICE 'Total number of points % found for envelope with area %, % ', num_rows, ST_Area(boundary), ST_Astext(ST_Envelope(boundary));
		 	
	CREATE INDEX geoidx_geo_omr
	ON geo_omr
	USING gist(geo);

	-- Only use consider data1.artype=30 that contains sampling points
	UPDATE geo_omr  pt
	SET valid_area_point=true
	FROM (	SELECT
		pt1.gid AS gid
		FROM 
		geo_omr AS pt1,
		REMOVED_AR5_KOMM_FLATE as data1
		WHERE 
		data1.geo && boundary AND
		ST_Contains(data1.geo,pt1.geo) AND
		data1.artype=30
	) AS r1
	WHERE pt.gid = r1.gid ;



	-- særs høg + høg bonitet				: 100
	-- artype=30 and arskogbon in (14,15)
	UPDATE geo_omr  pt
	SET value=100
	FROM (	SELECT
		pt1.gid AS gid
		FROM 
		geo_omr AS pt1,
		REMOVED_AR5_KOMM_FLATE as data1
		WHERE 
		data1.geo && boundary AND
		pt1.valid_area_point = '1' AND -- only use points in the valid intersection
		pt1.value = default_value AND -- only consider points not set default value 00
		ST_Contains(data1.geo,pt1.geo) AND
		data1.arskogbon in (14,15)
	) AS r1
	WHERE pt.gid = r1.gid ;
	GET DIAGNOSTICS num_rows = ROW_COUNT;
	RAISE NOTICE '% rows with value 100', num_rows;

	-- middels bonitet					: 0
	-- artype=30 and arskogbon = 13 
	UPDATE geo_omr  pt
	SET value=0
	FROM (	SELECT
		pt1.gid AS gid
		FROM 
		geo_omr AS pt1,
		REMOVED_AR5_KOMM_FLATE AS data1
		WHERE 
		data1.geo && boundary AND
		pt1.valid_area_point = '1' AND -- only use points in the valid intersection
		pt1.value = default_value AND -- only consider points not set default value 00
		ST_Contains(data1.geo,pt1.geo) AND
		data1.arskogbon in (13)
	) AS r1
	WHERE pt.gid = r1.gid ;
	GET DIAGNOSTICS num_rows = ROW_COUNT;
	RAISE NOTICE '% rows with value 0', num_rows;
	



	FOR returnrec IN SELECT gid,value FROM geo_omr LOOP
        RETURN NEXT returnrec;
    	END LOOP;

    
	DROP TABLE geo_omr;



END;
$BODY$ LANGUAGE plpgsql;


drop table if exists mess.view_2_5_1;
CREATE table mess.view_2_5_1 AS
  	SELECT (r1).function_2_5_1.gid::bigint, (r1).function_2_5_1.value::integer
	FROM (
		select mess.function_2_5_1(ST_GeomFromText('POLYGON EMPTY'))
	) as r1;


CREATE OR REPLACE VIEW mess.view_2_5_1_quick AS
  	SELECT (r1).function_2_5_1.gid::bigint, (r1).function_2_5_1.value::integer
	FROM (
		select mess.function_2_5_1(ST_GeomFromText('SRID=4258;POLYGON((10.6558688136438 59.3402438918609,10.6466824831826 			59.4118779477458,10.8399481744994 59.4181898901846,10.8487296062088 59.3465379468792,10.6558688136438 59.3402438918609))'))
	) as r1;





