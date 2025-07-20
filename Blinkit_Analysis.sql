
USE Blinkitdb;
SELECT * FROM blinkit_data;

UPDATE blinkit_data
SET Item_Fat_Content = 
CASE 
WHEN Item_Fat_Content IN ('LF','low fat') THEN 'Low Fat'
WHEN Item_Fat_Content = 'reg' THEN 'Regular'
ELSE Item_Fat_Content
END

 -- TOTAL SALES
SELECT 
	CONCAT('$',(CAST(SUM(Sales)/1000000 AS DECIMAL(10,2)))) as Total_Sales_Millions
FROM blinkit_data;

-- AVERAGE OF TOTAL SALES
SELECT  CAST(AVG(Sales) AS DECIMAL(10,0))as Avg_Sales 
FROM blinkit_data;

-- TOTAL NUMBER OF ITEMS
SELECT COUNT(*) AS No_of_Items
FROM blinkit_data
WHERE Outlet_Establishment_Year = 2022;

--AVERAGE OF RATINGS
SELECT CAST(AVG(Rating) AS DECIMAL(10,2))as Avg_Rating
FROM blinkit_data;

-- TOTAL SALES BY ITEM FAT CONTENTS 
SELECT Item_Fat_Content,
	CONCAT(CAST(SUM(Sales)/1000 AS DECIMAL(10,2)),'K') AS Total_Sales_Thousands,
	CAST(AVG(Sales) AS DECIMAL(10,1))as Avg_Sales,
	COUNT(*) AS No_of_Items,
	CAST(AVG(Rating) AS DECIMAL(10,2))as Avg_Rating
FROM blinkit_data
GROUP BY Item_Fat_Content
ORDER BY Total_Sales_Thousands DESC;

-- TOTAL SALES BY ITEM TYPE
SELECT Item_Type,
	CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales,
	CAST(AVG(Sales) AS DECIMAL(10,0))as Avg_Sales,
	COUNT(*) AS No_of_Items,
	CAST(AVG(Rating) AS DECIMAL(10,2))as Avg_Rating
FROM blinkit_data
GROUP BY Item_Type
ORDER BY Total_Sales DESC;

-- FAT CONTENT BY OUTLET FOR TOTAL SALES
SELECT Outlet_Location_Type,
	CAST(SUM(CASE WHEN Item_Fat_Content = 'Low fat' THEN sales ELSE 0 END) AS DECIMAL(10,2)) AS Low_fat ,
	CAST(SUM(CASE WHEN Item_Fat_Content = 'Regular' THEN sales ELSE 0 END)AS DECIMAL(10,2)) AS Regular
FROM blinkit_data
GROUP BY Outlet_Location_Type
ORDER BY Outlet_Location_Type;

-- TOTAL SALES BY OUTLET ESTABLISHMNET
SELECT Outlet_Establishment_Year,
	CAST(SUM(sales)AS DECIMAL(10,2)) AS Total_Sales,
	CAST(AVG(sales)AS DECIMAL(10,2)) AS Avg_Sales,
	COUNT(*) AS No_of_Items,
	CAST(AVG(Rating)AS DECIMAL(10,2)) AS Avg_Ratings
FROM blinkit_data
GROUP BY Outlet_Establishment_Year
ORDER BY Outlet_Establishment_Year;

-- PERCENTAGE OF SALES BY OUTLET SIZE
SELECT Outlet_Size,
	CAST(SUM(sales)AS DECIMAL(10,2))AS Total_Sales,
	CAST((SUM(sales) * 100.0/ SUM(SUM(sales)) OVER()) AS DECIMAL(10,2)) as Percentage_of_Sales
FROM blinkit_data
GROUP BY Outlet_Size
ORDER BY Percentage_of_Sales DESC;

-- SALES BY OUTLET LOCATION
SELECT Outlet_Location_Type, 
	CAST(SUM(sales)AS DECIMAL(10,2)) AS Total_Sales,
	CAST((SUM(sales) * 100.0/ SUM(SUM(sales)) OVER()) AS DECIMAL(10,2)) as Percentage_of_Sales,
	CAST(AVG(sales)AS DECIMAL(10,2)) AS Avg_Sales,
	COUNT(*) AS No_of_Items,
	CAST(AVG(Rating)AS DECIMAL(10,2)) AS Avg_Ratings
FROM blinkit_data
GROUP BY Outlet_Location_Type
ORDER BY Total_Sales DESC;

-- ALL METRICS BY OUTLET TYPE
SELECT Outlet_Type, 
	CAST(SUM(sales)AS DECIMAL(10,2)) AS Total_Sales,
	CAST((SUM(sales) * 100.0/ SUM(SUM(sales)) OVER()) AS DECIMAL(10,2)) as Percentage_of_Sales,
	CAST(AVG(sales)AS DECIMAL(10,2)) AS Avg_Sales,
	COUNT(*) AS No_of_Items,
	CAST(AVG(Rating)AS DECIMAL(10,2)) AS Avg_Ratings
FROM blinkit_data
GROUP BY Outlet_Type
ORDER BY Total_Sales DESC;

