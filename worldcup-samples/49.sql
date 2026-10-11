select
	name,
	to_char(birth, 'YYYY年mm月dd日') as birthday
from
	players;