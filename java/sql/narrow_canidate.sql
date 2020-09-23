select u.user_id,
       u.account_status,
       u.first_name,
       u.last_name,
       sl.type,
       sl.name,
       sl.record_count,
       sl.status as 'sl.status',
       slm.stored_list_id as 'eslm.stored_list_id',
	   slm.stored_list_member_id as 'slm.stored_list_member_id',
	   slm.first_name,
	   slm.last_name,
	   slm.company_name, 
	   len(slm.company_name) as 'len(slm.title)'
from (
	   SELECT distinct c.user_id
	   FROM communication AS c WITH (NOLOCK) 
	   INNER JOIN communication_template AS ct WITH (nolock) ON ct.communication_template_id = c.communication_template_id
	   INNER JOIN communication_wave AS w WITH (NOLOCK) ON w.communication_id = c.communication_id 
	   INNER JOIN communication_wave_event AS e WITH (NOLOCK) ON e.communication_wave_id = w.communication_wave_id
	   INNER JOIN stored_list_member as eslm WITH(NOLOCK) on eslm.stored_list_id = e.stored_list_id
	   and len(eslm.company_name) > 50
	   WHERE 1=1
	   and len(eslm.company_name) > 50
) as candidate_user
inner join users as u with(nolock) on u.user_id = candidate_user.user_id
	and u.account_status = 'ACTIVE'
inner join stored_list as sl with(nolock) on sl.owner_id = u.user_id
	and sl.status = 'ACTIVE'
INNER JOIN stored_list_member as slm WITH(NOLOCK) on slm.stored_list_id = sl.stored_list_id
	and len(slm.company_name) > 50
where 1=1
and u.account_status = 'ACTIVE'
and sl.status = 'ACTIVE'
and len(slm.company_name) > 50

users, stored_list, and stored_list_member are huge table.
1>you really need to figure out candidate user_id before you go ahead join those big table.
2>so you need to create from clause this way and then join with other table
