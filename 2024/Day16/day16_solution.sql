-- SKills: Window Function, Geometry, Lead, CTE


--select * from sleigh_locations;

WITH location_durations AS (
    SELECT
        sl.timestamp AS start_time,
        LEAD(sl.timestamp) OVER (ORDER BY sl.timestamp) AS end_time,
        sl.coordinate
    FROM
        sleigh_locations sl
),
location_areas AS (
    SELECT
        ld.start_time,
        ld.end_time,
        ld.coordinate,
        a.place_name AS area
    FROM
        location_durations ld
    LEFT JOIN
        areas a
    ON
        ST_Contains(a.polygon::geometry, ld.coordinate::geometry)
),
area_durations AS (
    SELECT
        area,
        SUM(EXTRACT(EPOCH FROM (end_time - start_time))) AS total_seconds
    FROM
        location_areas
    WHERE
        end_time IS NOT NULL -- Exclude the last location as it has no duration
    GROUP BY
        area
)
SELECT
    area,
    ROUND(total_seconds, 2) as total_seconds,
    ROUND((total_seconds / 3600), 2) AS total_hours
FROM
    area_durations
ORDER BY
    total_seconds DESC;

