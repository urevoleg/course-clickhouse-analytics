select countIf(1, near_city = 'Viborg')
from (select event,
               argMin(city, dist_km) as near_city
        from (select l.event,
                        l.lat,
                        l.long,
                        c.city,
                        c.lat,
                        c.long,
                        greatCircleDistance(l.long, l.lat, c.long, c.lat) / 1000.0 as dist_km
                from log l
                cross join big_city c) d
        where d.dist_km < 300
        group by event) near_city;