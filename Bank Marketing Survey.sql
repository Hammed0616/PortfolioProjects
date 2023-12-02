/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [age]
      ,[job]
      ,[marital]
      ,[education]
      ,[default]
      ,[balance]
      ,[housing]
      ,[loan]
      ,[contact]
      ,[day]
      ,[month]
      ,[duration]
      ,[campaign]
      ,[pdays]
      ,[previous]
      ,[poutcome]
      ,[deposit]
  FROM [PortfolioProject].[dbo].[bank_survey]

  -- Checking for null values
  select*
  from bank_survey
  where [age] is null
      or[job] is null
      or[marital] is null
      or[education] is null
      or[default] is null
      or[balance] is null
      or[housing] is null
      or[loan] is null
      or[contact] is null
      or[day] is null
      or[month] is null
      or[duration] is null
      or[campaign] is null
      or[pdays] is null
      or[previous] is null
      or[poutcome]is null
      or[deposit] is null

select *
from bank_survey
where age >=71 or age =95

-- Grouping age of respondants
select max(age), min(age)
from bank_survey

alter table bank_survey
add customer_type nvarchar (50)

update bank_survey
set customer_type = case
    when age <=18 or age <= 25 then 'young'
	when age <= 26 or age <= 55 then 'Adult'
	when age <= 56 or age <= 70 then 'Elderly'
	when age <= 71 or age <= 95 then 'Senior'
else 'Unknown'
end
from bank_survey

-- customers deposit and loan matrix
select deposit,loan, count(deposit) dep_loan 
from bank_survey
group by deposit,loan

--- Which group of customer has the hightest deposit
select customer_type, sum(balance) depositbal,
round(sum(balance)/(select sum(balance) from bank_survey)*100,2)
from bank_survey
group by customer_type
order by 2 desc

-- Impact of education on deposit
select education, sum(balance) total_balance,count(deposit) num_account,
round(sum(balance)/(select sum(balance) from bank_survey)*100,2) perct
from bank_survey
group by education
order by 2 desc

--numbers of married and educated people with bank account
select marital,education, count(deposit) num_deposit
from bank_survey
group by marital,education
order by 3 desc

-- Avg duration of account ownership by different age group
select customer_type, round(avg(duration),2) acct_period
from bank_survey
group by customer_type

-- Rate of default among different job roles
select job, count([default]) as default_rate
from bank_survey
where [default] = 'yes'
group by job
order by 2 desc

-- what class of professional bank with the back
select job, count(job) cust_num
from bank_survey
group by job
order by 2 desc

