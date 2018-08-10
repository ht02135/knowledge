drop table #candidate;
SELECT
       max(slm.stored_list_member_id) as stored_list_member_id,
       slm.last_name,
       slm.first_name,
       slm.state_province,
	   slm.postal_code,
	   slm.city,
	   slm.address_line_1
into #candidate
FROM communication AS c WITH (NOLOCK) 
inner join stored_list as sl WITH (NOLOCK) ON sl.stored_list_id = c.stored_list_id
inner join stored_list_member as slm WITH (NOLOCK) ON slm.stored_list_id = sl.stored_list_id
WHERE 1=1
and c.communication_id in (195163)
group by slm.last_name, slm.first_name, slm.state_province, slm.postal_code, slm.city, slm.address_line_1
ORDER BY slm.last_name desc, slm.first_name desc, slm.state_province desc, slm.postal_code desc, slm.city desc, slm.address_line_1 desc


SELECT
	   CASE WHEN EXISTS (select 1 from #candidate as ca where 1=1 and ca.stored_list_member_id = slm.stored_list_member_id) 
       THEN 'KEEP'
	   ELSE 'DELETE' 
	   END AS 'KEEP or DELETE',
       slm.stored_list_member_id,
       slm.last_name,
       slm.first_name,
       slm.state_province,
	   slm.postal_code,
	   slm.city,
	   slm.address_line_1
FROM communication AS c WITH (NOLOCK) 
inner join stored_list as sl WITH (NOLOCK) ON sl.stored_list_id = c.stored_list_id
inner join stored_list_member as slm WITH (NOLOCK) ON slm.stored_list_id = sl.stored_list_id
WHERE 1=1
and c.communication_id in (195163)
ORDER BY slm.last_name desc, slm.first_name desc, slm.state_province desc, slm.postal_code desc, slm.city desc, slm.address_line_1 desc, slm.stored_list_member_id desc
