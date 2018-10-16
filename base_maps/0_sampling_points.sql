-- sampling_points.sql

-- all norway points, 200x200m resolution, with 20x20 focus near Rygge (example)

drop table if exists mess.nor_pts;
drop sequence if exists mess.nor_pts_gid_seq;

CREATE sequence mess.nor_pts_gid_seq;

create table mess.nor_pts as select 
        nextval('mess.nor_pts_gid_seq') as gid,
        ST_SetSRID(ST_Point(x,y), 25833) as geom25833
        FROM
            	generate_series(-80000,1120000,200) AS x CROSS JOIN
                generate_series(6440000,7940000,200) AS y;   

insert into mess.nor_pts select 
        nextval('mess.nor_pts_gid_seq') as gid,
        ST_SetSRID(ST_Point(x,y), 25833) as geom25833
        FROM
          generate_series(253000,264000,20) AS x CROSS JOIN
          generate_series(6586000,6594000,20) AS y;    -- may need to scale to 50 depending on system

select addgeometrycolumn('mess', 'nor_pts', 'geom4258', 4258, 'POINT', 2);
select addgeometrycolumn('mess', 'nor_pts', 'geom3857', 3857, 'POINT', 2);

update mess.nor_pts set geom4258=st_transform(geom25833,4258);
update mess.nor_pts set geom3857=st_transform(geom25833,3857);

create index nor_pts_geom_25833_idx on mess.nor_pts using gist(geom25833);
create index nor_pts_geom_4258_idx on mess.nor_pts using gist(geom4258);
create index nor_pts_geom_3857_idx on mess.nor_pts using gist(geom3857);
create index nor_pts_gid_idx on mess.nor_pts (gid);

vacuum analyze mess.nor_pts;

