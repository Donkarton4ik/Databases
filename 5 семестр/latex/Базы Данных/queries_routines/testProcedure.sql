SELECT last_name AS "Имя", first_name AS "Фамилия", middle_name AS "Отчество",
       employee_initials(last_name, first_name, middle_name) AS "ФИО"
FROM employees;

BEGIN;

------------------------------------------------------------------------
-- 1. Нет сотрудника, выставки и типа выставки
------------------------------------------------------------------------

-- До вызова -----------------------------------------------------------
SELECT *
FROM employee_curation_stats_table
WHERE last_name = 'Тестов' AND first_name = 'Тест';

SELECT employee_id, last_name, first_name, middle_name
FROM employees
WHERE last_name = 'Тестов' AND first_name = 'Тест'
  AND middle_name = 'Тестович';

SELECT exhibition_id, exhibition_name, exhibition_type_id
FROM exhibitions
WHERE exhibition_name = 'ЛР5 Выставка А' AND exhibition_type_id = (SELECT exhibition_type_id FROM exhibition_type WHERE exhibition_type_name = 'ЛР5 Тип А');

CALL assign_exhibition_curator('Тестов', 'Тест', 'Тестович', 'ЛР5 Выставка А', 'ЛР5 Тип А');

-- После вызова --------------------------------------------------------
SELECT *
FROM employee_curation_stats_table
WHERE last_name = 'Тестов' AND first_name = 'Тест';

SELECT employee_id, last_name, first_name, middle_name
FROM employees
WHERE last_name = 'Тестов' AND first_name = 'Тест'
  AND middle_name = 'Тестович';

SELECT exhibition_id, exhibition_name, exhibition_type_id
FROM exhibitions
WHERE exhibition_name = 'ЛР5 Выставка А' AND exhibition_type_id = (SELECT exhibition_type_id FROM exhibition_type WHERE exhibition_type_name = 'ЛР5 Тип А');

------------------------------------------------------------------------
-- 2. Повтор того же назначения
------------------------------------------------------------------------

-- До вызова -----------------------------------------------------------
SELECT *
FROM employee_curation_stats_table
WHERE last_name = 'Тестов' AND first_name = 'Тест';

SELECT employee_id, last_name, first_name, middle_name
FROM employees
WHERE last_name = 'Тестов' AND first_name = 'Тест'
  AND middle_name = 'Тестович';

SELECT exhibition_id, exhibition_name, exhibition_type_id
FROM exhibitions
WHERE exhibition_name = 'ЛР5 Выставка А' AND exhibition_type_id = (SELECT exhibition_type_id FROM exhibition_type WHERE exhibition_type_name = 'ЛР5 Тип А');

CALL assign_exhibition_curator('Тестов', 'Тест', 'Тестович', 'ЛР5 Выставка А', 'ЛР5 Тип А');

-- После вызова --------------------------------------------------------
SELECT *
FROM employee_curation_stats_table
WHERE last_name = 'Тестов' AND first_name = 'Тест';

SELECT employee_id, last_name, first_name, middle_name
FROM employees
WHERE last_name = 'Тестов' AND first_name = 'Тест'
  AND middle_name = 'Тестович';

SELECT exhibition_id, exhibition_name, exhibition_type_id
FROM exhibitions
WHERE exhibition_name = 'ЛР5 Выставка А' AND exhibition_type_id = (SELECT exhibition_type_id FROM exhibition_type WHERE exhibition_type_name = 'ЛР5 Тип А');

------------------------------------------------------------------------
-- 3. Выставка есть, сотрудника нет
------------------------------------------------------------------------

-- До вызова -----------------------------------------------------------
SELECT *
FROM employee_curation_stats_table
WHERE last_name = 'Тестов' AND first_name = 'Павел';

SELECT employee_id, last_name, first_name, middle_name
FROM employees
WHERE last_name = 'Тестов' AND first_name = 'Павел'
  AND middle_name = 'Павлович';

SELECT exhibition_id, exhibition_name, exhibition_type_id
FROM exhibitions
WHERE exhibition_name = 'ЛР5 Выставка А' AND exhibition_type_id = (SELECT exhibition_type_id FROM exhibition_type WHERE exhibition_type_name = 'ЛР5 Тип А');

CALL assign_exhibition_curator('Тестов', 'Павел', 'Павлович', 'ЛР5 Выставка А', 'ЛР5 Тип А');

