-- Function: fein.feinstaub_kmeans_update()

-- DROP FUNCTION fein.feinstaub_kmeans_update();

CREATE OR REPLACE FUNCTION fein.feinstaub_kmeans_update()
  RETURNS smallint AS
$BODY$ 
declare 
anz smallint;
begin 
truncate  table fein.feinstaub_distance;
truncate  table fein.feinstaub_cluster;
truncate  table  fein.feinstaub_temp_centroid;

insert into fein.feinstaub_distance
select d.id,c.centroid_id,(d.p1-c.p1) *(d.p1-c.p1) + (d.p2-c.p2) * (d.p2-c.p2) 
from aveg.sensor_sds2 d,fein.feinstaub_centroid c where d.p1 is not null and d.p2 is not null;

insert into fein.feinstaub_cluster (select d.id, d.centroid_id from fein.feinstaub_distance d,
                    (select d.id,min(distance) mindist from fein.feinstaub_distance d group by d.id) mind 
                    where d.id = mind.id and d.distance= mind.mindist);
                   
 insert into fein."feinstaub_temp_centroid" 
 select  cl.centroid_id, avg(d.p1),avg(d.p2)  	
 from aveg.sensor_sds2 d,fein.feinstaub_cluster cl WHERE d.id=cl.id  group by cl.centroid_id;
 



  
  anz = count(*) from ((select centroid_id , p1, p2 from fein.feinstaub_centroid c 
  full outer join fein.feinstaub_temp_centroid t using (centroid_id , p1,p2)) 
  except (select centroid_id,c.p1,c.p2 from fein.feinstaub_centroid c inner join fein.feinstaub_temp_centroid t using (centroid_id))) tmp;
                     
  truncate fein.feinstaub_centroid;
  insert into fein.feinstaub_centroid 
  select * from fein.feinstaub_temp_centroid;
  return anz;
  end;
  $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION fein.feinstaub_kmeans_update()
  OWNER TO neidi;
