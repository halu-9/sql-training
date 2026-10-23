select
	c.name,
	p.name,
	p.uniform_num
from
	players p
join countries c on
	c.id = p.country_id;