-- Function: fein.mindistance(text)

-- DROP FUNCTION fein.mindistance(text);

CREATE OR REPLACE FUNCTION fein.mindistance(IN sensorname text)
  RETURNS TABLE(minstationsname text, mindistance double precision) AS
$BODY$
begin 

IF sensorname LIKE 'bme' THEN
drop table if exists fein.mindistance_bme;

CREATE TABLE IF NOT EXISTS fein.mindistance_bme (station_id bigint,stationsname text,sensor_id bigint,distance double precision, rank  integer) 
  distribute by REPLICATION;

INSERT INTO fein.mindistance_bme
SELECT dwd.station_id,dwd.stationsname, locbme.sensor_id, 
min(fein.calc_dist3(dwd.lat,dwd.lon,locbme.lat, locbme.lon)), 
dense_rank() OVER (PARTITION BY dwd.stationsname ORDER BY min(fein.calc_dist3(dwd.lat,dwd.lon,locbme.lat, locbme.lon)))
from fein.stations dwd cross join 
(Select distinct sensor_id,lat,lon from fein.locations_bme sbme
where sbme.lat is not null and sbme.lon is not null and rank = 1 group by sensor_id,lat,lon) locbme
group by dwd.station_id,dwd.stationsname, locbme.sensor_id,dwd.lat,dwd.lon,locbme.lat, locbme.lon;
END IF;

IF sensorname LIKE 'dht' THEN
drop table  if exists fein.mindistance_dht;
CREATE TABLE IF NOT EXISTS fein.mindistance_dht (station_id bigint,stationsname text,sensor_id bigint,distance double precision, rank  integer) 
  distribute by REPLICATION;

INSERT INTO fein.mindistance_dht
SELECT dwd.station_id,dwd.stationsname, locdht.sensor_id, 
min(fein.calc_dist3(dwd.lat,dwd.lon,locdht.lat, locdht.lon)), 
dense_rank() OVER (PARTITION BY dwd.stationsname ORDER BY min(fein.calc_dist3(dwd.lat,dwd.lon,locdht.lat, locdht.lon)))
from fein.stations dwd cross join 
(Select distinct sensor_id,lat,lon from fein.locations_dht sdht
where sdht.lat is not null and sdht.lon is not null and rank = 1 group by sensor_id,lat,lon) locdht
group by dwd.station_id,dwd.stationsname, locdht.sensor_id,dwd.lat,dwd.lon,locdht.lat, locdht.lon;
END IF;


IF sensorname LIKE 'sds' THEN
drop table if exists fein.mindistance_sds;
CREATE TABLE IF NOT EXISTS fein.mindistance_sds(station_id bigint,stationsname text,sensor_id bigint,distance double precision, rank  integer) 
  distribute by REPLICATION;

INSERT INTO fein.mindistance_sds
SELECT dwd.station_id,dwd.stationsname, locsds.sensor_id, 
min(fein.calc_dist3(dwd.lat,dwd.lon,locsds.lat, locsds.lon)), 
dense_rank() OVER (PARTITION BY dwd.stationsname ORDER BY min(fein.calc_dist3(dwd.lat,dwd.lon,locsds.lat, locsds.lon)))
from fein.stations dwd cross join 
(Select distinct sensor_id,lat,lon from fein.locations_sds ssds
where ssds.lat is not null and ssds.lon is not null and rank = 1 group by sensor_id,lat,lon) locsds
group by dwd.station_id,dwd.stationsname, locsds.sensor_id,dwd.lat,dwd.lon,locsds.lat, locsds.lon;
END IF;

end;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION fein.mindistance(text)
  OWNER TO neidi;
