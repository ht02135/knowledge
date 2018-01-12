/*
when birthday string can be
11/20
12/01/73
*/
SELECT
	slm.attribute21 as 'slm.attribute21',
	ct.subscription_ind, 
	ct.communication_template_type, 
	ct.communication_template_code, 
    c.communication_id,
    c.creation_date,
    c.status as 'c.status',
    cw.order_type,
	cwt.processing_type,
	sl.stored_list_id as 'sl.stored_list_id',
	slm.stored_list_member_id as 'slm.stored_list_member_id',
	slm.*
FROM communication c WITH(NOLOCK)
inner JOIN communication_template AS ct WITH (NOLOCK) ON ct.communication_template_id = c.communication_template_id 
INNER JOIN communication_wave cw WITH(NOLOCK) ON cw.communication_id = c.communication_id
INNER JOIN communication_wave_template cwt WITH(NOLOCK) ON cwt.communication_wave_template_id = cw.communication_wave_template_id
inner join stored_list sl with(nolock) on sl.stored_list_id = c.stored_list_id
inner join stored_list_member slm with(nolock) on slm.stored_list_id = sl.stored_list_id
WHERE 1 = 1
and ct.communication_template_code in ('subscription_email_birthday_cards')
AND c.status not in ('CANCELLED')
AND (c.creation_date <= '2017-12-05 00:00:00.000')
AND cw.order_type       = 'EMAIL_NEWSLETTER_SUBSCR'
AND cwt.processing_type = 'EMAIL_NEWSLETTER_SUBSCR'
and 
--for email, i found there is no invoice between 2017-11-10 and 2017-12-03
(
	(
	SUBSTRING([slm].[attribute21], 1, 2) = RIGHT('00' + CONVERT(NVARCHAR(2), DATEPART(MONTH, DATEADD(month, 0, '2017-11-10 00:00:00.000'))), 2) AND 
	SUBSTRING([slm].[attribute21], 4, 2) BETWEEN '10' AND '31'
	)
	or
	(
	SUBSTRING([slm].[attribute21], 1, 2) = RIGHT('00' + CONVERT(NVARCHAR(2), DATEPART(MONTH, DATEADD(month, 0, '2017-12-03 00:00:00.000'))), 2) AND 
	SUBSTRING([slm].[attribute21], 4, 2) BETWEEN '01' AND '03'
	)
)
