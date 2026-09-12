SELECT 
    exhibitions.exhibition_name,
    grid.exhibit_status_name,
    COUNT(real_status.exhibit_status_id)

    FROM exhibitions CROSS JOIN exhibit_status AS grid
        
    -- через размещения выходим на статусы экспонатов
    LEFT JOIN exhibit_placements
        ON exhibit_placements.exhibition_id = exhibitions.exhibition_id
    LEFT JOIN exhibits
        ON exhibits.exhibit_id = exhibit_placements.exhibit_id

    -- приклевиваем статус к сетке (который и будем считать), только если данные совпадают
    LEFT JOIN exhibit_status AS real_status
        ON exhibits.exhibit_status_id = real_status.exhibit_status_id
        AND real_status.exhibit_status_name = grid.exhibit_status_name

    GROUP BY 
        exhibitions.exhibition_name,
        grid.exhibit_status_name;
