begin transaction

drop table #candidates;

select
	'' as 'it',
	it.item_code as 'it.item_code',
	it.status as 'it.status',
	it.expire as 'it.expire',
    it.*
INTO #candidates
from item as it with(nolock)
where 1=1
and it.expire < GETDATE()
and it.status <> 'INACTIVE'
ORDER BY it.item_code

--QUERY
select ca.* from #candidates as ca WITH (NOLOCK) order by ca.item_code

--/////////////////////
--update

DECLARE @userId NUMERIC(19, 0);
SELECT @userId = user_id from users with(nolock) where user_name = 'hello';

update it
set it.version = it.version+1,
    it.status = 'INACTIVE',
    it.modified_by = @userId,
    it.modification_date = GETDATE()
from item as it
where 1=1
and it.expire < GETDATE()
and it.status <> 'INACTIVE'

--/////////////////////
--qc

select
	'if INACTIVE?' as 'qc it',
	it.item_code as 'it.item_code',
	it.status as 'it.status',
	it.expire as 'it.expire',
	it.modified_by as 'it.modified_by',
	it.modification_date as 'it.modification_date',
    it.*
from item as it with(nolock)
where 1=1
and it.item_code in (select ca.item_code from #candidates as ca WITH (NOLOCK))
ORDER BY it.item_code

select
	'anymore ACTIVE?' as 'qc it',
	it.item_code as 'it.item_code',
	it.status as 'it.status',
	it.expire as 'it.expire',
	it.modified_by as 'it.modified_by',
	it.modification_date as 'it.modification_date',
    it.*
from item as it with(nolock)
where 1=1
and it.expire < GETDATE()
and it.status <> 'INACTIVE'
ORDER BY it.item_code


rollback


-- =============================================================================
-- Clean up
--
PRINT ''
PRINT '================================================================================'
PRINT 'Cleanup...'
DECLARE @table_name varchar(100);

BEGIN TRANSACTION;
SET @table_name = 'item';
PRINT ''
PRINT 'Table: ' + @table_name + '...'
DBCC checkident(@table_name, RESEED, 0);
DBCC checkident(@table_name, RESEED);
COMMIT;


PRINT ''
PRINT 'Done'
