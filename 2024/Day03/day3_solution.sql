-- SKills: CTE, XML

WITH extracted_data AS (
    SELECT
        id,
        UNNEST(
            ARRAY(
                SELECT xpath('//food_item_id/text()', menu_data)
            )
        )::TEXT::INT AS food_item_id,
        COALESCE(
            (xpath('//total_count/text()', menu_data))[1]::TEXT::INT,
            (xpath('//total_guests/text()', menu_data))[1]::TEXT::INT,
            (xpath('//guestCount/text()', menu_data))[1]::TEXT::INT
        ) AS total_count
    FROM christmas_menus
)
SELECT
    food_item_id,
    COUNT(*) AS occurrences
    --total_count
FROM
    extracted_data
WHERE
    total_count > 78
GROUP BY
    food_item_id--, total_count
ORDER BY
    occurrences DESC;

