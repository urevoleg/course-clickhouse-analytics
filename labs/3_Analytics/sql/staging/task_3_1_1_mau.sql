select toStartOfMonth(event_time) as dated_at,
       uniqExact(login.uid) as uniq_users
from login
group by toStartOfMonth(event_time)
order by toStartOfMonth(event_time);