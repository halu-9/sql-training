select
	count(g.player_id)
from
	goals g

-- 下記のようにするとオウンゴール含めた全件になる
/*
select
	count(*)
from
	goals g
*/