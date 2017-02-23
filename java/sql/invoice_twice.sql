select
    '' as 'c+cwe',
	ct.subscription_ind, 
	ct.communication_template_type, 
	ct.communication_template_code,
    c.communication_id,
    --c.stored_list_id as 'c.stored_list_id',
    --c.record_count as 'c.record_count',
    c.status as 'c.status',
    --csl.stored_list_id as 'csl.stored_list_id',
    --csl.record_count as 'csl.record_count',
    --csl.status as 'sl.status',
    i.invoice_id as 'i.invoice_id',
    i.created_date as 'i.created_date',
    i.invoice_date as 'i.invoice_date',
    i.payment_status as 'i.payment_status',
    i.invoice_total as 'i.invoice_total',
    cw.communication_wave_id,
    cw.order_type,
	cwt.processing_type,
	cwe.communication_wave_event_id,
    cwe.creation_date,
    cwe.datetime_to_execute,
    cwe.mail_date,
	cwe.processing_stage,
	cwe.processing_status,
    cwe.status as 'cwe.status',
    esl.stored_list_id as 'esl.stored_list_id',
    esl.record_count as 'esl.record_count',
    esl.status as 'esl.status'
from communication as c
INNER JOIN invoice AS i ON i.communication_id = c.communication_id 
INNER JOIN communication_template as ct WITH(NOLOCK) ON ct.communication_template_id = c.communication_template_id
inner JOIN communication_wave AS cw WITH (NOLOCK) ON cw.communication_id = c.communication_id 
INNER JOIN communication_wave_template cwt WITH(NOLOCK) ON cwt.communication_wave_template_id = cw.communication_wave_template_id
inner JOIN communication_wave_event AS cwe WITH (NOLOCK) ON cwe.communication_wave_id = cw.communication_wave_id
left join stored_list as csl WITH (NOLOCK) ON csl.stored_list_id = c.stored_list_id
left join stored_list as esl WITH (NOLOCK) ON esl.stored_list_id = cwe.stored_list_id
where 1=1
and cw.order_type in ('EZG')
AND CONVERT(VARCHAR(10), cwe.creation_date, 120) in ('2017-02-15')
AND CONVERT(VARCHAR(10), cwe.datetime_to_execute, 120) in ('2017-02-22')
AND 
(
	DATEADD(DAY, DATEDIFF(DAY, 0, '2017-02-22')-7, 0) = DATEADD(DAY, DATEDIFF(DAY, 0, CONVERT(VARCHAR(10), i.invoice_date, 120)), 0) or
	DATEADD(DAY, DATEDIFF(DAY, 0, '2017-02-22'), 0) = DATEADD(DAY, DATEDIFF(DAY, 0, CONVERT(VARCHAR(10), i.invoice_date, 120)), 0)
)
--and cwe.processing_stage = 500
--and cwe.processing_status = 1
--and cwe.status = 'PAID'
order by c.communication_id, cwe.communication_wave_event_id, i.invoice_id
