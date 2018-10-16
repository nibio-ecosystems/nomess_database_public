-- Kilden Jordsmonn Andre tema organisk materiale 
-- Soil monitoring, other themes, organic material
-- REMOVED_JM_FLATE_V

-- Dyp organisk + Grunn organisk   			: 100
--	orgjordf in (1,2)

-- Kombinasjon av organisk jord og mineraljord		: 0
--	orgjordf in (3)

-- Mineraljord (3 klasser) 				: -100 
--	orgjordf in (4,5,6)


-- Default value other combinations 			: 0
-- No map values 					: 0

-- If no map data we 0 because there. Perhaps we could here check ar5 to make better value for this
-- Defalt value is 0

-- use REMOVED_JM_FLATE_V(a.figurid)

--		WHEN data.orgjordf IN (1,2) THEN 100
--		WHEN data.orgjordf IN (3) THEN -100




DROP TYPE mess.function_2_5_2_type CASCADE;


CREATE TYPE mess.function_2_5_2_type AS 
(		  	
	gid bigint,
	value integer
);

CREATE OR REPLACE FUNCTION mess.function_2_5_2(p_in geometry) 
returns setof mess.function_2_5_2_type AS $BODY$
DECLARE
	returnrec mess.function_2_5_2_type;
	boundary geometry;
	num_rows int;
	default_value int = 0;


BEGIN
	
	CREATE TEMP TABLE  geo_omr(
		gid bigint,
		value integer,
		jm_orgjordf integer ,
		geo geometry(geometry,4258)
		
	);


		
	-- default value is 0
	IF ST_IsEmpty(p_in) THEN
		INSERT INTO geo_omr(gid,value,geo)   		
		SELECT pt1.gid, default_value AS value, pt1.geom4258 as geo
		FROM mess.nor_pts AS pt1;
		GET DIAGNOSTICS num_rows = ROW_COUNT;

		SELECT ST_Envelope(ST_Extent(geom4258)) INTO boundary FROM mess.nor_pts;
	ELSE 
		
		INSERT INTO geo_omr(gid,value,geo)   		
		SELECT pt1.gid, 0 AS default_value, pt1.geom4258 as geo
		FROM mess.nor_pts AS pt1
		WHERE ST_Intersects(pt1.geom4258,p_in);
		GET DIAGNOSTICS num_rows = ROW_COUNT;

		SELECT p_in into boundary;
	END IF;


	RAISE NOTICE 'Total number of points % found for envelope with area %, % ', num_rows, ST_Area(boundary), ST_Astext(ST_Envelope(boundary));
		 	
	CREATE INDEX geoidx_geo_omr
	ON geo_omr
	USING gist(geo);

	-- Only orgjordf IN (2,3,4,5,6) contains sampling points be different from default
	UPDATE geo_omr  pt
	SET jm_orgjordf=r1.jm_orgjordf
	FROM (	SELECT
		pt1.gid AS gid,
		REMOVED_JM_ORGJORDF_FUNCTION as jm_orgjordf
		FROM 
		geo_omr AS pt1,
		REMOVED_JM_FLATE_V AS data1
		WHERE 
		data1.geo && boundary AND
		ST_Contains(data1.geo,pt1.geo)
 	) AS r1
	WHERE pt.gid = r1.gid AND
	r1.jm_orgjordf IN (1,2,4,5,6);


	-- Dyp organisk + Grunn organisk   			: 100
	--	orgjordf in (1,2)
	UPDATE geo_omr  pt
	SET value=100
	FROM (	SELECT
		pt1.gid AS gid
		FROM 
		geo_omr AS pt1
		WHERE 
		jm_orgjordf IN (1,2)
	) AS r1
	WHERE pt.gid = r1.gid ;
	GET DIAGNOSTICS num_rows = ROW_COUNT;
	RAISE NOTICE '% rows with value 100', num_rows;


	-- Mineraljord (3 klasser) 				: -100 
	--	orgjordf in (4,5,6)
	UPDATE geo_omr  pt
	SET value=-100
	FROM (	SELECT
		pt1.gid AS gid
		FROM 
		geo_omr AS pt1
		WHERE 
		jm_orgjordf IN (4,5,6)
	) AS r1
	WHERE pt.gid = r1.gid ;
	GET DIAGNOSTICS num_rows = ROW_COUNT;
	RAISE NOTICE '% rows with value -100', num_rows;
	



	FOR returnrec IN SELECT gid,value FROM geo_omr LOOP
        RETURN NEXT returnrec;
    	END LOOP;

    
	DROP TABLE geo_omr;



END;
$BODY$ LANGUAGE plpgsql;


drop table if exists mess.view_2_5_2;
CREATE table mess.view_2_5_2 AS
  	SELECT (r1).function_2_5_2.gid::bigint, (r1).function_2_5_2.value::integer
	FROM (
		select mess.function_2_5_2(ST_GeomFromText('POLYGON EMPTY'))
	) as r1;


CREATE OR REPLACE VIEW mess.view_2_5_2_quick AS
  	SELECT (r1).function_2_5_2.gid::bigint, (r1).function_2_5_2.value::integer
	FROM (
		select mess.function_2_5_2(ST_GeomFromText('SRID=4258;POLYGON((10.6558688136438 59.3402438918609,10.6466824831826 			59.4118779477458,10.8399481744994 59.4181898901846,10.8487296062088 59.3465379468792,10.6558688136438 59.3402438918609))'))
	) as r1;



