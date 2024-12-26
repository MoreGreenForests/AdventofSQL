-- SKills: array filter, cte, string to array

WITH elf_skills AS (
    SELECT elf_name,
    string_to_array(skills, ',') as skills_array
    FROM elves
),
elf_sql_filter AS (
    SELECT * FROM elf_skills
    WHERE 'SQL'=ANY(skills_array)
)
SELECT COUNT(*) FROM elf_sql_filter;
