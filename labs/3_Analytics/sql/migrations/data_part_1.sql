CREATE TABLE login(event_time DateTime,uid Int64) engine=Log;

INSERT INTO login SELECT * FROM url('https://raw.githubusercontent.com/dmitrii12334/clickhouse/main/login%20(2).csv', CSVWithNames, 'event_time DateTime,uid Int64');

CREATE TABLE funnel(time Datetime,event_type String,uid Int64,user_reg_date Date) engine=Log;

INSERT INTO funnel SELECT * FROM url('https://raw.githubusercontent.com/dmitrii12334/clickhouse/main/funnel', CSVWithNames, 'time Datetime,event_type String,uid Int64,user_reg_date Date');

CREATE TABLE finance(event_time DateTime,revenue_usd Float64,uid Int64,is_test Int8) engine=Log;

INSERT INTO finance SELECT * FROM url('https://raw.githubusercontent.com/dmitrii12334/clickhouse/main/finance', CSVWithNames, 'event_time DateTime,revenue_usd Float64,uid Int64,is_test Int8');