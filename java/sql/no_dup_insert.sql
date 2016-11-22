INSERT INTO schedule2 
(	version
	,name
	,execute) 
SELECT
	0
	,sd.name
	,sd.execute
from schedule as sd
where NOT EXISTS (
	SELECT sd2.sd_id 
	from schedule2 as sd2 with(nolock)
	where 1=1
	and sd2.name = sd.name
	and sd2.execute = sd.execute
)
