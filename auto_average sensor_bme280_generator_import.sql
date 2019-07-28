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
		
		 --execute('CREATE TABLE aveg.sensor_bme280_y' ||  startyear || 'm' || (counter %12 +1 ) || ' (CHECK ( extract (year from timestamp) =' || startyear || ' and  extract (month from timestamp) ='|| (counter %12 +1 )|| ')) INHERITS (aveg.sensor_bme280) to node(dn_'|| (node %10 +1 ) ||');');
		 --execute('CREATE INDEX sensor_bme280_y' ||  startyear || 'm' || (counter %12 +1 ) || '_timestamp on aveg.sensor_bme280_y' ||  startyear || 'm' || (counter %12 +1 ) || '(timestamp);' );
	
		 execute('insert into aveg.sensor_bme280_y' ||  startyear || 'm' || (counter %12 +1 ) || '(sensor_id, location_id ,  temperature,humidity ,timestamp)
SELECT  sensor_id, location_id ,  avg( temperature),avg(humidity),
to_timestamp(floor((extract(''epoch'' from timestamp) / 3600 )) *3600) 
AT TIME ZONE ''UTC'' as interval_alias
FROM test.sensor_bme280_y' ||  startyear || 'm' || (counter %12 +1 ) || '
where temperature <> ''NaN'' and humidity <> ''NaN''
GROUP BY sensor_id, location_id,  interval_alias ;');
	 node=node+1;
		if ((counter % 12) + 1) = 12   then
		  startyear  = startyear + 1;
		end if;	
		raise notice '% , %s',startyear, (counter %12 +1 )
	END LOOP;
END; $$
