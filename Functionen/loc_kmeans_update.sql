-- Function: fein.kmeans_update()

-- DROP FUNCTION fein.kmeans_update();

CREATE OR REPLACE FUNCTION fein.kmeans_update()
  RETURNS smallint AS
$BODY$ 
declare 
anz smallint;
begin 
truncate  table fein.distance;
truncate  table fein.cluster;
truncate  table  fein.temp_centroid;

insert into fein.distance
select d.id,c.centroid_id,fein.calc_dist(d.lat,d.lon, c.lat,c.lon) * d.count
from fein.locations  d,fein.centroid c where d.lat is not null and d.lon is not null group by d.id,c.centroid_id,d.lat,d.lon, c.lat,c.lon;

insert into fein.cluster (select d.id, d.centroid_id from fein.distance d,
                    (select d.id,min(distance) mindist from fein.distance d group by d.id) mind 
                    where d.id = mind.id and d.distance= mind.mindist);
 insert into fein.temp_centroid 
  select  d.centroid_id, atan2(avgZ, sqrt(avgX * avgX + avgY * avgY)) *  (180 / pi()) as  lat, 
   atan2(avgY,avgX) *  (180 / pi()) as  lng from 
   (select 
    cl.centroid_id ,
    sum( cos( lat * (pi()/180)) * cos( lon * (pi()/180))  )/  count(*) as avgX,
    sum(cos( lat * (pi()/180))* sin( lon * (pi()/180)))/ count( *) as avgY,
    sum(sin(lat * (pi()/180)))/ count(*) as avgZ 
    FROM fein.locations b, fein.cluster cl where b.lat is not null and b.lon is not null and cl.id = b.id group by cl.centroid_id)    d;
 
 
  anz = count(*) from ((select centroid_id , lat, lon from fein.centroid c 
  full outer join fein.temp_centroid t using (centroid_id , lat,lon)) 
  except (select centroid_id,c.lat,c.lon from fein.centroid c inner join fein.temp_centroid t using (centroid_id))) tmp;
                     
  truncate fein.centroid;
  insert into fein.centroid select * from fein.temp_centroid;
  return anz;
  end;
  $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION fein.kmeans_update()
  OWNER TO neidi;
