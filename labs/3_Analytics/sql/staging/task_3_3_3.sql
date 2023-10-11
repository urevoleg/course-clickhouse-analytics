/*
 Через lifetime
необходимо писать так
 sumIf(price_usd, toDate(event_time) <= 3 + first_reg_date) === umIf(price_usd, date_diff('day', first_reg_date, toDate(event_time)) <= 3)
 */
select first_reg_date,
       uniqIf(uid, date_diff('day', first_reg_date, toDate(event_time)) = 0) as reg_user,
       uniqIf(uid, date_diff('day', first_reg_date, toDate(event_time)) = 2) as users_day3,
       users_day3 / reg_user as ret_day3,
       uniqIf(uid, date_diff('day', first_reg_date, toDate(event_time)) >= 3) as roll_users_day3,
       roll_users_day3 / reg_user as roll_ret_day3,
       1 - roll_users_day3 / reg_user as roll_churn_day3,
       uniqIf(uid, price_usd>0) as payed_users,
       uniqIf(uid, price_usd>0)/reg_user,

      sumIf(price_usd, toDate(event_time) <= 3 + first_reg_date) as rev_day_3, -- выручка когорты на 3 день жизни
      sumIf(price_usd, toDate(event_time) <= 7 + first_reg_date) as rev_day_7, -- выручка когорты на 7 день жизни
      sumIf(price_usd, toDate(event_time) <= 10 + first_reg_date) as rev_day_10, -- выручка когорты на 10 день жизни
      sumIf(price_usd, toDate(event_time) <= 15 + first_reg_date) as rev_day_15, -- выручка когорты на 15 день жизни

      rev_day_3 / reg_user as CARPU3,
      rev_day_7 / reg_user as CARPU7,
      rev_day_10 / reg_user as CARPU10,
      rev_day_15 / payed_users as CARPPU15
from (
    SELECT
        event_time
        , 'login' as event_type
        , uid
        , 0 as price_usd
    FROM login
    UNION ALL
    SELECT
        event_time
        , 'finance' as event_type
        , uid
        , revenue_usd as price_usd
    FROM finance
    WHERE is_test = 0
     ) t1
any left join (SELECT uid,
                     min(toDate(event_time)) as first_reg_date
              FROM login
              GROUP BY uid) t2
using uid
group by first_reg_date;
