-- SKills: CTE, Window Functions

WITH elfs_ranked AS (
    SELECT 
        elf_id, 
        primary_skill, 
        years_experience, 
        COUNT(*) OVER (PARTITION BY elf_id, primary_skill ORDER BY years_experience DESC) AS prime_increment,
        COUNT(*) OVER (PARTITION BY elf_id, primary_skill ORDER BY years_experience ASC) AS sec_increment 
    FROM workshop_elves
),
min_max AS (
    SELECT
        primary_skill,
        MIN(years_experience) AS min_exp,
        MAX(years_experience) AS max_exp
    FROM workshop_elves 
    GROUP BY primary_skill
),
paired_ids AS (
    SELECT DISTINCT ON (m.primary_skill)
        m.primary_skill,
        min_table.elf_id AS elf_id_2,
        max_table.elf_id AS elf_id_1,
        m.min_exp,
        m.max_exp
    FROM
        min_max m
    JOIN
        workshop_elves min_table
    ON
        min_table.primary_skill = m.primary_skill AND min_table.years_experience = m.min_exp
    JOIN
        workshop_elves max_table
    ON
        max_table.primary_skill = m.primary_skill AND max_table.years_experience = m.max_exp
    ORDER BY
        m.primary_skill, min_table.elf_id, max_table.elf_id
),
final_out_put AS (
    SELECT
        elf_id_1,
        elf_id_2,
        primary_skill
    FROM
        paired_ids
    ORDER BY
        primary_skill
)
SELECT * FROM final_out_put
-- SELECT 
--     string_agg(elf_id_1::text, ',') AS elf_id_1_values,
--     string_agg(elf_id_2::text, ',') AS elf_id_2_values,
--     string_agg(primary_skill::text, ',') AS primary_skill_values
-- FROM final_out_put;




-- -- Works with unique Min/Max but with multiple failes
-- WITH workshop_elves_grouped AS (SELECT 
--     elf_id, 
--     primary_skill, 
--     years_experience, 
--     COUNT(*) OVER (PARTITION BY elf_id, primary_skill ORDER BY years_experience DESC) AS prime_increment,
--     COUNT(*) OVER (PARTITION BY elf_id, primary_skill ORDER BY years_experience ASC) AS sec_increment 
-- FROM workshop_elves
-- ORDER BY primary_skill, years_experience DESC),
-- primary_elfs as (SELECT elf_id, primary_skill FROM workshop_elves_grouped WHERE prime_increment = 1),
-- secondary_elfs as (SELECT elf_id, primary_skill FROM workshop_elves_grouped WHERE sec_increment = 1)
-- SELECT p.elf_id AS elf_1_id, s.elf_id AS elf_2_id, p.primary_skill FROM primary_elfs p
-- LEFT JOIN secondary_elfs s ON s.primary_skill = p.primary_skill;