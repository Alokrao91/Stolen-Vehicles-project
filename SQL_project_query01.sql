create database Vehicle_theftdb
use Vehicle_theftdb

--- Bulk insert is to import the data from localdb into the RDBms by writing the query

--Stolen_vehicles Table 1

create table st_veh
(vehicle_id varchar(max),vehicle_type varchar(max),make_id varchar(max),model_year varchar(max),vehicle_desc varchar(max),
color varchar(max),date_stolen varchar(max),location_id varchar(max))


--make details table 2

create table make_d
(make_id varchar(max),make_name varchar(max),make_type varchar(max))


--Locations table 3

create table locations
(location_id varchar(max),	region varchar(max), country varchar(max),	
population varchar(max),density varchar(max))

----  Import the data here 

Bulk insert locations
from 'C:\Users\admin\Downloads\locations.csv'  -- path
with  -- need to provide the parameter
  (fieldterminator=',' ,  rowterminator='\n' , firstrow=2, maxerrors=20)

-- copy the location of your csv files
--path: C:\Users\admin\Downloads\locations

select * from locations

-- make_details
Bulk insert make_d
from 'C:\Users\admin\Downloads\make_details.csv'  -- path
with  -- need to provide the parameter
  (fieldterminator=',' ,  rowterminator='\n' , firstrow=2, maxerrors=20)

  ---- 
  select * from make_d

  --- stolen_vh

  Bulk insert st_veh
from 'C:\Users\admin\Downloads\stolen_vehicles.csv'  -- path
with  -- need to provide the parameter
  (fieldterminator=',' ,  rowterminator='\n' , firstrow=2, maxerrors=20)

  select * from st_veh

  ---- we'll go with the data validation check

  alter table st_veh
  alter column date_stolen date

  select Date_stolen,try_convert(date, date_stolen) as formatted_date from st_veh
  where try_convert(date, date_stolen) is null

  select * from st_veh
  where isdate(date_stolen)=0   ---- which are not recognize date format

  select 

  --- YYYY-MM-DD  -- default storage format of date data type
  --- there are different styles to present a date
  -- 100 to 113 
  -- Saturday 1 feb,2025
  -- 2025.02.01
  ---20250201

  update st_veh set date_stolen= case when date_stolen='2021/15/10' then '2021-10-15'
										when date_stolen='13-02-2022' then '2022-02-13'
										else date_stolen end 



--- update the date_stolen column data type in to date

update st_veh set date_stolen=convert(date, date_stolen)

--- alter the column
  alter table st_veh
  alter column date_stolen date

  select * from st_veh


  select * from locations

  alter table locations
  alter column population int

  
  alter table locations
  alter column density decimal(5,2)


  --- make_d

  select * from make_d
  

  select * from st_veh
  -- count the data

  -- check for duplicates
  select count(*) from st_veh
  select distinct count(*) from st_veh

   -- there are no duplicates

    select count(*) from make_d
	 select distinct count(*) from make_d

	 --- no duplicates

	  select count(*) from locations
	   select distinct count(*) from locations

	   --- no duplicates

--- will check the data distribution

select * from st_veh

select Distinct vehicle_type from st_veh

select vehicle_type,color, count(vehicle_id) as 'no_of_veh_stolen' from st_veh
group by vehicle_type,color
order by no_of_veh_stolen desc

-- in the vehicle type we have one null category, we convert it into the unknow_type

update st_veh set vehicle_type= 'unknown_type'
where vehicle_type is null


--- vehicle_desc

select distinct vehicle_type,vehicle_desc from st_veh
where vehicle_desc is null

---- we'll change the null or undefined veh_desc into ' not-provided'

update st_veh set vehicle_desc='not-provided'
where vehicle_desc is null

select distinct vehicle_type,vehicle_desc from st_veh
where vehicle_desc='not-provided'

select distinct vehicle_type, vehicle_desc from st_veh
where vehicle_type='Boat trailer'


select distinct model_year from st_veh

--- min and max model year

select min(model_year) as 'oldest_model_year' , max(model_year) as 'latest_model_year' from st_veh

---- will create the model_year group in our data
--- group vintage_veh= 1940 to 1960
--- classic model - 1961- 1990
-- oldest model - 1991- 2018
-- latest model -->2018

select *, case when model_year between 1940 and 1960 then 'vintage model'
			   when model_year between 1961 and 1990 then 'classic model'
			   when model_year between 1991 and 2018 then 'oldest model'
			   when model_year>2018 then 'vintage model'
			   Else 'unknown' end as 'Model_group'
from st_veh

---- create a column for this model_group

alter table st_veh
add Model_group varchar(40)

update st_veh set model_group=case when model_year between 1940 and 1960 then 'vintage model'
			   when model_year between 1961 and 1990 then 'classic model'
			   when model_year between 1991 and 2018 then 'oldest model'
				Else 'latest_model' end


-- null-- unknown

alter table st_veh
drop column model_year

--- creating temp table st_veh1 as copied
create table st_veh1
(vehicle_id varchar(max),vehicle_type varchar(max),make_id varchar(max),model_year varchar(max),vehicle_desc varchar(max),
color varchar(max),date_stolen varchar(max),location_id varchar(max))

--bulk insert


  Bulk insert st_veh1
from 'C:\Users\admin\Downloads\stolen_vehicles.csv'  -- path
with  -- need to provide the parameter
  (fieldterminator=',' ,  rowterminator='\n' , firstrow=2, maxerrors=20)

  alter table st_veh
  add model_year varchar(max)

  -- this query update model_year column values from temp table st_veh1.model_year into st_veh.model_year column
  update st_veh set model_year=st_veh1.model_year
  from st_veh 
  join st_veh1 on st_veh.vehicle_id=st_veh1.vehicle_id

  select * from st_veh

  -- will update the model_group column again

  update st_veh set model_group=case when model_year between 1940 and 1960 then 'vintage model(1940-60)'
			   when model_year between 1961 and 1990 then 'classic model(1961-90)'
			   when model_year between 1991 and 2018 then 'oldest model(1991-2018)'
				Else 'latest_model(>2018)' end

select model_group ,vehicle_type,vehicle_desc, count(vehicle_id) as 'total_st_veh_count' from st_veh
group by model_group, vehicle_type,vehicle_desc
order by total_st_veh_count desc
  -- now we can drop the temp table st_veh1

  --drop table st_veh1

