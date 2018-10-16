-- Beite / overflatedyrka produserer kjøtt/melk (areas producing meat/milk)
-- Jordbruk, fulldyrka, overflatedyrka or innmarksbeit then 0 -- TODO: CHECK
-- if a lot of milk production use 100


DROP TYPE mess.function_3_2_2_type cascade;

CREATE TYPE mess.function_3_2_2_type AS 
(		  	
	gid bigint,
	value integer
);


--DROP FUNCTION mess.function_3_2_2(p_in geometry) cascade ;


CREATE OR REPLACE FUNCTION mess.function_3_2_2(p_in geometry) 
returns setof mess.function_3_2_2_type AS $BODY$
DECLARE
	returnrec mess.function_3_2_2_type;
	boundary geometry;
	num_rows int;
	default_value int = -100;

BEGIN

	
	CREATE TEMP TABLE  geo_omr(
		gid bigint,
		value integer,
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


	-- compute intersected area
	UPDATE geo_omr  pt
	SET value=0
	FROM (	SELECT
		pt1.gid AS gid
		FROM 
		geo_omr AS pt1,
                REMOVED_AR5_AREALKLASS_GPI AS data2
		WHERE 
		data2.geo && boundary AND -- 100% times faster with 
		ST_Intersects(data2.geo,pt1.geo) AND
		data2.artype IN (20,21,22,23)
	) AS r1
	WHERE pt.gid = r1.gid ;

	-- todo: set to 100 if there is milk production there

	GET DIAGNOSTICS num_rows = ROW_COUNT;
	RAISE NOTICE '% rows with value 100', num_rows;
	
	FOR returnrec IN SELECT gid,value FROM geo_omr LOOP
        RETURN NEXT returnrec;
    	END LOOP;
    
	DROP TABLE geo_omr;



END;
$BODY$ LANGUAGE plpgsql;

drop table if exists mess.view_3_2_2; 
CREATE table mess.view_3_2_2 AS
  	SELECT (r1).function_3_2_2.gid::bigint, (r1).function_3_2_2.value::integer
	FROM (
		select mess.function_3_2_2(ST_GeomFromText('POLYGON EMPTY'))
	) as r1;

CREATE OR REPLACE view mess.view_3_2_2_quick AS
  	SELECT (r1).function_3_2_2.gid::bigint, (r1).function_3_2_2.value::integer
	FROM (
		select mess.function_3_2_2(ST_GeomFromText('SRID=4258;POLYGON((10.6558688136438 59.3402438918609,10.6466824831826 			59.4118779477458,10.8399481744994 59.4181898901846,10.8487296062088 59.3465379468792,10.6558688136438 59.3402438918609))'))
	) as r1;





\timing

  	
select count(gid), value from mess.view_3_2_2_quick group by value;


select count(gid), value from mess.view_3_2_2 group by value;


