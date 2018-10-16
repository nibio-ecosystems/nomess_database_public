create or replace function mess.data_normalise(_tbl regclass, colname text, newMin float, newMax float) returns boolean as $$

DECLARE
oldMax float;
oldMin float;
oldAvg float;

BEGIN

execute format('select avg(%s) from %s;', colname, _tbl) into oldAvg;    -- new code oct 2015 to try to move the points into a 50/50 distribution around zero.
execute format('update %s set %s = %s - $1;',  _tbl, colname,  colname) using oldAvg;  -- new code

execute format('select min(%s) from %s;', colname, _tbl) into oldMin;
execute format('select max(%s) from %s;', colname, _tbl) into oldMax;

execute format(
'update %s set %s = $1 + (( %s - $2 ) * ($3-$4) / ($5-$6)) where ($5-$6)!=0;',
  _tbl, colname,  colname) using newMin, oldMin, newMax, newMin, oldMax, oldMin;

return true;

END

$$ LANGUAGE plpgsql;

-- e.g. select mess.data_normalise('mess.overview_1', 'value', -100, 100);
