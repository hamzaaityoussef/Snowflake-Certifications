use role sysadmin ;

create database MELS_SMOOTHIE_CHALLENGE_DB;

drop schema public ; 

create schema TRAILS ;


use role sysadmin ;

create file format MELS_SMOOTHIE_CHALLENGE_DB.TRAILS.FF_JSON
    type =  JSON
    --  [ formatTypeOptions ]
    -- comment = '<comment>' 
    ;

create file format MELS_SMOOTHIE_CHALLENGE_DB.TRAILS.FF_PARQUET
    type =  parquet
    --  [ formatTypeOptions ]
    -- comment = '<comment>' 
    ;



select *
from @trails_geojson
(file_format => ff_json);


select *
from @trails_parquet
(file_format => ff_parquet);
