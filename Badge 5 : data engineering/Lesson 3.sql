
--what time zone is your account(and/or session) currently set to? Is it -0700?
select current_timestamp();

--worksheets are sometimes called sessions -- we'll be changing the worksheet time zone
alter session set timezone = 'UTC';
select current_timestamp();

--how did the time differ after changing the time zone for the worksheet?
alter session set timezone = 'Africa/Nairobi';
select current_timestamp();

alter session set timezone = 'Pacific/Funafuti';
select current_timestamp();

alter session set timezone = 'Asia/Shanghai';
select current_timestamp();

--show the account parameter called timezone
show parameters like 'timezone';






describe table game_logs ; 


select 
RAW_LOG:agent::text as AGENT ,
RAW_LOG:ip_address::text as ip_address ,
RAW_LOG:user_event::text as USER_EVENT,
RAW_LOG:datetime_iso8601::timestamp_ntz as datetime_iso8601,
RAW_LOG:user_login::text as user_login,
*
from game_logs;


select * from logs 
where agent is null;



--looking for empty AGENT column
select * 
from ags_game_audience.raw.LOGS
where agent is null;

--looking for non-empty IP_ADDRESS column
select 
RAW_LOG:ip_address::text as IP_ADDRESS
,*
from ags_game_audience.raw.LOGS
where ip_address is not null;





select * from logs where USER_LOGIN ilike '%kishore%' ;