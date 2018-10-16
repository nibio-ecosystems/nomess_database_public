-- metadata_db.sql
-- no implementation provided here
-- can be used as a data model for tracking structure of the ESS Tree

\set view_names 'mess.view_names'
\set view_uses 'mess.view_uses'

DROP TABLE IF EXISTS :view_names;
DROP TABLE IF EXISTS :view_uses;

-- this table tracks information about views

CREATE TABLE :view_names (
	id 		serial,
	view_id 	text PRIMARY KEY,   -- e.g. '2_2_5'
	designer	text,		    -- e.g. 'Wenche'
	implementer	text,		    -- e.g. 'GBB/LOP'
	version         text,               -- e.g. git commit reference
	description	text		    -- e.g. purpose/concept of view
			);

-- this table tracks dependencies: which views use other views

CREATE TABLE :view_uses (
	id		serial,
	this_view_id	integer,
	uses_view_id	integer,
	weighting       real
			);
	
