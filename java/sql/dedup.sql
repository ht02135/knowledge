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


rollback
