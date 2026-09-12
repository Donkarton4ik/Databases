INSERT INTO exhibition_status (exhibition_status_name)
VALUES
    ('Планируется'),
    ('Активна'),
    ('Завершена'),
    ('Отменена');


INSERT INTO exhibition_type (exhibition_type_name)
VALUES
    ('Cозерцательный'),
    ('Тематический'),
    ('Средовой'),
    ('Систематический'),
    ('Интерактивный'),
    ('Прикладной');


INSERT INTO exhibition_subject (exhibition_subject_name)
VALUES
    ('Военная история'),
    ('Быт'),
    ('Религия'),
    ('Нумизматика'),
    ('Этнография');


INSERT INTO exhibit_status (exhibit_status_name)
VALUES
    ('В хранилище'),
    ('На выставке'),
    ('На реставрации'),
    ('Утерян');


INSERT INTO materials (material_name)
VALUES
    ('Дерево'),
    ('Металл'),
    ('Керамика'),
    ('Ткань'),
    ('Бумага'),
    ('Камень'),
    ('Стекло');


INSERT INTO exhibit_conditions (exhibit_conditions_name)
VALUES
    ('Отличное'),
    ('Хорошее'),
    ('Удовлетворительное'),
    ('Плохое'),
    ('Критическое');


INSERT INTO epochs (epoch_name)
VALUES
    ('Древний мир'),
    ('Средневековье'),
    ('Возрождение'),
    ('Новое время'),
    ('Новейшее время'),
    ('Современность');


INSERT INTO temp_categories (temp_category_name, min_value, max_value)
VALUES
    ('Низкая', NULL, 5.0),
    ('Умеренная', 5.0, 18.0),
    ('Комнатная', 18.0, 25.0),
    ('Высокая', 25.0, NULL);


INSERT INTO humidity_categories (humidity_category_name, min_value, max_value)
VALUES
    ('Сухо', 0.0, 30.0),
    ('Норма', 30.0, 60.0),
    ('Повышенная', 60.0, 75.0),
    ('Опасная', 75.0, 100.0);


INSERT INTO lighting_categories (lighting_category_name, min_value, max_value)
VALUES
    ('Темное', 0.0, 50.0),
    ('Слабое', 50.0, 150.0),
    ('Среднее', 150.0, 300.0),
    ('Яркое', 300.0, NULL);


INSERT INTO room_type (room_type_name)
VALUES
    ('Зал'),
    ('Галерея'),
    ('Атриум'),
    ('Подвал');