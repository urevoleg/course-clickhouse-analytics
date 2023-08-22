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

3.1 [Download data](https://github.com/urevoleg/course-clickhouse-analytics/tree/main/data)
3.2 Копируем данные в папку `/var/lib/clickhouse/user_files` (clickhouse поднят в докере)

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

Загружаем данные из локального файла:

```sql
INSERT INTO kinopoisk_parsing_result
SELECT * FROM file('/var/lib/clickhouse/user_files/kinopoisk_parsing_clear.csv', CSV, 'id UInt32,
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
    film_descr String');
```

## Интересные особенности Clickhouse

Clickhouse поддерживает все основные SQL команды:
- `SELECT`
- `FROM`
- `JOIN`
- `GROUP BY`
- `LIMIT`
- `ORDER BY`
- `WHERE`
- `HAVING`
- `WITH`
- `UNION`
- и др

Также содержит специфически интересные интструменты:
- `SAMPLE` - семплирование, позволяет выполнять расчеты приближенно
- `PREWHERE` - это оптимизация для более эффективного применения фильтрации. Она включена по умолчанию, даже если секция PREWHERE явно не указана. 
В этом случае работает автоматическое перемещение части выражения из WHERE до стадии prewhere
- `ANY\ALL` - выбирает первое попавшееся значения\Если в таблице несколько совпадающих строк, то ALL возвращает все из них. Поведение запроса SELECT ALL точно такое же, как и SELECT без аргумента DISTINCT.
- `AS OF`

☝️UPPER\lower CASE не имеет значения для стандартных команд языка SQL, но вариат написания специфических фукнций должени соблюдаться, например:
`JSONExtractString` != `jsonsxtractstring` 

**Выгрузка в файл**

```sql
SELECT * # Выбор столбцa
FROM table1 # Из какой таблицы
ORDER BY id DESC # Обратная сортировка
LIMIT 5 # Обрезаем сверху
INTO OUTFILE filename # Выгрузка в файл
FORMAT CSVWithNames # Формат выходного файла
```

Пробуем - `sql/staging/dump_into_file.sql`

Команда `INTO OUTFILE` имеет особенности:
- функция доступна только в следующих интерфейсах: клиент командной строки и clickhouse-local. Таким образом, запрос, отправленный через HTTP интерфейс вернет ошибку.
- запрос завершится ошибкой, если файл с тем же именем уже существует.
- По умолчанию используется выходной формат TabSeparated (как в пакетном режиме клиента командной строки). 
- Его можно изменить в секции FORMAT

Чтобы поэкспериментировать:
1. Заходим в clickhouse

```
docker exec -it clickhouse-server /bin/bash
```

2. Переходим в директорию пользовательских файлов

```
cd //var/lib/clickhouse/user_files
```

3. Сохраняем запрос из `sql/staging/dump_into_file.sql` в файл `top_genres.sql`

```
nano top_genres.sql # вставляем текст запроса и сохраняем
```

4. Выполняем из локального клиента (устанавливается по-умолчанию)

```
clickhouse-client --user your_user_name --password your_user_pass --queries-file top_genres.sql
```

Проверяем файл с данными, всё на месте:
![into_outfile_top_genres.png](..%2F..%2Fimg%2Finto_outfile_top_genres.png)

 Популярные жанры: драма\комедия\боевик, как говорится, хлеба и зрелищ =)


Теперь мы на один шажок ближе к магии:
![magic.gif](..%2F..%2Fimg%2Fmagic.gif)


### Tasks

1. 
```В таблице titanic найти имя человека который\
Женщина
Первый класс 
Не выжила
В ответе указать человека с самым большим ID
```

```sql
SELECT PassengerId,
       Name
FROM titanic
WHERE Sex = 'female'
and Pclass = 1
and Survived = 0
ORDER BY PassengerId desc
LIMIT 1;
```

2
```В таблице titanic найдите имя человека  
Который не выжил
Отсортируйте по имени [A->Z]
В решении использовать ORDER BY и LIMIT

В качестве ответа укажите имя человека который будет на первом месте после сортировки.
```

```sql
SELECT Name
FROM titanic
WHERE Survived = 0
ORDER BY Name asc
LIMIT 1;
```

## Условные и логические операторы

Помимо `CASE WHEN` в Clickhouse реализованы:
- продвинутый оператор `If(cond, then, else)`: оба выражения будут вычислены (и cond и then)
- `multiIf(cond1, then1, cond2, then2, ...., else)`. 

Для условных конструкций доступно использование операторов `AND, OR`, например:

```sql
If(Pclass='1' OR Pclass='2', 'rich_person', 'cheap_person')
```

### Tasks

