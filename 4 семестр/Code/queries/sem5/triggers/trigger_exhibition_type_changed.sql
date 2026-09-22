-- изменение типа выставки -> меняется число уникальных типов
-- среди курируемых выставок у всех её кураторов, нужно пересчитать
CREATE OR REPLACE FUNCTION trg_exhibition_type_changed()
RETURNS TRIGGER AS $$
DECLARE
    curator RECORD;
BEGIN
    FOR curator IN
        SELECT DISTINCT employee_id
        FROM exhibition_curators
        WHERE exhibition_id = NEW.exhibition_id
    LOOP
        DELETE FROM employee_curation_stats_table WHERE employee_id = curator.employee_id;

        INSERT INTO employee_curation_stats_table
            (employee_id, first_name, last_name, curated_exhibitions_count, curated_exhibition_types_count)
        SELECT
            employees.employee_id, employees.first_name, employees.last_name,
            COUNT(exhibition_curators.exhibition_id),
            COUNT(DISTINCT exhibitions.exhibition_type_id)
        FROM employees
            INNER JOIN exhibition_curators ON exhibition_curators.employee_id = employees.employee_id
            INNER JOIN exhibitions ON exhibitions.exhibition_id = exhibition_curators.exhibition_id
        WHERE employees.employee_id = curator.employee_id
        GROUP BY employees.employee_id, employees.first_name, employees.last_name;
    END LOOP;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER exhibition_type_changed
    AFTER UPDATE OF exhibition_type_id ON exhibitions
    FOR EACH ROW
    EXECUTE FUNCTION trg_exhibition_type_changed();
