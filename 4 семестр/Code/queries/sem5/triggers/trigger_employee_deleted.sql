-- удаление сотрудника -> убираем его строку из таблицы
CREATE OR REPLACE FUNCTION trg_employee_deleted()
RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM employee_curation_stats_table WHERE employee_id = OLD.employee_id;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER employee_deleted
    AFTER DELETE ON employees
    FOR EACH ROW
    EXECUTE FUNCTION trg_employee_deleted();
