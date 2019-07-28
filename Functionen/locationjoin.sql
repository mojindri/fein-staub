-- Function: fein.locationjoin(text, integer)

-- DROP FUNCTION fein.locationjoin(text, integer);

CREATE OR REPLACE FUNCTION fein.locationjoin(
    sensorname text,
    n integer)
  RETURNS void AS
$BODY$
BEGIN 

IF sensorname='bme' THEN
DROP TABLE IF EXISTS fein.locationjoin_bme;

CREATE TABLE IF NOT EXISTS fein.locationjoin_bme(station_id bigint,stationsname text, sensor_id bigint,distance double precision, rank integer)
distribute by REPLICATION;

insert into fein.locationjoin_bme 
Select bme.station_id,bme.stationsname, bme.sensor_id,bme.distance, bme.rank from fein.mindistance_bme bme where bme.rank < n+1;
END IF;

IF sensorname='dht' THEN
DROP TABLE IF EXISTS fein.locationjoin_dht;

CREATE TABLE IF NOT EXISTS fein.locationjoin_dht(station_id bigint,stationsname text, sensor_id bigint,distance double precision, rank integer)
distribute by REPLICATION;

insert into fein.locationjoin_dht
Select dht.station_id,dht.stationsname, dht.sensor_id,dht.distance, dht.rank from fein.mindistance_dht dht where dht.rank < n+1;
END IF;

IF sensorname='sds' THEN
DROP TABLE IF EXISTS fein.locationjoin_sds;

CREATE TABLE IF NOT EXISTS fein.locationjoin_sds(station_id bigint,stationsname text, sensor_id bigint,distance double precision, rank integer)
distribute by REPLICATION;

insert into fein.locationjoin_sds
Select sds.station_id,sds.stationsname, sds.sensor_id,sds.distance, sds.rank from fein.mindistance_sds sds where sds.rank < n+1;
END IF;



END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION fein.locationjoin(text, integer)
  OWNER TO neidi;
