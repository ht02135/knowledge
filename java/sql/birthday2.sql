
select
       sl2.list_id as 'sl2.list_id',
       sl2.record_count as 'sl2.record_count',
       slm2.list_member_id as 'slm2.list_member_id',
       slm2.first_name as 'slm2.first_name',
       slm2.last_name as 'slm2.last_name',
       slm2.attribute888 as 'slm2.attribute888',
       birthday.new_attribute888 as 'birthday.new_attribute888',
       getdate() as 'invoice run date',
       DATEDIFF(day, birthday.new_attribute888, getdate()) AS exec_vs_birthday_diff_days,
       CAST(CONVERT(VARCHAR(10),DATEADD(day, -38, getdate()),121) AS DATETIME) as 'range begin',
       CAST(CONVERT(VARCHAR(10),DATEADD(day, -32, getdate()),121)AS DATETIME) as 'range end'
from (
	select
	    sl.list_id,
		slm.list_member_id,
		case 
			when SUBSTRING(slm.attribute888,4,3) = 'Dec' and 
				(DATEPART (year,DATEADD(day, -38, getdate()) ) < DATEPART (year, getdate()) OR 
				 DATEPART (year,DATEADD(day, -32, getdate()) ) < DATEPART (year, getdate())) 
			then CAST(DATEPART (year,DATEADD(year, -1, getdate())) AS VARCHAR(4)) + '-' + SUBSTRING(slm.attribute888,4,3) + '-' + SUBSTRING(slm.attribute888,1,2)
			else CAST(DATEPART (year, getdate()) AS VARCHAR(4)) + '-' + SUBSTRING(slm.attribute888,4,3) + '-' + SUBSTRING(slm.attribute888,1,2)
		end AS new_attribute888
	FROM communication AS c WITH (NOLOCK) 
	INNER JOIN CT AS ct WITH (NOLOCK) ON ct.CT_id = c.CT_id 
	INNER JOIN wave AS cw WITH (NOLOCK) ON cw.communication_id = c.communication_id 
	INNER JOIN event AS cwe WITH (NOLOCK) ON cwe.wave_id = cw.wave_id
	INNER JOIN list as sl with (nolock) on sl.list_id = c.list_id
	inner join list_member as slm with (nolock) on slm.list_id = sl.list_id
	where 1=1
	AND LEN(RTRIM(LTRIM(slm.attribute888))) = 11
	and ct.CT_code in ('aloha')
	and c.status = 'IN_PROCESS'
) birthday
inner join list sl2 on sl2.list_id = birthday.list_id
INNER JOIN [list_member] slm2 WITH(NOLOCK) ON slm2.list_member_id = birthday.list_member_id
where 1=1
AND CAST(birthday.new_attribute888 as datetime) 
	BETWEEN CAST(CONVERT(VARCHAR(10),DATEADD(day, -38, getdate()),121) AS DATETIME)
	AND CAST(CONVERT(VARCHAR(10),DATEADD(day, -32, getdate()),121)AS DATETIME)
