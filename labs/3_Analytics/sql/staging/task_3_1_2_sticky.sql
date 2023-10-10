select avg(sticky) as avg_sticky
from (select toDate(event_time) as dated_at,
               uniqExact(login.uid) / (select  uniqExact(login.uid) as mau from login where toStartOfMonth(event_time) == '2023-01-01') as sticky
        from login
        where toStartOfMonth(event_time) == '2023-01-01'
        group by toDate(event_time)
        order by toDate(event_time));