show databases;
use absentism;
show tables;
-- using ABS_work, and reason table to check workers who are elligible for absenteeism compensation

select ID, reason_for_absence, month_of_absence, age, body_mass_index, absenteeism_time_in_hours
from abs_work;
-- joining this table with reason for absence table(reason) 
select * from reasons;
 select a.ID, a.reason_for_absence, a.month_of_absence, a.age, a.body_mass_index, a.absenteeism_time_in_hours, 
 r.reason from abs_work a
left join reasons r
on r.number=a.Reason_for_absence;
-- optimizing query


select a.ID, a.month_of_absence, a.age, a.body_mass_index, a.absenteeism_time_in_hours,
case when a.month_of_absence in (12,1,2) then 'Winter'
	when a.Month_of_absence in (3,4,5) then 'Spring'
	when a.Month_of_absence in (6,7,8) then 'Summer'
	when a.month_of_absence  in (9,10,11) then 'Fall'
else 'unknown' end as seasons_of_absence,
case when a.body_mass_index < 18.5 then 'underweight'
	when a.body_mass_index between 18.5 and 25 then 'heathy weight'
	when a.body_mass_index between 25 and 30 then 'overweight'
	when a.body_mass_index > 30 then 'obese'
	end as body_weight,
    r.reason
from abs_work a
left join reasons r
on r.number=a.Reason_for_absence;
-- checking the rate of absenteeism with factors
select a.ID, a.absenteeism_time_in_hours,
case when age <25 then 'young'
	when age between 25 and 35 then 'adult'
    when age between 36 and 64 then 'old folks'
    when age > 64 then 'retiring stage'
    else 'unknown' end as Age_bracket,
case when a.month_of_absence in (12,1,2) then 'Winter'
	when a.Month_of_absence in (3,4,5) then 'Spring'
	when a.Month_of_absence in (6,7,8) then 'Summer'
	when a.month_of_absence  in (9,10,11) then 'Fall'
else 'unknown' end as seasons_of_absence,
case when a.body_mass_index < 18.5 then 'underweight'
	when a.body_mass_index between 18.5 and 25 then 'heathy weight'
	when a.body_mass_index between 25 and 30 then 'overweight'
	when a.body_mass_index > 30 then 'obese'
	end as body_weight,
    r.reason
from abs_work a
left join reasons r
on r.number=a.Reason_for_absence
order by Absenteeism_time_in_hours desc;
-- most people with the highest number of absenteeism all within the class of adult and old folks

-- checking total money the organization will pay as absenteeism compensation if they are to pay 50% of normal £12.50/per



 select a.ID, a.absenteeism_time_in_hours, r.reason,
	case
		when r.reason like '%nkown' then a.absenteeism_time_in_hours+(0)
		when r.reason like '%unjust%' then a.absenteeism_time_in_hours*0
		else a.absenteeism_time_in_hours*(12.50/2)
		end as compensaction_fee
  -- those with unkown and unjustified reason for absence will not recieve any compensaction 
 from abs_work a 
 left join reasons r
on r.number=a.Reason_for_absence
order by Absenteeism_time_in_hours desc;
-- The highest compensaction was £750


drop table if exists Absenteeism_compensaction_fee;
create table Absenteeism_compensaction_fee (id int, absenteeism_time_in_hours int, 
reason_for_ansence nvarchar (255), compensaction int);
select * from Absenteeism_compensaction_fee;
insert Absenteeism_compensaction_fee
select a.ID, a.absenteeism_time_in_hours, r.reason,
	case
		when r.reason like '%nkown' then a.absenteeism_time_in_hours+(0)
		when r.reason like '%unjust%' then a.absenteeism_time_in_hours*0
		else a.absenteeism_time_in_hours*(12.50/2)
		end as compensaction_fee
  -- those with unkown and unjustified reason for absence will not recieve any compensaction 
 from abs_work a 
 left join reasons r
on r.number=a.Reason_for_absence
order by Absenteeism_time_in_hours desc;

select * from Absenteeism_compensaction_fee; 



-- using CTE to calcalte the total money the organization spent on absenteeism compensaction. 

with compe AS (select a.ID, a.absenteeism_time_in_hours, r.reason,
	case
		when r.reason like '%nkown' then a.absenteeism_time_in_hours+(0)
		when r.reason like '%unjust%' then a.absenteeism_time_in_hours*0
		else a.absenteeism_time_in_hours*(12.50/2)
		end as compensaction_fee
  -- those with unkown and unjustified reason for absence will not recieve any compensaction 
 from abs_work a 
 left join reasons r
on r.number=a.Reason_for_absence
order by Absenteeism_time_in_hours desc)
select sum(compensaction_fee) from compe;
-- Total compensation the organization paid for absenteeism is £30,525

-- creating view for further visualization



create view Absenteeism_compensaction_fee as
select * from Absenteeism_compensaction_fee;
insert Absenteeism_compensaction_fee
select a.ID, a.absenteeism_time_in_hours, r.reason,
	case
		when r.reason like '%nkown' then a.absenteeism_time_in_hours+(0)
		when r.reason like '%unjust%' then a.absenteeism_time_in_hours*0
		else a.absenteeism_time_in_hours*(12.50/2)
		end as compensaction_fee
  -- those with unkown and unjustified reason for absence will not recieve any compensaction 
 from abs_work a 
 left join reasons r
on r.number=a.Reason_for_absence
order by Absenteeism_time_in_hours desc;