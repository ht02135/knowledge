begin transaction


select count(*)
from stored_list as sl with(nolock)
inner join stored_list_member as slm with(nolock) on slm.stored_list_id = sl.stored_list_id
where 1=1
and sl.stored_list_id = 2


/*
DELETE FROM cart_cache_cart_387015   
WHERE ID NOT IN (   
	SELECT MIN(id) 
	FROM cart_cache_cart_387015   
	GROUP BY   
	isnull(first_name,''), isnull(last_name,''), isnull(full_name,''),   
	isnull(address_line_1,''), isnull(postal_code,''),   
	isnull(email_addr,''))  
-----------------
stored_list_id=2
---------------------------
*/
select MIN(slm.stored_list_member_id)
from stored_list as sl with(nolock)
inner join stored_list_member as slm with(nolock) on slm.stored_list_id = sl.stored_list_id
where 1=1
and sl.stored_list_id = 2
group by 
isnull(slm.first_name,''), isnull(slm.last_name,''), isnull(slm.full_name,''),   
isnull(slm.address_line_1,''), isnull(slm.postal_code,''),   
isnull(slm.email_addr,'')


--deduped record
select '' as 'deduped record',
       slm2.stored_list_member_id,
       slm2.first_name,
       slm2.last_name,
       slm2.full_name,
       slm2.address_line_1,
       slm2.postal_code,
       slm2.email_addr
from stored_list as sl2 with(nolock)
inner join stored_list_member as slm2 with(nolock) on slm2.stored_list_id = sl2.stored_list_id
where 1=1
and sl2.stored_list_id = 2
and slm2.stored_list_member_id not in (
	select MIN(slm.stored_list_member_id)
	from stored_list as sl with(nolock)
	inner join stored_list_member as slm with(nolock) on slm.stored_list_id = sl.stored_list_id
	where 1=1
	and sl.stored_list_id = 2
	group by 
	isnull(slm.first_name,''), isnull(slm.last_name,''), isnull(slm.full_name,''),   
	isnull(slm.address_line_1,''), isnull(slm.postal_code,''),   
	isnull(slm.email_addr,'')
)


--selectd records
select '' as 'selected record',
       slm2.stored_list_member_id,
       slm2.first_name,
       slm2.last_name,
       slm2.full_name,
       slm2.address_line_1,
       slm2.postal_code,
       slm2.email_addr
from stored_list as sl2 with(nolock)
inner join stored_list_member as slm2 with(nolock) on slm2.stored_list_id = sl2.stored_list_id
where 1=1
and sl2.stored_list_id = 2
and slm2.stored_list_member_id in (
	select MIN(slm.stored_list_member_id)
	from stored_list as sl with(nolock)
	inner join stored_list_member as slm with(nolock) on slm.stored_list_id = sl.stored_list_id
	where 1=1
	and sl.stored_list_id = 2
	group by 
	isnull(slm.first_name,''), isnull(slm.last_name,''), isnull(slm.full_name,''),   
	isnull(slm.address_line_1,''), isnull(slm.postal_code,''),   
	isnull(slm.email_addr,'')
)

--/////////////////

--selectd records
select '' as 'deduped record 2',
       slm2.stored_list_member_id,
       slm2.first_name,
       slm2.last_name,
       slm2.state_province,
       slm2.city,
       slm2.postal_code,
       slm2.address_line_1
from stored_list as sl2 with(nolock)
inner join stored_list_member as slm2 with(nolock) on slm2.stored_list_id = sl2.stored_list_id
where 1=1
and sl2.stored_list_id = 1836586
and slm2.stored_list_member_id in (
	select MIN(slm.stored_list_member_id)
	from stored_list as sl with(nolock)
	inner join stored_list_member as slm with(nolock) on slm.stored_list_id = sl.stored_list_id
	where 1=1
	and sl.stored_list_id = 1836586
	group by 
	isnull(slm.state_province,''), isnull(slm.city,''), isnull(slm.postal_code,''),   
	isnull(slm.address_line_1,'')
)
and slm2.stored_list_member_id in (
	select MIN(slm.stored_list_member_id)
	from stored_list as sl with(nolock)
	inner join stored_list_member as slm with(nolock) on slm.stored_list_id = sl.stored_list_id
	where 1=1
	and sl.stored_list_id = 1836586
	group by 
	isnull(slm.last_name,''), isnull(slm.first_name,'')
)


--/////////////

drop table #candidate;
select
       slm2.stored_list_member_id,
       slm2.first_name,
       slm2.last_name,
       slm2.state_province,
       slm2.city,
       slm2.postal_code,
       slm2.address_line_1
into #candidate
from stored_list as sl2 with(nolock)
inner join stored_list_member as slm2 with(nolock) on slm2.stored_list_id = sl2.stored_list_id
where 1=1
and sl2.stored_list_id = 1836586
and slm2.stored_list_member_id in (
	select MIN(slm.stored_list_member_id)
	from stored_list as sl with(nolock)
	inner join stored_list_member as slm with(nolock) on slm.stored_list_id = sl.stored_list_id
	where 1=1
	and sl.stored_list_id = 1836586
	group by 
	isnull(slm.state_province,''), isnull(slm.city,''), isnull(slm.postal_code,''),   
	isnull(slm.address_line_1,'')
)
and slm2.stored_list_member_id in (
	select MIN(slm.stored_list_member_id)
	from stored_list as sl with(nolock)
	inner join stored_list_member as slm with(nolock) on slm.stored_list_id = sl.stored_list_id
	where 1=1
	and sl.stored_list_id = 1836586
	group by 
	isnull(slm.last_name,''), isnull(slm.first_name,'')
)

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
and c.communication_id in (197113)
ORDER BY slm.last_name desc, slm.first_name desc, slm.state_province desc, slm.postal_code desc, slm.city desc, slm.address_line_1 desc, slm.stored_list_member_id desc




rollback
