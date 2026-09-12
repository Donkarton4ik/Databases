import random

from connection import get_conn


def fill_level2():
    conn = get_conn()
    cur = conn.cursor()

    fill_exhibitions(cur)
    fill_exhibition_spaces(cur)
    fill_exhibits(cur)

    conn.commit()
    cur.close()
    conn.close()


def fill_exhibitions(cur):
    cur.execute("SELECT exhibition_status_id FROM exhibition_status")
    statuses = [row[0] for row in cur.fetchall()]
 
    cur.execute("SELECT exhibition_type_id FROM exhibition_type")
    types = [row[0] for row in cur.fetchall()]
 
    cur.execute("SELECT exhibition_subject_id FROM exhibition_subject")
    subjects = [row[0] for row in cur.fetchall()]
 
    rows = [ (
            random.choice(statuses),
            random.choice(types),
            random.choice(subjects),
            f"Выставка {i + 1}",
        ) for i in range(200) ]
 
    cur.executemany(
        "INSERT INTO exhibitions(exhibition_status_id, exhibition_type_id, exhibition_subject_id, exhibition_name) VALUES(%s,%s,%s,%s)",
        rows
    )


def fill_exhibition_spaces(cur):
    cur.execute("SELECT room_type_id FROM room_type")
    room_types = [row[0] for row in cur.fetchall()]
 
    rows = [ (
            random.choice(room_types),
            random.randint(10, 500), # вместимость посетителей
            round(random.uniform(2.2, 10.0), 2), # высота потолка
            round(random.uniform(10.0, 1000.0), 2), # площадь
        ) for _ in range(100) ]
    
    cur.executemany(
        "INSERT INTO exhibition_spaces(room_type_id, visitor_capacity, ceiling_height, area) VALUES(%s,%s,%s,%s)",
        rows,
    )


def generate_exhibit_name():
    # Происхождение
    styles = [
        "Прусский", "Китайский", "Византийский", "Древнеегипетский", 
        "Славянский", "Османский", "Английский", "Кельтский", 
        "Персидский", "Японский", "Скифский", "Норманнский"
    ]
    
    # Конкретный предмет
    types = [
        "кувшин", "меч", "шлем", "браслет", "рукопись", 
        "амулет", "саркофаг", "щит", "кинжал", "кубок", 
        "перстень", "барельеф", "статуэтка", "гобелен"
    ]
    
    # Деталь
    details = [
        "династии Мин", "времён крестоносцев", "великого хана", 
        "для тайных обрядов", "царской семьи", "с личной печатью", 
        "храмового комплекса", "найденный в кургане", "эпохи Просвещения",
        "со следами сражений", "для коронации", "забытого королевства",
        "странствующего рыцаря", "высшего жреца", "из коллекции герцога",
        "морских кочевников", "времён великого переселения", "с руническими символами",
        "придворного лекаря", "с родовым гербом"
    ]
    
    name = f"{random.choice(styles)} {random.choice(types)} {random.choice(details)}"
    
    return name


def fill_exhibits(cur):
    cur.execute("SELECT exhibit_status_id FROM exhibit_status")
    statuses = [row[0] for row in cur.fetchall()]
 
    rows = [ (random.choice(statuses), generate_exhibit_name()) for i in range(67000) ]

    cur.executemany(
        "INSERT INTO exhibits(exhibit_status_id, exhibit_name) VALUES(%s,%s)",
        rows,
    )