SELECT exhibitions.exhibition_name
    FROM 
        -- Найти выставки
        exhibitions

        -- на которых экспонировался экспонат А
        INNER JOIN exhibit_placements
            ON exhibit_placements.exhibition_id = exhibitions.exhibition_id
        INNER JOIN exhibits
            ON exhibits.exhibit_id = exhibit_placements.exhibit_id

        -- паспорт которого формировал сотрудник Б
        INNER JOIN passports
            ON exhibits.exhibit_id = passports.exhibit_id
        INNER JOIN employees
            ON passports.employee_id = employees.employee_id

        -- в выставочном пространстве В
        INNER JOIN display_places
            ON exhibit_placements.display_place_id = display_places.display_place_id
        INNER JOIN exhibition_spaces
            ON exhibition_spaces.exhibition_space_id = display_places.exhibition_space_id
        INNER JOIN room_type
            ON exhibition_spaces.room_type_id = room_type.room_type_id

        -- с типом выставки Д
        INNER JOIN exhibition_type
            ON exhibition_type.exhibition_type_id = exhibitions.exhibition_type_id

    WHERE 
        exhibits.exhibit_name = 'Персидский барельеф храмового комплекса' 
        AND employees.first_name = 'Алексей' 
        AND employees.last_name = 'Никитин' 
        AND room_type.room_type_name = 'Зал' 
        and exhibition_type.exhibition_type_name = 'Систематический';

