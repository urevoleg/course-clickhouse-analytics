with total_sales as (select Year,
       sum(Global_Sales) as all_sales,
       sumIf(Global_Sales, Publisher in (SELECT Publisher
                                                     FROM video_game_sales
                                                     GROUP BY Publisher
                                                      ORDER BY sum(Global_Sales) desc
                                                     LIMIT 5)) as top5,
       sumIf(Global_Sales, Publisher not in (SELECT Publisher
                                                     FROM video_game_sales
                                                     GROUP BY Publisher
                                                      ORDER BY sum(Global_Sales) desc
                                                     LIMIT 5)) as not_top5
from video_game_sales
group by Year)
select arrayStringConcat(groupArray(toString(Year)), ',') as year_list
    from (select *,
       top5 - not_top5 as delta
from total_sales
where delta > 60
order by Year desc);