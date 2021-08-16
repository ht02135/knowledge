begin transaction


--//////////////////////////////////////////////////


declare @userId bigint = (select user_id from users where user_name = 'haha')

DECLARE @createdTime datetime;
SET @createdTime = getdate();

DECLARE @messageCode varchar(max);

drop table #candidates
CREATE TABLE #candidates (
	messageCode VARCHAR(MAX)
);

--INSERT INTO #candidates (messageCode) VALUES ('hung_test_message_sql');

--//////////////////////////////////////////////////


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
order by m.message_type, m.message_format, m.message_priority, m.message_code, m.subject


select 'BACKUP' as 'ca',
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
and m.message_code like '%BACKUP%'
order by m.message_type, m.message_format, m.message_priority, m.message_code, m.subject


--//////////////////////////////////////////////////


--SET NOCOUNT ON;

DECLARE insertCursor CURSOR
FOR SELECT messageCode FROM #candidates order by messageCode
OPEN insertCursor
FETCH insertCursor INTO @messageCode
WHILE (@@FETCH_STATUS=0) BEGIN


--insert from TEST
PRINT 'insert message: BEGIN ========================================='
IF NOT EXISTS(
	SELECT 1
	FROM [aloha_user_test_release].[dbo].[message] WITH(NOLOCK) 
	WHERE 1=1
	AND message_code = @messageCode
)
INSERT INTO [aloha_user_test_release].[dbo].[message] (
	 [version]
	,[user_id]
	,[message_priority]
	,[status]
	,[message_from]
	,[subject]
	,[message_body]
	,[message_format]
	,[role]
	,[location]
	,[location1]
	,[location2]
	,[attribute1]
	,[attribute2]
	,[attribute3]
	,[attribute4]
	,[attribute5]
	,[effective_from]
	,[effective_thru]
	,[created_by]
	,[creation_date]
	,[modified_by]
	,[modification_date]
	,[message_actions]
	,[message_code]
	,[message_type]
	,[url]
) select
	 0																--[version]
	,NULL															--[user_id]
	,NULL															--[message_priority]
	,'ACTIVE'														--[status]
	,'Admin'														--[message_from]
	,m.[subject]													--[subject]
	,m.[message_body]												--[message_body]
	,'RAW_HTML'														--[message_format]
	,m.[role]														--[role]
	,m.[location]													--[location]
	,m.[location1]													--[location1]
	,m.[location2]													--[location2]
	,NULL															--[attribute1]
	,NULL															--[attribute2]
	,NULL															--[attribute3]
	,NULL															--[attribute4]
	,NULL															--[attribute5]
	,NULL															--[effective_from]
	,NULL															--[effective_thru]
	,@userId														--[created_by]
	,@createdTime													--[creation_date]
	,NULL															--[modified_by]
	,NULL															--[modification_date]
	,m.[message_actions]											--[message_actions]
	,m.[message_code]												--[message_code]
	,'MESSAGE'														--[message_type]
	,m.[url]														--[url]
from [aloha_user_testnew].[dbo].[message] as m WITH(NOLOCK) 
where 1=1
and m.message_code = @messageCode
PRINT 'insert message: END ========================================='


--create 'under construction' message
PRINT 'insert message: BEGIN ========================================='
IF NOT EXISTS(
	SELECT 1
	FROM message WITH(NOLOCK) 
	WHERE 1=1
	AND message_code = @messageCode
)
INSERT INTO message (
	 [version]
	,[user_id]
	,[message_priority]
	,[status]
	,[message_from]
	,[subject]
	,[message_body]
	,[message_format]
	,[role]
	,[location]
	,[location1]
	,[location2]
	,[attribute1]
	,[attribute2]
	,[attribute3]
	,[attribute4]
	,[attribute5]
	,[effective_from]
	,[effective_thru]
	,[created_by]
	,[creation_date]
	,[modified_by]
	,[modification_date]
	,[message_actions]
	,[message_code]
	,[message_type]
	,[url]
) VALUES (
	 0																--[version]
	,NULL															--[user_id]
	,NULL															--[message_priority]
	,'ACTIVE'														--[status]
	,'Admin'														--[message_from]
	,@messageCode													--[subject]
	,'<div class="h3">'+@messageCode+' under construction</div>'	--[message_body]
	,'RAW_HTML'														--[message_format]
	,NULL															--[role]
	,NULL															--[location]
	,NULL															--[location1]
	,NULL															--[location2]
	,NULL															--[attribute1]
	,NULL															--[attribute2]
	,NULL															--[attribute3]
	,NULL															--[attribute4]
	,NULL															--[attribute5]
	,NULL															--[effective_from]
	,NULL															--[effective_thru]
	,@userId														--[created_by]
	,@createdTime													--[creation_date]
	,NULL															--[modified_by]
	,NULL															--[modification_date]
	,NULL															--[message_actions]
	,@messageCode													--[message_code]
	,'MESSAGE'														--[message_type]
	,NULL															--[url]
)
PRINT 'insert message: ENC ========================================='


--look for 'xxx_BACKUP' and rename to 'xxx_BACKUP_20210805'
PRINT 'update message: BEGIN ========================================='
IF NOT EXISTS(
	SELECT 1
	FROM message WITH(NOLOCK) 
	WHERE 1=1
	AND message_code = @messageCode + '_BACKUP_20210805'
)
update m
set m.message_code = m.message_code + '_20210805'
from [message] as m WITH (nolock) 
where 1=1
and m.message_code = @messageCode + '_BACKUP'
PRINT 'update message: END ========================================='


