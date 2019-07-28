-- Function: fein.feinstaub_kmeans(smallint)

-- DROP FUNCTION fein.feinstaub_kmeans(smallint);

CREATE OR REPLACE FUNCTION fein.feinstaub_kmeans(IN k smallint)
  RETURNS TABLE(id smallint, p1 double precision, p2 double precision) AS
$BODY$ 
 declare 
 b smallint ;
 c smallint ;
 begin 
 b =  1;
 c =1;
 perform fein.feinstaub_kmeans_initial(k);
 while b > 0 and c<8 loop
  b:= fein.feinstaub_kmeans_update();
  c:=c+1;
 raise notice 'c%: remained for cluster : %',c,b;
 end loop;
 return query select * from fein.feinstaub_centroid;
 end;
  $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION fein.feinstaub_kmeans(smallint)
  OWNER TO neidi;
