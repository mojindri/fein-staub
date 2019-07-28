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

	FOR counter IN  (startmonth-1) .. (months -1)
	LOOP
		
	         execute('CREATE TABLE aveg.sensor_dht_y' ||  startyear || 'm' || (counter %12 +1 ) || ' (CHECK ( extract (year from timestamp) =' || startyear || ' and  extract (month from timestamp) ='|| (counter %12 +1 )|| ')) INHERITS (aveg.sensor_dht) to node(dn_'|| (node %10 +1 ) ||');');
		 execute('CREATE INDEX sensor_dht_y' ||  startyear || 'm' || (counter %12 +1 ) || '_timestamp on aveg.sensor_dht_y' ||  startyear || 'm' || (counter %12 +1 ) || '(timestamp);' );
		
		if ((counter % 12) + 1) = 12   then
		  startyear  = startyear + 1;
		end if;	
		raise notice '% , %s',startyear, (counter %12 +1 );
	END LOOP;
END; $$
