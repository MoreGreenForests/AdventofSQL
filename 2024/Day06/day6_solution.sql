-- SKills: Subquery, Aggregates

WITH children_gifts AS (
SELECT 
    c.name as child_name, 
    g.name as gift_name, 
    g.price as gift_price
FROM children c
LEFT JOIN gifts g ON g.child_id = c.child_id
GROUP BY c.name, g.name, g.price
ORDER BY g.price DESC
),
gift_avg AS (
    SELECT AVG(price) as average_price FROM gifts
    )
SELECT 
    child_name, 
    gift_name, 
    gift_price 
FROM children_gifts
WHERE gift_price > (SELECT average_price from gift_avg)
ORDER by gift_price;

--Simpler solution 
-- SELECT
--     children.name
-- FROM children
-- LEFT JOIN gifts ON gifts.child_id = children.child_id
-- WHERE price > (SELECT AVG(price) FROM gifts)
-- ORDER BY price
-- LIMIT 1;