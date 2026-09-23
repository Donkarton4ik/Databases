-- изменение типа выставки -> меняется число уникальных типов
-- среди курируемых выставок у всех её кураторов, нужно пересчитать
CREATE OR REPLACE FUNCTION trg_exhibition_type_changed()
RETURNS TRIGGER AS $$
BEGIN
    -- одним UPDATE пересчитываем сразу всех кураторов этой выставки, без цикла;
    -- своя выставка у них никуда не делась, поэтому агрегат точно не пуст
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
        WHERE exhibition_curators.employee_id IN (
            SELECT employee_id FROM exhibition_curators WHERE exhibition_id = NEW.exhibition_id
        )
        GROUP BY exhibition_curators.employee_id
    ) AS affected_with_counts
    WHERE employee_curation_stats_table.employee_id = affected_with_counts.employee_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER exhibition_type_changed
    AFTER UPDATE OF exhibition_type_id ON exhibitions
    FOR EACH ROW
    EXECUTE FUNCTION trg_exhibition_type_changed();
