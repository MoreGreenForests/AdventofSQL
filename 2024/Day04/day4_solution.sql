-- SKills: Arrays, Set Oprations (except, intersect)

WITH tag_lists AS (SELECT 
    toy_id,
    toy_name,
    ARRAY(SELECT UNNEST(new_tags) EXCEPT SELECT UNNEST(previous_tags)) AS added_tags,
    ARRAY(SELECT UNNEST(previous_tags) INTERSECT SELECT UNNEST(new_tags)) AS unchanged_tags,
    ARRAY(SELECT UNNEST(previous_tags) EXCEPT SELECT UNNEST(new_tags)) AS removed_tags
FROM toy_production)
SELECT * FROM tag_lists
WHERE added_tags is NOT NULL AND
added_tags <> '{}'
ORDER BY array_length(added_tags, 1) DESC;


WITH tag_split AS (SELECT 
    toy_id,
    toy_name,
    ARRAY(SELECT UNNEST(new_tags) EXCEPT SELECT UNNEST(previous_tags)) AS added_tags,
    ARRAY(SELECT UNNEST(previous_tags) INTERSECT SELECT UNNEST(new_tags)) AS unchanged_tags,
    ARRAY(SELECT UNNEST(previous_tags) EXCEPT SELECT UNNEST(new_tags)) AS removed_tags
FROM toy_production
),
added_tag_lengths AS (SELECT toy_id, toy_name, 
                        array_length(added_tags, 1) as added_tag_count,
                        array_length(unchanged_tags, 1) as unchanged_tag_count,
                        array_length(removed_tags, 1) as removed_tag_count
                        FROM tag_split)
SELECT * FROM added_tag_lengths
WHERE added_tag_count is not NULL
ORDER BY added_tag_count desc;