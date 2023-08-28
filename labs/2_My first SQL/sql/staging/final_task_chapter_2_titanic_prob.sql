-- final task chapter 2
with raw as (select *,
         roundAge(case when toFloat32OrNull(Age) is null then (select avg(toFloat32OrNull(Age)) from titanic)
                   else toFloat32(Age) end) as age_gr
  from titanic),
probs as (select Pclass,
       Sex,
       age_gr,
       sum(Survived) / count(Survived) as prob,
       if(sum(Survived) / count(Survived) > 0.1, 'lucky', 'other') as pss
from raw
group by Pclass, Sex, age_gr)
select PassengerId,
       Pclass,
       Sex,
       age_gr,
       Survived,
       prob,
       pss
from raw t
join probs p
on t.Pclass = p.Pclass
and t.Sex = p.Sex
and t.age_gr = p.age_gr
where pss = 'other';