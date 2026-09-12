SELECT
    employee_curation_stats.first_name,
    employee_curation_stats.last_name,
    employee_curation_stats.curated_exhibitions_count,
    employee_curation_stats.curated_exhibition_types_count
    FROM
        employee_curation_stats
    WHERE
        employee_curation_stats.curated_exhibitions_count > 3
        AND employee_curation_stats.curated_exhibition_types_count > 1;
