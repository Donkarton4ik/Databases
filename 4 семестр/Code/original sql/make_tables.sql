-- Уровень 1

CREATE TABLE IF NOT EXISTS exhibition_status(
    exhibition_status_id SERIAL PRIMARY KEY NOT NULL, 
    exhibition_status_name VARCHAR(11) NOT NULL
);

CREATE TABLE IF NOT EXISTS exhibition_type(
    exhibition_type_id SERIAL PRIMARY KEY NOT NULL, 
    exhibition_type_name VARCHAR(15) NOT NULL
);

CREATE TABLE IF NOT EXISTS exhibition_subject(
    exhibition_subject_id SERIAL PRIMARY KEY NOT NULL, 
    exhibition_subject_name VARCHAR(25) NOT NULL
);

CREATE TABLE IF NOT EXISTS exhibit_status(
    exhibit_status_id SERIAL PRIMARY KEY NOT NULL, 
    exhibit_status_name VARCHAR(25) NOT NULL
);

CREATE TABLE IF NOT EXISTS materials(
    material_id SERIAL PRIMARY KEY NOT NULL, 
    material_name VARCHAR(25) NOT NULL
);

CREATE TABLE IF NOT EXISTS exhibit_conditions(
    exhibit_conditions_id SERIAL PRIMARY KEY NOT NULL, 
    exhibit_conditions_name VARCHAR(18) NOT NULL
);

CREATE TABLE IF NOT EXISTS epochs(
    epoch_id SERIAL PRIMARY KEY NOT NULL, 
    epoch_name VARCHAR(30) NOT NULL
);

CREATE TABLE IF NOT EXISTS temp_categories(
    temp_category_id SERIAL PRIMARY KEY NOT NULL, 
    temp_category_name VARCHAR(9) NOT NULL,
    min_value DECIMAL(4,2),
    max_value DECIMAL(4,2)
);

CREATE TABLE IF NOT EXISTS humidity_categories(
    humidity_category_id SERIAL PRIMARY KEY NOT NULL, 
    humidity_category_name VARCHAR(10) NOT NULL,
    min_value DECIMAL(5,2),
    max_value DECIMAL(5,2)
);

CREATE TABLE IF NOT EXISTS lighting_categories(
    lighting_category_id SERIAL PRIMARY KEY NOT NULL, 
    lighting_category_name VARCHAR(7) NOT NULL,
    min_value DECIMAL(7,2),
    max_value DECIMAL(7,2)
);

CREATE TABLE IF NOT EXISTS room_type(
    room_type_id SERIAL PRIMARY KEY NOT NULL, 
    room_type_name VARCHAR(132) NOT NULL
);

CREATE TABLE IF NOT EXISTS employees(
    employee_id SERIAL PRIMARY KEY NOT NULL, 
    first_name VARCHAR(60) NOT NULL,
    last_name VARCHAR(60) NOT NULL,
    middle_name VARCHAR(60),
    phone_number VARCHAR(15)
);


-- Уровень 2

CREATE TABLE IF NOT EXISTS exhibits(
    exhibit_id SERIAL PRIMARY KEY NOT NULL,
    exhibit_status_id INT NOT NULL REFERENCES exhibit_status(exhibit_status_id),
    exhibit_name VARCHAR(200) NOT NULL
);

CREATE TABLE IF NOT EXISTS exhibitions(
    exhibition_id SERIAL PRIMARY KEY NOT NULL,
    exhibition_status_id INT REFERENCES exhibition_status(exhibition_status_id),
    exhibition_type_id INT REFERENCES exhibition_type(exhibition_type_id),
    exhibition_subject_id INT REFERENCES exhibition_subject(exhibition_subject_id),
    exhibition_name VARCHAR(150) NOT NULL
);

CREATE TABLE IF NOT EXISTS exhibition_spaces(
    exhibition_space_id SERIAL PRIMARY KEY NOT NULL,
    room_type_id INT REFERENCES room_type(room_type_id),

    visitor_capacity INT,
    ceiling_height DECIMAL(4,2),
    area DECIMAL(7,2)
);

-- Уровень 3

CREATE TABLE IF NOT EXISTS passports(
    passport_id SERIAL PRIMARY KEY NOT NULL,

    employee_id INT NOT NULL REFERENCES employees(employee_id),
    exhibit_id INT NOT NULL REFERENCES exhibits(exhibit_id),

    condition_id INT REFERENCES exhibit_conditions(exhibit_conditions_id),
    epoch_id INT REFERENCES epochs(epoch_id),

    req_temp_category_id INT REFERENCES temp_categories(temp_category_id),
    req_humidity_category_id INT REFERENCES humidity_categories(humidity_category_id),
    req_lighting_category_id INT REFERENCES lighting_categories(lighting_category_id),

    weight DECIMAL(8,3),
    passport_version INT
);

CREATE TABLE IF NOT EXISTS  exhibition_curators(
    curator_id SERIAL PRIMARY KEY NOT NULL,
    employee_id INT NOT NULL REFERENCES employees(employee_id),
    exhibition_id INT NOT NULL REFERENCES exhibitions(exhibition_id)
);

CREATE TABLE IF NOT EXISTS display_places(
    display_place_id SERIAL PRIMARY KEY NOT NULL,
    exhibition_space_id INT NOT NULL REFERENCES exhibition_spaces(exhibition_space_id),

    temp_category_id INT REFERENCES temp_categories(temp_category_id),
    humidity_category_id INT REFERENCES humidity_categories(humidity_category_id),
    lighting_category_id INT REFERENCES lighting_categories(lighting_category_id),

    place_name VARCHAR(50)
);

-- Уровень 4

CREATE TABLE IF NOT EXISTS exhibit_materials(
    material_in_passport_id SERIAL PRIMARY KEY NOT NULL, 
    passport_id INT NOT NULL REFERENCES passports(passport_id),
    material_id INT NOT NULL REFERENCES materials(material_id)
);

CREATE TABLE IF NOT EXISTS exhibit_placements(
    exhibit_placement_id SERIAL PRIMARY KEY NOT NULL, 
    exhibit_id INT NOT NULL REFERENCES exhibits(exhibit_id),
    exhibition_id INT NOT NULL REFERENCES exhibitions(exhibition_id),
    display_place_id INT NOT NULL REFERENCES display_places(display_place_id)
);