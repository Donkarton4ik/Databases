-- удаление выставки -> у всех ее кураторов пропадает эта выставка из счета
-- поэтому пересчитываем их строки (или удаляем строку, если это была последняя выставка)
CREATE OR REPLACE FUNCTION trg_exhibition_deleted()
RETURNS TRIGGER AS $$
DECLARE
    affected_employees INT[];
BEGIN
    -- запоминаем ID всех кураторов этой выставки, пока связи ещё не удалены
    SELECT ARRAY_AGG(DISTINCT employee_id)
    INTO affected_employees
    FROM exhibition_curators
    WHERE exhibition_id = OLD.exhibition_id;

    -- несмотря на ON DELETE CASCADE, чистим сами: триггер BEFORE DELETE, а каскад
    -- выполнится только после него - без этой строки пересчёт ниже увидит устаревшие связи
    DELETE FROM exhibition_curators WHERE exhibition_id = OLD.exhibition_id;

    -- одним UPDATE пересчитываем всех задетых сотрудников, у которых остались другие выставки
    UPDATE employee_curation_stats_table
    SET curated_exhibitions_count = affected_with_counts.exhibitions_count,
        curated_exhibition_types_count = affected_with_counts.types_count
    -- подзапросом находим задетых сотрудников 
    FROM (
        SELECT
            exhibition_curators.employee_id,
            COUNT(exhibition_curators.exhibition_id) AS exhibitions_count,
            COUNT(DISTINCT exhibitions.exhibition_type_id) AS types_count
        FROM exhibition_curators
            INNER JOIN exhibitions ON exhibitions.exhibition_id = exhibition_curators.exhibition_id
        WHERE exhibition_curators.employee_id = ANY(affected_employees)
        GROUP BY exhibition_curators.employee_id
    ) AS affected_with_counts
    WHERE employee_curation_stats_table.employee_id = affected_with_counts.employee_id;

    -- DELETE убираем строки тех, у кого выставок больше не осталось
    DELETE FROM employee_curation_stats_table
    WHERE employee_id = ANY(affected_employees) AND employee_id NOT IN (SELECT employee_id FROM exhibition_curators);

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER exhibition_deleted
    BEFORE DELETE ON exhibitions
    FOR EACH ROW
    EXECUTE FUNCTION trg_exhibition_deleted();
