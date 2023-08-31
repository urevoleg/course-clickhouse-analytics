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

---------------------------------------------
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

------------------------------------
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

Существует два типа:
- `Date` - хранит только дату
- `DateTime` - хранит дату и время и можно еще с указанием таймзоны, например, `DateTime('Europe/Moscow')`

В столбец типа `DateTime` можно вставлять дату в формате timestamp (123456789) или текст формата `2020-02-01 01:01:01` - 
распарсится само. Сложные текстовые форматы вставляются строкой, есть отдельные функции для пасинга.

Например, одна из фукнций для парсинга:
- `parseDateTimeBestEffort`

Также существует множество функций для работы с различными периодами (день, год) и разницами дат:
- `toYear` - вернет год
- `toStartOfWeek` - преобразует дату к началу недели, по-умолчанию, возвращает дату воскресенья, если необходим понедельник, то
пишем `toStartOfWeek(date_columns, 1)`
- для вывода текущей даты используйте `now()`, дня `today()`
- для разницы дат `date_diff`


### Tasks

1.
```
В финансовом отчете Google Play есть таблица earnings она хранит список транзакций 
по каждой покупке, однако время и дата в данной таблице хранятся не в самом удобном виде.

Формат ответа:
В качестве ответа приведите transaction_id с самой большой датой, 
отсортируйте в порядке убывания по дате, первая строка будет ответом.
```

![datetime_tasks_parse.png](..%2F..%2Fimg%2Fdatetime_tasks_parse.png)


Создаем таблицу для данных:

```sql
CREATE TABLE transactions_log (
    transaction_id String,
    transaction_date String,
    transaction_time String,
    tax_type String,
    transaction_type String,
    refund_type String,
    product_name String,
    product_id String
) ENGINE = Log;
```

Заполняем данными - выполняем скрипт [script_1_2_2.sql](sql%2Fstaging%2Fscript_1_2_2.sql)

Тестовая VIEW
```sql
create view transactions_log_view as select * from transactions_log order by transaction_id limit 50;
```

Проверка тестом:
![datetime_google_play_task.png](..%2F..%2Fimg%2Fdatetime_google_play_task.png)

Скрипт ответа [task_datetime_parse_answer.sql](sql%2Fstaging%2Ftask_datetime_parse_answer.sql)

-------------------------------------

## Агрегация данных

Тревиальные вещи:
- `GROUP BY`
- `HAVING` - для фильтрации результата агрегации

