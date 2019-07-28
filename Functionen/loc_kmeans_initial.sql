-- Function: fein.kmeans_initial(smallint)

-- DROP FUNCTION fein.kmeans_initial(smallint);

CREATE OR REPLACE FUNCTION fein.kmeans_initial(k smallint)
  RETURNS void AS
$BODY$
BEGIN
TRUNCATE fein.centroid;

INSERT INTO fein.centroid ( lat , lon) 
(SELECT d.lat, d.lon FROM fein.locations
 d group by d.sensor_id,d.lat, d.lon ORDER BY random() LIMIT k);
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION fein.kmeans_initial(smallint)
  OWNER TO neidi;
