import random

from connection import get_conn


def fill_level3():
    conn = get_conn()
    cur = conn.cursor()

    fill_exhibition_curators(cur)
    fill_passports(cur)
    fill_display_places(cur)

    conn.commit()
    cur.close()
    conn.close()


def fill_exhibition_curators(cur):
    cur.execute("SELECT employee_id FROM employees")
    employees = [row[0] for row in cur.fetchall()]
 
    cur.execute("SELECT exhibition_id FROM exhibitions")
    exhibitions = [row[0] for row in cur.fetchall()]
 
    rows = [
        (random.choice(employees), exhibition)
        for exhibition in exhibitions for worker in range(random.randint(3, 5))
    ]
    cur.executemany(
        "INSERT INTO exhibition_curators(employee_id, exhibition_id) VALUES(%s,%s)",
        rows,
    )


def fill_passports(cur):
    cur.execute("SELECT employee_id FROM employees")
    employees = [row[0] for row in cur.fetchall()]
 
    cur.execute("SELECT exhibit_id FROM exhibits")
    exhibits = [row[0] for row in cur.fetchall()]
 
    cur.execute("SELECT exhibit_conditions_id FROM exhibit_conditions")
    conditions = [row[0] for row in cur.fetchall()]
 
    cur.execute("SELECT epoch_id FROM epochs")
    epochs = [row[0] for row in cur.fetchall()]
 
    cur.execute("SELECT temp_category_id FROM temp_categories")
    temps = [row[0] for row in cur.fetchall()]
 
    cur.execute("SELECT humidity_category_id FROM humidity_categories")
    humidities = [row[0] for row in cur.fetchall()]
 
    cur.execute("SELECT lighting_category_id FROM lighting_categories")
    lightings = [row[0] for row in cur.fetchall()]
 
    rows = [ (
            random.choice(employees),
            exhibit,
            random.choice(conditions),
            random.choice(epochs),
            random.choice(temps),
            random.choice(humidities),
            random.choice(lightings),
            round(random.uniform(0.1, 500.0), 3),
            version,
        ) for exhibit in exhibits for version in range(random.randint(1, 8))]
    
    cur.executemany(
        """INSERT INTO passports(
            employee_id, exhibit_id, condition_id, epoch_id,
            req_temp_category_id, req_humidity_category_id, req_lighting_category_id,
            weight, passport_version
        ) VALUES(%s,%s,%s,%s,%s,%s,%s,%s,%s)""",
        rows,
    )


def fill_display_places(cur):
    cur.execute("SELECT exhibition_space_id FROM exhibition_spaces")
    spaces = [row[0] for row in cur.fetchall()]
 
    cur.execute("SELECT temp_category_id FROM temp_categories")
    temps = [row[0] for row in cur.fetchall()]
 
    cur.execute("SELECT humidity_category_id FROM humidity_categories")
    humidities = [row[0] for row in cur.fetchall()]
 
    cur.execute("SELECT lighting_category_id FROM lighting_categories")
    lightings = [row[0] for row in cur.fetchall()]
 
    rows = [ (
            space,
            random.choice(temps),
            random.choice(humidities),
            random.choice(lightings),
            f"Место {place} в пространстве {space}",
        ) for space in spaces for place in range(random.randint(20, 30))]
    
    cur.executemany(
        "INSERT INTO display_places(exhibition_space_id, temp_category_id, humidity_category_id, lighting_category_id, place_name) VALUES(%s,%s,%s,%s,%s)",
        rows,
    )