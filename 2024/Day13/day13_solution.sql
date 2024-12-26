-- SKills: CTE, split parts, unnest, array_agg

WITH email_exploded AS (
    SELECT 
        unnest(email_addresses) AS email
    FROM 
        contact_list
),
email_domains AS (
    SELECT 
        email,
        split_part(email, '@', 2) AS domain
    FROM 
        email_exploded
)
SELECT 
    domain,
    COUNT(DISTINCT email) AS distinct_email_count,
    ARRAY_AGG(email) AS email_list
FROM 
    email_domains
GROUP BY 
    domain
ORDER BY 
    distinct_email_count DESC,
    domain DESC;


-- Simpler solution
-- from (
--     from contact_list
--     select split(unnest(email_addresses), '@')[-1] as domain
-- )
-- group by domain
-- order by count(*) desc
-- limit 1