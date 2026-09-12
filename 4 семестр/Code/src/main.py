import sys
from make_tables import create_tables
from drop_and_clear import drop_tables
from fill_db import fill_db
from connection import get_conn

def run_query(query):
    conn = get_conn()
    try:
        with conn.cursor() as cur:
            cur.execute(query)
            if query.strip().lower().startswith("select"):
                rows = cur.fetchall()
                if rows:
                    for row in rows:
                        print(row)
                else:
                    print("(нет результатов)")
            else:
                conn.commit()
                print(f"OK, затронуто строк: {cur.rowcount}")
    except Exception as e:
        conn.rollback()
        print(f"Ошибка: {e}")
    finally:
        conn.close()

HELP = """
Команды:
  create   — создать таблицы
  drop     — удалить таблицы
  fill     — заполнить БД
  sql      — ввести SQL-запрос вручную
  exit     — выход
"""

def main():
    print("Museum DB Console")
    print(HELP)
    while True:
        try:
            cmd = input(">>> ").strip().lower()
        except (EOFError, KeyboardInterrupt):
            print("\nВыход.")
            sys.exit(0)

        if cmd == "create":
            create_tables()
            print("Таблицы созданы.")
        elif cmd == "drop":
            confirm = input("Удалить все таблицы? (yes/no): ").strip().lower()
            if confirm == "yes":
                drop_tables()
                print("Таблицы удалены.")
        elif cmd == "fill":
            fill_db()
            print("БД заполнена.")
        elif cmd == "sql":
            query = input("SQL> ").strip()
            if query:
                run_query(query)
        elif cmd in ("exit", "quit"):
            print("Выход.")
            sys.exit(0)
        elif cmd == "help":
            print(HELP)
        elif cmd == "":
            continue
        else:
            print(f"Неизвестная команда: '{cmd}'. Введите help.")

if __name__ == "__main__":
    main()