-- SKills: JSON, CTE, JSON_OBJECT_AGG

--SELECT *, split_part(url, '?', 2) AS params FROM web_requests;

-- filter for cases with 'utm_source=advent-of-sql' as a param value

WITH SPLIT_PARAMS AS (
    SELECT
        URL,
        split_part(url, '?', 2) AS params
    FROM web_requests
),
JSON_PARAMETERS AS (
    SELECT
        URL,
        jsonb_object_agg(
            split_part(param, '=', 1),
            split_part(param, '=', 2)
        ) AS params_dict
    FROM SPLIT_PARAMS,
         LATERAL unnest(string_to_array(params, '&')) AS param
    GROUP BY URL
),
PARAM_KEYS AS (
    SELECT
        URL,
        params_dict,
        jsonb_object_keys(params_dict) AS param_key
    FROM JSON_PARAMETERS
),
PARAM_COUNTS AS (
    SELECT
        URL,
        params_dict,
        COUNT(param_key) AS param_count
    FROM PARAM_KEYS
    GROUP BY URL, params_dict
)
SELECT 
    URL, 
    params_dict, 
    param_count
FROM PARAM_COUNTS
WHERE params_dict ->> 'utm_source' = 'advent-of-sql'
ORDER BY param_count DESC, URL ASC;


-- Simpler Solution
-- from (
--     from web_requests
--     select url, split(split(url, '?')[-1], '&') as params
-- )
-- select url
-- where params.list_contains('utm_source=advent-of-sql')
-- order by len(params) desc, url
-- limit 1