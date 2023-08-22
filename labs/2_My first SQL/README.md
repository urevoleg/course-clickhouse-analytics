# Writing first SQL queries

## Наливаем данных

1. Titanic Data description

```
Pclass — класс пассажира (1 — высший, 2 — средний, 3 — низший);
Name — имя;
Sex — пол;
Age — возраст;
SibSp — количество братьев, сестер, сводных братьев, сводных сестер, супругов на борту титаника;
Parch — количество родителей, детей (в том числе приемных) на борту титаника;
Ticket — номер билета;
Fare — плата за проезд;
Cabin — каюта;
Embarked — порт посадки (C — Шербур; Q — Квинстаун; S — Саутгемптон).
```

2. Games

```
Rank - Рейтинг общих продаж
Name - Название игры
Platform - Платформа, на которой была выпущена игра (например, PC, PS4 и т.д.)
Year - Год выпуска игры
Genre - Жанр игры
Publisher - Издатель игры
NA_Sales - Продажи в Северной Америке (в миллионах)
EU_Sales - Продажи в Европе (в миллионах)
JP_Sales - Продажи в Японии (в миллионах)
Other_Sales - Продажи в остальном мире (в миллионах)
Global_Sales - Общие мировые продажи.
```

Создаем таблицу:

```sql
CREATE TABLE video_game_sales (
    Rank UInt32,
    Name String,
    Platform String,
    Year String,
    Genre String,
    Publisher String,
    NA_Sales Float32,
    EU_Sales Float32,
    JP_Sales Float32,
    Other_Sales Float32,
    Global_Sales Float32
) ENGINE = Log
```

Загружаем данные:

```sql
INSERT INTO video_game_sales SELECT * FROM url('https://raw.githubusercontent.com/dmitrii12334/clickhouse/main/vgsale', CSVWithNames, 'Rank UInt32,
    Name String,
    Platform String,
    Year String,
    Genre String,
    Publisher String,
    NA_Sales Float32,
    EU_Sales Float32,
    JP_Sales Float32,
    Other_Sales Float32,
    Global_Sales Float32');
```

### И еще немного кастомных данных
3. Kinopoisk Parsing

Создаем таблицу:
```sql
CREATE TABLE kinopoisk_parsing_result (
    id UInt32,
    search_item String,
    search_url String,
    film_id UInt32,
    film_url String,
    film_name String,
    production_year String,
    country String,
    genre String,
    director String,
    screenwriter String,
    operator String,
    compositor String,
    painter String,
    mount String,
    budget String,
    box_office_usa String,
    box_office_world String,
    box_office_russia String,
    rating_kp_top Float,
    marks_amount_kinopoisk String,
    rating_kp_pos String,
    rating_kp_neu String,
    rating_kp_neg String,
    rating_imbd String,
    marks_amount_imbd String,
    release_world String,
    release_russia String,
    digital_release String,
    checked_at String,
    error String,
    poster_link String,
    film_descr String
) ENGINE = Log;
```

Загружаем данные:

```sql

```