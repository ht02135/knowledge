select top 1000
	'' as 'u',
	r.name as 'r.name',
	r.type as 'r.type', 
	r.status as 'r.status',
	u.user_id,
	u.user_name,
	u.first_name as 'u.first_name',
	u.last_name as 'u.last_name',
	u.first_login_date as 'u.first_login_date',
	u.last_login_date as 'u.last_login_date',
	u.last_login_attempt as 'u.last_login_attempt',
	u.login_attempts as 'login_attempts',
	u.account_status as 'u.account_status'
FROM users AS u with (nolock)
INNER JOIN user_role AS ur with (nolock) ON ur.user_id = u.user_id 
INNER JOIN role AS r with (nolock) ON r.role_id = ur.role_id
where 1=1
and r.name in ('ROLE_CA')
and u.account_status in ('ACTIVE')
and u.user_id in (
	select u2.user_id
	FROM users AS u2 with (nolock)
	INNER JOIN user_role AS ur2 with (nolock) ON ur2.user_id = u2.user_id 
	INNER JOIN role AS r2 with (nolock) ON r2.role_id = ur2.role_id
	where 1=1
	and u2.account_status in ('ACTIVE')
	group by u2.user_id
	having count(*) = 1
)
order by u.user_id
