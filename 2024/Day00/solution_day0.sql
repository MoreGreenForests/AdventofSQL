WITH DELIVERED_GIFTS AS (SELECT c.child_id, c.city, c.country, c.naughty_nice_score FROM Children as c
                        LEFT JOIN christmaslist as cl on c.child_id = cl.child_id
                        WHERE cl.was_delivered is True),
SIGNIFICANT_CITIES AS (SELECT count(child_id) as child_count, 
                                city, 
                                country, 
                                avg(naughty_nice_score) as nice_avg
                                FROM DELIVERED_GIFTS
                                GROUP BY city, country
                                ORDER BY nice_avg DESC),
ORDERED_CITIES AS ( SELECT *, ROW_NUMBER() OVER (PARTITION BY country ORDER BY nice_avg DESC) AS row_num
                    FROM SIGNIFICANT_CITIES)

SELECT child_count, city, country, nice_avg, row_num
FROM ORDERED_CITIES
WHERE child_count >= 5
AND row_num <=3
ORDER BY nice_avg DESC;