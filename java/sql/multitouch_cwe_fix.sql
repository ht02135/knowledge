select
    '' as 'cwe',
    c.communication_id,
    c.status as 'c.status',
    cwe.creation_date,
    cwe.datetime_to_execute,
    cwe.mail_date,
    cwe.date_executed,
    cwe.processing_stage, 
	cwe.processing_status,
	cwe.status as 'e.status'
from communication as c
inner JOIN communication_wave AS cw WITH (NOLOCK) ON cw.communication_id = c.communication_id 
inner JOIN communication_wave_event AS cwe WITH (NOLOCK) ON cwe.communication_wave_id = cw.communication_wave_id
where 1=1
and c.communication_id in (1)    
order by cwe.creation_date, c.communication_id

update cwe
set cwe.datetime_to_execute = sd.execute_date,
    cwe.mail_date = sd.mail_date,
    cwe.date_executed = sd.mail_date
from communication as c
inner JOIN communication_wave AS cw WITH (NOLOCK) ON cw.communication_id = c.communication_id 
inner JOIN communication_wave_event AS cwe WITH (NOLOCK) ON cwe.communication_wave_id = cw.communication_wave_id
inner join schedule_date as sd on CONVERT(VARCHAR(10), sd.cutoff_date, 120) = CONVERT(VARCHAR(10), cwe.creation_date, 120)
    and sd.schedule_name like 'MultiTouch%Subscription'
    and sd.schedule_name NOT IN ('MultiTouchThreeSubscription', 'MultiTouchTwoSubscription')
where 1=1
and c.communication_id in (1)

select
    '' as 'qc cwe',
    c.communication_id,
    c.status as 'c.status',
    cwe.creation_date,
    cwe.datetime_to_execute,
    cwe.mail_date,
    cwe.date_executed,
    cwe.processing_stage, 
	cwe.processing_status,
	cwe.status as 'e.status'
from communication as c
inner JOIN communication_wave AS cw WITH (NOLOCK) ON cw.communication_id = c.communication_id 
inner JOIN communication_wave_event AS cwe WITH (NOLOCK) ON cwe.communication_wave_id = cw.communication_wave_id
where 1=1
and c.communication_id in (1)    
order by cwe.creation_date, c.communication_id
