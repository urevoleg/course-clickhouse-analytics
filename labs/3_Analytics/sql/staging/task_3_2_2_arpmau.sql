SELECT
    event_date
    , MAU
    , payers
    , revenue_usd
    , ARPPU
    , payers / MAU as paying_share -- - получаем долю платящих
    , revenue_usd/MAU as ARPMAU -- делим деньги на всех юзеров - ARPDAU
FROM
   (
    SELECT
        toStartOfMonth(event_time)  as event_date
        , uniq(uid) as MAU
    FROM login
    GROUP BY event_date
    ) t1 ANY LEFT JOIN -- СОЕДИНИЕ
        (SELECT
            toStartOfMonth(event_time) as event_date
            , uniq(uid) as payers
            , sum(revenue_usd) as revenue_usd
            , revenue_usd / payers as ARPPU -- все деньги на всех платящих
        FROM finance
        where is_test = 0
        GROUP BY event_date
        ) t2 USING event_date;