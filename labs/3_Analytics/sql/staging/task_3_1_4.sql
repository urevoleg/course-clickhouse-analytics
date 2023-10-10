with logins as (select uid,
                       toMonday(min(event_time)) as first_login_date
                from login
                group by uid),
buyers as (select *,
                  toMonday(event_time) as buy_date
           from finance
           where is_test = 0)
select l.first_login_date as week,
       uniq(l.uid) as new_users,
       countif(distinct b.uid, b.uid != 0) as new_pay_users
from logins l
left join buyers b
on l.uid = b.uid
group by l.first_login_date;
