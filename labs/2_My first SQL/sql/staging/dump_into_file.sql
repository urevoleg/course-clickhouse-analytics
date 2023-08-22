select arrayElement(splitByChar('_', genre), 1) as main_genre,
       count(film_id) as cnt
from kinopoisk_parsing_result
where genre is not null and genre != ''
group by arrayElement(splitByChar('_', genre), 1)
order by cnt desc
LIMIT 10
INTO OUTFILE 'top_genres.csv'
FORMAT CSVWithNames;