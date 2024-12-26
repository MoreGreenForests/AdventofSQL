-- SKills: array functions, json functions

WITH expanded_json AS (
    SELECT 
        jsonb_array_elements(cleaning_receipts) AS item
    FROM 
        SantaRecords
)
SELECT 
    item->>'color' AS color,
    item->>'pickup' AS pickup_date,
    item->>'drop_off' AS drop_off_date,
    item->>'garment' AS garment,
    item->>'receipt_id' AS receipt_id
FROM 
    expanded_json
WHERE 
    item->>'color' = 'green'
    AND item->>'garment' = 'suit'
ORDER BY 
    item->>'drop_off' DESC;
