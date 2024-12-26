--Skills: JSON, Joins, Case
WITH wishlist_split AS (SELECT 
                    list_id, 
                    name,
                    c.child_id, 
                    (wishes ->> 'first_choice') AS primary_wish, 
                    (wishes ->> 'second_choice') AS backup_wish, 
                    (wishes -> 'colors') AS favorite_color
                    FROM wish_lists
                    LEFT JOIN children c ON c.child_id = wish_lists.child_id),
added_toy_catalog AS (SELECT 
                    name, 
                    primary_wish, 
                    backup_wish, 
                    favorite_color,
                    json_array_length(favorite_color) as color_count,
                    tc.difficulty_to_make,
                    tc.category
                    FROM wishlist_split AS ws
                    LEFT JOIN toy_catalogue AS tc ON ws.primary_wish = tc.toy_name)
        SELECT name, 
        primary_wish, 
        backup_wish, 
        favorite_color ->> 0 AS favorite_color, 
        color_count, 
        CASE
            WHEN difficulty_to_make = 1 THEN 'Simple Gift'
            WHEN difficulty_to_make = 2 THEN 'Moderate Gift'
            WHEN difficulty_to_make >= 3 THEN 'Complex Gift'
        END AS gift_complexity,
         CASE
            WHEN category = 'outdoor' THEN 'Outside Workshop'
            WHEN category = 'educational' THEN 'Learning Workshop'
            ELSE 'General Workshop'
        END AS workshop_assignment
        FROM added_toy_catalog
        ORDER BY name ASC;
