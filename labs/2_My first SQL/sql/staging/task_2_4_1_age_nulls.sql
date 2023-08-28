select sum(isNull(toFloat64OrNull(Age)))
from titanic;