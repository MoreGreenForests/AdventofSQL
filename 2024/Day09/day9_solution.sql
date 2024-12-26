-- SKills: CTE, Aggregate Functions

WITH avg_scores_reindeer AS (
    SELECT reindeer_id, avg(speed_record) as avg_speed from Training_Sessions
    WHERE reindeer_id != COALESCE((SELECT reindeer_id FROM Reindeers WHERE reindeer_name = 'Rudolph'), -1)
    group by reindeer_id, exercise_name),
top_reindeer AS (
    SELECT reindeer_id, max(avg_speed) as top_speed FROM avg_scores_reindeer
    GROUP BY reindeer_id
)
SELECT r.reindeer_name, round(tr.top_speed, 2) FROM top_reindeer tr
LEFT JOIN Reindeers r ON r.reindeer_id = tr.reindeer_id
ORDER BY top_speed desc
LIMIT 3

