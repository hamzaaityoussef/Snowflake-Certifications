create table garden_plants.veggies.vegetable_details
(
plant_name varchar(25)
, root_depth_code varchar(1)    
);






select * from garden_plants.veggies.vegetable_details where plant_name = 'Spinach' ;


delete from garden_plants.veggies.vegetable_details where plant_name = 'Spinach' and root_depth_code = 'D' ;