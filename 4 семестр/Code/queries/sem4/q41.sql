SELECT 
    exhibition_spaces.exhibition_space_id,
    room_type.room_type_name,
    COUNT(exhibit_placements.exhibit_id)
    FROM 
        -- берем выставочные пространства
        exhibition_spaces
        
        -- берем их названия из словарика
        INNER JOIN room_type
            ON room_type.room_type_id = exhibition_spaces.room_type_id
            
        -- соединяем с конкретными витринами
        INNER JOIN display_places
            ON display_places.exhibition_space_id = exhibition_spaces.exhibition_space_id
            
        -- приклеиваем факты размещения экспонатов в витринах
        INNER JOIN exhibit_placements
            ON exhibit_placements.display_place_id = display_places.display_place_id
            
    GROUP BY 
        exhibition_spaces.exhibition_space_id, 
        room_type.room_type_name

    -- оставляем только те, что равны максимуму
    HAVING COUNT(exhibit_placements.exhibit_id) = ( SELECT MAX(cnt) 
        FROM ( -- ищем максимум в точно таком же запросе
            SELECT COUNT(exhibit_placements.exhibit_id) as cnt
            FROM exhibition_spaces

            INNER JOIN display_places ON display_places.exhibition_space_id = exhibition_spaces.exhibition_space_id
            INNER JOIN exhibit_placements ON exhibit_placements.display_place_id = display_places.display_place_id

            GROUP BY exhibition_spaces.exhibition_space_id
        )
    );