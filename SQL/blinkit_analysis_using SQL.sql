
--Extract the blinkit_data
select * from blinkit_data;
--no of rows
select COUNT(*) from blinkit_data;
--data cleaning
update blinkit_data 
set Item_Fat_Content=
case 
when Item_Fat_Content in ('LF','low fat') then 'Low Fat'
when Item_Fat_Content ='reg' then 'Regular'
else Item_Fat_Content
end
--distinct value
select distinct( Item_Fat_Content) from blinkit_data;
--total sales
select SUM(Sales)as total_sales from blinkit_data;
--total_Sales in milions
select CAST(sum(Sales)/1000000 as int) as total_sales_in_millions from blinkit_data;
--average sales
select CAST(avg(Sales) as decimal(10,0)) as avearage_sales_in_millions from blinkit_data;

select AVG(Sales) from blinkit_data;

--number of items
select COUNT(Item_identifier) as total_order from blinkit_data;
--avearage rating 
select cast(AVG(rating) as decimal(10,1)) as avg_rating from blinkit_data;

--total sales by fat content
select Item_Fat_Content ,
cast(SUM(Sales)as decimal(10,2)) as total_Sales,
cast(AVG(Sales) as decimal(10,1)) as avg_rating,
count(*) as number_of_items,
cast(AVG(rating) as decimal(10,2)) as avg_rating
from blinkit_data
group by Item_Fat_Content
order by total_Sales desc;
--total sales by item type
SELECT Item_Type, CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales
FROM blinkit_data
GROUP BY Item_Type
ORDER BY Total_Sales DESC;
--fat content by outlet for total sales
SELECT Outlet_Location_Type, 
       ISNULL([Low Fat], 0) AS Low_Fat, 
       ISNULL([Regular], 0) AS Regular
FROM 
(
    SELECT Outlet_Location_Type, Item_Fat_Content, 
           CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales
    FROM blinkit_data
    GROUP BY Outlet_Location_Type, Item_Fat_Content
) AS SourceTable
PIVOT 
(
    SUM(Total_Sales) 
    FOR Item_Fat_Content IN ([Low Fat], [Regular])
) AS PivotTable
ORDER BY Outlet_Location_Type;


-- Total Sales by Outlet Establishment
SELECT Outlet_Establishment_Year, CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales
FROM blinkit_data
GROUP BY Outlet_Establishment_Year
ORDER BY Outlet_Establishment_Year;
-- Percentage of Sales by Outlet Size
SELECT 
    Outlet_Size, 
    CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST((SUM(Sales) * 100.0 / SUM(SUM(Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage
FROM blinkit_data
GROUP BY Outlet_Size
ORDER BY Total_Sales DESC;
--sales by outlet location
SELECT Outlet_Location_Type, CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales
FROM blinkit_data
GROUP BY Outlet_Location_Type
ORDER BY Total_Sales DESC;
-- All Metrics by Outlet Type:
SELECT Outlet_Type, 
CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales,
		CAST(AVG(Sales) AS DECIMAL(10,0)) AS Avg_Sales,
		COUNT(*) AS No_Of_Items,
		CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating,
		CAST(AVG(Item_Visibility) AS DECIMAL(10,2)) AS Item_Visibility
FROM blinkit_data
GROUP BY Outlet_Type
ORDER BY Total_Sales DESC




