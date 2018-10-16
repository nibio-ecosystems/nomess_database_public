-- setup colour scheme for the WMS maps

drop table if exists mess.wms_color; 

create table mess.wms_color (value int, color text); 

insert into mess.wms_color select generate_series(-100,-76,1) as value, '255 0 0' as color;
insert into mess.wms_color select generate_series(-75,-51,1) as value, '192 0 0' as color;
insert into mess.wms_color select generate_series(-50,-26,1) as value, '128 0 0' as color;
insert into mess.wms_color select generate_series(-25,0,1) as value, '64 0 0' as color;

insert into mess.wms_color select generate_series(1,25,1) as value, '0 64 0' as color;
insert into mess.wms_color select generate_series(26,50,1) as value, '0 128 0' as color;
insert into mess.wms_color select generate_series(51,75,1) as value, '0 192 0' as color;
insert into mess.wms_color select generate_series(76,100,1) as value, '0 255 0' as color;