Нетривально наличие [комбинаторов](https://clickhouse.com/docs/ru/sql-reference/aggregate-functions/combinators) - 
специальные дополнения для агрегирующих функций, которые расширяют возможности, например:
- `sum -> sumIf(column, cond)` - сумма будет выполнятся только для тех значений, где `cond==True`

Это позволяет избегать лишних JOIN или subqueries.


### Task

1. 
```
Мы с вами уже изучали функцию SUM для группировок, 
однако такой же функции для произведения не существует, вам необходимо написать скрипт который будет перемножать числа в столбце. Можно использовать только математические функции. 
Вам нужно вспомнить про численный тип данных и школьную математику, а точнее логарифмы.

Результат
В ответ впишите произведение чисел столбца PassengerId Ответ округлить вниз. Для запроса выше
```

```sql
select # ваш код #
from titanic 
where PassengerId < 10
```

Напрягли 🤯 и вспомнили свойства логарифмов. Ответ искать [task_prod.sql](sql%2Fstaging%2Ftask_prod.sql)


2. 
```
Описание задачи:

Посчитайте сумму продаж по Global_Sales по всем издателям, кроме топ 5 по продажам за все время . 
Задачу можно решить с помощью not in (select ... from ...) для того чтобы исключить лишних издателей.
Для начала вам нужно найти всех издателей которые входят 
в топ 5 по продажам за все время, после чего исключить их из выборки и посчитать сумму по Global_Sales

Формат ответа:

В качестве ответа введите число без округления
```

Ответ тут [task_2_sum_global_exclude_top_publisher.sql](sql%2Fstaging%2Ftask_2_sum_global_exclude_top_publisher.sql)

3. 
```
Описание задачи:
Перечислите через запятую в порядке убывания: в какие годы топ 5 издателей по продажам за все время превышали 
продажи Global_Sales всех остальных более чем на 60 Ссылка на описание датасета. 

Подсказка: в комбинатор функций можно вставлять подзапросы sumIf( Global_Sales, publisher not in (SELECT ...))

План запроса:
Первый столбец - год 
Второй - продажи топ 5 издателей 
Третий - продажи кроме топ 5 издателей 
Четвертый - посчитайте разницу между 2 и 3 
Отсортируйте результаты по годам и оставьте только те что удовлетворяют условию >60
```

Тестовый VIEW:

```sql
create view video_game_sales_view as select * from video_game_sales limit 200;
```

Проверочный ответ:
![task_3_global_sales.png](..%2F..%2Fimg%2Ftask_3_global_sales.png)

Верный скрипт [task_3_global_sales.sql](sql%2Fstaging%2Ftask_3_global_sales.sql)

В ходе решения использованы:
- `groupArray` - комбинатор `Array`
- `arrayStringConcat` - склейка строковых представлений элементов массива

-----------------------------------
## Подзапросы и CTE

В clickhouse реализована конструкция `WITH`, но она имеет особенности:
- исключается рекурсия
- таким образом можно передать константу
- при обращении к CTE каждый раз происходит пересчет данных
- ```
   WITH долгое время не было в КХ, а когда его добавили он не умел использовать таблицы, 
  только численные значения, поэтому в нем не было смысла
  ```
  По этой причине существует практика сложившаяся при использовании ClickHouse для многих аналитических команд разработки, 
это избегать WITH и писать с помощью подзапросов. Ломаем антипаттерн💪 (хотя пересчет данных каждый раз при использовании CTE - это **жирный** минус)

-----------------------------
## Тип данных NULL, NaN и INF

![nan_null_inf.png](..%2F..%2Fimg%2Fnan_null_inf.png)

### Null

Особенности:
- при создании таблицы можно обернуть тип данных вот так `Nullable(Int64)` - что даёт возможность использовать Null.
- Для хранения используются отдельные файлы с пометкой о Null - маска

**Почти всегда использование `Nullable` снижает производительность, учитывайте это при проектировании своих баз.**


### NaN\Inf

**NaN** - число с плавающей точкой Float, характеризует **НЕ ЧИСЛО**

**Inf** - бесконечность

![inf.png](..%2F..%2Fimg%2Finf.png)

### Tasks

1.
```
Используя toFloat64OrNull, посчитать сколько пропущенных значений в столбце Age
```

Скрипт ответа [task_2_4_1_age_nulls.sql](sql%2Fstaging%2Ftask_2_4_1_age_nulls.sql)

-----------------------
## JOIN

![join.png](..%2F..%2Fimg%2Fjoin.png)

Тут без сюрпризов:
- `inner`
- `left\left`
- `full`
- `cross`

Есть нюансы с использование `ANY JOIN` - оператор ANY отключает декартово произведение, то есть не будет повторов по колонке по которой происходит объединение, 
из нескольких одинаковых строк будет выбрана первая попавшаяся.

### Tasks

1. 
```
Для начала простой запрос на JOIN. 
У нас есть таблица с выручкой в рублях и таблица с курсом USD-RUB. 
Объедините данные и посчитайте выручку в долларах.    
```

![task_2_4_1_usd_rub.png](..%2F..%2Fimg%2Ftask_2_4_1_usd_rub.png)

Скрипт подготовки таблиц [data_task_2_4_1.sql](sql%2Fmigrations%2Fdata_task_2_4_1.sql)

Решение [task_2_4_1_usd_rub.sql](sql%2Fstaging%2Ftask_2_4_1_usd_rub.sql)

2. 
```
Описание задачи:

Попрактикуемся в использовании CROSS JOIN, 
ваша задача реализовать столбец rank который назначает порядок числу из числового столбца, пример ниже. Данную задачу часто дают на собеседованиях. Решается через CROSS JOIN и GROUP BY . 
Пользоваться массивами или оконными функциями в данном задании нельзя.
```

![task_2_4_2_cross_join.png](..%2F..%2Fimg%2Ftask_2_4_2_cross_join.png)

Немного 🤯 и решение готово [task_2_4_2_rank.sql](sql%2Fstaging%2Ftask_2_4_2_rank.sql)
  

### Редкие типы JOIN

- `SEMI JOIN` - объединяем все совпадающие строки из левой и правой таблицы, но если в правой таблице есть 2 строки которые должны быть соединены с левой, 
то не происходит декартово произведение и случайным образом выбирается только 1 строка. 
- `ANTI JOIN` - берем левую таблицу и оставляем всё что не было найдено в правой.
- `ASOF JOIN` - нечеткий JOIN
Данный механизм слияния таблиц будет объединять таблицы по ближайшему значению.

Особенности ASOF JOIN:
- Должен содержать упорядоченную последовательность.
- Может быть одного из следующих типов: Int, UInt, Float, Date, DateTime, Decimal.
- Не может быть единственным столбцом в секции JOIN.

Данные для тестирования ASOF [data_asof_join.sql](sql%2Fmigrations%2Fdata_asof_join.sql)

Выполнив запрос:

```sql
select *,
       t2.dt
from join_table1 t1
asof left join join_table2 t2
using(id, dt);
```

Получаем, для второй записи с id=3, для 4 января получаем нечеткое объединение с 3 января:

![asof_join.png](..%2F..%2Fimg%2Fasof_join.png)

### Tasks

1.
```
Описание задачи:
Давайте оценим как менялись глобальные продаже от года к году для приставок PS3, PS2, X360, Wii.

Нужно посчитать какие были продажи за каждый год после чего отфильтровать строки с пустым годом. 
Далее нужно объединить таблицу саму с собой так чтобы данные за ближайший предыдущий 
(возможно в данных есть пропуски, не обращайте на это внимания) год были в текущем.

Формат ответа:
После чего просто возьмите сумму от столбца разницы текущего и предыдущего года. 
У вас получится отрицательное число, впишите ответ по модулю округленный до целого числа.
```

Тестовая VIEW

```sql
create view video_game_sales_view as select * from video_game_sales limit 200;
```

Проверка
![task_2_4_3_diff_sales.png](..%2F..%2Fimg%2Ftask_2_4_3_diff_sales.png)

Скрипт решения [task_2_4_3_sales_asof.sql](sql%2Fstaging%2Ftask_2_4_3_sales_asof.sql)

**UPD** Кажется, что оптимальнее и чуть прозрачнее делать так:
```sql
asof join t1 as t2
on t1.Platform = t2.Platform and t1.Year > t2.Year
```

### UNION

Есть только один нюанс, для исключения дублирующихся строк используется `UNION DISTINCT`


## Control task

```
В данном задании нам нужно будет вычислить вероятность 
выжить на Титанике для различных групп пассажиров и выяснить сколько людей 
из тех у кого были самые маленькие шансы на спасение в итоге выжил. 
Задание большое! Шаги которые нужно выполнить для этого:

Для начала нужно выделить столбцы по которым будем считать вероятность выживет пассажир или нет: Pclass, Sex, Age
Для поля Age нам нужно преобразовать тип во Float после чего заполнить пустые значения, сделать это нужно следующим способом: заполнить средним значением avg (без учета пустых значений).
На выходе вы должны получить таблицу с такими полями: Pclass, Sex, Age, Survived
Для поля Age воспользуйтесь функцией roundAge() для округления до различных возрастных групп
После чего посчитайте вероятность выжить по полям Pclass, Sex, Age.  Вероятность выжить считается по формуле 

x= count(AllUser)/count(SurvivedUser) по конкретной группе
  
Сделайте дополнительный столбец в котором те у кого вероятность выжить > 0.1 называются lucky остальные именуются other
Далее объедините полученные данные с таблицей Титаник чтобы выяснить какие шансы выжить ест ьу каждого пассажира в отдельности.
После чего посчитайте количество other кому удалось выжить
Полученное значение будет ответом
```

Тестовая VIEW

```sql
create view titanic_view as select * from titanic order by PassengerId limit 200;
```

Проверка
![chapter_2_final_titanic.png](..%2F..%2Fimg%2Fchapter_2_final_titanic.png)

Решение [final_task_chapter_2_titanic_prob.sql](sql%2Fstaging%2Ffinal_task_chapter_2_titanic_prob.sql)


## Массивы. Часть 1

Из интересного:
- если необходимо создать столбец массива, то тип `Array(UInt64)`
- массив - это набор элементов одного типа
- `tokens` - функция позволяет разбиваться строки, используя в качестве разделителя не буквенно-цифровые символы ASCII

### Tasks

```
Описание задачи:
Для таблицы Титаник. Давайте посмотрим кто из пассажиров заселился в несколько номеров. Для этого

Разобьем колонку Cabin на массив значений
Отсортируйте по размеру массива по убыванию
Например из C23 F C25 C27 получаем [23, "F", 25, 27]

Формат ответа:
В качестве ответ впишите номер билета по которому куплено больше всего номеров.
```

Решение [task_2_5_1_arrays.sql](sql%2Fstaging%2Ftask_2_5_1_arrays.sql)

---------------------------------
## Массивы. Часть 2

Готовим окружение [make_table_and_data_array_p2.sql](sql%2Fmigrations%2Fmake_table_and_data_array_p2.sql)

Из тренировок:
```sql
select food_type,
       arrayFilter(x-> x > 10, arrayMap(x-> toFloat32(replaceRegexpAll(x, 'мл|г', '')), groupArray(count_0_2)))
from food
group by food_type;
```

Узнаем полезные функции:
- `groupArray` - собирает элементы в массив (такое мы видели уже в Postgres)
- `replaceRegexpAll` - классика обработки строк, замена паттерна на что-то
- `arrayMap\arrayFilter` - как Python-lambda, только в clickhouse, не иначе магия 🧙‍♀️
синтаксис 

```sql
arrayMap(x-> function(x), array)
```

- `arrayJoin` -  разворачивает массив в строки, аналогично [pandas.DataFrame.explode](https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.explode.html)

![arrayJoin_demo.png](..%2F..%2Fimg%2FarrayJoin_demo.png)

- и еще есть много полезных функций `arraySort\arrayDifference\arrayCumsum\arrayEnumerate` и др

### Tasks

```
Описание задачи:
У нас есть таблица с событиями пользователей в мобильном приложении, но как это обычно бывает в жизни, не все события доходят до нашей таблицы, и это большая проблема, так как мы не можем корректно оценить последовательность действий совершенных пользователем. Однако для части событий мы можем решить эту проблему.
Допустим наш пользователь пытается купить что то на сайте, и мы точно знаем что он не сможет сделать новый шаг без завершения предыдущего. Исходя из этого мы можем сгенерировать последовательность шагов для каждого пользователя (в свое время я решал такую задачу для заполнения пропусков в таблице чтобы потом это можно было использовать для построения прогнозов).

Ваша задача в этом задании заполнить данные которые пропущены, у нас есть uid (пользователь) и step_ (имя шага, события). Шаги помечены номерами, они соответствуют последовательности действий, то есть идут друг за другом. Но часть из них пропущена, нужно их проставить. Нам известно что у нас 9 пользователей, и такая последовательность шагов

step a (1 шаг)
step b
step c
step d
step e
step f
step g
step w (последний шаг)
У каждого пользователя максимальный шаг свой! В задании не нужно использовать CROSS JOIN

Формат ответа:
В качестве ответа нужно указать сумму по столбцу UID
```

Окружение [make_view_and_data_2_5_2_events.sql](sql%2Fmigrations%2Fmake_view_and_data_2_5_2_events.sql)


Пример, решения:

![task_2_5_2_example.png](..%2F..%2Fimg%2Ftask_2_5_2_example.png)


Решение [task_2_5_2_aarays.sql](sql%2Fstaging%2Ftask_2_5_2_aarays.sql)

------------------------------
## Оконные функции

![window_functions_in_click.png](..%2F..%2Fimg%2Fwindow_functions_in_click.png)

Оконные функции подвезли не так давно, но тут ни чего нового, всё работает как и в Postgres.

Можно сходить поглядеть в [доку](https://clickhouse.com/docs/en/sql-reference/window-functions#moving--sliding-average-per-3-rows)

#### Offtop

При гулянии по доке clickhouse нашлась забавная фукнция [bar](https://clickhouse.com/docs/ru/sql-reference/functions/other-functions#function-bar), она позволяет
строить столбчатые диаграммы в консоли 🤘:

![bar_function.png](..%2F..%2Fimg%2Fbar_function.png)

## Tasks

```
Описание задачи:
Для таблицы Титаник, посчитайте шансы выжить для каждого пользователя исходя 
из его пола и класса 

Формат ответа:
В качестве ответа впишите имя пассажира у которого шанс выжить больше всего, 
отсортируйте по имени если таких пассажиров несколько [A -> Z]. 
Нельзя использовать JOIN Только оконные функции.
```

Решение [task_2_5_3_titanic_surv.sql](sql%2Fstaging%2Ftask_2_5_3_titanic_surv.sql)

В процессе решения выяснилось, что нельзя делить одну оконку на другую, например, так:

```sql
sum(1) over(partition by date) / count(1) over(partition by date)
```
Вылетает ошибка `UNKNOWN IDENTIFIER`🤷‍♂️

-------------------------------
## Аналоги оконных функций

До появления оконок в клике были некоторые аналоги функций, например:
- `neighbor` - сдвиг аналогично `lag\lead`
- `rowNumberInBlock` - типа `row_number` только не для `PARTITION`, а для некоторого блока (узнаем позже)
- `runningDifference` - разница между текущей и предыдущей (для первой будет 0)

### Tasks

```
Описание задачи:

В нашем распоряжении таблица с логинами пользователей в наше приложение, 
мы снимаем лог каждые 5 минут если пользователь был в сети. 
Получается таблица примерно такого вида
```
![task_2_5_4_sessions.png](..%2F..%2Fimg%2Ftask_2_5_4_sessions.png)

```
Если разница между двумя заходами больше 5 минут, 
то значит пользователь начал новую сессию. 
Ваша задача разметить все сессии для каждого пользователя, то есть каждой сессии назначить номер от 1 до N.
Каждая новая сессия нового пользователя должна начинаться с 1 
```

Готовим окружение [make_data_2_5_4_sessions.sql](sql%2Fmigrations%2Fmake_data_2_5_4_sessions.sql)

Решение [task_2_5_4_sessions.sql](sql%2Fstaging%2Ftask_2_5_4_sessions.sql)

--------------------------------
## Другие составные типы данных

