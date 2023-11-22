/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [Id]
      ,[Year_Birth]
      ,[Education]
      ,[Marital_Status]
      ,[Income]
      ,[Kidhome]
      ,[Teenhome]
      ,[Dt_Customer]
      ,[Recency]
      ,[MntWines]
      ,[MntFruits]
      ,[MntMeatProducts]
      ,[MntFishProducts]
      ,[MntSweetProducts]
      ,[MntGoldProds]
      ,[NumDealsPurchases]
      ,[NumWebPurchases]
      ,[NumCatalogPurchases]
      ,[NumStorePurchases]
      ,[NumWebVisitsMonth]
      ,[Response]
      ,[Complain]
  FROM [PortfolioProject].[dbo].[superstore_data]

  -- Identifying null value in the dataset

  select *
  from superstore_data
  where  [Id] is null
      or[Year_Birth] is null
      or[Education] is null
      or[Marital_Status] is null
      or[Income] is null
      or[Kidhome] is null
      or[Teenhome] is null
      or[Dt_Customer] is null
      or[Recency] is null
      or[MntWines] is null
      or[MntFruits] is null
      or[MntMeatProducts] is null
      or[MntFishProducts] is null
      or[MntSweetProducts] is null
      or[MntGoldProds] is null
      or[NumDealsPurchases] is null
      or[NumWebPurchases] is null
      or[NumCatalogPurchases] is null
      or[NumStorePurchases] is null
      or[NumWebVisitsMonth] is null
      or[Response] is null
      or[Complain]is null

select *
from superstore_data

-- Deleting rows with null values

delete superstore_data
where Income is null

-- Adding another column to categorize 'Education' to Level of Education
alter table superstore_data
add Education_Level nvarchar(50)

update superstore_data
set Education_Level = 'Higher Edu'
where Education in ('Graduation','PhD','Master')

update superstore_data
set Education_Level = 'Basic Edu'
where Education in ('2n Cycle','Basic')

--Proportion of spendig on wine by Marital Status
select Marital_Status,round(avg(Income),2) AvgInc,round(avg(MntWines),2) WineSpend,
round(avg(MntWines)/avg(Income)*100,2) PerctSpend
from superstore_data
group by Marital_Status
order by 4 desc

--Proportion of spendig on meat by Marital Status
select Marital_Status,round(avg(Income),2) AvgInc,round(avg(MntMeatProducts),2) MeatSpend,
round(avg(MntMeatProducts)/avg(Income)*100,2) PerctSpend
from superstore_data
group by Marital_Status
order by 4 desc

-- The segement taking advantage of deal purchase 
select Marital_Status,Education_Level,sum(NumDealsPurchases) D_Purch,
round(sum(NumDealsPurchases)/(select sum(NumDealsPurchases) from superstore_data),2) PerctDP
from superstore_data
group by Marital_Status,Education_Level
order by 3 desc

-- The segement using the web for purchase 
select Marital_Status,Education_Level,sum(NumWebPurchases) W_Purch,
round(sum(NumWebPurchases)/(select sum(NumWebPurchases) from superstore_data),2) PerctWP
from superstore_data
group by Marital_Status,Education_Level
order by 3 desc

-- The segement using the web for purchase 
select Marital_Status,Education_Level,sum(NumWebPurchases) W_Purch,
round(sum(NumWebPurchases)/(select sum(NumWebPurchases) from superstore_data),2) PerctWP
from superstore_data
group by Marital_Status,Education_Level
order by 3 desc


-- The segement using Catalog for purchase 
select Marital_Status,Education_Level,sum(NumCatalogPurchases) W_Purch,
round(sum(NumCatalogPurchases)/(select sum(NumCatalogPurchases) from superstore_data),2) PerctCP
from superstore_data
group by Marital_Status,Education_Level
order by 3 desc

-- The segement buying directly from the store 
select Marital_Status,Education_Level,sum(NumStorePurchases) W_Purch,
round(sum(NumStorePurchases)/(select sum(NumStorePurchases) from superstore_data),2) PerctSP
from superstore_data
group by Marital_Status,Education_Level
order by 3 desc

-- Who are the customer of the superstore
select Marital_Status,Education_Level, count(Id) NumCust
from superstore_data
group by Marital_Status,Education_Level
order by 3 desc


--Total Sales for all prodcut for the 2yrs
with CumSales (WineSales,FruitSales,MeatSales,FishSales,SweetSales,GoldSales,TotalSales)
as
(select sum(MntWines) WineSales,sum(MntFruits) FruitStales,sum(MntMeatProducts) MeatSales,sum(MntFishProducts) FishSales,sum(MntSweetProducts) SweetSales,
sum(MntGoldProds) GoldSales,
sum(MntWines)+sum(MntFruits)+sum(MntMeatProducts)+sum(MntFishProducts)+sum(MntSweetProducts)+sum(MntGoldProds) TotalSales
from superstore_data
)

Select WineSales, round((WineSales/TotalSales)*100,2) WinePert
,FruitSales, round((FruitSales/TotalSales)*100,2) FruitPert
,MeatSales, round((MeatSales/TotalSales)*100,2) MeatPert
,FishSales, round((FishSales/TotalSales)*100,2) FishPert
,SweetSales, round((SweetSales/TotalSales)*100,2) SweetPert
,GoldSales, round((GoldSales/TotalSales)*100,2) GoldPert
,TotalSales
from CumSales




