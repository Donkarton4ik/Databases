-- 1. А
BEGIN ISOLATION LEVEL READ COMMITTED;

-- 2. А
SELECT count(*) FROM exhibition_curators WHERE employee_id = 1;

-- 3. Б
BEGIN;

-- 4. Б
INSERT INTO exhibition_curators (employee_id, exhibition_id) VALUES (1, 5);

-- 5. Б
COMMIT;

-- 6. А
SELECT count(*) FROM exhibition_curators WHERE employee_id = 1;

-- 7. А
COMMIT;
