select Name,
       surv / cnt as prob
from
        (select Name,
               sum(Survived) over(partition by Sex, Pclass) as surv,
               count(Survived) over(partition by Sex, Pclass) as cnt
        from titanic)
order by prob desc, Name asc;