use SQL_P2
------
select * from tesla_deliveries_dataset_2015_2025
select count(*) as row_count from tesla_deliveries_dataset_2015_2025
SELECT Region, COUNT(*) AS observation_count FROM tesla_deliveries_dataset_2015_2025 GROUP BY Region;
SELECT 
    Model,
    MIN(Avg_Price_USD) AS Min_Price,
    MAX(Avg_Price_USD) AS Max_Price,
    AVG(Avg_Price_USD) AS Avg_Price
FROM tesla_deliveries_dataset_2015_2025
GROUP BY Model;

-----
select year, sum(cast(Estimated_Deliveries as int)) as deliveri_total from tesla_deliveries_dataset_2015_2025
group by year
order by year

-----

select model, sum(cast(Production_Units as int)) as Production_Units_total from tesla_deliveries_dataset_2015_2025
group by model
order by model


-----

SELECT
    Region,
    Model,
    PERCENTILE_CONT(0.5) WITHIN GROUP 
        (ORDER BY CAST(Estimated_Deliveries AS INT)) 
        OVER (PARTITION BY Region, Model) AS Median_Estimated_Deliveries
FROM tesla_deliveries_dataset_2015_2025


-----
WITH yearly_data AS (
    SELECT
        Model,
        Year,
        SUM(CAST(Estimated_Deliveries AS INT)) AS Total_Deliveries
    FROM tesla_deliveries_dataset_2015_2025
    WHERE Year BETWEEN 2020 AND 2025
    GROUP BY Model, Year
),
with_growth AS (
    SELECT
        Model,
        Year,
        Total_Deliveries,
        LAG(Total_Deliveries, 1) OVER (PARTITION BY Model ORDER BY Year) AS Prev_Year_Deliveries
    FROM yearly_data
)
SELECT
    Model,
    Year,
    Total_Deliveries,
    Prev_Year_Deliveries,
    CASE 
        WHEN Prev_Year_Deliveries IS NULL THEN NULL
        ELSE ROUND( ( (Total_Deliveries - Prev_Year_Deliveries) * 100.0 ) / Prev_Year_Deliveries , 2)
    END AS YoY_Growth_Percent
FROM with_growth
ORDER BY Model, Year;

-----
SELECT
    Model,
    AVG(CAST(Battery_Capacity_kWh AS FLOAT)) AS Avg_Battery_Capacity,
    AVG(CAST(Range_km AS FLOAT)) AS Avg_Range_km
FROM tesla_deliveries_dataset_2015_2025
GROUP BY Model
ORDER BY Model;

-----
WITH model_totals AS (
    SELECT
        Region,
        Model,
        SUM(CAST(Estimated_Deliveries AS INT)) AS Total_Deliveries
    FROM tesla_deliveries_dataset_2015_2025
    GROUP BY Region, Model
),
ranked AS (
    SELECT
        Region,
        Model,
        Total_Deliveries,
        RANK() OVER (PARTITION BY Region ORDER BY Total_Deliveries DESC) AS rnk
    FROM model_totals
)
SELECT
    Region,
    Model AS Top_Model,
    Total_Deliveries
FROM ranked
WHERE rnk = 1
ORDER BY Region;

-----
with ilk as (select model, year, month,  sum(cast(Estimated_Deliveries as int)) as total_sales from tesla_deliveries_dataset_2015_2025
group by model,year,month)

select model, year, month,total_sales, rank() over(partition by  year, month order by total_sales desc) as rnk from ilk
order by year,Month,rnk


------
SELECT
    region,
    year,
    month,
    CAST(Estimated_Deliveries AS int) AS deliveries,
    AVG(CAST(Estimated_Deliveries AS int)) 
        OVER(PARTITION BY region 
             ORDER BY year, month
             ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS uc_ay_rolling_avg
FROM tesla_deliveries_dataset_2015_2025
ORDER BY region, year, month;


-----

select model,sum(coalesce(CAST(Avg_Price_USD AS float),0) * coalesce(CAST(Estimated_Deliveries AS float),0)) as revenue 
from tesla_deliveries_dataset_2015_2025
group by model
order by revenue desc


-----

select top 1 model, max(CAST(Avg_Price_USD AS float)) as max_price from tesla_deliveries_dataset_2015_2025
group by model
order by max_price desc


-----

select Region, sum(cast(CO2_Saved_tons as float)) as total_CO2
from tesla_deliveries_dataset_2015_2025
group by region
order by total_CO2 desc


-----
;WITH monthly AS (
    SELECT 
        region,
        [year],
        [month],
        SUM(CAST(Charging_Stations AS FLOAT)) AS stations
    FROM tesla_deliveries_dataset_2015_2025
    GROUP BY region, [year], [month]
),

diffs AS (
    SELECT
        region,
        [year],
        [month],
        stations,
        LAG(stations) OVER (PARTITION BY region ORDER BY [year], [month]) AS prev_stations
    FROM monthly
)

SELECT TOP 1
    region,
    [year],
    [month],
    (stations - prev_stations) AS increase_amount
FROM diffs
WHERE prev_stations IS NOT NULL
ORDER BY increase_amount DESC;







