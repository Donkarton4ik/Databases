-- добавление факта кураторства выставки
CREATE OR REPLACE FUNCTION trg_curator_added()
RETURNS TRIGGER AS $$
BEGIN
    -- удаляем старую строку из таблички, чтобы вставить обновлённую
    DELETE FROM employee_curation_stats_table WHERE employee_id = NEW.employee_id;

    INSERT INTO employee_curation_stats_table
        (employee_id, first_name, last_name, curated_exhibitions_count, curated_exhibition_types_count)
    SELECT
        employees.employee_id, employees.first_name, employees.last_name,
        COUNT(exhibition_curators.exhibition_id),
        COUNT(DISTINCT exhibitions.exhibition_type_id)
    FROM employees
        INNER JOIN exhibition_curators ON exhibition_curators.employee_id = employees.employee_id
        INNER JOIN exhibitions ON exhibitions.exhibition_id = exhibition_curators.exhibition_id
    WHERE employees.employee_id = NEW.employee_id
    GROUP BY employees.employee_id, employees.first_name, employees.last_name;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER curator_added
    AFTER INSERT ON exhibition_curators
    FOR EACH ROW
    EXECUTE FUNCTION trg_curator_added();
