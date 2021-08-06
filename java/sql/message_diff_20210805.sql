begin transaction

select '' as 'm',
       m.message_code as 'm.message_code',
       m.message_body as 'm.message_body',
       '---' as '---',
       m.*
from [message] as m with(nolock)
where 1=1
and (
	m.message_code like '%%xxx%' or
	m.message_code like '%%yyy%' or
-----------------------------------
)
order by m.message_type, m.message_format, m.message_priority, m.message_code, m.subject


--///////////////////////////////////////////

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


--migrate to PROD
PRINT 'diff message: BEGIN ========================================='
select 'diff' as 'm+m2',
       m2.message_code as 'm2.message_code',
       m2.message_body as 'm2.message_body',
       m.message_code as 'm.message_code',
       m.message_body as 'm.message_body',
from [message] as m with(nolock)
inner join [message] as m2 with(nolock) on m.message_code = @messageCode and m2.message_code = m.message_code + '_BACKUP'
where 1=1
and m.message_code = @messageCode 
and m2.message_code = m.message_code + '_BACKUP'
and m.message_body <> m2.message_body
order by m.message_code
PRINT 'diff message: END ========================================='


	-- =========================================================================
	-- Fetch the next row
	--
	FETCH insertCursor INTO @messageCode
END
CLOSE insertCursor
DEALLOCATE insertCursor

--SET NOCOUNT OFF;

drop table #candidates


--///////////////////////////////////////////


select '' as 'qc m',
       m.message_code as 'm.message_code',
       m.message_body as 'm.message_body',
       '---' as '---',
       m.*
from [message] as m with(nolock)
where 1=1
and (
	m.message_code like '%%xxx%' or
	m.message_code like '%%yyy%' or
-----------------------------------
)
order by m.message_type, m.message_format, m.message_priority, m.message_code, m.subject


rollback
