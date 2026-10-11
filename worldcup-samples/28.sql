WITH player_ages AS (
  SELECT
    p.*,
    EXTRACT(YEAR FROM age(DATE '2016-01-13', p.birth))::int AS age
  FROM players AS p
)
SELECT *
FROM player_ages
WHERE age >= 40
ORDER BY age DESC, birth;