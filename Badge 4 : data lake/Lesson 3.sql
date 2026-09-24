
list @product_metadata;


select $1
from @product_metadata/swt_product_line.txt; 


create or replace file format zmd_file_format_1
RECORD_DELIMITER = ';'
TRIM_SPACE = True ;


select $1
from @product_metadata/product_coordination_suggestions.txt
(file_format => zmd_file_format_1);



create or replace file format zmd_file_format_2
FIELD_DELIMITER = '|'
RECORD_DELIMITER = ';'
TRIM_SPACE = TRUE ;  

select $1
from @product_metadata/product_coordination_suggestions.txt
(file_format => zmd_file_format_2);



create or replace file format zmd_file_format_3
FIELD_DELIMITER = '='
RECORD_DELIMITER = '^'
TRIM_SPACE = True ; 

select $1, $2
from @product_metadata/product_coordination_suggestions.txt
(file_format => zmd_file_format_3);



select $1 as sizes_available
from @product_metadata/sweatsuit_sizes.txt
(file_format => zmd_file_format_1 );


select replace($1 , chr(13)||chr(10)) , $2 , $3 
from @product_metadata/swt_product_line.txt
(file_format => zmd_file_format_2) ;




create or replace view zenas_athleisure_db.products.sweatsuit_sizes as (
select replace($1,chr(13)||chr(10)) as sizes_available
from @product_metadata/sweatsuit_sizes.txt
(file_format=> zmd_file_format_1) 
where sizes_available <> '' ) ;


select * from  zenas_athleisure_db.products.sweatsuit_sizes;



create or replace view zenas_athleisure_db.products.SWEATBAND_PRODUCT_LINE as (
select replace($1 , chr(13)||chr(10)) as PRODUCT_CODE , $2 AS HEADBAND_DESCRIPTION, $3 AS WRISTBAND_DESCRIPTION 
from @product_metadata/swt_product_line.txt
(file_format => zmd_file_format_2) 
);


select * from zenas_athleisure_db.products.SWEATBAND_PRODUCT_LINE ; 


CREATE VIEW  zenas_athleisure_db.products.SWEATBAND_COORDINATION AS (
select $1 as PRODUCT_CODE, $2 AS HAS_MATCHING_SWEATSUIT
from @product_metadata/product_coordination_suggestions.txt
(file_format => zmd_file_format_3)
);

select * from  zenas_athleisure_db.products.SWEATBAND_COORDINATION ;