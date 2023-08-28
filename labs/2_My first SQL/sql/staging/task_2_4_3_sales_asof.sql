-- , 'PS3', 'Wii', 'X360'
with t1 as (select Platform,
                   toInt32(Year) as Year,
                   sum(Global_Sales) as cur_sale
from (select * from video_game_sales where toInt32OrNull(Year) is not null) t1
where Platform in ('PS2', 'PS3', 'Wii', 'X360')
group by Platform, t1.Year
order by Year),
main as (select t1.Platform,
       t1.Year,
       t2.Year,
       t1.cur_sale,
       t2.cur_sale,
       t1.cur_sale - t2.cur_sale as diff
from t1
asof left join t1 as t2
on t1.Platform = t2.Platform and t1.Year > t2.Year
where t2.Year != 0
order by t1.Year)
select round(abs(sum(diff)), 0) from main;