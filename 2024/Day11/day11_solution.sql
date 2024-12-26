-- SKills: Average Over (moving average), window function

--SELECT * FROM TreeHarvests;

WITH treeharvest_season_order AS (
SELECT
    field_name,
    harvest_year,
    season,
    CASE 
        WHEN season = 'Spring' THEN 1
        WHEN season = 'Summer' THEN 2
        WHEN season = 'Fall' THEN 3
        WHEN season = 'Winter' THEN 4
    END as season_order,
    trees_harvested
    FROM TreeHarvests
    )
SELECT 
    field_name,
    harvest_year,
    season,
    round(AVG(trees_harvested) OVER (PARTITION BY field_name ORDER BY harvest_year, season_order ASC ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS three_season_moving_avg
FROM treeharvest_season_order
ORDER BY three_season_moving_avg DESC;