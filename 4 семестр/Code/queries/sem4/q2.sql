SELECT 
    employees.first_name, 
    employees.last_name, 
    COUNT(DISTINCT exhibits.exhibit_id) AS count_exhibits
    FROM 
        -- берем сотрудников
        employees
        
        -- которые являются кураторами выставки А
        INNER JOIN exhibition_curators
            ON exhibition_curators.employee_id = employees.employee_id
        INNER JOIN exhibitions
            ON exhibitions.exhibition_id = exhibition_curators.exhibition_id
            
        -- находим паспорта, которые формировали эти же сотрудники
        INNER JOIN passports
            ON passports.employee_id = employees.employee_id
            
        -- находим экспонаты, к которым относятся эти паспорта
        INNER JOIN exhibits
            ON exhibits.exhibit_id = passports.exhibit_id
            
        -- проверяем, что эти экспонаты участвуют в выставке А
        INNER JOIN exhibit_placements
            ON exhibit_placements.exhibit_id = exhibits.exhibit_id 
            AND exhibit_placements.exhibition_id = exhibitions.exhibition_id

    WHERE 
        exhibitions.exhibition_name = 'Выставка 120'

    GROUP BY 
        employees.employee_id, 
        employees.first_name, 
        employees.last_name;