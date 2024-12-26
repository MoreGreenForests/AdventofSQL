-- SKills: CTE,count


WITH user_play_info AS (
    SELECT s.song_title,
            us.*,
            s.song_duration,
    CASE 
        WHEN us.duration < s.song_duration THEN 1
        WHEN us.duration IS NULL THEN 1
        ELSE 0
    END AS song_skips
 FROM user_plays us
 LEFT JOIN songs s ON s.song_id = us.song_id
)
SELECT song_title, 
        count(play_id) as total_plays,
        SUM(song_skips) as total_skips
FROM user_play_info
GROUP BY song_title
ORDER BY total_plays DESC, total_skips ASC;
