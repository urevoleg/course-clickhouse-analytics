with s as (select *
           from login
           order by id, date)
select id,
       mark,
       sum(mark) over(partition by id order by date) as session
from (select *,
       neighbor(date, -1),
       multiIf(toUnixTimestamp(date) - toUnixTimestamp(neighbor(date, -1)) > 300, 1,
           toUnixTimestamp(date) < toUnixTimestamp(neighbor(date, -1)), 1, 0) as mark
from s);