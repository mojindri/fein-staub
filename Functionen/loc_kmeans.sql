-- Function: fein.kmeans(smallint)

-- DROP FUNCTION fein.kmeans(smallint);

CREATE OR REPLACE FUNCTION fein.kmeans(IN k smallint)
  RETURNS TABLE(id smallint, lat double precision, lon double precision) AS
$BODY$ 
 declare 
 b smallint ;
 c smallint ;
 begin 
 b =  1;
 c =1;
 perform fein.kmeans_initial(k);
 while b > 0 and c<10  loop
  b:= fein.kmeans_update();
  c:=c+1;
 raise notice 'c%: remained for cluster : %',c,b;
 end loop;
 return query select * from fein.centroid;
 end;
  $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION fein.kmeans(smallint)
  OWNER TO neidi;
