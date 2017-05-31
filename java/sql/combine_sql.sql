select distinct
	   cr.inventory_code as 'cr.inventory_code',
	   cr.status as 'cr.status', 
	   cr.effective_from as 'cr.effective_from',
	   cr.effective_thru as 'cr.effective_thru',
       cr.*
from creative as cr with(nolock)
where 1=1
and cr.inventory_code not in (
	select cr2.inventory_code
	from creative as cr2 with(nolock)
	where 1=1
	and cr2.status not in ('INACTIVE')
	AND (cr2.effective_from IS NULL OR cr2.effective_from < getDate())
	AND (cr2.effective_thru IS NULL OR cr2.effective_thru > getDate())
)
order by cr.status, cr.inventory_code


select distinct
	   cr.inventory_code as 'cr.inventory_code',
	   cr.status as 'cr.status', 
	   cr.effective_from as 'cr.effective_from',
	   cr.effective_thru as 'cr.effective_thru',
       cr.*
from creative as cr with(nolock)
where 1=1
and cr.inventory_code not in (
	select cr2.inventory_code
	FROM communication as c2 WITH(NOLOCK)
	JOIN CW as cw2 WITH(NOLOCK) ON cw2.communication_id = c2.communication_id
	JOIN CWCR as cwcr2 WITH(NOLOCK) ON cwcr2.CW_id = cw2.CW_id
	JOIN creative cr2 WITH(NOLOCK) ON cr2.creative_id = cwcr2.creative_id
	WHERE 1=1
	and c2.creation_date > DATEADD(month, -6, GETDATE())
	)
order by cr.status, cr.inventory_code


--///////////////////////////

UNION is best way to combine.  

select distinct
	   cr.inventory_code as 'cr.inventory_code',
	   cr.status as 'cr.status', 
	   cr.effective_from as 'cr.effective_from',
	   cr.effective_thru as 'cr.effective_thru',
       cr.*
from creative as cr with(nolock)
where 1=1
and cr.inventory_code not in (
	select cr2.inventory_code
	from creative as cr2 with(nolock)
	where 1=1
	and cr2.status not in ('INACTIVE')
	AND (cr2.effective_from IS NULL OR cr2.effective_from < getDate())
	AND (cr2.effective_thru IS NULL OR cr2.effective_thru > getDate())
	union
	select cr2.inventory_code
	FROM communication as c2 WITH(NOLOCK)
	JOIN CW as cw2 WITH(NOLOCK) ON cw2.communication_id = c2.communication_id
	JOIN CWCR as cwcr2 WITH(NOLOCK) ON cwcr2.CW_id = cw2.CW_id
	JOIN creative cr2 WITH(NOLOCK) ON cr2.creative_id = cwcr2.creative_id
	WHERE 1=1
	and c2.creation_date > DATEADD(month, -3, GETDATE())
)
order by cr.status, cr.inventory_code
