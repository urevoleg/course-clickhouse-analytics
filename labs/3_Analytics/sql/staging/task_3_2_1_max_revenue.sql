SELECT argMax(toMonday(week), revenue)
FROM (select toMonday(event_time) as week,
       sum(revenue_usd) as revenue
from finance
where is_test = 0
group by toMonday(event_time));