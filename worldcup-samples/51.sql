-- case文を使うと次のようにもかける。
-- 今回の場合はこちらの方が直感的でわかりやすいかもしれない。

select
	case
		when player_id is null then 9999
		else player_id
	end as player_id,
	goal_time
from
	goals
order by
	case
		when goal_time like '前半%' then 1
		when goal_time like '後半%' then 2
		when goal_time like '延前%' then 3
		when goal_time like '延後%' then 4
		else 5
	end,
	SUBSTRING(goal_time from '[0-9]+')::int;