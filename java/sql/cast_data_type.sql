
/*
CTO.value - (ntext, null)
CCRC.value - (nvarchar(max), null)
*/


select '' as 'font', 
	   cto.* 
from CTO as cto WITH (nolock)
where 1=1
and cast(cto.value as nvarchar(max)) in (
	select ccrc.value
	FROM C AS c WITH (nolock)
	LEFT JOIN CW AS cw WITH (nolock) ON cw.c_id = c.c_id
	LEFT JOIN CWCR AS cwcr WITH (nolock) ON cwcr.cw_id = cw.cw_id
	LEFT JOIN CCRC AS ccrc WITH (nolock) ON ccrc.ccrc_id = cwcr.cwcr_id
	WHERE 1 = 1
	and c.C_id in (126598)
	and ccrc.name in ('font')
)

use cast to solve data type problem

///////////

and CONVERT(VARCHAR(10), c.creation_date, 120) >= '2016-09-09'

///////////
