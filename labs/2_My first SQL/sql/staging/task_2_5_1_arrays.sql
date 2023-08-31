select Ticket,
       Name,
       splitByChar(' ', Cabin)
from titanic
order by length(splitByChar(' ', Cabin)) desc;