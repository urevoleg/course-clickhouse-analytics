select sum(sq.value * sq.rank)
from (select t1.user, t1.value,
       count(t1.user) as rank
from table1 t1
cross join table1 t2
where t1.value <= t2.value
group by t1.user, t1.value
order by t1.value desc) sq;