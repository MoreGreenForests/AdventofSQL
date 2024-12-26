-- SKills: Pivot function, CTE

--SELECT * FROM drinks

-- Find Date Where:
--     HotCocoa: 38
--     PeppermintSchnapps: 298
--     Eggnog: 198


CREATE EXTENSION IF NOT EXISTS tablefunc;

WITH drink_total AS (
  SELECT
    date,
    drink_name,
    sum(quantity) as quantity
  FROM drinks
  GROUP BY date, drink_name
),
drink_array AS (
SELECT
  date,
  jsonb_object_agg(drink_name, quantity) AS drinks
FROM drink_total
GROUP BY date
)
SELECT * FROM drink_array
WHERE drinks->'Hot Cocoa' @> '38'
AND drinks->'Eggnog' @> '198'
AND drinks->'Peppermint Schnapps' @> '298';


