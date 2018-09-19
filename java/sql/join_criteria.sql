1>criteria in join

SELECT '' as 'ct+ctm',
       ct.subscription_ind as 'ct.subscription_ind', 
       ct.CT_type as 'ct.CT_type',
       ct.CT_code as 'ct.CT_code', 
       ct.status as 'ct.status',
       ctm.metadata_id as 'ctm.metadata_id',
       ctm.name as 'ctm.name',
       ctm.meta_value as 'ctm.meta_value',
       ctm.*
FROM CT as ct WITH(NOLOCK) 
left join CTM as ctm with (nolock) on ctm.CT_id = ct.CT_id and ctm.name in ('EffectiveDays')
WHERE 1=1
and ct.status='ACTIVE'
and ct.CT_code like '%seminar%'
and ct.CT_code in (
	'woman',
	'invitation',
	'pkg'
)
ORDER BY ct.subscription_ind desc, ct.CT_type desc, ct.CT_code desc

it returns null and let you know which is missing
ct.subscription_ind	ct.CT_type	ct.CT_code	ct.status	ctm.metadata_id	ctm.name	ctm.meta_value
0	Direct Mail	woman	ACTIVE	178	EffectiveDays	30
0	Direct Mail	invitation	ACTIVE	NULL	NULL	NULL
0	Direct Mail	pkg	ACTIVE	171	EffectiveDays	30

///////////////////////////////////////////////

DECLARE @userId NUMERIC(19, 0);
SELECT @userId = user_id from users with(nolock) where user_name = 'haha';

INSERT INTO CTM
( version
, name
, meta_value
, created_by
, creation_date
, CT_id
)
SELECT 0 as version
, 'EffectiveDays' as name
, '90' as meta_value
, @userId
, GETDATE() as creation_date
, ct.CT_id
FROM CT as ct WITH(NOLOCK) 
left join CTM as ctm with (nolock) on ctm.CT_id = ct.CT_id and ctm.name in ('EffectiveDays')
where 1=1
and ct.CT_code in (
	'woman',
	'invitation',
	'pkg'
)
and ctm.metadata_id is null

////////////////////////////////////////////////
VS

2>criteria in where

SELECT '' as 'ct+ctm',
       ct.subscription_ind as 'ct.subscription_ind', 
       ct.CT_type as 'ct.CT_type',
       ct.CT_code as 'ct.CT_code', 
       ct.status as 'ct.status',
       ctm.metadata_id as 'ctm.metadata_id',
       ctm.name as 'ctm.name',
       ctm.meta_value as 'ctm.meta_value',
       ctm.*
FROM CT as ct WITH(NOLOCK) 
left join CTM as ctm with (nolock) on ctm.CT_id = ct.CT_id
WHERE 1=1
and ct.status='ACTIVE'
and ct.CT_code like '%seminar%'
and ct.CT_code in (
	'woman',
	'invitation',
	'pkg'
)
and ctm.name in ('EffectiveDays')
ORDER BY ct.subscription_ind desc, ct.CT_type desc, ct.CT_code desc

it outright exclude the null
ct.subscription_ind	ct.CT_type	ct.CT_code	ct.status	ctm.metadata_id	ctm.name	ctm.meta_value
0	Direct Mail	woman	ACTIVE	178	EffectiveDays	30
0	Direct Mail	pkg	ACTIVE	171	EffectiveDays	30
