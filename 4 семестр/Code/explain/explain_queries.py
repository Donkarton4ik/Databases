import csv
import json
import os
import re
import sys
from pathlib import Path

import psycopg2


BASE_DIR = Path(__file__).resolve().parents[1]
QUERIES_DIR = Path(os.getenv("QUERIES_DIR", BASE_DIR / "queries"))
OUTPUT_DIR = Path(os.getenv("EXPLAIN_OUTPUT_DIR", BASE_DIR / "explain" / "output"))


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


def query_files(requested):
    if requested:
        return [find_query_file(name) for name in requested]
    return sorted(QUERIES_DIR.rglob("q*.sql"))


def normalize_query_name(name):
    return name if name.endswith(".sql") else f"{name}.sql"


def find_query_file(name):
    filename = normalize_query_name(name)
    matches = sorted(QUERIES_DIR.rglob(filename))
    if not matches:
        raise SystemExit(f"Query file not found: {filename}")
    if len(matches) > 1:
        raise SystemExit(f"Multiple query files named {filename} found: {matches}")
    return matches[0]


def read_query(path):
    return path.read_text(encoding="utf-8").strip().rstrip(";")


def safe_name(path):
    return re.sub(r"[^a-zA-Z0-9_-]+", "_", path.stem)


def run_explain(conn, query):
    with conn.cursor() as cur:
        cur.execute("BEGIN")
        cur.execute(f"EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON) {query}")
        raw_json_plan = cur.fetchone()[0]
        cur.execute("ROLLBACK")

    return raw_json_plan[0] if isinstance(raw_json_plan, list) else raw_json_plan


def save_json_plan(name, json_plan):
    target = OUTPUT_DIR / f"{name}_explain.json"
    target.write_text(json.dumps(json_plan, ensure_ascii=False, indent=2), encoding="utf-8")
    return target


def collect_summary(query_name, json_plan):
    plan = json_plan["Plan"]
    return {
        "query": query_name,
        "planning_time_ms": json_plan.get("Planning Time", 0),
        "execution_time_ms": json_plan.get("Execution Time", 0),
        "total_time_ms": json_plan.get("Planning Time", 0) + json_plan.get("Execution Time", 0),
        "top_node": plan.get("Node Type", ""),
        "estimated_rows": plan.get("Plan Rows", ""),
        "actual_rows": plan.get("Actual Rows", ""),
    }


def save_summary(rows):
    target = OUTPUT_DIR / "summary.csv"
    with target.open("w", encoding="utf-8", newline="") as file:
        writer = csv.DictWriter(file, fieldnames=rows[0].keys())
        writer.writeheader()
        writer.writerows(rows)
    return target


def main():
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    files = query_files(sys.argv[1:])
    summaries = []

    with get_conn() as conn:
        conn.autocommit = False
        for path in files:
            if not path.exists():
                raise SystemExit(f"Query file not found: {path}")

            name = safe_name(path)
            query = read_query(path)
            json_plan = run_explain(conn, query)

            json_target = save_json_plan(name, json_plan)
            summary = collect_summary(path.name, json_plan)
            summaries.append(summary)

            print(
                f"{path.name}: planning={summary['planning_time_ms']:.3f} ms, "
                f"execution={summary['execution_time_ms']:.3f} ms"
            )
            print(f"  json:   {json_target}")

    summary_target = save_summary(summaries)
    print(f"Summary: {summary_target}")


if __name__ == "__main__":
    main()
