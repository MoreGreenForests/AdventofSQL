-- SKills: CTE, Timezones

SELECT 
    w.workshop_id,
    w.workshop_name,
    w.timezone,
    w.business_start_time,
    w.business_end_time,
    w.business_start_time - pgt.utc_offset AS utc_start_time,
    w.business_end_time - pgt.utc_offset AS utc_end_time
FROM 
    workshops w
LEFT JOIN 
    pg_timezone_names pgt ON w.timezone = pgt.name
ORDER BY 
    w.workshop_id;



WITH RECURSIVE time_windows AS (
    -- Generate 30-minute intervals from 00:00 to 23:30
    SELECT '00:00:00'::time AS time_window
    UNION ALL
    SELECT time_window + INTERVAL '30 minutes'
    FROM time_windows
    WHERE time_window < '23:30:00'::time
),
workshop_hours AS (
    -- Adjust workshop business hours to UTC
    SELECT 
        w.workshop_id,
        w.workshop_name,
        w.business_start_time - pgt.utc_offset AS utc_start_time,
        w.business_end_time - pgt.utc_offset AS utc_end_time
    FROM 
        workshops w
    LEFT JOIN 
        pg_timezone_names pgt ON w.timezone = pgt.name
),
availability AS (
    SELECT
        tw.time_window,
        COUNT(CASE 
            WHEN tw.time_window BETWEEN wh.utc_start_time::time AND (wh.utc_end_time - INTERVAL '1 hour')::time
            THEN 1 END) AS available_workshops,
        ARRAY_AGG(CASE 
            WHEN tw.time_window NOT BETWEEN wh.utc_start_time::time AND (wh.utc_end_time - INTERVAL '1 hour')::time
            THEN wh.workshop_name END) FILTER (WHERE 
            tw.time_window NOT BETWEEN wh.utc_start_time::time AND (wh.utc_end_time - INTERVAL '1 hour')::time) AS unavailable_workshops
    FROM 
        time_windows tw
    CROSS JOIN
        workshop_hours wh
    GROUP BY 
        tw.time_window
)
SELECT 
    time_window,
    available_workshops,
    unavailable_workshops
FROM 
    availability
ORDER BY 
    available_workshops DESC, time_window ASC;
