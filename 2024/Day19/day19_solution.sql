-- SKills: cross join, SUM, ROUND

WITH latest_performance AS (
    SELECT *, 
           (year_end_performance_scores[array_length(year_end_performance_scores, 1)])::integer AS last_score 
    FROM employees
),
AVG_SCORE AS (
    SELECT AVG(last_score) AS avg_last_score 
    FROM latest_performance
),
BONUS_Eligable AS (
    SELECT name, 
           salary, 
           last_score, 
           CASE
               WHEN last_score > avg_last_score THEN 1
               ELSE 0
           END AS recieved_bonus
    FROM latest_performance
    CROSS JOIN AVG_SCORE
),
total_compensation AS (
    SELECT name, 
           last_score, 
           salary, 
           recieved_bonus, 
           (salary + (salary * (recieved_bonus * 0.15))) AS total_comp 
    FROM BONUS_Eligable
)
SELECT SUM(total_comp) 
FROM total_compensation;


-- Simpler solution
-- with employee as (
--     select
--         salary,
--         year_end_performance_scores[array_upper(year_end_performance_scores, 1)]
--             as score
--     from employees
-- )
-- select
--     round(
--         sum(case
--             when score > (select avg(score) from employee) then salary * 1.15
--             else salary
--         end),
--         2
--     ) as total_salary_with_bonuses
-- from employee