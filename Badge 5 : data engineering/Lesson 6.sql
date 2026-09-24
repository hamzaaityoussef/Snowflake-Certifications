create or replace TABLE AGS_GAME_AUDIENCE.RAW.PL_GAME_LOGS (
	RAW_LOG VARIANT
);

grant ownership on table pl_game_logs to role sysadmin;

COPY INTO ags_game_audience.raw.PL_GAME_LOGS
from @UNI_KISHORE_PIPELINE
file_format = (format_name=FF_JSON_LOGS);




truncate table pl_game_logs;




create or replace task AGS_GAME_AUDIENCE.RAW.GET_NEW_FILES 
    schedule = '10 minute '
    USER_TASK_MANAGED_INITIAL_WAREHOUSE_SIZE = 'XSMALL'
    
  as
    COPY INTO ags_game_audience.raw.PL_GAME_LOGS
    from @UNI_KISHORE_PIPELINE
    file_format = (format_name=FF_JSON_LOGS);



execute task AGS_GAME_AUDIENCE.RAW.GET_NEW_FILES;




create or replace view PL_LOGS as
select 
raw_log:datetime_iso8601::timestamp_ntz as datetime_iso8601,
raw_log:ip_address::text as ip_address,
raw_log:user_event::text as user_event,
raw_log:user_login::text as user_login,
raw_log

from pl_game_logs;



select * from PL_LOGS;



create or replace task AGS_GAME_AUDIENCE.RAW.LOAD_LOGS_ENHANCED
    USER_TASK_MANAGED_INITIAL_WAREHOUSE_SIZE = 'XSMALL'
    SCHEDULE = '5 Minutes'
  as
  MERGE INTO ENHANCED.LOGS_ENHANCED e
using(
SELECT PL_LOGS.ip_address 
, PL_LOGS.user_login as GAMER_NAME
, PL_LOGS.user_event as GAME_EVENT_NAME
, PL_LOGS.datetime_iso8601 as GAME_EVENT_UTC
, city
, region
, country
, timezone as GAMER_LTZ_NAME
, CONVERT_TIMEZONE( 'UTC',timezone,PL_LOGS.datetime_iso8601) as game_event_ltz
, DAYNAME(game_event_ltz) as DOW_NAME
, TOD_NAME
from ags_game_audience.raw.ED_PIPELINE_LOGS PL_LOGS
JOIN ipinfo_geoloc.demo.location loc 
ON ipinfo_geoloc.public.TO_JOIN_KEY(PL_LOGS.ip_address) = loc.join_key
AND ipinfo_geoloc.public.TO_INT(PL_LOGS.ip_address) 
BETWEEN start_ip_int AND end_ip_int
JOIN ags_game_audience.raw.TIME_OF_DAY_LU tod
ON HOUR(game_event_ltz) = tod.hour ) r

ON r.GAMER_NAME = e.GAMER_NAME
and r.GAME_EVENT_UTC = e.game_event_utc
and r.GAME_EVENT_NAME = e.game_event_name

WHEN NOT MATCHED THEN
insert (
IP_ADDRESS, GAMER_NAME, GAME_EVENT_NAME, GAME_EVENT_UTC, CITY, REGION, COUNTRY, GAMER_LTZ_NAME, GAME_EVENT_LTZ, DOW_NAME, TOD_NAME
) 
values (
IP_ADDRESS, GAMER_NAME, GAME_EVENT_NAME, GAME_EVENT_UTC, CITY, REGION, COUNTRY, GAMER_LTZ_NAME, GAME_EVENT_LTZ, DOW_NAME, TOD_NAME
) 
;

execute task AGS_GAME_AUDIENCE.RAW.LOAD_LOGS_ENHANCED ;

select * from AGS_GAME_AUDIENCE.enhanced.LOGS_ENHANCED;
-- truncate table AGS_GAME_AUDIENCE.enhanced.LOGS_ENHANCED;

use role accountadmin;
grant ownership on task LOAD_LOGS_ENHANCED to role sysadmin ;
use role sysadmin;


describe schema AGS_GAME_AUDIENCE.RAW ;


select * from pl_game_logs;







--Turning on a task is done with a RESUME command
alter task AGS_GAME_AUDIENCE.RAW.GET_NEW_FILES resume;
alter task AGS_GAME_AUDIENCE.RAW.LOAD_LOGS_ENHANCED resume;

--Turning OFF a task is done with a SUSPEND command
alter task AGS_GAME_AUDIENCE.RAW.GET_NEW_FILES suspend;
alter task AGS_GAME_AUDIENCE.RAW.LOAD_LOGS_ENHANCED suspend;





--Step 1 - how many files in the bucket?
list @AGS_GAME_AUDIENCE.RAW.UNI_KISHORE_PIPELINE;

--Step 2 - number of rows in raw table (should be file count x 10)
select count(*) from AGS_GAME_AUDIENCE.RAW.PL_GAME_LOGS;

--Step 3 - number of rows in raw view (should be file count x 10)
select count(*) from AGS_GAME_AUDIENCE.RAW.PL_LOGS;

--Step 4 - number of rows in enhanced table (should be file count x 10 but fewer rows is okay because not all IP addresses are available from the IPInfo share)
select count(*) from AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED;



USE ROLE ACCOUNTADMIN;

GRANT EXECUTE MANAGED TASK ON ACCOUNT TO ROLE SYSADMIN;
USE ROLE sysadmin;