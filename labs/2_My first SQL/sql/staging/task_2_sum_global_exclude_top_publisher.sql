select toInt32(sumIf(Global_Sales, Publisher not in (SELECT Publisher
                                                     FROM video_game_sales
                                                     GROUP BY Publisher
                                                      ORDER BY sum(Global_Sales) desc
                                                     LIMIT 5)))
from video_game_sales;