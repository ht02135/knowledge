SELECT distinct
	'invoice' as 'dmsub orders',
	crm.meta_value as 'schedule_name',
	cs.parent_inventory_code, 
    cs.inventory_code, 
	c.communication_id,
	c.status as 'c.status',
	w.order_type,
	wt.processing_type,
	e.communication_wave_event_id,
	e.datetime_to_execute,
	--e.date_executed, 
	e.mail_date, 
	e.processing_stage, 
	e.processing_status,
	e.status as 'e.status'
FROM communication_wave_event e WITH(NOLOCK)
inner JOIN communication_wave w WITH(NOLOCK) ON w.communication_wave_id = e.communication_wave_id
inner JOIN communication_wave_template wt WITH(NOLOCK) ON wt.communication_wave_template_id = w.communication_wave_template_id
inner JOIN communication c WITH(NOLOCK) ON c.communication_id = w.communication_id 
inner JOIN communication_template as ct WITH(NOLOCK) ON ct.communication_template_id = c.communication_template_id
inner JOIN users u WITH(NOLOCK) ON u.user_id = c.user_id
inner JOIN communication_wave_creative as wc WITH(NOLOCK) ON wc.communication_wave_id = w.communication_wave_id
inner JOIN creative as cr WITH(NOLOCK) ON cr.creative_id = wc.creative_id
inner JOIN creative_metadata as crm on (
	crm.creative_id = cr.creative_id
	AND crm.name = 'schedule' 
	AND crm.meta_value like 'MultiTouch%Subscription'
	AND crm.meta_value NOT IN ('MultiTouchThreeSubscription', 'MultiTouchTwoSubscription')
)
inner JOIN control_subscription as cs WITH(NOLOCK) ON (
	cs.parent_inventory_code = cr.inventory_code					
    AND cs.mail_date = '2017-03-15'
)
inner JOIN schedule_date sd WITH(NOLOCK) ON (
   sd.schedule_name = crm.meta_value
   AND CONVERT(VARCHAR(10), sd.mail_date, 120) = '2017-03-15'
)
where 1=1
AND ct.subscription_ind = 1
AND ct.communication_template_code like '%multi%'
AND wt.processing_type='DIRECT_MAIL_SUBSCR'
AND w.order_type='DIRECT_MAIL_SUBSCR'
AND c.status='LOCKED' 
AND e.status='SUBMITTED' 
AND e.processing_stage=100 AND e.processing_status=1
--AND (e.datetime_to_execute IS NULL OR e.datetime_to_execute <= getDate())
AND (e.datetime_to_execute IS NULL OR e.datetime_to_execute <= '2017-02-13 01:00:00.000')
AND u.account_status='ACTIVE'
AND (u.effective_from IS NULL OR u.effective_from < getDate())
AND (u.effective_thru IS NULL OR u.effective_thru > getDate())	
order by crm.meta_value, cs.parent_inventory_code, c.communication_id, e.communication_wave_event_id