-- После вызова --------------------------------------------------------
SELECT *
FROM employee_curation_stats_table
WHERE last_name = 'Тестов' AND first_name = 'Павел';

SELECT employee_id, last_name, first_name, middle_name
FROM employees
WHERE last_name = 'Тестов' AND first_name = 'Павел'
  AND middle_name = 'Павлович';

SELECT exhibition_id, exhibition_name, exhibition_type_id
FROM exhibitions
WHERE exhibition_name = 'ЛР5 Выставка А' AND exhibition_type_id = (SELECT exhibition_type_id FROM exhibition_type WHERE exhibition_type_name = 'ЛР5 Тип А');

------------------------------------------------------------------------
-- 4. Сотрудник есть, выставки и ее типа нет
------------------------------------------------------------------------

-- До вызова -----------------------------------------------------------
SELECT *
FROM employee_curation_stats_table
WHERE last_name = 'Тестов' AND first_name = 'Тест';

SELECT employee_id, last_name, first_name, middle_name
FROM employees
WHERE last_name = 'Тестов' AND first_name = 'Тест'
  AND middle_name = 'Тестович';

SELECT exhibition_id, exhibition_name, exhibition_type_id
FROM exhibitions
WHERE exhibition_name = 'ЛР5 Выставка Б' AND exhibition_type_id = (SELECT exhibition_type_id FROM exhibition_type WHERE exhibition_type_name = 'ЛР5 Тип Б');

CALL assign_exhibition_curator('Тестов', 'Тест', 'Тестович', 'ЛР5 Выставка Б', 'ЛР5 Тип Б');

-- После вызова --------------------------------------------------------
SELECT *
FROM employee_curation_stats_table
WHERE last_name = 'Тестов' AND first_name = 'Тест';

SELECT employee_id, last_name, first_name, middle_name
FROM employees
WHERE last_name = 'Тестов' AND first_name = 'Тест'
  AND middle_name = 'Тестович';

SELECT exhibition_id, exhibition_name, exhibition_type_id
FROM exhibitions
WHERE exhibition_name = 'ЛР5 Выставка Б' AND exhibition_type_id = (SELECT exhibition_type_id FROM exhibition_type WHERE exhibition_type_name = 'ЛР5 Тип Б');

-- Подготовка к сценариям 5 и 6. Четыре выставки одного типа у Алексея.
INSERT INTO employees (last_name, first_name, middle_name)
VALUES ('Тестов', 'Алексей', 'Алексеевич');

INSERT INTO exhibitions (exhibition_name, exhibition_type_id)
VALUES ('ЛР5 Выставка 1',
    (SELECT exhibition_type_id FROM exhibition_type WHERE exhibition_type_name = 'ЛР5 Тип А'));

INSERT INTO exhibitions (exhibition_name, exhibition_type_id)
VALUES ('ЛР5 Выставка 2',
    (SELECT exhibition_type_id FROM exhibition_type WHERE exhibition_type_name = 'ЛР5 Тип А'));

INSERT INTO exhibitions (exhibition_name, exhibition_type_id)
VALUES ('ЛР5 Выставка 3',
    (SELECT exhibition_type_id FROM exhibition_type WHERE exhibition_type_name = 'ЛР5 Тип А'));

INSERT INTO exhibitions (exhibition_name, exhibition_type_id)
VALUES ('ЛР5 Выставка 4',
    (SELECT exhibition_type_id FROM exhibition_type WHERE exhibition_type_name = 'ЛР5 Тип А'));

INSERT INTO exhibition_curators (employee_id, exhibition_id)
VALUES (
    (SELECT employee_id FROM employees
     WHERE last_name = 'Тестов' AND first_name = 'Алексей'
       AND middle_name = 'Алексеевич'),
    (SELECT exhibition_id FROM exhibitions
     WHERE exhibition_name = 'ЛР5 Выставка 1' AND exhibition_type_id = (SELECT exhibition_type_id FROM exhibition_type WHERE exhibition_type_name = 'ЛР5 Тип А'))
);

INSERT INTO exhibition_curators (employee_id, exhibition_id)
VALUES (
    (SELECT employee_id FROM employees
     WHERE last_name = 'Тестов' AND first_name = 'Алексей'
       AND middle_name = 'Алексеевич'),
    (SELECT exhibition_id FROM exhibitions
     WHERE exhibition_name = 'ЛР5 Выставка 2' AND exhibition_type_id = (SELECT exhibition_type_id FROM exhibition_type WHERE exhibition_type_name = 'ЛР5 Тип А'))
);

