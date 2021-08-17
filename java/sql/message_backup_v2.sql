begin transaction


DECLARE @messageCode varchar(max);

drop table #candidates
CREATE TABLE #candidates (
	messageCode VARCHAR(MAX)
);

INSERT INTO #candidates (messageCode) VALUES ('test_sql');


select '' as 'ca',
	   ca.messageCode as 'ca.messageCode',
       m.message_code as 'm.message_code',
       '|'+m.message_code+'|' as 'm.message_code 2',
       m.creation_date as 'm.creation_date',
       m.modification_date as 'm.modification_date',
       m.subject as 'm.subject',
       m.message_body as 'm.message_body',
       m.url as 'm.url',
       m.message_type as 'm.message_type',
       m.message_format as 'm.message_format',
       m.message_priority as 'm.message_priority',
       m.status as 'm.status',
       '---' as '---',
       m.*
from #candidates as ca WITH (nolock) 
left join [message] as m WITH (nolock) on m.message_code like ca.messageCode + '%'
where 1=1
and m.message_code like ca.messageCode + '%'
and ((m.message_code = ca.messageCode) or
     (m.message_code+'_BACKUP' = ca.messageCode+'_BACKUP') or
     (m.message_code+'_BACKUP_20210805' = ca.messageCode+'_BACKUP_20210816'))
order by m.message_type, m.message_format, m.message_priority, m.message_code, m.subject


rollback