-- Identify the top 3 Item_Type in each Outlet_Location_Type
--based on total sales, and also show the percentage of total outlet location sales they contribute.
WITH TotalSales as
(
SELECT Outlet_Location_Type,
	Item_Type,
	CAST(SUM(sales)AS DECIMAL(10,2))AS Total_Sales
FROM blinkit_data
GROUP BY Outlet_Location_Type, Item_Type
)
, Location_wise_sales as
(
SELECT 
	Outlet_Location_Type,
	CAST(SUM(Total_Sales)AS DECIMAL(10,2))AS Total_Location_Sales
FROM TotalSales
GROUP BY Outlet_Location_Type
)
, Ranked_Sales as
(
SELECT
	t.Outlet_Location_Type,
	t.Item_Type,
	t.Total_Sales,
	l.Total_Location_Sales,
	CAST(((t.Total_Sales * 100.0) / l.Total_Location_Sales )AS DECIMAL(10,2))AS Sales_Percentage,
	RANK() OVER(PARTITION BY t.Outlet_Location_Type ORDER BY t.Total_Sales DESC)AS rn
FROM TotalSales t
INNER JOIN Location_wise_sales l
ON t.Outlet_Location_Type=l.Outlet_Location_Type
)
SELECT	
	Outlet_Location_Type,
	Item_Type,
	Total_Sales,
	Total_Location_Sales,
	Sales_Percentage
FROM Ranked_Sales
WHERE rn <=3
ORDER BY Outlet_Location_Type,rn;

-- Sales Efficiency by Visibility 
-- Divide products into 4 quantiles based on Item_Visibility.
-- For each quantile:
-- Calculate average sales and average rating.
-- Then analyze:
-- Does more visibility always lead to more sales and higher ratings
WITH visibility_quartile AS
(
SELECT *,
	NTILE(4)OVER(ORDER BY Item_Visibility) AS Quartile
FROM blinkit_data
)
SELECT
	Quartile,
	CAST(MIN(Item_Visibility) AS DECIMAL(5,4)) AS Min_Visibility,
    CAST(MAX(Item_Visibility) AS DECIMAL(5,4)) AS Max_Visibility,
	CAST(SUM(sales)AS DECIMAL(10,2))AS Total_Sales,
	CAST(AVG(sales)AS DECIMAL(10,2))AS Avg_Sales,
	COUNT(*)AS Item_Count
FROM visibility_quartile
GROUP BY Quartile
ORDER BY Quartile;

--Outlet Age vs Performance :Analyze how the age of an outlet affects its average sales, rating, and store type preferences.
WITH outlet_age AS
(
SELECT *,
	(2025 - Outlet_Establishment_Year) AS Outlet_Age,
	CASE 
	WHEN (2025 - Outlet_Establishment_Year) <=5 THEN '0-5 Years'
	WHEN (2025 - Outlet_Establishment_Year) BETWEEN 6 AND 10 THEN '6-10 Years'
	ELSE '10+ Years'
	END AS Age_Bucket
FROM blinkit_data
)
,aggregated_data AS
(
SELECT 
	Age_Bucket,
	CAST(AVG(sales)AS DECIMAL(10,2))AS Avg_Sales,
	CAST(AVG(Rating) AS DECIMAL(10,2))AS Avg_Ratings
FROM outlet_age
GROUP BY Age_Bucket
),
mode_outlet_type AS
(
SELECT Age_Bucket,
	Outlet_Type
FROM (
	SELECT 
		Age_Bucket,
		Outlet_Type,
		COUNT(*) AS cnt,
		ROW_NUMBER() OVER(PARTITION BY Age_Bucket ORDER BY COUNT(*) DESC)AS rn
	FROM outlet_age
	GROUP BY Age_Bucket, Outlet_Type
)ranked
WHERE rn =1
)
SELECT
	a.Age_Bucket,
	a.Avg_Sales,
	a.Avg_Ratings,
	m.Outlet_Type as Most_Common_Outlet_type
FROM aggregated_data a
INNER JOIN mode_outlet_type m
ON a.Age_Bucket=m.Age_Bucket
ORDER BY a.Age_Bucket;

--Identify products (rows) where:
-- Sales are in the top 10% (≥ 90th percentile)
-- Ratings are below average
--This helps find products that sell well but are rated poorly, 
--indicating potential mismatches in customer satisfaction vs commercial success.

with percentile_sales as
(
SELECT *,
	PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY sales)OVER () AS p_90_sales,
	(SELECT AVG(Rating) FROM blinkit_data) AS Avg_rating
FROM blinkit_data
)

SELECT
	Item_Identifier,
	CAST(Sales AS DECIMAL(10,2))AS Sales,
	CAST (Rating AS DECIMAL(10,2))AS Rating,
	Item_Type,
	Outlet_Identifier,
	Outlet_Type,
	Outlet_Size,
	Outlet_Location_Type
FROM percentile_sales
WHERE sales >= p_90_sales and Rating < Avg_rating
ORDER BY Sales DESC;
