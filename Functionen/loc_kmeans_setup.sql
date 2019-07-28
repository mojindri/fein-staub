-- Function: fein.kmeans_setup()

-- DROP FUNCTION fein.kmeans_setup();

CREATE OR REPLACE FUNCTION fein.kmeans_setup()
  RETURNS void AS
$BODY$
begin 

 create table fein.centroid (centroid_id smallserial ,lat double precision, lon double precision ) 
  distribute by REPLICATION; 

 create table fein.distance(id bigint, centroid_id smallint, distance double precision )
  distribute by hash(centroid_id) to node(dn_3);

 create table fein.cluster(id bigint, centroid_id smallint)
  distribute by hash(centroid_id) to node(dn_3);

 create table fein.temp_centroid(centroid_id smallint,lat double precision, lon double precision ) 
  distribute by hash(centroid_id) to node(dn_3);

end;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION fein.kmeans_setup()
  OWNER TO neidi;
