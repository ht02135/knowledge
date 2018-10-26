
SELECT distinct
	bji.JOB_NAME,
	FORMAT(bje.CREATE_TIME,'hh:mm') as 'createTime',
	max(DATEDIFF(minute, bje.START_TIME, bje.END_TIME)) AS 'delta',
	count(*)
FROM BATCH_JOB_INSTANCE AS bji WITH (nolock)
left outer JOIN BATCH_JOB_EXECUTION AS bje WITH (nolock) ON bji.JOB_INSTANCE_ID = bje.JOB_INSTANCE_ID
WHERE 1 = 1
AND bje.create_time > @cutoffDate
AND (bji.JOB_NAME like '%invoice%' or bji.JOB_NAME like '%extract%')
AND (bji.JOB_NAME like '%SubscriptionInvoice%' or bji.JOB_NAME like '%SubscriptionExtract%')
group by FORMAT(bje.CREATE_TIME,'hh:mm'),bji.JOB_NAME
having count(*) > 1
ORDER BY FORMAT(bje.CREATE_TIME,'hh:mm'),bji.JOB_NAME


SELECT distinct
	bji.JOB_NAME,
	FORMAT(bje.CREATE_TIME,'hh:mm') as 'createTime',
	count(*)
FROM BATCH_JOB_INSTANCE AS bji WITH (nolock)
left outer JOIN BATCH_JOB_EXECUTION AS bje WITH (nolock) ON bji.JOB_INSTANCE_ID = bje.JOB_INSTANCE_ID
WHERE 1 = 1
AND bje.create_time > @cutoffDate
AND (bji.JOB_NAME like '%invoice%' or bji.JOB_NAME like '%extract%')
AND (bji.JOB_NAME like '%SubscriptionInvoice%' or bji.JOB_NAME like '%SubscriptionExtract%')
group by FORMAT(bje.CREATE_TIME,'hh:mm'),bji.JOB_NAME
having count(*) > 1
ORDER BY FORMAT(bje.CREATE_TIME,'hh:mm'),bji.JOB_NAME



--////////////


SELECT distinct
	bji.JOB_NAME,
	FORMAT(bje.CREATE_TIME,'hh:mm') as 'createTime',
	max(DATEDIFF(minute, bje.START_TIME, bje.END_TIME)) AS 'delta',
	count(*)
FROM BATCH_JOB_INSTANCE AS bji WITH (nolock)
left outer JOIN BATCH_JOB_EXECUTION AS bje WITH (nolock) ON bji.JOB_INSTANCE_ID = bje.JOB_INSTANCE_ID
WHERE 1 = 1
AND bje.create_time > @cutoffDate
AND (bji.JOB_NAME like '%invoice%' or bji.JOB_NAME like '%extract%')
AND (bji.JOB_NAME like '%SubscriptionInvoice%' or bji.JOB_NAME like '%SubscriptionExtract%')
and DATEDIFF(minute, bje.START_TIME, bje.END_TIME) > 5
group by FORMAT(bje.CREATE_TIME,'hh:mm'),bji.JOB_NAME
ORDER BY FORMAT(bje.CREATE_TIME,'hh:mm'),bji.JOB_NAME


SELECT distinct
	bji.JOB_NAME,
	max(DATEDIFF(minute, bje.START_TIME, bje.END_TIME)) AS 'delta'
FROM BATCH_JOB_INSTANCE AS bji WITH (nolock)
left outer JOIN BATCH_JOB_EXECUTION AS bje WITH (nolock) ON bji.JOB_INSTANCE_ID = bje.JOB_INSTANCE_ID
WHERE 1 = 1
AND bje.create_time > @cutoffDate
AND (bji.JOB_NAME like '%invoice%' or bji.JOB_NAME like '%extract%')
AND (bji.JOB_NAME like '%SubscriptionInvoice%' or bji.JOB_NAME like '%SubscriptionExtract%')
and DATEDIFF(minute, bje.START_TIME, bje.END_TIME) > 5
group by bji.JOB_NAME
ORDER BY bji.JOB_NAME
