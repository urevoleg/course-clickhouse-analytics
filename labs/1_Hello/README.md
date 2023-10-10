# Chapter 1 - Greating with clickhouse

1. Installation

[Link to instruction]()

2. Connect to `clickhouse-server`

Use various clients:
- [Dbeaver](https://clickhouse.com/docs/en/integrations/dbeaver)
- [curl](https://clickhouse.com/docs/ru/interfaces/http)
- [Python](https://github.com/mymarilyn/clickhouse-driver)
- [PyCharm](https://www.jetbrains.com/help/pycharm/clickhouse.html#connect-to-clickhouse-database)

3. Create table

```sql
CREATE TABLE titanic 
    (PassengerId Int64, 
    Survived Int8, 
    Pclass Int16, 
    Name String, 
    Sex String, 
    Age String, 
    SibSp  Int8, 
    Parch Int32, 
    Ticket String, 
    Fare String, 
    Cabin  String, 
    Embarked  String)
ENGINE=TinyLog;
```

4. Load data from URL

```sql
INSERT INTO titanic SELECT * FROM url('https://raw.githubusercontent.com/dmitrii12334/clickhouse/main/titanic', CSVWithNames, 'PassengerId Int64, Survived Int8, Pclass Int16, Name String, Sex String, Age String, SibSp Int8, Parch Int32, Ticket String, Fare String, Cabin  String, Embarked  String');
```

5. Check your data

```sql
SELECT *
FROM titanic
```

if you see (like PyCharm screen):
![pycharm_click_test.png](..%2F..%2Fimg%2Fpycharm_click_test.png)

or you see (like DBeaver screen):
![dbeaver_click_test.png](..%2F..%2Fimg%2Fdbeaver_click_test.png)

Congrats, you are superhero!

![superhero-clickhouse.jpg](..%2F..%2Fimg%2Fsuperhero-clickhouse.jpg)
