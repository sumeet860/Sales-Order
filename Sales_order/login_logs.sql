use plantix;

select * from login_logs;

-- Total count of users loggedin in  
select count(login_log_id) from login_logs;

-- Total login in year 21, 22
select 
(select count(login_log_id) distinct_users) Total_logins,
(select count(login_log_id) users from login_logs where year(login_time)=2021) login21,
(select count(login_log_id) users from login_logs where year(login_time)=2022) login22,
(((select count(login_log_id) users from login_logs where year(login_time)=2022)-
(select count(login_log_id) users from login_logs where year(login_time)=2021))/
(select count(login_log_id) distinct_users)*100 ) increase_login_percent
from login_logs;

-- Distinct users
select count(distinct user_id)
from login_logs;

-- Distinct user by year
select year(login_time) period,count( distinct user_id) users
from login_logs
group by period;

-- Distinct login user increase %
select 
(select count(distinct user_id) distinct_users) Total_distinct_users,
(select count( distinct user_id) users from login_logs where year(login_time)=2021) users_of_year_2021,
(select count( distinct user_id) users from login_logs where year(login_time)=2022) users_of_year_2022,
(((select count( distinct user_id) users from login_logs where year(login_time)=2022)-
(select count( distinct user_id) users from login_logs where year(login_time)=2021))/
(select count(distinct user_id) unique_users)*100 ) percent_increase_distinct_user
from login_logs;

-- Max login by day
select date(login_time) day_period,count(*) login_attempts
from login_logs
group by day_period
order by login_attempts desc
limit 1;

-- Max login by week
select week(login_time) week_period,count(*) login_attempts, year(login_time) year_login
from login_logs
group by week_period
order by login_attempts desc
limit 1;

-- Max login by year
select year(login_time) year_period,count(*) login_attempts
from login_logs
group by year_period
order by login_attempts desc
limit 1;

-- login by week
with cte as (SELECT *, week(login_time) week_period
, concat(week(login_time),'-', week(login_time)+1) period_slot
 FROM login_logs)
 select period_slot ,count(*) login_attempt
 from cte
 group by period_slot
 order by period_slot;
 
 -- Top 3 day with max login
 select dayname(login_time) day,count(*) login_attempts
from login_logs
group by day
order by login_attempts desc
limit 3;

-- hour with max login
with cte as (SELECT *, date(login_time) Date
, concat(hour(time(login_time)),'-', hour(time(login_time))+1) Time_slot
 FROM login_logs)
 select Time_slot ,count(*) login_attempt
 from cte
 group by Time_slot
 order by login_attempt DESC
 limit 1;
 