
select
       sl2.list_id as 'sl2.list_id',
       sl2.record_count as 'sl2.record_count',
       slm2.list_member_id as 'slm2.list_member_id',
       slm2.first_name as 'slm2.first_name',
       slm2.last_name as 'slm2.last_name',
       slm2.attribute999 as 'slm2.attribute999',
       birthday.new_attribute999 as 'birthday.new_attribute999',
       CAST(CONVERT(VARCHAR(10),DATEADD(day, 14, getdate()),121) AS DATETIME) as 'begin',
       CAST(CONVERT(VARCHAR(10),DATEADD(day, 20, getdate()),121)AS DATETIME) as 'end'
from (
	select
	    sl.list_id,
		slm.list_member_id,
		CASE 
			WHEN DATEPART(month, getdate()) = 12 and SUBSTRING(slm.attribute999,6,2) = '01'
			THEN CAST(DATEPART (year, DATEADD(year, 1, getdate())) AS VARCHAR(4)) + '-' + SUBSTRING(slm.attribute999,6,2) + '-' + SUBSTRING(slm.attribute999,9,2)
			ELSE CAST(DATEPART (year, getdate()) AS VARCHAR(4)) + '-' + SUBSTRING(slm.attribute999,6,2) + '-' + SUBSTRING(slm.attribute999,9,2) 
		END AS new_attribute999
	FROM communication AS c WITH (NOLOCK) 
	INNER JOIN list as sl with (nolock) on sl.list_id = c.list_id
	inner join list_member as slm with (nolock) on slm.list_id = sl.list_id
	where 1=1
	and LEN(slm.attribute999) >= 10
	and c.communication_id in (157067)
) birthday
inner join list sl2 on sl2.list_id = birthday.list_id
INNER JOIN [list_member] slm2 WITH(NOLOCK) ON slm2.list_member_id = birthday.list_member_id
where 1=1
AND CAST(birthday.new_attribute999 as datetime) 
	BETWEEN CAST(CONVERT(VARCHAR(10),DATEADD(day, 14, getdate()),121) AS DATETIME)
	AND CAST(CONVERT(VARCHAR(10),DATEADD(day, 20, getdate()),121)AS DATETIME)
