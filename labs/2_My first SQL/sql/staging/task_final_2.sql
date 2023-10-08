select argMin(c.city, greatCircleDistance(c.longitude, c.latitude, m.mks_long, m.mks_lat)) as near_city
from cities c
cross join (select toFloat64(JSONExtractString(JSONExtractRaw(json, 'iss_position'), 'longitude')) as mks_long,
                   toFloat64(JSONExtractString(JSONExtractRaw(json, 'iss_position'), 'latitude')) as mks_lat
            from mks) m;