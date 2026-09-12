import random

from connection import get_conn


def fill_level4():
    conn = get_conn()
    cur = conn.cursor()

    fill_exhibit_placements(cur)
    fill_exhibit_materials(cur)

    conn.commit()
    cur.close()
    conn.close()


def fill_exhibit_placements(cur):
    cur.execute("SELECT exhibit_id FROM exhibits")
    exhibits = [row[0] for row in cur.fetchall()]
 
    cur.execute("SELECT exhibition_id FROM exhibitions")
    exhibitions = [row[0] for row in cur.fetchall()]
 
    cur.execute("SELECT display_place_id FROM display_places")
    places = [row[0] for row in cur.fetchall()]
 
    rows = [
        (random.choice(exhibits), exhibition, random.choice(places))
        for exhibition in exhibitions for exhibit in range(random.randint(50, 70))
    ]
    cur.executemany(
        "INSERT INTO exhibit_placements(exhibit_id, exhibition_id, display_place_id) VALUES(%s,%s,%s)",
        rows,
    )


def fill_exhibit_materials(cur):
    cur.execute("SELECT passport_id FROM passports")
    passports = [row[0] for row in cur.fetchall()]
 
    cur.execute("SELECT material_id FROM materials")
    materials = [row[0] for row in cur.fetchall()]
 
    rows = [
        (passport, random.choice(materials))
        for passport in passports for material in range(random.randint(5, 10))
    ]

    cur.executemany(
        "INSERT INTO exhibit_materials(passport_id, material_id) VALUES(%s,%s)",
        rows,
    )