with e as (select *,
                  multiIf(step == 'step a', 1, step == 'step b', 2, step == 'step c', 3,
                      step == 'step d', 4, step == 'step e', 5, step == 'step f', 6,
                      step == 'step g', 7, step == 'step w', 8, -1) as n_step
           from events)
select UID,
       sum(UID) over(),
       arrayJoin(range(1, toUInt8(arrayMax(arraySort(groupArray(n_step))) + 1), 1)) as step_fixed
from e
group by UID;