INSERT INTO exhibition_curators (employee_id, exhibition_id)
VALUES (
    (SELECT employee_id FROM employees
     WHERE last_name = 'Тестов' AND first_name = 'Алексей'
       AND middle_name = 'Алексеевич'),
    (SELECT exhibition_id FROM exhibitions
     WHERE exhibition_name = 'ЛР5 Выставка 3' AND exhibition_type_id = (SELECT exhibition_type_id FROM exhibition_type WHERE exhibition_type_name = 'ЛР5 Тип А'))
);

INSERT INTO exhibition_curators (employee_id, exhibition_id)
VALUES (
    (SELECT employee_id FROM employees
     WHERE last_name = 'Тестов' AND first_name = 'Алексей'
       AND middle_name = 'Алексеевич'),
    (SELECT exhibition_id FROM exhibitions
     WHERE exhibition_name = 'ЛР5 Выставка 4' AND exhibition_type_id = (SELECT exhibition_type_id FROM exhibition_type WHERE exhibition_type_name = 'ЛР5 Тип А'))
);

SAVEPOINT before_fifth_assignment;

------------------------------------------------------------------------
-- 5. Оба есть, назначения еще нет. Пятая выставка того же типа
------------------------------------------------------------------------

-- До вызова -----------------------------------------------------------
SELECT *
FROM employee_curation_stats_table
WHERE last_name = 'Тестов' AND first_name = 'Алексей';

SELECT employee_id, last_name, first_name, middle_name
FROM employees
WHERE last_name = 'Тестов' AND first_name = 'Алексей'
  AND middle_name = 'Алексеевич';

SELECT exhibition_id, exhibition_name, exhibition_type_id
FROM exhibitions
WHERE exhibition_name = 'ЛР5 Выставка А' AND exhibition_type_id = (SELECT exhibition_type_id FROM exhibition_type WHERE exhibition_type_name = 'ЛР5 Тип А');

CALL assign_exhibition_curator('Тестов', 'Алексей', 'Алексеевич', 'ЛР5 Выставка А', 'ЛР5 Тип А');

-- После вызова --------------------------------------------------------
SELECT *
FROM employee_curation_stats_table
WHERE last_name = 'Тестов' AND first_name = 'Алексей';

SELECT employee_id, last_name, first_name, middle_name
FROM employees
WHERE last_name = 'Тестов' AND first_name = 'Алексей'
  AND middle_name = 'Алексеевич';

SELECT exhibition_id, exhibition_name, exhibition_type_id
FROM exhibitions
WHERE exhibition_name = 'ЛР5 Выставка А' AND exhibition_type_id = (SELECT exhibition_type_id FROM exhibition_type WHERE exhibition_type_name = 'ЛР5 Тип А');

ROLLBACK TO SAVEPOINT before_fifth_assignment;

------------------------------------------------------------------------
-- 6. Оба есть, назначения еще нет. Пятая выставка другого типа
------------------------------------------------------------------------

-- До вызова -----------------------------------------------------------
SELECT *
FROM employee_curation_stats_table
WHERE last_name = 'Тестов' AND first_name = 'Алексей';

SELECT employee_id, last_name, first_name, middle_name
FROM employees
WHERE last_name = 'Тестов' AND first_name = 'Алексей'
  AND middle_name = 'Алексеевич';

SELECT exhibition_id, exhibition_name, exhibition_type_id
FROM exhibitions
WHERE exhibition_name = 'ЛР5 Выставка Б' AND exhibition_type_id = (SELECT exhibition_type_id FROM exhibition_type WHERE exhibition_type_name = 'ЛР5 Тип Б');

CALL assign_exhibition_curator('Тестов', 'Алексей', 'Алексеевич', 'ЛР5 Выставка Б', 'ЛР5 Тип Б');

-- После вызова --------------------------------------------------------
SELECT *
FROM employee_curation_stats_table
WHERE last_name = 'Тестов' AND first_name = 'Алексей';

SELECT employee_id, last_name, first_name, middle_name
FROM employees
WHERE last_name = 'Тестов' AND first_name = 'Алексей'
  AND middle_name = 'Алексеевич';

SELECT exhibition_id, exhibition_name, exhibition_type_id
FROM exhibitions
WHERE exhibition_name = 'ЛР5 Выставка Б' AND exhibition_type_id = (SELECT exhibition_type_id FROM exhibition_type WHERE exhibition_type_name = 'ЛР5 Тип Б');

ROLLBACK;
