CREATE USER guinea_pig PASSWORD '123';
CREATE USER ex_curator PASSWORD '123';

-- вход в БД и видимость схемы нужны обоим
GRANT CONNECT ON DATABASE museum_db TO guinea_pig, ex_curator;
-- т.к. при создании таблиц, не были указаны схемы, то все таблицы сейчас лежат в public
GRANT USAGE ON SCHEMA public TO guinea_pig, ex_curator;


-- для морской свинки только SELECT из новой таблицы
GRANT SELECT ON employee_curation_stats_table TO guinea_pig;

-- ex_curator 
GRANT SELECT ON employee_curation_stats_table TO ex_curator;
GRANT SELECT, INSERT, UPDATE, DELETE ON employees, exhibitions, exhibition_curators TO ex_curator;

-- для INSERT в таблицы с SERIAL нужны права на их последовательности, без них меня послало
GRANT USAGE, SELECT, UPDATE ON SEQUENCE
    employees_employee_id_seq,
    exhibitions_exhibition_id_seq,
    exhibition_curators_curator_id_seq
TO ex_curator;

-- по умолчанию триггерная функция выполняется с правами того, кто изменил таблицу (ex_curator),
-- а прав на запись в employee_curation_stats_table у него быть не должно (иначе он правил бы её руками),
-- поэтому триггерные функции выполняем с правами владельца (postgres): SECURITY DEFINER
-- SET search_path = public фиксирует схему, т.к. функция триггера может начать писать не туда,
-- если мы, допустим, создадим таблицу с таким же именем в схеме пользователя ex_curator
ALTER FUNCTION trg_curator_added() SECURITY DEFINER SET search_path = public;
ALTER FUNCTION trg_curator_removed() SECURITY DEFINER SET search_path = public;
ALTER FUNCTION trg_employee_deleted() SECURITY DEFINER SET search_path = public;
ALTER FUNCTION trg_employee_renamed() SECURITY DEFINER SET search_path = public;
ALTER FUNCTION trg_exhibition_deleted() SECURITY DEFINER SET search_path = public;
ALTER FUNCTION trg_exhibition_type_changed() SECURITY DEFINER SET search_path = public;
