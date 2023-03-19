-- Calcualte the total profit and revenue of each bike product--
select distinct(Product),sum([ Revenue ])as total_revenue,sum([ Profit ]) as total_profit
from bike_sales
group by Product
--- which gender bought the most bike between the years 2012 and 2016  ---
select Customer_Gender,count(Product) as Bikes 
from bike_sales
where  Sub_Category like '%bike racks%' and year between 2012 and 2016
group by Customer_Gender
--- Top counrties with the hieghst revenue of touring, road bikes 
select Country, RANK() over (order by country desc) as rank_of_countries ,max([ Revenue ]) as Highest_revenue
from bike_sales
where Sub_Category in('touring bikes', 'road bikes')
group by country 
--- which month had the average sales in the USA based on state
select distinct(Month),State,avg([ Revenue ]) as Average_Revenue
from bike_sales
where Country like 'United States%'
group by Month,State
order by Month
-- which accessories product_category brought in the most revenue --- 
select Product_Category,[Product], max([ Revenue ])as Max_revenue
from bike_sales
group by Product_Category,Product,[ Revenue ]
order by [ Revenue ]desc
--- which age purchased the most bikes --
select Customer_Age,sum([ Revenue ])as Totla_sales
from bike_sales
where Product_Category like '%bike%'
group by Customer_Age
order by [ Revenue ] desc
--- Locate the ratio between total profit and total revenue of each bike 
select Product,sum([ Revenue ])/sum([ Profit ]) as Ratio
from bike_sales
where Product_Category like '%bikes%'
group by Product
order by Ratio desc
---Creating view for Future visulaizations 
create view Number_bikes_sold as 
select Country, RANK() over (order by country desc) as rank_of_countries ,max([ Revenue ]) as Highest_revenue
from bike_sales
where Sub_Category in('touring bikes', 'road bikes')
group by country 

