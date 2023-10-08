CREATE TABLE log(
  event String,
  long Float64,
  lat Float64
) ENGINE = Log;

CREATE TABLE big_city (
  city String,
  long Float64,
  lat Float64
) ENGINE = Log;

INSERT INTO big_city (*) VALUES
	('Moscow', '55.755826', '37.6172999'),
	('Peterburg', '59.9342802', '30.3350986'),
	('Viborg', '60.7130803', '28.7577354');


INSERT INTO log SELECT * FROM url('https://raw.githubusercontent.com/dmitrii12334/clickhouse/main/geo', CSVWithNames, 'event String,
  long Float64,
  lat Float64');


create view log_view as select * from log order by event limit 200;