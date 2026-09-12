SELECT 
    subquery.passports_count,
    COUNT(subquery.exhibit_id)
    FROM (
        -- в подзапросе считаем кол-во паспортов для каждого экспоната
        SELECT 
            exhibits.exhibit_id,
            COUNT(passports.passport_id) AS passports_count -- без AS падает
        FROM 
            exhibits
            -- LEFT потому что могут быть экспонаты без паспортов
            LEFT JOIN passports 
                ON exhibits.exhibit_id = passports.exhibit_id
        GROUP BY 
            exhibits.exhibit_id
    ) AS subquery

    -- группируем по числу паспортов => получаем количество экспонатов для каждого числа паспортов
    GROUP BY 
        subquery.passports_count