-- Function: fein.calc_dist3(double precision, double precision, double precision, double precision)

-- DROP FUNCTION fein.calc_dist3(double precision, double precision, double precision, double precision);

CREATE OR REPLACE FUNCTION fein.calc_dist3(
    lat1 double precision,
    lon1 double precision,
    lat2 double precision,
    lon2 double precision)
  RETURNS double precision AS
$BODY$

select ACOS( SIN(lat1*PI()/180)*SIN(lat2*PI()/180) + COS(lat1*PI()/180)*COS(lat2*PI()/180)*COS(lon2*PI()/180-lon1*PI()/180) ) * 6371;

$BODY$
  LANGUAGE sql IMMUTABLE
  COST 100;
ALTER FUNCTION fein.calc_dist3(double precision, double precision, double precision, double precision)
  OWNER TO neidi;
