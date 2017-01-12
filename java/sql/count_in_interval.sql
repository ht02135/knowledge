
--for 2016-12-16, hourly interval count
SELECT datepart(hour, event_timestamp) as hour, COUNT(*) as results
FROM email
where 1=1
and CONVERT(VARCHAR(10), event_timestamp, 120) in ('2016-12-16')
GROUP BY datepart(hour, event_timestamp)

--GROUP BY CONVERT(VARCHAR(10), event_timestamp, 120), datepart(hour, event_timestamp)
select 
	CONVERT(VARCHAR(10), event_timestamp, 120) as day,
	datepart(hour, event_timestamp) as hour,
	COUNT(*) as results
FROM email
where 1=1
and CONVERT(VARCHAR(10), event_timestamp, 120) >= '2016-12-01'
GROUP BY CONVERT(VARCHAR(10), event_timestamp, 120), datepart(hour, event_timestamp)