--clone 'xxx_BACKUP' off 'xxx'
PRINT 'insert message: BEGIN ========================================='
IF NOT EXISTS(
	SELECT 1
	FROM message WITH(NOLOCK) 
	WHERE 1=1
	AND message_code = @messageCode + '_BACKUP'
)
INSERT INTO message (
	 [version]
	,[user_id]
	,[message_priority]
	,[status]
	,[message_from]
	,[subject]
	,[message_body]
	,[message_format]
	,[role]
	,[location]
	,[location1]
	,[location2]
	,[attribute1]
	,[attribute2]
	,[attribute3]
	,[attribute4]
	,[attribute5]
	,[effective_from]
	,[effective_thru]
	,[created_by]
	,[creation_date]
	,[modified_by]
	,[modification_date]
	,[message_actions]
	,[message_code]
	,[message_type]
	,[url]
) 
SELECT
	 0 --[version]
	,[user_id]
	,[message_priority]
	,[status]
	,[message_from]
	,[subject]						 	--[subject]
	,[message_body]						--[message_body]
	,[message_format]
	,[role]
	,[location]
	,[location1]
	,[location2]
	,[attribute1]
	,[attribute2]
	,[attribute3]
	,[attribute4]
	,[attribute5]
	,[effective_from]
	,[effective_thru]
	,@userId 							--[created_by]
	,@createdTime 						--[creation_date]
	,NULL 								--[modified_by]
	,NULL 								--[modification_date]
	,[message_actions]
	,[message_code]+'_BACKUP'			--[message_code]
	,[message_type]					 	--[message_type]
	,[url]
FROM message
where 1=1
AND message_code in (@messageCode)
PRINT 'insert message: ENC ========================================='


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
from [aloha_user_test_release].[dbo].[message] as m_target with(nolock)
inner join [aloha_user_testnew].[dbo].[message] as m with(nolock) on m.message_code = m_target.message_code
	and ((m.role = m_target.role) or (m.role is null and m_target.role is null))
	and m.message_code = @messageCode 
where 1=1
and m.message_code = m_target.message_code
and ((m.role = m_target.role) or (m.role is null and m_target.role is null))
and m.message_code = @messageCode
/*
and (m.subject <> m_target.subject or
	 m.message_body <> m_target.message_body)
*/
and m.message_body <> m_target.message_body
order by m.message_type, m.message_format, m.message_priority, m.message_code, m.subject


---------------------------------------------
--update aloha_user_test_release
--and m.subject <> m_target.subject
/*
update m_target
set m_target.subject = m.subject
from [aloha_user_test_release].[dbo].[message] as m_target with(nolock)
inner join [aloha_user_testnew].[dbo].[message] as m with(nolock) on m.message_code = m_target.message_code
	and ((m.role = m_target.role) or (m.role is null and m_target.role is null))
	and m.message_code = @messageCode 
where 1=1
and m.message_code = m_target.message_code
and ((m.role = m_target.role) or (m.role is null and m_target.role is null))
and m.message_code = @messageCode 	
and m.subject <> m_target.subject
*/


--update aloha_user_test_release
--and m.message_body <> m_target.message_body 
update m_target
set m_target.message_body = m.message_body
from [aloha_user_test_release].[dbo].[message] as m_target with(nolock)
inner join [aloha_user_testnew].[dbo].[message] as m with(nolock) on m.message_code = m_target.message_code
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
from [aloha_user_test_release].[dbo].[message] as m_target with(nolock)
inner join [aloha_user_testnew].[dbo].[message] as m with(nolock) on m.message_code = m_target.message_code
	and ((m.role = m_target.role) or (m.role is null and m_target.role is null))
	and m.message_code = @messageCode 
where 1=1
and m.message_code = m_target.message_code
and ((m.role = m_target.role) or (m.role is null and m_target.role is null))
and m.message_code = @messageCode 	
/*
and (m.subject <> m_target.subject or
	 m.message_body <> m_target.message_body)
*/
and m.message_body <> m_target.message_body
order by m.message_type, m.message_format, m.message_priority, m.message_code, m.subject


PRINT 'migrate message: END ========================================='


	-- =========================================================================
	-- Fetch the next row
	--
	FETCH insertCursor INTO @messageCode
END
CLOSE insertCursor
DEALLOCATE insertCursor

--SET NOCOUNT OFF;


--/////////////////////////////////////////////////////////


--qc 'xxx'
select '' as 'qc m',
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
order by m.message_type, m.message_format, m.message_priority, m.message_code, m.subject


select 'BACKUP' as 'qc m',
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
and m.message_code like '%BACKUP%'
order by m.message_type, m.message_format, m.message_priority, m.message_code, m.subject


select 'sort message_id' as 'last m',
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
order by m.message_id desc


select 'sort modification_date' as 'last m',
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
order by m.modification_date desc


select 'count' as 'last m',
       m.message_code,
       count(*) as 'cnt'
from #candidates as ca WITH (nolock) 
left join [message] as m WITH (nolock) on m.message_code like ca.messageCode + '%'
where 1=1
and m.message_code like ca.messageCode + '%'
group by m.message_code
order by count(*) desc


rollback

-- =============================================================================
-- Clean up
--
PRINT ''
PRINT '================================================================================'
PRINT 'Cleanup...'
DECLARE @table_name varchar(100);

BEGIN TRANSACTION;
SET @table_name = 'message';
PRINT ''
PRINT 'Table: ' + @table_name + '...'
DBCC checkident(@table_name, RESEED, 0);
DBCC checkident(@table_name, RESEED);
COMMIT;

PRINT ''
PRINT 'Done'
