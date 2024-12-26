-- SKills: Precent_Rank, Window Function

SELECT 
    g.gift_name,
    PERCENT_RANK() OVER (ORDER BY COUNT(gr.gift_id)) AS overall_rank
FROM gift_requests gr
LEFT JOIN gifts g ON g.gift_id = gr.gift_id
GROUP BY g.gift_name, gr.gift_id
ORDER BY overall_rank DESC, g.gift_name ASC
