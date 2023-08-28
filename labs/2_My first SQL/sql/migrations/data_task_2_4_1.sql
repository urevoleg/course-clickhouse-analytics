CREATE TABLE revenue_rub
(
    date	String,
    revenue_rub	UInt64
)engine=Log

INSERT INTO revenue_rub (*) VALUES
	('2023-04-01', '2461712'),
	('2023-04-02', '1904536'),
	('2023-04-03', '3021203'),
	('2023-04-04', '3217854'),
	('2023-04-05', '2312401'),
	('2023-04-06', '2522456'),
	('2023-04-07', '3271421'),
	('2023-04-08', '2708432'),
	('2023-04-09', '2785278'),
	('2023-04-10', '2716433'),
	('2023-04-11', '2815574'),
	('2023-04-12', '2876831'),
	('2023-04-13', '2015123'),
	('2023-04-14', '1802406'),
	('2023-04-15', '2698974'),
	('2023-04-16', '2473162'),
	('2023-04-17', '2346825'),
	('2023-04-18', '2927760'),
	('2023-04-19', '2367126'),
	('2023-04-20', '2457581'),
	('2023-04-21', '2062530'),
	('2023-04-22', '1898335'),
	('2023-04-23', '2177096'),
	('2023-04-24', '2235702'),
	('2023-04-25', '2212442'),
	('2023-04-26', '2189182'),
	('2023-04-27', '2165921'),
	('2023-04-28', '2142661'),
	('2023-04-29', '2119400'),
	('2023-04-30', '2096140');

CREATE TABLE usd_rub
(
    date	String,
    usdrub	Float64
) engine=Log

INSERT INTO usd_rub(*) VALUES
	('2023-04-01', '80.3'),
	('2023-04-02', '81.3'),
	('2023-04-03', '81.6'),
	('2023-04-04', '81.6'),
	('2023-04-05', '81.3'),
	('2023-04-06', '81.7'),
	('2023-04-07', '81.6'),
	('2023-04-08', '81.9'),
	('2023-04-09', '81.5'),
	('2023-04-10', '81.4'),
	('2023-04-11', '81.8'),
	('2023-04-12', '81.4'),
	('2023-04-13', '82'),
	('2023-04-14', '82'),
	('2023-04-15', '81.6'),
	('2023-04-16', '81.1'),
	('2023-04-17', '81.4'),
	('2023-04-18', '79.8'),
	('2023-04-19', '79.5'),
	('2023-04-20', '78.7'),
	('2023-04-21', '77.6'),
	('2023-04-22', '77.1'),
	('2023-04-23', '77.2'),
	('2023-04-24', '76.2'),
	('2023-04-25', '75.6'),
	('2023-04-26', '75'),
	('2023-04-27', '74.4'),
	('2023-04-28', '73.8'),
	('2023-04-29', '73.2'),
	('2023-04-30', '72.6');