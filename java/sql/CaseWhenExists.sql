SELECT distinct
       c.C_id, 
       c.status as 'c.status', 
       cw.CW_id,
       cwt.CWT_id,
       CASE WHEN exists (
       		select 1 
        	from CT as ct2
            inner join CWT as cwt2 on cwt2.CT_id = ct.CT_id
            where 1=1
            and ct2.CT_code in ('aloha')
            and cwt2.status in ('ACTIVE'))
            and cwt2.CWT_id in (cwt.CWT_id)
       THEN 'Y'
       ELSE 'N'
       END AS 'cwt found',
       cwt.order_type as 'cwt.order_type', 
       cwt.processing_type as 'cwt.processing_type',
       cwt.status as 'cwt.status',
       cr.inventory_code, 
	   cr.status as 'cr.status',
	   cr.effective_from as 'cr.effective_from',
	   cr.effective_thru as 'cr.effective_thru',
	   CASE WHEN (Getdate() > cr.effective_thru) 
       THEN 'Y'
	   ELSE 'N' 
	   END AS 'creative expired' 
FROM C AS c WITH (NOLOCK) 
inner JOIN CT AS ct WITH (NOLOCK) ON ct.CT_id = c.CT_id 
inner JOIN CW AS cw WITH (NOLOCK) ON cw.C_id = c.C_id 
inner JOIN CWT cwt WITH(NOLOCK) ON cwt.CWT_id = cw.CWT_id
inner JOIN CWCR AS cwcr WITH(NOLOCK) ON cwcr.CW_id = cw.CW_id
inner JOIN creative cr WITH(NOLOCK) ON cr.creative_id = cwcr.creative_id
WHERE 1=1
and ct.CT_code in ('aloha')
and c.C_id in (171094)
ORDER BY ct.subscription_ind, ct.CT_type, c.C_id, cwe.datetime_to_execute
