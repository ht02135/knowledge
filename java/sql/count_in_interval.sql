
--for 2016-12-16, hourly interval count
SELECT datepart(hour, event_timestamp) as hour, COUNT(*) as results
FROM event
and CONVERT(VARCHAR(10), event_timestamp, 120) in ('2016-12-16')
GROUP BY datepart(hour, event_timestamp)
