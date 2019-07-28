DO $$
declare 
	startyear integer ;
	startmonth integer ;
	endyear integer ;
	endmonth integer ;
	months integer;
BEGIN 
	startyear = 2017;
	startmonth  = 3 ;
	endmonth= 6;
	endyear=2018;
	months = (endyear-startyear)* 12  + (endmonth);
	FOR counter IN  (startmonth-1) .. (months -1)
	LOOP
		
		 
		--execute('CREATE TABLE test.sensor_bme280_y' ||  startyear || 'm' || (counter %12 +1 ) || ' (
--    CHECK ( extract (year from timestamp) =' || startyear || ' and  extract (month from timestamp) ='|| (counter %12 +1 )|| ')
 --   ) INHERITS (test.sensor_bme280);');
		--execute('CREATE INDEX sensor_bme280_y' ||  startyear || 'm' || (counter %12 +1 ) || '_timestamp on test.sensor_bme280_y' ||  startyear || 'm' || (counter %12 +1 ) || '(timestamp);' );
		--execute ('drop  TABLE test.sensor_bme280_y' ||  startyear || 'm' || counter);

		--execute ('truncate TABLE test.sensor_bme280_y' ||  startyear || 'm' || (counter %12 +1 ));
		execute	('INSERT INTO test.sensor_dwd_y' ||  startyear || 'm' || (counter %12 +1 ) || ' (station_id,timestamp,tt_10,rf_10)
 SELECT station_id, timestamp,tt_10,rf_10  FROM fein.sensor_dwd where (extract(month from timestamp) = '|| (counter %12 +1 ) ||' and extract(year from timestamp) = ' || startyear ||')
 AND (tt_10 > -50 AND tt_10 < 60) AND (rf_10 >= 0 AND rf_10 < 100)') ;

 

		if ((counter % 12) + 1) = 12   then
		  startyear  = startyear + 1;
		end if;	
	END LOOP;
END; $$