-- 1. SELECT из новой таблицы (оба: таблица)
SELECT * FROM employee_curation_stats_table LIMIT 3;

-- 2. INSERT в новую таблицу, тестовый id 999999 (оба: permission denied)
INSERT INTO employee_curation_stats_table
    (employee_id, first_name, last_name, curated_exhibitions_count, curated_exhibition_types_count)
VALUES (999999, 'Гвинея', 'Пиг', 1, 1);

-- 3. UPDATE новой таблицы, условие на несуществующий id (оба: permission denied)
UPDATE employee_curation_stats_table SET curated_exhibitions_count = 100 WHERE employee_id = 999999;

-- 4. DELETE из новой таблицы, условие на несуществующий id (оба: permission denied)
DELETE FROM employee_curation_stats_table WHERE employee_id = 999999;

-- 5. SELECT из исходной таблицы employees (guinea_pig: permission denied, ex_curator: таблица)
SELECT * FROM employees LIMIT 3;

-- 6. INSERT тестового сотрудника ТестИмя ТестФамилия (guinea_pig: permission denied, ex_curator: INSERT 0 1)
INSERT INTO employees (first_name, last_name) VALUES ('ТестИмя', 'ТестФамилия');

-- 7. UPDATE имени тестового сотрудника на ТестИмя2
--    (guinea_pig: permission denied, ex_curator: UPDATE 1)
UPDATE employees SET first_name = 'ТестИмя2' WHERE last_name = 'ТестФамилия';

-- 8. DELETE тестового сотрудника
--    (guinea_pig: permission denied, ex_curator: DELETE 1)
DELETE FROM employees WHERE last_name = 'ТестФамилия';

-- 9. SELECT из постороннего объекта passports (оба: permission denied)
SELECT * FROM passports LIMIT 3;

-- 10. DELETE из постороннего объекта passports, условие на несуществующий id (оба: permission denied)
DELETE FROM passports WHERE passport_id = -1;
