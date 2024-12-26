-- Skills: UNION, CTE, ASCII, STRING AGG

-- should use where "value" between ascii('a') and ascii('z')
-- and chr("value") in (' ', '!', ',', '.')

WITH decoded_list AS (SELECT id, CHR(value) as letter_value FROM letters_a 
                        UNION ALL 
                        SELECT id, CHR(value) as letter_value FROM letters_b)
SELECT STRING_AGG(letter_value, '') as decoded_output FROM decoded_list
WHERE letter_value not in ('$', '#', '@', '*', '%', '&', '{', '}', '_', '+', '=', '^', '\', '/', '[', ']', '|', '<', '>', '~', '`')