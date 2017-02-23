select
    '' as 'c+cwe',
    c.communication_id,
    c.status as 'c.status',
    i.invoice_id as 'i.invoice_id',
    i.created_date as 'i.created_date',
    i.payment_status as 'i.payment_status',
    i.invoice_total as 'i.invoice_total',
	cwe.communication_wave_event_id,
    cwe.creation_date,
    cwe.datetime_to_execute
from communication as c
INNER JOIN invoice AS i ON i.communication_id = c.communication_id 
inner JOIN communication_wave AS cw WITH (NOLOCK) ON cw.communication_id = c.communication_id 
inner JOIN communication_wave_event AS cwe WITH (NOLOCK) ON cwe.communication_wave_id = cw.communication_wave_id
where 1=1
AND CONVERT(VARCHAR(10), cwe.datetime_to_execute, 120) in ('2017-02-22')
AND 
(
	DATEADD(DAY, DATEDIFF(DAY, 0, '2017-02-22')-7, 0) = DATEADD(DAY, DATEDIFF(DAY, 0, CONVERT(VARCHAR(10), i.invoice_date, 120)), 0) or
	DATEADD(DAY, DATEDIFF(DAY, 0, '2017-02-22'), 0) = DATEADD(DAY, DATEDIFF(DAY, 0, CONVERT(VARCHAR(10), i.invoice_date, 120)), 0)
)
order by c.communication_id, cwe.communication_wave_event_id, i.invoice_id
