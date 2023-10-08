create view mks as
SELECT *
FROM url('http://api.open-notify.org/iss-now.json', JSONAsString, 'json String');


create view cities as
SELECT *
FROM url('https://raw.githubusercontent.com/dmitrii12334/clickhouse/main/cities', CSVWithNames, 'region String,city String, latitude Float64, longitude Float64');