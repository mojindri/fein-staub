-- Function: fein.calc_dist(double precision, double precision, double precision, double precision)

-- DROP FUNCTION fein.calc_dist(double precision, double precision, double precision, double precision);

CREATE OR REPLACE FUNCTION fein.calc_dist(
    lat1 double precision,
    lon1 double precision,
    lat2 double precision,
    lon2 double precision)
  RETURNS double precision AS
$BODY$
DECLARE                                                   
	r double precision;
BEGIN          
 
		return 7912 * ASIN((SIN((lat1 - abs(lat2)) * pi()/180 / 2)) * (SIN((lat1 - abs(lat2)) * pi()/180 / 2)) 
              + COS(lon1 * pi()/180 ) * COS(abs(lat2) * pi()/180)  
              *  SIN((lon1 - lon2) * pi()/180 / 2) * SIN((lon1 - lon2) * pi()/180 / 2));                                
	      
END  
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION fein.calc_dist(double precision, double precision, double precision, double precision)
  OWNER TO neidi;
