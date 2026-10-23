select
	count(id) as 日本のゴール数
from
	goals
where
	player_id >= 714
	and player_id <= 736;

-- 実務では次のように書くことが多いみたい。
/*
SELECT COUNT(*) AS "日本のゴール数"
FROM goals AS g
JOIN players AS p ON p.id = g.player_id
WHERE p.country_id = 12;
*/