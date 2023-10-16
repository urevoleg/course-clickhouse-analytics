WITH predict_ml AS (SELECT first_reg_date,
	   groupArray(lifetime) AS X,
	   arrayMap(x -> x / max(users), groupArrayMovingSum(revenue)) AS y, --расчет LTV=CumRevenue / cohort_size
	   arrayMap(x -> ln(x + 2),X) AS X_ln, -- формула по которой считаем, можно задать любую другую
       arrayReduce('simpleLinearRegression', X_ln, y) AS coef, -- прогнозирвоание с помощью простой линейной
       /* Все последующие преобразования нужны для прогноза выручки на N день */
       length(X_ln) AS count_days, -- Считаем количество дней
       arrayMap(x -> ln(x + 2), range(length(X_ln) + 1)) AS days_predict, -- Применяем функцию к данным + 50 дней,
       tupleElement(coef, 1) AS coef_a,
       tupleElement(coef, 2) AS coef_b,
       arrayMap(x -> x * coef_a + coef_b, days_predict) AS array_predict
FROM (SELECT first_reg_date,
			   lifetime,
			   uniq(uid) AS users,
			   sum(price_usd) AS revenue
		FROM
			(select *,
				   date_diff('day', first_reg_date, toDate(event_time)) + 1 AS lifetime -- вычисление lifetime
			from
				-- JOIN события + когорта
					(--объединение login + finance
				    SELECT
				        event_time
				        , 'login' as event_type
				        , uid
				        , 0 as price_usd
				    FROM login
				    UNION ALL
				    SELECT
				        event_time
				        , 'finance' as event_type
				        , uid
				        , revenue_usd as price_usd
				    FROM finance
				    WHERE is_test = 0) t1
				any left join (SELECT uid,
				                     min(toDate(event_time)) as first_reg_date
				              FROM login
				              GROUP BY uid) t2
				using uid
				WHERE first_reg_date IN ('2023-01-01', '2023-01-02', '2023-01-03')
				ORDER BY first_reg_date, lifetime)
		GROUP BY first_reg_date, lifetime
		ORDER BY first_reg_date, lifetime)
GROUP BY first_reg_date)
SELECT first_reg_date,
       arrayJoin(range(count_days + 1)) AS index_days, -- Формируем список из 30 дней
       arrayElement(array_predict, index_days + 1) AS predict, -- Извлекаем из полчившегося массива ДНИ
       arrayElement(y, index_days + 1) AS revenue -- Извлекаем из полчившегося массива ВЫРУЧКА
FROM predict_ml;