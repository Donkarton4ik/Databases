-- Проверка всех 6 триггеров синхронизации employee_curation_stats_table.
-- Всё делается на временных тестовых записях (сотрудник + 2 выставки),
-- реальные данные не затрагиваются, в конце всё за собой удаляется.
-- Для каждого триггера показано состояние ДО и ПОСЛЕ действия, которое его вызывает.
--
-- Запуск: psql -U postgres -d museum_db -f test_triggers.sql
-- (или \i test_triggers.sql внутри уже открытой psql-сессии)

-- ===== Подготовка: временный сотрудник, два типа выставок и две тестовые выставки =====
-- обеим выставкам сразу задаём реальный тип - у реальных выставок exhibition_type_id
-- всегда заполнен, поэтому curated_exhibition_types_count не может быть 0,
-- если curated_exhibitions_count >= 1
SELECT exhibition_type_id FROM exhibition_type ORDER BY exhibition_type_id LIMIT 1 \gset type1_
SELECT exhibition_type_id FROM exhibition_type WHERE exhibition_type_id <> :type1_exhibition_type_id ORDER BY exhibition_type_id LIMIT 1 \gset type2_

INSERT INTO employees (first_name, last_name) VALUES ('ТестИмя', 'ТестФамилия') RETURNING employee_id \gset test_
INSERT INTO exhibitions (exhibition_name, exhibition_type_id) VALUES ('ТЕСТ_ВЫСТАВКА_A', :type1_exhibition_type_id) RETURNING exhibition_id \gset exh_a_
INSERT INTO exhibitions (exhibition_name, exhibition_type_id) VALUES ('ТЕСТ_ВЫСТАВКА_B', :type1_exhibition_type_id) RETURNING exhibition_id \gset exh_b_

\echo '=== ТЕСТ 1: добавление факта кураторства (INSERT exhibition_curators) ==='
\echo '--- ДО: сотрудник ещё ничего не курирует, строки по нему нет ---'
SELECT * FROM employee_curation_stats_table WHERE employee_id = :test_employee_id;

INSERT INTO exhibition_curators (employee_id, exhibition_id) VALUES (:test_employee_id, :exh_a_exhibition_id);

\echo '--- ПОСЛЕ: появилась строка, curated_exhibitions_count = 1, curated_exhibition_types_count = 1 ---'
SELECT * FROM employee_curation_stats_table WHERE employee_id = :test_employee_id;

\echo '=== добавляем вторую выставку (тот же тип) для дальнейших тестов ==='
INSERT INTO exhibition_curators (employee_id, exhibition_id) VALUES (:test_employee_id, :exh_b_exhibition_id);
-- ожидание: curated_exhibitions_count = 2, curated_exhibition_types_count по-прежнему 1 (тип общий)
SELECT * FROM employee_curation_stats_table WHERE employee_id = :test_employee_id;

\echo '=== ТЕСТ 2: удаление факта кураторства (DELETE exhibition_curators) ==='
\echo '--- ДО: у сотрудника 2 курируемые выставки ---'
SELECT * FROM employee_curation_stats_table WHERE employee_id = :test_employee_id;

DELETE FROM exhibition_curators WHERE employee_id = :test_employee_id AND exhibition_id = :exh_a_exhibition_id;

\echo '--- ПОСЛЕ: curated_exhibitions_count вернулся к 1 (осталась только B) ---'
SELECT * FROM employee_curation_stats_table WHERE employee_id = :test_employee_id;

\echo '=== возвращаем выставку A для дальнейших тестов ==='
INSERT INTO exhibition_curators (employee_id, exhibition_id) VALUES (:test_employee_id, :exh_a_exhibition_id);

\echo '=== ТЕСТ 3: изменение типа выставки (UPDATE exhibitions.exhibition_type_id) ==='
\echo '--- ДО: A и B одного типа, curated_exhibition_types_count = 1 ---'
SELECT * FROM employee_curation_stats_table WHERE employee_id = :test_employee_id;

UPDATE exhibitions SET exhibition_type_id = :type2_exhibition_type_id WHERE exhibition_id = :exh_a_exhibition_id;

\echo '--- ПОСЛЕ: у A теперь другой тип, curated_exhibition_types_count = 2 ---'
SELECT * FROM employee_curation_stats_table WHERE employee_id = :test_employee_id;

\echo '=== ТЕСТ 4: изменение сотрудника (UPDATE employees, смена имени) ==='
\echo '--- ДО: сотрудника зовут ТестИмя ТестФамилия ---'
SELECT * FROM employee_curation_stats_table WHERE employee_id = :test_employee_id;

UPDATE employees SET first_name = 'ТестИмяПереименован' WHERE employee_id = :test_employee_id;

\echo '--- ПОСЛЕ: first_name синхронизировался, счётчики не изменились ---'
SELECT * FROM employee_curation_stats_table WHERE employee_id = :test_employee_id;

\echo '=== ТЕСТ 5: удаление выставки (DELETE exhibitions) ==='
\echo '--- ДО: у сотрудника 2 курируемые выставки (A и B) ---'
SELECT * FROM employee_curation_stats_table WHERE employee_id = :test_employee_id;

DELETE FROM exhibitions WHERE exhibition_id = :exh_a_exhibition_id;

\echo '--- ПОСЛЕ: curated_exhibitions_count = 1 (осталась только B) ---'
SELECT * FROM employee_curation_stats_table WHERE employee_id = :test_employee_id;
-- ожидание: 0 - связь с A триггер сам убрал из exhibition_curators
SELECT count(*) AS should_be_zero_a_link FROM exhibition_curators WHERE employee_id = :test_employee_id AND exhibition_id = :exh_a_exhibition_id;

\echo '=== ТЕСТ 6: удаление сотрудника (DELETE employees) ==='
-- exhibition_curators.employee_id теперь ON DELETE CASCADE, поэтому предварительно
-- чистить связи вручную не нужно - Postgres уберёт их сам вместе с сотрудником
\echo '--- ДО: у сотрудника есть курируемая выставка, строка в таблице присутствует ---'
SELECT * FROM employee_curation_stats_table WHERE employee_id = :test_employee_id;

DELETE FROM employees WHERE employee_id = :test_employee_id;

\echo '--- ПОСЛЕ: строки по сотруднику в таблице больше нет ---'
SELECT count(*) AS should_be_zero_table FROM employee_curation_stats_table WHERE employee_id = :test_employee_id;

\echo '=== Тесты завершены, тестовые данные за собой убраны ==='
