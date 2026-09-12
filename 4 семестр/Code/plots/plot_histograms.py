import os
import sys
from pathlib import Path

import matplotlib
matplotlib.use("Agg")

import matplotlib.pyplot as plt
import pandas as pd
import psycopg2


BASE_DIR = Path(__file__).resolve().parents[1]
QUERIES_DIR = Path(os.getenv("QUERIES_DIR", BASE_DIR / "queries"))
OUTPUT_DIR = Path(os.getenv("PLOTS_OUTPUT_DIR", BASE_DIR / "plots" / "output"))


def get_conn():
    db_host = os.getenv("DB_HOST", "localhost")
    db_port = "5432" if db_host == "db" else os.getenv("DB_PORT", "5432")

    return psycopg2.connect(
        host=db_host,
        port=db_port,
        dbname=os.getenv("DB_NAME"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
    )


def read_query(filename):
    return (QUERIES_DIR / filename).read_text(encoding="utf-8")


def load_query(filename):
    with get_conn() as conn:
        return pd.read_sql_query(read_query(filename), conn)


def save_current_plot(filename):
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    target = OUTPUT_DIR / filename
    plt.savefig(target, dpi=180, bbox_inches="tight")
    plt.close()
    print(f"Saved {target}")


def plot_q3():
    # Ограничиваем первыми 20 выставками
    df = load_query("q3.sql").head(20)

    ax = df.plot(
        x="exhibition_name",
        y=["total_exhibits", "total_passports"],
        kind="bar",
        figsize=(12, 6),
    )
    ax.set_title("Количество экспонатов и паспортов для каждой выставки (первые 20)")
    ax.set_xlabel("Выставка")
    ax.set_ylabel("Количество")
    ax.legend(["Экспонаты", "Паспорта"])
    plt.xticks(rotation=35, ha="right")

    save_current_plot("q3_2d_histogram.png")


def plot_q5():
    df = load_query("q5.sql")
    df.columns = ["passports_count", "exhibits_count"]
    df = df.sort_values("passports_count")

    plt.figure(figsize=(10, 6))
    plt.bar(df["passports_count"].astype(str), df["exhibits_count"])
    plt.title("Распределение экспонатов по количеству паспортов")
    plt.xlabel("Количество паспортов у экспоната")
    plt.ylabel("Количество экспонатов")
    
    # Настройка оси Y: график начинается с 8000
    plt.ylim(bottom=8000)

    save_current_plot("q5_2d_histogram.png")


def plot_q8():
    df = load_query("q8.sql")
    df.columns = ["exhibition_name", "exhibit_status_name", "count"]

    # Отбираем первые 20 уникальных выставок, чтобы график не перегружался
    top_20_exhibitions = df["exhibition_name"].unique()[:20]
    df = df[df["exhibition_name"].isin(top_20_exhibitions)]

    exhibitions = sorted(df["exhibition_name"].unique())
    statuses = sorted(df["exhibit_status_name"].unique())
    
    bar_width_x = 0.3
    bar_width_y = 0.3

    x_pos = df["exhibition_name"].map({name: index for index, name in enumerate(exhibitions)})
    y_pos = df["exhibit_status_name"].map({name: index for index, name in enumerate(statuses)})
    z_pos = [0] * len(df)
    dx = [bar_width_x] * len(df)
    dy = [bar_width_y] * len(df)

    fig = plt.figure(figsize=(16, 10))
    ax = fig.add_subplot(111, projection="3d")
    
    # Отрисовываем 3D-бары
    ax.bar3d(x_pos, y_pos, z_pos, dx, dy, df["count"], shade=True, alpha=0.8)

    # Настройка названий осей X и Y с хорошими отступами
    ax.set_title("Количество экспонатов для каждой выставки и статуса (первые 20 выставок)", fontsize=14, pad=30)
    ax.set_xlabel("Выставка", labelpad=45, fontsize=11)
    ax.set_ylabel("Статус", labelpad=30, fontsize=11)
    
    # --- ЖЕЛЕЗОБЕТОННЫЙ ФИКС ДЛЯ ОСИ Z ---
    ax.text2D(0.92, 0.5, "Количество экспонатов", rotation=270, 
              va="center", ha="center", fontsize=11, transform=ax.transAxes)
    # -------------------------------------

    # Центрирование меток на осях
    centered_x_ticks = [index + bar_width_x / 2 for index in range(len(exhibitions))]
    centered_y_ticks = [index + bar_width_y / 2 for index in range(len(statuses))]
    
    ax.set_xticks(centered_x_ticks)
    ax.set_xticklabels(exhibitions, rotation=45, ha="right", fontsize=8)
    ax.set_yticks(centered_y_ticks)
    ax.set_yticklabels(statuses, fontsize=10)

    # Тонкая настройка оси Z и сетки
    ax.zaxis.set_tick_params(labelsize=10, pad=12)
    ax.grid(True)
    
    # Идеальный ракурс
    ax.view_init(elev=32, azim=-35)
    ax.dist = 12
    
    # Задаем верхний лимит оси Z с небольшим запасом
    max_val = df["count"].max()
    ax.set_zlim(0, max_val * 1.05)

    # Корректируем внешние отступы фигуры
    fig.subplots_adjust(left=0.08, right=0.88, bottom=0.32, top=0.88)

    save_current_plot("q8_3d_histogram.png")


PLOTS = {
    "q3": plot_q3,
    "q5": plot_q5,
    "q8": plot_q8,
}


def main():
    requested = sys.argv[1:] or ["q3", "q5", "q8"]

    for name in requested:
        plot = PLOTS.get(name)
        if plot is None:
            known = ", ".join(PLOTS)
            raise SystemExit(f"Unknown plot '{name}'. Use one of: {known}")
        plot()


if __name__ == "__main__":
    main()