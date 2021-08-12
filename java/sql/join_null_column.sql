begin transaction

/*
assuming you try to synch message from TEST to TR
1>message_code is not empty, but is not unique
2>role can have value or null?

how to join
from [TR].[dbo].[message] as m_target with(nolock)
inner join [TEST].[dbo].[message] as m with(nolock) on m.message_code = m_target.message_code
	and ((m.role = m_target.role) or (m.role is null and m_target.role is null))
  
this is just chance thing align message with same message_code and role up.  it is only good
1>few message_code with distinct role configuration
*/

--migrate to 
PRINT 'migrate message: BEGIN ========================================='
select 'diff' as 'm+m_target diff',
       m_target.message_code as 'm_target.message_code',
       m_target.subject as 'm_target.subject',
       m_target.message_body as 'm_target.message_body',
       m_target.role as 'm_target.role',
       m.message_code as 'm.message_code',
       m.subject as 'm.subject',
       m.message_body as 'm.message_body',
       m.role as 'm.role'
from [TR].[dbo].[message] as m_target with(nolock)
inner join [TEST].[dbo].[message] as m with(nolock) on m.message_code = m_target.message_code
	and ((m.role = m_target.role) or (m.role is null and m_target.role is null))
	and m.message_code = @messageCode 
where 1=1
and m.message_code = m_target.message_code
and ((m.role = m_target.role) or (m.role is null and m_target.role is null))
and m.message_code = @messageCode 	
and (m.subject <> m_target.subject or
	 m.message_body <> m_target.message_body)
order by m.message_type, m.message_format, m.message_priority, m.message_code, m.subject


---------------------------------------------
--update TR
--and m.subject <> m_target.subject
update m_target
set m_target.subject = m.subject
from [TR].[dbo].[message] as m_target with(nolock)
inner join [TEST].[dbo].[message] as m with(nolock) on m.message_code = m_target.message_code
	and ((m.role = m_target.role) or (m.role is null and m_target.role is null))
	and m.message_code = @messageCode 
where 1=1
and m.message_code = m_target.message_code
and ((m.role = m_target.role) or (m.role is null and m_target.role is null))
and m.message_code = @messageCode 	
and m.subject <> m_target.subject
	 

--update TR
--and m.message_body <> m_target.message_body 
update m_target
set m_target.message_body = m.message_body
from [TR].[dbo].[message] as m_target with(nolock)
inner join [TEST].[dbo].[message] as m with(nolock) on m.message_code = m_target.message_code
	and ((m.role = m_target.role) or (m.role is null and m_target.role is null))
	and m.message_code = @messageCode 
where 1=1
and m.message_code = m_target.message_code
and ((m.role = m_target.role) or (m.role is null and m_target.role is null))
and m.message_code = @messageCode 	
and m.message_body <> m_target.message_body


select 'diff 2' as 'm+m_target diff 2',
       m_target.message_code as 'm_target.message_code',
       m_target.subject as 'm_target.subject',
       m_target.message_body as 'm_target.message_body',
       m_target.role as 'm_target.role',
       m.message_code as 'm.message_code',
       m.subject as 'm.subject',
       m.message_body as 'm.message_body',
       m.role as 'm.role'
from [TR].[dbo].[message] as m_target with(nolock)
inner join [TEST].[dbo].[message] as m with(nolock) on m.message_code = m_target.message_code
	and ((m.role = m_target.role) or (m.role is null and m_target.role is null))
	and m.message_code = @messageCode 
where 1=1
and m.message_code = m_target.message_code
and ((m.role = m_target.role) or (m.role is null and m_target.role is null))
and m.message_code = @messageCode 	
and (m.subject <> m_target.subject or
	 m.message_body <> m_target.message_body)
order by m.message_type, m.message_format, m.message_priority, m.message_code, m.subject



rollback