1. 
```
В таблице titanic разметить пассажиров и найти человека по условию

Создать дополнительный столбец chance_survived в котором

Пассажир который женщина 1 или 2 класса мы будем считать lucky (больше шансов выжить)
Пассажир который женщина 3 класса мы будем считать fortunate (очевидно что шансов меньше, но они есть)
Для остальных просто оставьте other
Найти имя человека который

В имени присутствовало Miss
Оканчивался текст a
Начинался текст с L
В качестве ответа написать имя пассажира, который оказался lucky с самым большим PassengerId   
```

```sql
select Name,
       multiIf(Sex='female' and Pclass in (1, 2), 'lucky', Sex='female' and Pclass=3, 'fortunate', 'other') as chance_survived
from titanic
where Name like '%Miss%' and Name like '%a' and Name like 'L%'
and chance_survived = 'lucky'
order by PassengerId desc
limit 10;
```

## Работа со строками

Функций реализовано много, из "потроганных":
- `length` - длина строки
- `uppper` - приведение к ВЕРХНЕМУ регистру, есть с указанием кодировки `upperUTF8`
- `substring(str, start, end)` - обрезание строк по байтам, есть с указанием кодировки `substringUTF8`
- `concat` - слияние строк
- `position(str, pattern)` - возвращает позицию с которой наблюдается данный паттерн
- `match(str, pattern)` - проверка _есть или нет pattern_  в указанной строке
- `extract(str, pattern)` - извлечение указанного паттерна из строки
- `replaceAll(str, что заменять, на что заменять)` - замена подстрок

Для решения задачи потребовалось:
- `endsWith(str, ends)`
- `arrayElement(array, index)` - получить элемент из массива по индексу
- `splitByChar(split_char, str)` - разделить строку на части, возвращает массив


### Tasks

1. 
```
Описание задачи:
Знали ли вы, что на борту Титаника находилось некоторое количество пассажиров из Восточной Европы? 
Давайте попробуем найти их.
Для этого нужно выделить из поля Name с помощью регулярных выражений первую часть имени человека до Mr или Miss (деление по , ) и проверить, оканчивается ли она на off или eff (проверяем только суффикс, даже если там сложное имя). В этом может помочь функция endsWith(..), а также возможность использовать условные функции где угодно, например так: or(x=1, y=2)

Формат ответа:
Отсортировать по имени [A->Z] в качестве ответа выписать первую фамилию в списке. Эту задачу можно также решить с помощью регулярных выражений, вы можете самостоятельно выбрать способ решения.   
```

Для теста запроса создаётся VIEW

```sql
create view titanic_view as select * from titanic order by PassengerId LIMIT 300 OFFSET 300;
```

Правильный ответ корреткного запроса к задаче на тестовой выборке: **Coleff**

```sql
select arrayElement(splitByChar(',', Name), 1) as first_name_part
from titanic
where or(endsWith(first_name_part, 'off'), endsWith(first_name_part, 'eff'))
order by Name
limit 1;
```

### Типы строк

В Clickhouse реализованы дополнительные типы для хранения строк:
- `FixedString` - строка ограниченной длины (ограничение занимаемого места)
- `LowCardinality` - хранит цифровое представление строк и отдельно словарь, например:

Для такой колонки:
```
| str |
|-----|
| RU  |
| JP  |
| JP  |
| JP  |
| ES  |
| ES  |
| RU  |
```

Можно хранить данные в таком виде:
```
|str |
|----|
| 1  |
| 2  |
| 2  |
| 2  |
| 3  |
| 3  |
| 1  |

И отдлеьно словарь

{'RU': 1, 'JP': 2, 'ES': 3}
```

У типа `LowCardinality` есть нюансы, читать в [доке](https://clickhouse.com/docs/ru/sql-reference/data-types/lowcardinality)

Функции для работы со строками аналогичны для всех строковых типов + существуют методы преобразования одного типа в другой.

## Числа

Основные типы для хранения чисел это Int64, UInt64, Float64, Decimal64, Bool.

Приставка 32\64\... означает размер, который может хранить данный тип, например, Int8 = 2^8 = 256. Приставка `U` - означает `unsigned` - 
то есть беззнаковое число, Uint8 (0, 255), тогда как Int8(-127, 128).

Как и положено для вещественных чисел `Float` существует ошибка округления, для фиксации существует тип `Decimal` (стоит учитывать, что он медленнее),
сравните два вывода ниже:

![float_decimal.png](..%2F..%2Fimg%2Ffloat_decimal.png)

Для всех типов есть возможность добавить суффикс `..orNull\orZero` - это позволяет обрабатывать ошибки при преобразованиях.

## Дата и время

![2-file_2019_06_19_11_42_59.jpg](..%2F..%2Fimg%2F2-file_2019_06_19_11_42_59.jpg)

