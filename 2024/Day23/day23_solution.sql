-- SKills: CTE, LAG, Island problem

WITH base_calc AS (
    SELECT
        id,
        LAG(id) OVER (ORDER BY id) AS prev_id
    FROM sequence_table
)
SELECT    
    prev_id + 1 as gap_start,
    id - 1 as gap_end,
    array_to_string(ARRAY(SELECT * FROM generate_series(prev_id + 1, id - 1)), ',') gaps_list
FROM base_calc
WHERE id - prev_id > 1
