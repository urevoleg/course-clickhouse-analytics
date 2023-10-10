/*
 Задача решается через lifetime
 0 - это первый день, день когда пришла когорта
 2 - это третий день для обычного Retention
 3+ - это Roll_Ret_3day
 */
select first_reg_date,
       uniqIf(uid, date_diff('day', first_reg_date, toDate(event_time)) = 0) as reg_user,
       uniqIf(uid, date_diff('day', first_reg_date, toDate(event_time)) = 2) as users_day3,
       users_day3 / reg_user as ret_day3,
       uniqIf(uid, date_diff('day', first_reg_date, toDate(event_time)) >= 3) as roll_users_day3,
       roll_users_day3 / reg_user as roll_ret_day3,
       1 - roll_users_day3 / reg_user as roll_churn_day3
from login
any left join (SELECT uid,
                     min(toDate(event_time)) as first_reg_date
              FROM login
              GROUP BY uid) t2
using uid
group by first_reg_date;