create or replace table ROOT_DEPTH (
    ROOT_DEPTH_ID number(1),
    ROOT_DEPTH_CODE text(1),
    ROOT_DEPTH_NAME text(7),
    UBIT_OF_MEASURE text(2),
    RANGE_MIN number(2),
    RANGE_MAX number(2)

);



insert into root_depth 
values
(
    2,
    'D',
    'Deep',
    'cm',
    60,
    90
);


select * from root_depth ;

update  root_depth set root_depth_id = 3 where root_depth_code = 'D';