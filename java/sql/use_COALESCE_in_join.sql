use COALESCE when you need to join and join poit can potential be null.  you cant compare null, so COALESCE into '' to compare

select 'diff' as 'm+m_target diff',
       m_target.message_code as 'm_target.message_code',
       m_target.message_body as 'm_target.message_body',
       m_target.role as 'm_target.role',
       m_target.location as 'm_target.location',
       m.message_code as 'm.message_code',
       m.message_body as 'm.message_body',
       m.role as 'm.role',
       m.location as 'm.location'
from [message] as m with(nolock)
inner join [message] as m_target with(nolock) on m_target.message_code = m.message_code + '_BACKUP'
	--and ((m.role = m_target.role) or (m.role is null and m_target.role is null))
	--and ((m.location = m_target.location) or (m.location is null and m_target.location is null))
	and COALESCE(m.role,'') = COALESCE(m_target.role,'')
	and COALESCE(m.location,'') = COALESCE(m_target.location,'')
	and m.message_code = @messageCode 
where 1=1
and m_target.message_code = m.message_code + '_BACKUP'
and m_target.message_body <> m.message_body
and m.message_code = @messageCode


select 'diff' as 'm+m_target diff',
       m_target.message_code as 'm_target.message_code',
       m_target.message_body as 'm_target.message_body',
       m_target.role as 'm_target.role',
       m_target.location as 'm_target.location',
       m.message_code as 'm.message_code',
       m.message_body as 'm.message_body',
       m.role as 'm.role',
       m.location as 'm.location'
from [TR].[dbo].[message] as m_target with(nolock)
inner join [TEST].[dbo].[message] as m with(nolock) on m.message_code = m_target.message_code
	--and ((m.role = m_target.role) or (m.role is null and m_target.role is null))
	--and ((m.location = m_target.location) or (m.location is null and m_target.location is null))
	and COALESCE(m.role,'') = COALESCE(m_target.role,'')
	and COALESCE(m.location,'') = COALESCE(m_target.location,'')
	and m.message_code = @messageCode 
where 1=1
and m.message_code = m_target.message_code
and m.message_body <> m_target.message_body
and m.message_code = @messageCode
