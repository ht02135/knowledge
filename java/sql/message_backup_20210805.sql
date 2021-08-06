begin transaction


--query 'xxx'
select '' as 'm',
       m.message_type as 'm.message_type',
       m.message_format as 'm.message_format',
       m.message_priority as 'm.message_priority',
       m.message_code as 'm.message_code',
       m.subject as 'm.subject',
       m.message_body as 'm.message_body',
       m.url as 'm.url',
       m.status as 'm.status',
       '---' as '---',
       m.*
from [message] as m WITH (nolock) 
where 1=1
--and m.creation_date >= '2021-06-01 00:00:00.000'
and (
	m.message_code like '%%xxx%' or
	m.message_code like '%%yyy%' or
-----------------------------------
)
order by m.message_type, m.message_format, m.message_priority, m.message_code, m.subject


select 'BACKUP' as 'm',
       m.message_type as 'm.message_type',
       m.message_format as 'm.message_format',
       m.message_priority as 'm.message_priority',
       m.message_code as 'm.message_code',
       m.subject as 'm.subject',
       m.message_body as 'm.message_body',
       m.url as 'm.url',
       m.status as 'm.status',
       '---' as '---',
       m.*
from [message] as m WITH (nolock) 
where 1=1
--and m.creation_date >= '2021-06-01 00:00:00.000'
and (
	m.message_code like '%%xxx%' or
	m.message_code like '%%yyy%' or
-----------------------------------
)
and m.message_code like '%BACKUP%'
order by m.message_type, m.message_format, m.message_priority, m.message_code, m.subject


--/////////////////////////////////////////////////////////


declare @userId bigint = (select user_id from users where user_name = 'hello')

DECLARE @createdTime datetime;
SET @createdTime = getdate();

DECLARE @messageCode varchar(max);

drop table #candidates
CREATE TABLE #candidates (
	messageCode VARCHAR(MAX)
);

--INSERT INTO #candidates (messageCode) VALUES ('xxx');
INSERT INTO #candidates (messageCode) VALUES ('yyy');

--SET NOCOUNT ON;

DECLARE insertCursor CURSOR
FOR SELECT messageCode FROM #candidates order by messageCode
OPEN insertCursor
FETCH insertCursor INTO @messageCode
WHILE (@@FETCH_STATUS=0) BEGIN


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


--clone 'xxx_BACKUP' of 'xxx'
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
	,[message_code]
	,[message_type]
) 
SELECT
	 0 --[version]
	,[user_id]
	,[message_code]+'_BACKUP'			--[message_code]
	,[message_type]					 	--[message_type]
FROM message
where 1=1
AND message_code in (@messageCode)
PRINT 'insert message: ENC ========================================='

	-- =========================================================================
	-- Fetch the next row
	--
	FETCH insertCursor INTO @messageCode
END
CLOSE insertCursor
DEALLOCATE insertCursor

--SET NOCOUNT OFF;

drop table #candidates


--/////////////////////////////////////////////////////////


--qc 'xxx'
select 'after insert' as 'qc m',
       m.message_type as 'm.message_type',
       m.message_format as 'm.message_format',
       m.message_priority as 'm.message_priority',
       m.message_code as 'm.message_code',
       m.subject as 'm.subject',
       m.message_body as 'm.message_body',
       m.url as 'm.url',
       m.status as 'm.status',
       '---' as '---',
       m.*
from [message] as m WITH (nolock) 
where 1=1
--and m.creation_date >= '2021-06-01 00:00:00.000'
and (
	m.message_code like '%%xxx%' or
	m.message_code like '%%yyy%' or
-----------------------------------
)
and m.message_code like '%BACKUP%'
order by m.message_type, m.message_format, m.message_priority, m.message_code, m.subject


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
