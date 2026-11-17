CREATE OR REPLACE PROCEDURE assign_exhibition_curator(
    IN p_last_name varchar,
    IN p_first_name varchar,
    IN p_middle_name varchar,
    IN p_exhibition_name varchar,
    IN p_exhibition_type_name varchar
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_employee_id integer;
    v_exhibition_id integer;
    v_exhibition_type_id integer;
BEGIN
    p_middle_name := NULLIF(p_middle_name, '');

    -- ищем сотрудника
    v_employee_id := (
        SELECT employee_id FROM employees
        -- IS NOT DISTINCT FROM работает как =, но при сравнении двух NULL вернет true
        WHERE last_name = p_last_name AND first_name = p_first_name AND NULLIF(middle_name, '') IS NOT DISTINCT FROM NULLIF(p_middle_name, '')
    );

    -- если не нашли сотрудника, то добавляем его
    IF v_employee_id IS NULL THEN
        INSERT INTO employees (last_name, first_name, middle_name)
        VALUES (p_last_name, p_first_name, p_middle_name)
        -- записываем только что вставленную id в переменную
        RETURNING employee_id INTO v_employee_id;
    END IF;

    -- ищем тип выставки
    v_exhibition_type_id := (
        SELECT exhibition_type_id FROM exhibition_type
        WHERE exhibition_type_name = p_exhibition_type_name
    );

    -- если не нашли тип выставки, то добавляем его
    IF v_exhibition_type_id IS NULL THEN
        INSERT INTO exhibition_type (exhibition_type_name)
        VALUES (p_exhibition_type_name)
        RETURNING exhibition_type_id INTO v_exhibition_type_id;
    END IF;

    -- ищем выставку
    v_exhibition_id := (
        SELECT exhibition_id FROM exhibitions
        WHERE exhibition_name = p_exhibition_name AND exhibition_type_id = v_exhibition_type_id
    );

    -- если не нашли выставку, то добавляем новую
    IF v_exhibition_id IS NULL THEN
        INSERT INTO exhibitions (exhibition_name, exhibition_type_id)
        VALUES (p_exhibition_name, v_exhibition_type_id)
        RETURNING exhibition_id INTO v_exhibition_id;
    END IF;

    -- создаем факт кураторства сотрудника и выставки, параметры которых переданы на вход процедуре
    IF NOT EXISTS (
        SELECT 1 FROM exhibition_curators WHERE employee_id = v_employee_id AND exhibition_id = v_exhibition_id
    ) THEN
        INSERT INTO exhibition_curators (employee_id, exhibition_id) VALUES (v_employee_id, v_exhibition_id);
    END IF;

END;
$$;
