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