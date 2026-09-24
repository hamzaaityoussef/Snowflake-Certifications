// JSON DDL Scripts
use database library_card_catalog;
use role sysadmin;

// Create an Ingestion Table for JSON Data
create table library_card_catalog.public.author_ingest_json
(
  raw_author variant
);



//Create File Format for JSON Data 
create file format library_card_catalog.public.json_file_format
type = 'JSON' 
compression = 'AUTO' 
enable_octal =false
allow_duplicate = false
strip_outer_array = true
strip_null_values = false
ignore_utf8_errors = false; 





-- create or replace file format library_card_catalog.public.read_from_json
--     type = 'json'
--     STRIP_OUTER_ARRAY = TRUE;
    


select $1
from @util_db.public.my_internal_stage/author_with_header.json
(file_format => library_card_catalog.public.read_from_json);


copy into library_card_catalog.public.author_ingest_json
from @util_db.public.my_internal_stage/author_with_header.json
file_format = (format_name = library_card_catalog.public.json_file_format);

select * from author_ingest_json;


//returns AUTHOR_UID value from top-level object's attribute
select raw_author:AUTHOR_UID
from author_ingest_json;

//returns the data in a way that makes it look like a normalized table
SELECT 
 raw_author:AUTHOR_UID
,raw_author:FIRST_NAME::STRING as FIRST_NAME
,raw_author:MIDDLE_NAME::STRING as MIDDLE_NAME
,raw_author:LAST_NAME::STRING as LAST_NAME
FROM AUTHOR_INGEST_JSON;