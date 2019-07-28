-- Function: fein.timejoin(text)

-- DROP FUNCTION fein.timejoin(text);

CREATE OR REPLACE FUNCTION fein.timejoin(sensorname text)
  RETURNS void AS
$BODY$
BEGIN

IF sensorname LIKE 'bme' THEN
drop table if exists aveg.timejoin_dwd_bme;

create table if not exists aveg.timejoin_dwd_bme ("timestamp" timestamp without time zone,
station_id integer, sensor_id integer,temperature double precision, humidity double precision,
tt_10 double precision,rf_10 double precision);

Insert into aveg.timejoin_dwd_bme
Select dwd.timestamp, dwd.station_id, bme.sensor_id,bme.temperature,bme.humidity, dwd.tt_10,dwd.rf_10
from aveg.sensor_dwd dwd,
(select loc.station_id,av.sensor_id, temperature,humidity,timestamp 
from aveg.sensor_bme280 av,fein.locationjoin_bme loc
where av.sensor_id = loc.sensor_id) bme
where dwd.station_id =  bme.station_id and dwd.timestamp = bme.timestamp;
END IF;


IF sensorname LIKE 'dht' THEN
drop table if exists aveg.timejoin_dwd_dht;

create table if not exists aveg.timejoin_dwd_dht ("timestamp" timestamp without time zone,
station_id integer, sensor_id integer,temperature double precision, humidity double precision,
tt_10 double precision,rf_10 double precision);

Insert into aveg.timejoin_dwd_dht
Select dwd.timestamp, dwd.station_id, dht.sensor_id,dht.temperature,dht.humidity, dwd.tt_10,dwd.rf_10
from aveg.sensor_dwd dwd,
(select loc.station_id,av.sensor_id, temperature,humidity,timestamp 
from aveg.sensor_dht22 av,fein.locationjoin_dht loc
where av.sensor_id = loc.sensor_id) dht
where dwd.station_id =  dht.station_id and dwd.timestamp = dht.timestamp;
END IF;


IF sensorname LIKE 'sds' THEN
drop table if exists aveg.timejoin_dwd_sds;

create table if not exists aveg.timejoin_dwd_sds ("timestamp" timestamp without time zone,
station_id integer, sensor_id integer,p1 double precision, p2 double precision,
tt_10 double precision,rf_10 double precision);

Insert into aveg.timejoin_dwd_sds
Select dwd.timestamp, dwd.station_id, sds.sensor_id,sds.p1,sds.p2, dwd.tt_10,dwd.rf_10
from aveg.sensor_dwd dwd,
(select loc.station_id,av.sensor_id, p1,p2,timestamp 
from aveg.sensor_sds av,fein.locationjoin_sds loc
where av.sensor_id = loc.sensor_id) sds
where dwd.station_id =  sds.station_id and dwd.timestamp = sds.timestamp;
END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION fein.timejoin(text)
  OWNER TO neidi;
