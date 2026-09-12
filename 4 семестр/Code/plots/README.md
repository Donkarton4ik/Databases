# Гистограммы

Скрипт `plot_histograms.py` строит графики по запросам:

- `queries/q3.sql` -> `plots/output/q3_2d_histogram.png`
- `queries/q5.sql` -> `plots/output/q5_2d_histogram.png`
- `queries/q8.sql` -> `plots/output/q8_3d_histogram.png`

## Запуск через Docker Compose

Сначала база должна быть поднята и заполнена.

Построить все графики:

```bash
docker compose run --rm plots
```

Построить только один или несколько графиков:

```bash
docker compose run --rm plots q3
docker compose run --rm plots q5
docker compose run --rm plots q8
docker compose run --rm plots q3 q8
```

Готовые изображения появятся в `plots/output/`.

## Локальный запуск без Docker

Если PostgreSQL доступен с хоста и в окружении заданы `DB_NAME`, `DB_USER`, `DB_PASSWORD`, `DB_PORT`, можно запустить:

```bash
python plots/plot_histograms.py
```
