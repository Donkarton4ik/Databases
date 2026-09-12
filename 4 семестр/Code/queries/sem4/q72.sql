SELECT DISTINCT
    employees.first_name, 
    employees.last_name
FROM 
    employees
    
    -- в начале заджоиним вообще всех кураторов
    INNER JOIN exhibition_curators
        ON exhibition_curators.employee_id = employees.employee_id

WHERE 
    -- оставляем тех, которые не курировали А
    employees.employee_id NOT IN (
        SELECT 
            exhibition_curators.employee_id
        FROM 
            exhibition_curators
            
            INNER JOIN exhibitions
                ON exhibitions.exhibition_id = exhibition_curators.exhibition_id
                
            INNER JOIN exhibit_placements
                ON exhibit_placements.exhibition_id = exhibitions.exhibition_id
            INNER JOIN exhibits
                ON exhibits.exhibit_id = exhibit_placements.exhibit_id 
        WHERE 
            exhibits.exhibit_name = 'Персидский баreльеф храмового комплекса'
    );