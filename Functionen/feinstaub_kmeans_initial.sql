-- Function: fein.feinstaub_kmeans_initial(smallint)

-- DROP FUNCTION fein.feinstaub_kmeans_initial(smallint);

CREATE OR REPLACE FUNCTION fein.feinstaub_kmeans_initial(k smallint)
  RETURNS void AS
$BODY$
BEGIN
TRUNCATE fein.centroid;

INSERT INTO fein.feinstaub_centroid ( p1 , p2) 
(SELECT d.p1, d.p2 FROM
aveg.sensor_sds2 d group by d.p1, d.p2  ORDER BY random() LIMIT k);
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION fein.feinstaub_kmeans_initial(smallint)
  OWNER TO neidi;
