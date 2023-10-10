SELECT
    uniqIf(uid, event_type = 'install')  as installed_users, -- Количество установок
    uniqIf(uid, event_type = 'registration') as registered_users, -- Количество регистраций
    uniqIf(uid, event_type = 'tutorial_end') as tutor_end_users, -- Количество завершивших туториал

    uniqIf(uid, event_type = 'level_1') as level_1_users, -- Количество завершивших 1 уровень
    uniqIf(uid, event_type = 'level_2') as level_2_users, -- Количество завершивших 2 уровень
    uniqIf(uid, event_type = 'level_3') as level_3_users, -- Количество завершивших 3 уровень

    -- теперь, чтобы получить конверсии, делим количество пользователей на каждом этапе воронки на Количество установок
    registered_users/ installed_users as registration,
    tutor_end_users/ installed_users as tutor_end,
    level_1_users/ installed_users as lvl1_end,
    level_2_users/ installed_users as lvl2_end,
    level_3_users/ installed_users as lvl3_end,
    lvl3_end / lvl2_end as otval
FROM funnel
WHERE event_type in ('install','registration','tutorial_end','level_1','level_2','level_3') -- выбираем только нужные события