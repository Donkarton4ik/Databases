CREATE TABLE employee_curation_stats_table AS
SELECT
    employees.employee_id,
    employees.first_name,
    employees.last_name,
    COUNT (exhibition_curators.exhibition_id) AS curated_exhibitions_count,
    COUNT(DISTINCT exhibitions.exhibition_type_id) AS curated_exhibition_types_count

    FROM
        employees

        INNER JOIN exhibition_curators
            ON exhibition_curators.employee_id = employees.employee_id
        INNER JOIN exhibitions
            ON exhibitions.exhibition_id = exhibition_curators.exhibition_id

    GROUP BY
        employees.employee_id,
        employees.first_name,
        employees.last_name;
