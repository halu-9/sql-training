with
  player_bmi as (
    select
      p.*,
      p.weight / power(p.height / 100.0, 2) as bmi
    from
      players as p
  )
select
  *
from
  player_bmi
where
  bmi > 21;