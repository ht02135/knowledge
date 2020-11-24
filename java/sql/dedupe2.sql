begin transaction


DECLARE @lookup_list_name varchar(max);

drop table #candidates
CREATE TABLE #candidates (
	lookup_list_name VARCHAR(MAX),
);

SET NOCOUNT ON;

INSERT INTO #candidates (lookup_list_name) VALUES ('hello');
INSERT INTO #candidates (lookup_list_name) VALUES ('test');
INSERT INTO #candidates (lookup_list_name) VALUES ('blabla');

SET NOCOUNT OFF;

DECLARE insertCursor CURSOR
FOR SELECT lookup_list_name FROM #candidates order by lookup_list_name
OPEN insertCursor
FETCH insertCursor INTO @lookup_list_name
WHILE (@@FETCH_STATUS=0) BEGIN


--///////////////////////////////////////

select ll.creation_date as 'll.creation_date',
       ll.lookup_list_id as 'll.lookup_list_id',
       ll.lookup_list_name as 'll.lookup_list_name',
       ll.*
from LOOKUP_LIST as ll with(nolock) 
where 1=1
and ll.lookup_list_name = @lookup_list_name
and ll.status = 'ACTIVE'
order by ll.creation_date desc

select '' as 'before delete ll',
       min(ll.creation_date) as 'll.creation_date',
       min(ll.lookup_list_id) as 'll.lookup_list_id',
       ll.lookup_list_name,
       ll.lookup_code,
       count(*)
from LOOKUP_LIST as ll with(nolock) 
where 1=1
and ll.lookup_list_name = @lookup_list_name
and ll.status = 'ACTIVE'
group by ll.lookup_list_name, ll.lookup_code
order by ll.lookup_list_name, ll.lookup_code

PRINT 'delete ll: BEGIN ================================================================================'
delete from ll
from LOOKUP_LIST as ll with(nolock) 
where 1=1
and ll.lookup_list_name = @lookup_list_name
and ll.status = 'ACTIVE'
and ll.lookup_list_id not in (
	select min(ll2.lookup_list_id)
	from LOOKUP_LIST as ll2 with(nolock) 
	where 1=1
	and ll2.lookup_list_name = @lookup_list_name
	and ll2.status = 'ACTIVE'
	group by ll2.lookup_list_name, ll2.lookup_code
)
PRINT 'delete ll: END ================================================================================'

select '' as 'qc delete ll',
       min(ll.creation_date) as 'll.creation_date',
       min(ll.lookup_list_id) as 'll.lookup_list_id',
       ll.lookup_list_name,
       ll.lookup_code,
       count(*)
from LOOKUP_LIST as ll with(nolock) 
where 1=1
and ll.lookup_list_name = @lookup_list_name
and ll.status = 'ACTIVE'
group by ll.lookup_list_name, ll.lookup_code
order by ll.lookup_list_name, ll.lookup_code

--///////////////////////////////////////


	-- =========================================================================
	-- Fetch the next row
	--
	FETCH insertCursor INTO @lookup_list_name
END
CLOSE insertCursor
DEALLOCATE insertCursor

drop table #candidates


rollback


-- =============================================================================
-- Clean up
--
PRINT ''
PRINT '================================================================================'
PRINT 'Cleanup...'
DECLARE @table_name varchar(100);

BEGIN TRANSACTION;
SET @table_name = 'LOOKUP_LIST';
PRINT ''
PRINT 'Table: ' + @table_name + '...'
DBCC checkident(@table_name, RESEED, 0);
DBCC checkident(@table_name, RESEED);
COMMIT;

PRINT ''
PRINT 'Done'
