import random

from connection import get_conn


def fill_dicts(cur):

    cur.executemany(
        "INSERT INTO exhibition_status(exhibition_status_name) VALUES(%s)",
        [("Планируется",), ("Активна",), ("Завершена",), ("Отменена",)],
    )
    cur.executemany(
        "INSERT INTO exhibition_type(exhibition_type_name) VALUES(%s)",
        [("Созерцательный",), ("Тематический",), ("Средовой",), ("Систематический",), ("Интерактивный",), ("Прикладной",)],
    )
    cur.executemany(
        "INSERT INTO exhibition_subject(exhibition_subject_name) VALUES(%s)",
        [("Военная история",), ("Быт",), ("Религия",), ("Нумизматика",), ("Этнография",)],
    )
    cur.executemany(
        "INSERT INTO exhibit_status(exhibit_status_name) VALUES(%s)",
        [("В хранилище",), ("На выставке",), ("На реставрации",), ("Утерян",)],
    )
    cur.executemany(
        "INSERT INTO exhibit_conditions(exhibit_conditions_name) VALUES(%s)",
        [("Отличное",), ("Хорошее",), ("Удовлетворительное",), ("Плохое",), ("Критическое",)],
    )
    cur.executemany(
        "INSERT INTO epochs(epoch_name) VALUES(%s)",
        [("Древний мир",), ("Средневековье",), ("Возрождение",), ("Новое время",), ("Новейшее время",), ("Современность",)],
    )
    cur.executemany(
        "INSERT INTO temp_categories(temp_category_name, min_value, max_value) VALUES(%s,%s,%s)",
        [("Низкая", None, 5.0), ("Умеренная", 5.0, 18.0), ("Комнатная", 18.0, 25.0), ("Высокая", 25.0, None)],
    )
    cur.executemany(
        "INSERT INTO humidity_categories(humidity_category_name, min_value, max_value) VALUES(%s,%s,%s)",
        [("Сухо", 0.0, 30.0), ("Норма", 30.0, 60.0), ("Повышенная", 60.0, 75.0), ("Опасная", 75.0, 100.0)],
    )
    cur.executemany(
        "INSERT INTO lighting_categories(lighting_category_name, min_value, max_value) VALUES(%s,%s,%s)",
        [("Темное", 0.0, 50.0), ("Слабое", 50.0, 150.0), ("Среднее", 150.0, 300.0), ("Яркое", 300.0, None)],
    )
    cur.executemany(
        "INSERT INTO room_type(room_type_name) VALUES(%s)",
        [("Зал",), ("Галерея",), ("Атриум",), ("Подвал",)],
    )

    base_materials = ["Дерево", "Металл", "Керамика", "Ткань", "Бумага", "Камень", "Стекло"]
    cur.executemany(
        "INSERT INTO materials(material_name) VALUES(%s)",
        [(f"{m} {n}",) for m in base_materials for n in range(1, 10)],
    )


def generate_phone():
    code = random.randint(900, 999)
    number = random.randint(1000000, 9999999)
    return random.choice( [f"+7{code}{number}", f"8{code}{number}", None] )


def fill_level1():
    conn = get_conn()
    cur = conn.cursor()

    fill_dicts(cur)

    # сотрудники - единственная табличка на первом уровне, что не является словарем

    # 20 Имен
    first_names = [
        "Александр", "Дмитрий", "Сергей", "Андрей", "Алексей", 
        "Максим", "Иван", "Михаил", "Николай", "Владимир", 
        "Артем", "Антон", "Егор", "Денис", "Павел", 
        "Виктор", "Игорь", "Олег", "Степан", "Илья"
    ]
    # 30 Фамилий
    last_names = [
        "Иванов", "Смирнов", "Кузнецов", "Попов", "Васильев", 
        "Петров", "Соколов", "Михайлов", "Новиков", "Федоров", 
        "Морозов", "Волков", "Алексеев", "Лебедев", "Семенов", 
        "Егоров", "Павлов", "Козлов", "Степанов", "Николаев", 
        "Орлов", "Андреев", "Макаров", "Никитин", "Захаров", 
        "Зайцев", "Соловьев", "Борисов", "Яковлев", "Григорьев"
    ]
    # 20 Отчеств + None
    middle_names = [
        "Александрович", "Дмитриевич", "Сергеевич", "Андреевич", "Алексеевич", 
        "Максимович", "Иванович", "Михайлович", "Николаевич", "Владимирович", 
        "Артемович", "Антонович", "Егорович", "Денисович", "Павлович", 
        "Викторович", "Игоревич", "Олегович", "Степанович", "Ильич", None
    ]

    cur.executemany(
        "INSERT INTO employees(first_name, last_name, middle_name, phone_number) VALUES(%s, %s, %s, %s)",
        [(random.choice(first_names), 
          random.choice(last_names), 
          random.choice(middle_names), 
          generate_phone()) for _ in range(180)],
    )

    conn.commit()
    cur.close()
    conn.close()
