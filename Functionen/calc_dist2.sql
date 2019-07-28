-- Function: fein.calc_dist2(double precision, double precision, double precision, double precision)

-- DROP FUNCTION fein.calc_dist2(double precision, double precision, double precision, double precision);

CREATE OR REPLACE FUNCTION fein.calc_dist2(
    lat1 double precision,
    lon1 double precision,
    lat2 double precision,
    lon2 double precision)
  RETURNS double precision AS
$BODY$
DECLARE                                                   
	r double precision;
BEGIN          
 
		return earth_distance(ll_to_earth(lat1, lon1),ll_to_earth(lat2,lon2));                                
	      
END  
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION fein.calc_dist2(double precision, double precision, double precision, double precision)
  OWNER TO neidi;
