
1>criteria in join

SELECT '' as 'ct+ctm',
       ct.subscription_ind as 'ct.subscription_ind', 
       ct.communication_template_type as 'ct.communication_template_type',
       ct.communication_template_code as 'ct.communication_template_code', 
       ct.status as 'ct.status',
       ctm.metadata_id as 'ctm.metadata_id',
       ctm.name as 'ctm.name',
       ctm.meta_value as 'ctm.meta_value',
       ctm.*
FROM communication_template as ct WITH(NOLOCK) 
left join communication_template_metadata as ctm with (nolock) on ctm.communication_template_id = ct.communication_template_id and ctm.name in ('ListEffectiveDays')
WHERE 1=1
and ct.status='ACTIVE'
and ct.communication_template_code like '%seminar%'
and ct.communication_template_code in (
	'women_and_wealth_seminar',
	'seminar_invitation_postcards_dm',
	'seminar_express_seminar_pkg'
)
ORDER BY ct.subscription_ind desc, ct.communication_template_type desc, ct.communication_template_code desc

it returns null and let you know which is missing
ct.subscription_ind	ct.communication_template_type	ct.communication_template_code	ct.status	ctm.metadata_id	ctm.name	ctm.meta_value
0	Direct Mail	women_and_wealth_seminar	ACTIVE	178	ListEffectiveDays	30
0	Direct Mail	seminar_invitation_postcards_dm	ACTIVE	NULL	NULL	NULL
0	Direct Mail	seminar_express_seminar_pkg	ACTIVE	171	ListEffectiveDays	30

VS

2>criteria in where

SELECT '' as 'ct+ctm',
       ct.subscription_ind as 'ct.subscription_ind', 
       ct.communication_template_type as 'ct.communication_template_type',
       ct.communication_template_code as 'ct.communication_template_code', 
       ct.status as 'ct.status',
       ctm.metadata_id as 'ctm.metadata_id',
       ctm.name as 'ctm.name',
       ctm.meta_value as 'ctm.meta_value',
       ctm.*
FROM communication_template as ct WITH(NOLOCK) 
left join communication_template_metadata as ctm with (nolock) on ctm.communication_template_id = ct.communication_template_id
WHERE 1=1
and ct.status='ACTIVE'
and ct.communication_template_code like '%seminar%'
and ct.communication_template_code in (
	'women_and_wealth_seminar',
	'seminar_invitation_postcards_dm',
	'seminar_express_seminar_pkg'
)
and ctm.name in ('ListEffectiveDays')
ORDER BY ct.subscription_ind desc, ct.communication_template_type desc, ct.communication_template_code desc

it outright exclude the null
ct.subscription_ind	ct.communication_template_type	ct.communication_template_code	ct.status	ctm.metadata_id	ctm.name	ctm.meta_value
0	Direct Mail	women_and_wealth_seminar	ACTIVE	178	ListEffectiveDays	30
0	Direct Mail	seminar_express_seminar_pkg	ACTIVE	171	ListEffectiveDays	30
