select max(ccu.ccu) as pcu
from (select toStartOfFiveMinute(event_time) as period,
       uniqExact(uid) as ccu
from login
group by toStartOfFiveMinute(event_time)
order by period) ccu;