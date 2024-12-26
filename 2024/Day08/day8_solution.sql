-- SKills: CTE, Recursive Functions

WITH RECURSIVE staff_levels AS (
  SELECT
    staff_id,
    manager_id,
    staff_name,
    1 AS level,
    CAST(staff_id AS TEXT) AS path_to_ceo
  FROM
    staff
  WHERE
    staff_id = 1
  UNION ALL
  SELECT
    e.staff_id,
    e.manager_id,
    e.staff_name,
    s.level + 1 AS level,
    s.path_to_ceo || ',' || e.staff_id::TEXT AS path_to_ceo
  FROM
    staff e
    INNER JOIN staff_levels s ON e.manager_id = s.staff_id
)
SELECT
  staff_id,
  manager_id,
  staff_name,
  level,
  path_to_ceo
FROM
  staff_levels
ORDER BY level desc, staff_id;
