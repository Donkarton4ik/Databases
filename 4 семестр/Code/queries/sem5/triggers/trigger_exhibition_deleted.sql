-- удаление выставки -> у всех ее кураторов пропадает эта выставка из счета
-- поэтому пересчитываем их строки (или удаляем строку, если это была последняя выставка)
CREATE OR REPLACE FUNCTION trg_exhibition_deleted()
RETURNS TRIGGER AS $$
DECLARE
    affected_employees INT[];
BEGIN
    --запоминаем ID всех кураторов этой выставки
    SELECT ARRAY_AGG(DISTINCT employee_id)
    INTO affected_employees
    FROM exhibition_curators
    WHERE exhibition_id = OLD.exhibition_id;

    --несмотря на ON DELETE CASCADE, чистим сами: триггер BEFORE DELETE, а каскад
    --выполнится только после него - без этой строки пересчёт ниже увидит устаревшие связи
    DELETE FROM exhibition_curators WHERE exhibition_id = OLD.exhibition_id;

    IF affected_employees IS NOT NULL THEN
        --удаляем старую статистику для затронутых кураторов
        DELETE FROM employee_curation_stats_table
        WHERE employee_id = ANY(affected_employees);

        --вставляем обновленные данные
        INSERT INTO employee_curation_stats_table
            (employee_id, first_name, last_name, curated_exhibitions_count, curated_exhibition_types_count)
        SELECT
            employees.employee_id,
            employees.first_name,
            employees.last_name,
            COUNT(exhibition_curators.exhibition_id),
            COUNT(DISTINCT exhibitions.exhibition_type_id)
        FROM employees
            INNER JOIN exhibition_curators ON exhibition_curators.employee_id = employees.employee_id
            INNER JOIN exhibitions ON exhibitions.exhibition_id = exhibition_curators.exhibition_id
        WHERE employees.employee_id = ANY(affected_employees)
        GROUP BY employees.employee_id, employees.first_name, employees.last_name;
    END IF;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER exhibition_deleted
    BEFORE DELETE ON exhibitions
    FOR EACH ROW
    EXECUTE FUNCTION trg_exhibition_deleted();
