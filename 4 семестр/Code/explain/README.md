# EXPLAIN и время выполнения

Скрипт `explain_queries.py` запускает для SQL-файлов:

```sql
EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
```

Результаты сохраняются в `explain/output/`:

- `*_explain.json` - JSON-план PostgreSQL
- `summary.csv` - таблица со временем планирования и выполнения

Для `UPDATE`, `DELETE`, `INSERT` измерение идет внутри транзакции с `ROLLBACK`, поэтому данные не меняются.

## Запуск через Docker Compose

Все запросы `queries/**/q*.sql` (рекурсивно, по всем подпапкам):

```bash
docker compose run --rm explain
```

Один или несколько конкретных файлов — по имени, независимо от того, в какой подпапке они лежат:

```bash
docker compose run --rm explain q3
docker compose run --rm explain q5 q8
docker compose run --rm explain view2 view3
```

Готовые файлы появятся в `explain/output/`.
