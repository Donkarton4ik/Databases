SELECT 
    exhibitions.exhibition_name,
    COUNT(display_places.display_place_id)
    FROM 
        exhibitions
        
        INNER JOIN exhibit_placements
            ON exhibit_placements.exhibition_id = exhibitions.exhibition_id
        INNER JOIN display_places
            ON display_places.display_place_id = exhibit_placements.display_place_id
            
    GROUP BY 
        exhibitions.exhibition_id, 
        exhibitions.exhibition_name
        
    -- оставляем выставки, где мест больше, чем на выставке А
    HAVING COUNT(display_places.display_place_id) > (
        -- подзапросом ищем сколько мест экспонирования на выставке А
        SELECT COUNT(exhibit_placements_sub.display_place_id)
        FROM exhibitions AS exhibitions_sub
            INNER JOIN exhibit_placements AS exhibit_placements_sub 
                ON exhibit_placements_sub.exhibition_id = exhibitions_sub.exhibition_id
        WHERE exhibitions_sub.exhibition_name = 'Выставка 83'
    );