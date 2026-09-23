-- удаление факта кураторства выставки
CREATE OR REPLACE FUNCTION trg_curator_removed()
RETURNS TRIGGER AS $$
BEGIN
    -- обновляем счётчики, если у сотрудника остались другие выставки
    UPDATE employee_curation_stats_table
    SET curated_exhibitions_count = affected_with_counts.exhibitions_count,
        curated_exhibition_types_count = affected_with_counts.types_count
    FROM (
        SELECT
            exhibition_curators.employee_id,
            COUNT(exhibition_curators.exhibition_id) AS exhibitions_count,
            COUNT(DISTINCT exhibitions.exhibition_type_id) AS types_count
        FROM exhibition_curators
            INNER JOIN exhibitions ON exhibitions.exhibition_id = exhibition_curators.exhibition_id
        WHERE exhibition_curators.employee_id = OLD.employee_id
        GROUP BY exhibition_curators.employee_id
    ) AS affected_with_counts
    WHERE employee_curation_stats_table.employee_id = affected_with_counts.employee_id;

    -- курировать больше нечего - убираем строку
    DELETE FROM employee_curation_stats_table
    WHERE employee_id = OLD.employee_id AND (SELECT COUNT(*) FROM exhibition_curators WHERE employee_id = OLD.employee_id) = 0;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER curator_removed
    AFTER DELETE ON exhibition_curators
    FOR EACH ROW
    EXECUTE FUNCTION trg_curator_removed();
