-- create raw data
CREATE VIEW data AS
SELECT tupleElement(array, 1) AS cohort,
       toUInt16(tupleElement(array, 2)) AS DAY,
       tupleElement(array, 3) AS value
FROM
  (SELECT arrayJoin([('cohort 1', 1, 10), ('cohort 1', 2, 100), ('cohort 1', 3, 200), ('cohort 1', 4, 300), ('cohort 2', 2, 10), ('cohort 2', 3, 100), ('cohort 2', 5, 200), ('cohort 2', 8, 300)]) AS array)

-- generate all data without nulls
CREATE VIEW data_ml AS
SELECT *
FROM
    -- Считаем максимальный день жизни по когорте, и разворачиваем в таблицу
	(SELECT cohort,
		 day1 AS DAY
	FROM
		(SELECT cohort,
		 max(DAY) AS last_login,
		 arrayJoin(range(last_login)) + 1 AS day1
		FROM
			(SELECT cohort,
		 DAY,
		 value
			FROM data)
			GROUP BY  cohort)) ANY
		LEFT JOIN
        -- Данные с логинами
		(SELECT cohort,
		 DAY,
		 value
		FROM data)
	USING (cohort, DAY)
order by cohort, DAY
settings joined_subquery_requires_alias=0;

-- create array for forecast and forecast
CREATE VIEW predict_ml AS
SELECT cohort,
       groupArray(DAY) AS X,
       arrayCumSum(groupArray(value)) AS y,
       arrayMap(x -> ln(x + 2),X) AS X_ln, -- формула по которой считаем, можно задать любую другую
       arrayReduce('simpleLinearRegression', X_ln, y) AS coef, -- прогнозирвоание с помощью простой линейной регрессии

       /* Все последующие преобразования нужны для прогноза выручки на N день */
       length(X_ln) AS count_days, -- Считаем количество дней

       arrayMap(x -> ln(x + 2), range(length(X_ln) + 30)) AS days_predict, -- Применяем функцию к данным + 30 дней,

       tupleElement(coef, 1) AS coef_a,
       tupleElement(coef, 2) AS coef_b,
       arrayMap(x -> x * coef_a + coef_b, days_predict) AS array_predict
FROM  data_ml
group by cohort;