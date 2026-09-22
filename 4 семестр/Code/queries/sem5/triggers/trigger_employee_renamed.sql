-- изменение сотрудника (имя/фамилия) -> синхронизируем в таблице
-- счётчики не пересчитываем - смена имени на них не влияет
CREATE OR REPLACE FUNCTION trg_employee_renamed()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE employee_curation_stats_table
    SET first_name = NEW.first_name,
        last_name = NEW.last_name
    WHERE employee_id = NEW.employee_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER employee_renamed
    AFTER UPDATE OF first_name, last_name ON employees
    FOR EACH ROW
    EXECUTE FUNCTION trg_employee_renamed();
