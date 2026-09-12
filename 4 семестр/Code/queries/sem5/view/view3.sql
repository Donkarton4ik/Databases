SELECT
    passports.passport_id,
    employee_curation_stats.first_name,
    employee_curation_stats.last_name,
    employee_curation_stats.curated_exhibitions_count
    FROM
        passports

        INNER JOIN employee_curation_stats
            ON employee_curation_stats.employee_id = passports.employee_id

    WHERE
        employee_curation_stats.curated_exhibitions_count >= 2;
