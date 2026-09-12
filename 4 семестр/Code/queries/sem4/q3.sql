SELECT 
    exhibitions.exhibition_name,
    COUNT(DISTINCT exhibit_placements.exhibit_id) AS total_exhibits,
    COUNT(DISTINCT passports.passport_id) AS total_passports
    FROM 
        exhibitions
        
        -- в размещениях можно найти id задействованных экспонатов
        -- LEFT потому что у выставки может не быть экспонатов
        LEFT JOIN exhibit_placements
            ON exhibit_placements.exhibition_id = exhibitions.exhibition_id
            
        -- приклеиваем паспорта через id экспонатов из таблицы размещений
        -- LEFT потому что у экспонатов может не быть паспортов
        LEFT JOIN passports
            ON passports.exhibit_id = exhibit_placements.exhibit_id

    GROUP BY 
        exhibitions.exhibition_id, 
        exhibitions.exhibition_name;