-- SKills: LAG, intiger rounding

WITH basic_toy_production AS (
    SELECT 
    production_date, 
    toys_produced, 
    LAG(toys_produced) OVER (ORDER BY production_date) AS previous_day_production
FROM toy_production)
SELECT 
    production_date, 
    toys_produced, 
    previous_day_production,
    toys_produced - previous_day_production AS production_change,
    ((toys_produced - previous_day_production) / ABS(previous_day_production)) * 100 AS production_change_percentage
FROM basic_toy_production
ORDER by production_change_percentage DESC