-- SKills: Geometry

--select * FROM sleigh_locations;
-- select * FROM areas;

SELECT
    sl.timestamp,
    sl.coordinate,
    a.place_name AS area
FROM
    sleigh_locations sl
LEFT JOIN
    areas a
ON
    ST_DWithin(a.polygon::geography, sl.coordinate, 0)
WHERE sl.timestamp = '2024-12-24 22:00:00+00';