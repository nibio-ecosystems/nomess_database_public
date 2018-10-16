-- Kilden Jordsmonn (Soil monitoring data)

-- Dyp organisk + Grunn organisk   			: 100
--	orgjordf in (1,2)

-- Kombinasjon av organisk jord og mineraljord		: 0
--	orgjordf in (3)

-- Default value other combinations 			: -100

DROP TYPE mess.function_1_6_1_type CASCADE;

CREATE TYPE mess.function_1_6_1_type AS 
(		  	
	gid bigint,
	value integer
);

CREATE OR REPLACE FUNCTION mess.function_1_6_1(p_in geometry) 
returns setof mess.function_1_6_1_type AS $BODY$
DECLARE
	returnrec mess.function_1_6_1_type;
	boundary geometry;
	num_rows int;
	default_value int = -100;

BEGIN
	
	CREATE TEMP TABLE  geo_omr(
		gid bigint,
		value integer,
		jm_ljordkl integer ,
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
		SELECT pt1.gid, default_value AS default_value, pt1.geom4258 as geo
		FROM mess.nor_pts AS pt1
		WHERE ST_Intersects(pt1.geom4258,p_in);
		GET DIAGNOSTICS num_rows = ROW_COUNT;

		SELECT p_in into boundary;
	END IF;


	RAISE NOTICE 'Total number of points % found for envelope with area %, % ', num_rows, ST_Area(boundary), ST_Astext(ST_Envelope(boundary));
		 	
	CREATE INDEX geoidx_geo_omr
	ON geo_omr
	USING gist(geo);

	-- Only orgjordf IN (1,2,3) contains sampling points be different from default
	UPDATE geo_omr  pt
	SET jm_ljordkl=r1.jm_ljordkl
	FROM (	SELECT
		pt1.gid AS gid,
		data1.ljordkl AS jm_ljordkl
		FROM 
		geo_omr AS pt1,
		REMOVED_JM_TEMA AS data1,
		REMOVED_JM_UKOMM AS data2, 
		WHERE 
		data2.geo && boundary AND
		data1.ukomm_figurid = data2.figurid AND
		ST_Contains(data2.geo,pt1.geo)
 	) AS r1
	WHERE pt.gid = r1.gid AND
	r1.jm_ljordkl IN (1,2,3);

	-- Dyp organisk + Grunn organisk   			: 100
	--	orgjordf in (1,2)
	UPDATE geo_omr  pt
	SET value=100
	FROM (	SELECT
		pt1.gid AS gid
		FROM 
		geo_omr AS pt1
		WHERE 
		jm_ljordkl IN (1,2)
	) AS r1
	WHERE pt.gid = r1.gid ;
	GET DIAGNOSTICS num_rows = ROW_COUNT;
	RAISE NOTICE '% rows with value 100', num_rows;


	UPDATE geo_omr  pt
	SET value=0
	FROM (	SELECT
		pt1.gid AS gid
		FROM 
		geo_omr AS pt1
		WHERE 
		jm_ljordkl IN (3)
	) AS r1
	WHERE pt.gid = r1.gid ;
	GET DIAGNOSTICS num_rows = ROW_COUNT;
	RAISE NOTICE '% rows with value -0', num_rows;
	
	FOR returnrec IN SELECT gid,value FROM geo_omr LOOP
        RETURN NEXT returnrec;
    	END LOOP;

	DROP TABLE geo_omr;

END;
$BODY$ LANGUAGE plpgsql;


drop table if exists mess.view_1_6_1;
CREATE table mess.view_1_6_1 AS
  	SELECT (r1).function_1_6_1.gid::bigint, (r1).function_1_6_1.value::integer
	FROM (
		select mess.function_1_6_1(ST_GeomFromText('POLYGON EMPTY'))
	) as r1;


CREATE OR REPLACE VIEW mess.view_1_6_1_quick AS
  	SELECT (r1).function_1_6_1.gid::bigint, (r1).function_1_6_1.value::integer
	FROM (
		select mess.function_1_6_1(ST_GeomFromText('SRID=4258;POLYGON((10.6558688136438 59.3402438918609,10.6466824831826 			59.4118779477458,10.8399481744994 59.4181898901846,10.8487296062088 59.3465379468792,10.6558688136438 59.3402438918609))'))
	) as r1;



