select count(*)
from (SELECT uid,
            toDate(min(event_time)) as date
        FROM finance
        where is_test = 0
        GROUP BY uid
        having toDate(min(event_time)) = '2023-01-16');