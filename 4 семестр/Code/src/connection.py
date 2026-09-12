import os
import psycopg2
from dotenv import load_dotenv


#load_dotenv(dotenv_path="../.env")


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