-- Из всех кураторов вычитаем тех, кто использовал экспонат А
SELECT DISTINCT
    employees.first_name, 
    employees.last_name
    FROM 
        employees
        
        INNER JOIN exhibition_curators
            ON exhibition_curators.employee_id = employees.employee_id

EXCEPT

SELECT 
    employees.first_name, 
    employees.last_name
    FROM 
        employees
        
        -- находим выставки которые курировали
        INNER JOIN exhibition_curators
            ON exhibition_curators.employee_id = employees.employee_id
        INNER JOIN exhibitions
            ON exhibitions.exhibition_id = exhibition_curators.exhibition_id
            
        -- находим экспонаты
        INNER JOIN exhibit_placements
            ON exhibit_placements.exhibition_id = exhibitions.exhibition_id
        INNER JOIN exhibits
            ON exhibits.exhibit_id = exhibit_placements.exhibit_id 

    WHERE 
        exhibits.exhibit_name = 'Персидский барельеф храмового комплекса';