select toInt32(exp(sum(log(PassengerId))))
from titanic
where PassengerId < 10;