/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [Cust ID]
      ,[Customer]
      ,[Product ID]
      ,[Order ID]
      ,[Units Sold]
      ,[Date Purchased]
  FROM [PortfolioProject].[dbo].[apocolypse_sales]

  select *
  from apocolypse_sales

  -- Identifying categories od customers
  
  select distinct(Customer)
  from apocolypse_sales

  -- numbers of order and quantity bought by each category
  select Customer, count([Order ID]) num_order, sum([Units Sold]) as total_sales
  from apocolypse_sales
  group by Customer
  order by 3

  -- Most product sold and to which customer category
  select [Product Name],count(sales.[Product ID]) frqcy_order, sum([Units Sold]) units_sold
  from apocolypse_sales sales
  join apocolypse_store store
  on sales.[Product ID] = store.[Product ID]
  group by [Product Name]
  order by 3 desc

  --- Total profit on each product using CTE
  with total_profit ([Product Name],Price,[Production Cost],units_sold)
  as
  (select [Product Name],Price,[Production Cost],sum([Units Sold]) units_sold
  from apocolypse_sales sales
  join apocolypse_store store
  on sales.[Product ID] = store.[Product ID]
  group by [Product Name],Price,[Production Cost]
  )

  select [Product Name],units_sold,((Price - [Production Cost]) * units_sold) as profit
  from total_profit


