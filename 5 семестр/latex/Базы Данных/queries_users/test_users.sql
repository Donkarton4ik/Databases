-- 1. SELECT из новой таблицы (оба: таблица)
SELECT * FROM employee_curation_stats_table LIMIT 3;

-- 2. INSERT в новую таблицу, тестовый id 999999 (оба: permission denied)
INSERT INTO employee_curation_stats_table
    (employee_id, first_name, last_name, curated_exhibitions_count, curated_exhibition_types_count)
VALUES (999999, 'ТестИмя', 'ТестФамилия', 1, 1);
-- проверка: строки с id 999999 нет (оба: 0 rows)
SELECT * FROM employee_curation_stats_table WHERE employee_id = 999999;

-- 3. UPDATE новой таблицы, условие на несуществующий id (оба: permission denied)
UPDATE employee_curation_stats_table SET curated_exhibitions_count = 100 WHERE employee_id = 999999;
-- проверка: значения 100 в таблице нет (оба: 0 rows)
SELECT * FROM employee_curation_stats_table WHERE curated_exhibitions_count = 100;

-- 4. DELETE существующей строки из новой таблицы (оба: permission denied)
DELETE FROM employee_curation_stats_table WHERE employee_id = 1;
-- проверка: строка с id 1 на месте (оба: 1 row)
SELECT * FROM employee_curation_stats_table WHERE employee_id = 1;

-- 5. INSERT тестового сотрудника ТестИмя ТестФамилия (guinea_pig: permission denied, ex_curator: INSERT 0 1)
INSERT INTO employees (first_name, last_name) VALUES ('ТестИмя', 'ТестФамилия');
-- проверка: сотрудник появился (ex_curator: 1 row; guinea_pig: permission denied, прав на employees у него нет)
SELECT * FROM employees WHERE last_name = 'ТестФамилия';

-- 6. UPDATE имени тестового сотрудника на ТестИмя2
--    (guinea_pig: permission denied, ex_curator: UPDATE 1)
UPDATE employees SET first_name = 'ТестИмя2' WHERE last_name = 'ТестФамилия';
-- проверка: имя изменилось на ТестИмя2 (ex_curator: 1 row; guinea_pig: permission denied)
SELECT * FROM employees WHERE last_name = 'ТестФамилия';

-- 7. DELETE тестового сотрудника
--    (guinea_pig: permission denied, ex_curator: DELETE 1)
DELETE FROM employees WHERE last_name = 'ТестФамилия';
-- проверка: сотрудника больше нет (ex_curator: 0 rows; guinea_pig: permission denied)
SELECT * FROM employees WHERE last_name = 'ТестФамилия';

-- 8. SELECT из постороннего объекта passports (оба: permission denied)
SELECT * FROM passports LIMIT 3;

-- 9. DELETE из постороннего объекта passports (оба: permission denied)
DELETE FROM passports WHERE passport_id = 3;
-- проверка: чтение passports запрещено обоим, подтвердить удаление/неудаление можно только от postgres
SELECT * FROM passports WHERE passport_id = 3;
