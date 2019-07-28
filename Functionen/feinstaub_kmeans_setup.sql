-- Function: fein.feinstaub_kmeans_setup()

-- DROP FUNCTION fein.feinstaub_kmeans_setup();

CREATE OR REPLACE FUNCTION fein.feinstaub_kmeans_setup()
  RETURNS void AS
$BODY$
begin 

 create table fein.feinstaub_centroid (centroid_id smallserial ,p1 double precision, p2 double precision ) 
  distribute by REPLICATION; 

 create table fein.feinstaub_distance(id bigint, centroid_id smallint, distance double precision );
 
 create table fein.feinstaub_cluster(id bigint, centroid_id smallint);
 

 create table fein.feinstaub_temp_centroid(centroid_id smallint,p1  double precision, p2 double precision ) ;
 

end;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION fein.feinstaub_kmeans_setup()
  OWNER TO neidi;
