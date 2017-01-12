/*
SELECT 
	datepart(hour, event_timestamp) as 'hour', 
	COUNT(*) as 'results'
FROM email_event
where 1=1
and CONVERT(VARCHAR(10), event_timestamp, 120) in ('2016-12-16')
GROUP BY datepart(hour, event_timestamp)
order by datepart(hour, event_timestamp)
*/

select 
	CONVERT(VARCHAR(10), event_timestamp, 120) as 'day',
	datepart(hour, event_timestamp) as 'hour',
	COUNT(*) as 'results'
FROM email_event
where 1=1
and CONVERT(VARCHAR(10), event_timestamp, 120) >= '2016-12-01'
GROUP BY CONVERT(VARCHAR(10), event_timestamp, 120), datepart(hour, event_timestamp)
order by CONVERT(VARCHAR(10), event_timestamp, 120), datepart(hour, event_timestamp)

--group by 10min interval
--group by (DATEPART(MINUTE, [Date]) / 10)
select 
	CONVERT(VARCHAR(10), event_timestamp, 120) as 'day',
	datepart(hour, event_timestamp) as 'hour',
	(DATEPART(MINUTE, event_timestamp) / 10) as '10min',
	COUNT(*) as 'results'
FROM email_event
where 1=1
and CONVERT(VARCHAR(10), event_timestamp, 120) >= '2016-12-01'
GROUP BY CONVERT(VARCHAR(10), event_timestamp, 120), datepart(hour, event_timestamp), (DATEPART(MINUTE, event_timestamp) / 10)
order by CONVERT(VARCHAR(10), event_timestamp, 120), datepart(hour, event_timestamp), (DATEPART(MINUTE, event_timestamp) / 10)
