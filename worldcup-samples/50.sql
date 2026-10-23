-- こうすると後半11分が後半1分より前に来てしまう
-- select coalesce(player_id, 9999) as player_id, goal_time
-- from goals
-- order by goal_time desc;

SELECT COALESCE(player_id, 9999) AS player_id, goal_time
FROM goals
ORDER BY
  CASE
    WHEN goal_time LIKE '前半%' THEN 1
    WHEN goal_time LIKE '後半%' THEN 2
    WHEN goal_time LIKE '延前%' THEN 3
    WHEN goal_time LIKE '延後%' THEN 4
    ELSE 5
  END,
  SUBSTRING(goal_time FROM '[0-9]+')::int;