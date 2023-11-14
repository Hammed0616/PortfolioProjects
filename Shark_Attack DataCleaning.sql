/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [Case Number]
      ,[Date]
      ,[Year]
      ,[Type]
      ,[Country]
      ,[Area]
      ,[Location]
      ,[Activity]
      ,[Name]
      ,[Sex ]
      ,[Age]
      ,[Injury]
      ,[Fatal (Y/N)]
      ,[Time]
      ,[Species ]
      ,[Investigator or Source]
      ,[pdf]
      ,[href formula]
      ,[href]
      ,[Case Number1]
      ,[Case Number2]
      ,[original order]
      ,[F23]
      ,[F24]
  FROM [PortfolioProject].[dbo].[shark_attacks]
  
  -- Taking a look at the nul values in the dataset
  select *
  from shark_attacks
  where [Case Number] is null
  or [Date] is null

  -- Removing rows with null values
  delete from shark_attacks
  where [Case Number] is null
  or [Date] is null
  or [Year] is null
  or [Type] is null
  or [Country] is null
  or [Area] is null
  or [Location] is null
  or [Activity] is null
  or [Name] is null
  or [Sex ] is null
  or [Age] is null
  or [Injury] is null

  -- Rows with Type as 'Invalid'
  select *
  from shark_attacks
  where Type = 'Invalid'

  -- Number of 'Type in the dataset
  select Type, count(Type) as attack_type
  from shark_attacks
  group by Type
  order by 2 desc

  -- 'Boat' to be updated to 'Boating as they are likely to be refering to the same thing
  update shark_attacks
  set Type ='Boating'
  where Type = 'Boat'

  -- Number of activities in the dataset
  select distinct Activity
  from shark_attacks

  -- Activities that are fishing related (selecting similar rows of data)
  select distinct Activity
  from shark_attacks
  where Activity like '%fishing%'

  -- Ensuring data formart are consistent
  select distinct [Fatal (Y/N)] 
  from shark_attacks

  update shark_attacks
  set [Fatal (Y/N)] ='N'
  where [Fatal (Y/N)] =' N' 
  or [Fatal (Y/N)] ='M'


  update shark_attacks
  set [Fatal (Y/N)] = 'Y'
  where [Fatal (Y/N)] = 'UNKNOWN'

  select distinct [Name]
  from shark_attacks

  select [Name]
  from shark_attacks
  where [Name] in ('male','female','boy','girl')

  -- Comparing value in the Name and Gender column
  select [Name],[Sex ]
  from shark_attacks
  where [Name] in ('male','female','boy','girl')
  order by 2

  update shark_attacks
  set [Sex ] = 'F'
  where [Name] = 'female'
  and [Sex ] = 'M'
 
 -- Replace geneda value in name column with 'Unknown'
 update shark_attacks
  set [Name] = 'Unknown'
  where [Name] in ('male','female','boy','girl')

  select trim([Name])
  from shark_attacks

  update shark_attacks
  set [Name] = trim([Name])

  -- find blank/null species column and repalcing then with unknow
  select [Species ]
  from shark_attacks
  where [Species ] = ' '
  or [Species ] is null

  
  update shark_attacks
  set [Species ] = 'Unknown'
  where [Species ] = ' '
  or [Species ] is null

  -- update the injury column for FATAL to Fatal
  select Injury
  from shark_attacks

  update shark_attacks
  set Injury = 'Fatal'
  where Injury = 'FATAL'
  
  select *
  from shark_attacks
  
  -- Selecting year from the dataset
  select Year([Date]) Year
  from shark_attacks
  order by Year

  select CONCAT(Upper(substring(Country,1,1)), lower(substring(Country,2,Len(Country)))) as Country_Proper_Case
  from shark_attacks
  
  update shark_attacks
  set Country = CONCAT(Upper(substring(Country,1,1)), lower(substring(Country,2,Len(Country))))


  update shark_attacks
  set Country = 'USA'
  where Country = 'Usa'

  --Renaming column
  sp_rename 'dbo.shark_attacks.Sex','Gender','COLUMN'

  sp_rename 'shark_attacks.Fatal (Y/N)','Fatal','COLUMN'

  --Wrangling the time column
  select Time
  from shark_attacks

  -- using substring and CASE statement

  select Time, --substring(Time,1,2),
  case
      when substring(Time,1,2)<'04' then 'pre-dawn'
	  when substring(Time,1,2)>='04' and substring(Time,1,2)<'07' then 'Early morning'
	  when (substring(Time,1,2)>='07' or substring(Time,1,1)>='07') and substring(Time,1,2)<'10' then 'morning'
	  when substring(Time,1,2)>='10' and substring(Time,1,2)<'12' then 'Early noon'
	  when substring(Time,1,2)>='12' and substring(Time,1,2)<'13' then 'Noon'
	  when substring(Time,1,2)>='13' and substring(Time,1,2)<'15' then 'Afternoon'
	  when substring(Time,1,2)>='15' and substring(Time,1,2)<'16' then 'Early evening'
	  when substring(Time,1,2)>='16' and substring(Time,1,2)<'18' then 'Evening'
	  when substring(Time,1,2)>='18' and substring(Time,1,2)<'20' then 'Late evening'
	  when substring(Time,1,2)>='20' and substring(Time,1,2)<'22' then 'Night'
	  when substring(Time,1,2)>='22' then 'Late night'
  else Time
  end Attack_Time
  from shark_attacks
  where Time is not null
  order by Attack_Time
  
  -- Updating the date with the new time of attack
  update shark_attacks
  set Time=case
      when substring(Time,1,2)<'04' then 'pre-dawn'
	  when substring(Time,1,2)>='04' and substring(Time,1,2)<'07' then 'Early morning'
	  when (substring(Time,1,2)>='07' or substring(Time,1,1)>='07') and substring(Time,1,2)<'10' then 'morning'
	  when substring(Time,1,2)>='10' and substring(Time,1,2)<'12' then 'Early noon'
	  when substring(Time,1,2)>='12' and substring(Time,1,2)<'13' then 'Noon'
	  when substring(Time,1,2)>='13' and substring(Time,1,2)<'15' then 'Afternoon'
	  when substring(Time,1,2)>='15' and substring(Time,1,2)<'16' then 'Early evening'
	  when substring(Time,1,2)>='16' and substring(Time,1,2)<'18' then 'Evening'
	  when substring(Time,1,2)>='18' and substring(Time,1,2)<'20' then 'Late evening'
	  when substring(Time,1,2)>='20' and substring(Time,1,2)<'22' then 'Night'
	  when substring(Time,1,2)>='22' then 'Late night'
  else Time
  end
  
  select *
  from shark_attacks

  -- Rename the 'Time' to 'Attact Time'
  sp_rename 'shark_attacks.Time','Attack Time','COLUMN'









