CREATE OR REPLACE FUNCTION employee_initials(
    last_name varchar,
    first_name varchar,
    middle_name varchar
)
RETURNS varchar(65)
LANGUAGE sql
AS $$
    -- COALESCE(... , '') нужен чтобы вся строка не превратилась в NULL, если отчества нет
    SELECT last_name || ' ' || left(first_name, 1) || '.' ||
           COALESCE(left(NULLIF(middle_name, ''), 1) || '.', '');
$$;
