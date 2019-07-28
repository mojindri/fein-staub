DO $$
declare 
	startyear integer ;
	startmonth integer ;
	endyear integer ;
	endmonth integer ;
	months integer;
	node integer;
BEGIN 
	startyear = 2017;
	startmonth  = 3 ;
	endmonth= 6;
	endyear=2018;
	months = (endyear-startyear)* 12  + (endmonth);
	node=0;
	FOR counter IN  (startmonth-1) .. (months -1)
	LOOP
		
	         --execute('CREATE TABLE aveg.sensor_sds_y' ||  startyear || 'm' || (counter %12 +1 ) || ' (CHECK ( extract (year from timestamp) =' || startyear || ' and  extract (month from timestamp) ='|| (counter %12 +1 )|| ')) INHERITS (aveg.sensor_sds) to node(dn_'|| (node %10 +1 ) ||');');
		-- execute('CREATE INDEX sensor_sds_y' ||  startyear || 'm' || (counter %12 +1 ) || '_timestamp on aveg.sensor_sds_y' ||  startyear || 'm' || (counter %12 +1 ) || '(timestamp);' );
	
		 execute('insert into aveg.sensor_sds_y' ||  startyear || 'm' || (counter %12 +1 ) || '(location_id, sensor_id, p1, p2, "timestamp")
SELECT  location_id, sensor_id, avg(p1), avg(p2), 
to_timestamp(floor((extract(''epoch'' from timestamp) / 3600 )) * 3600) 
AT TIME ZONE ''UTC'' as interval_alias
FROM test.sensor_sds011_m' || (counter %12 +1 ) || '
 where p1 <> ''NaN'' and p2 <> ''NaN'' and extract(year from timestamp) = ' ||  startyear || '
GROUP BY sensor_id, location_id,  interval_alias ;');
	 node=node+1;
		if ((counter % 12) + 1) = 12   then
		  startyear  = startyear + 1;
		end if;	
		raise notice '% , %s',startyear, (counter %12 +1 );
	END LOOP;
END; $$
