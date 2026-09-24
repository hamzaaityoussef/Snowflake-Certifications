use role SYSADMIN;

create database AGS_GAME_AUDIENCE;

drop schema PUBLIC ; 

create schema RAW;


list @uni_kishore/updated_feed;


select $1
from @uni_kishore/updated_feed
(file_format => ff_json_logs);



COPY INTO ags_game_audience.raw.game_logs
from @uni_kishore/kickoff
file_format = (format_name=FF_JSON_LOGS);


COPY INTO ags_game_audience.raw.game_logs
from @uni_kishore/updated_feed
file_format = (format_name=FF_JSON_LOGS);



select 
RAW_LOG:agent::text as AGENT ,
RAW_LOG:user_event::text as USER_EVENT,
*
from game_logs;

truncate table game_logs;


CREATE or replace VIEW LOGS as
select 
RAW_LOG:ip_address::text as IP_ADDRESS ,
RAW_LOG:user_event::text as USER_EVENT,
RAW_LOG:datetime_iso8601::timestamp_ntz as datetime_iso8601,
RAW_LOG:user_login::text as user_login,
*
from game_logs
where ip_address is not null;

select * from logs;



describe schema ags_game_audience.raw ;


select current_timestamp() ;



