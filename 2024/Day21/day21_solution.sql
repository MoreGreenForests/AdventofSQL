-- SKills: extract, LAG, CTE

WITH SalesByQuarter AS (
    SELECT 
        extract(year from sale_date) AS year,
        extract(quarter from sale_date) AS quarter,
        SUM(amount) AS amount
    FROM SALES
    GROUP BY year, quarter
),
GrowthCalculation AS (
    SELECT 
        year,
        quarter,
        amount,
        CASE 
            WHEN LAG(amount) OVER (ORDER BY year, quarter) = 0 THEN 0
            ELSE (amount - LAG(amount) OVER (ORDER BY year, quarter)) / LAG(amount) OVER (ORDER BY year, quarter) * 100
        END AS growth_rate
    FROM SalesByQuarter
)
SELECT 
    year,
    quarter,
    amount,
    growth_rate
FROM GrowthCalculation
ORDER BY growth_rate DESC;
