-- Данные для заполнения q9.sql:
--   А = employee_last_name
--   Б = current_condition_name
--   В = одно из значений possible_new_conditions

-- SELECT
--     passports.passport_id,
--     employees.last_name AS employee_last_name,
--     employees.first_name AS employee_first_name,
--     employees.middle_name AS employee_middle_name,
--     exhibits.exhibit_name,
--     exhibit_conditions.exhibit_conditions_name AS current_condition_name,
--     (
--         SELECT string_agg(new_conditions.exhibit_conditions_name, ', ' ORDER BY new_conditions.exhibit_conditions_id)
--         FROM exhibit_conditions AS new_conditions
--     ) AS possible_new_conditions
-- FROM
--     passports
--     JOIN employees
--         ON passports.employee_id = employees.employee_id
--     JOIN exhibits
--         ON passports.exhibit_id = exhibits.exhibit_id
--     JOIN exhibit_conditions
--         ON passports.condition_id = exhibit_conditions.exhibit_conditions_id
-- ORDER BY
--     employees.last_name,
--     employees.first_name,
--     passports.passport_id;


SELECT 
    COALESCE(table_name, '--- ВСЕГО ЗАПИСЕЙ В БД ---') AS "Таблица",
    SUM(row_count) AS "Количество записей"
FROM (
    SELECT 
        relname AS table_name,
        n_live_tup AS row_count
    FROM 
        pg_stat_user_tables
    WHERE 
        schemaname = 'public'
) table_stats
GROUP BY 
    ROLLUP(table_name)
ORDER BY 
    (table_name = '--- ВСЕГО ЗАПИСЕЙ В БД ---') ASC, -- Гарантирует, что итог будет в самом внизу
    "Количество записей" DESC;