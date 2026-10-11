select
	id,
	country_id,
	uniform_num,
	substring(position, 1, 1),
	name
from
	players;