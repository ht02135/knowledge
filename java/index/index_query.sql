/*
OBJECT_ID ( '[ database_name . [ schema_name ] . | schema_name . ]   
  object_name' [ ,'object_type' ] )  
--------------
object_id	name	index_id	type	type_desc
97500975	idx_execution_id	1	1	CLUSTERED
129501089	idx_batch_job_execution_instance_id	6	2	NONCLUSTERED
193501317	idx_id	1	1	CLUSTERED
273501602	idx_id	1	1	CLUSTERED
289501659	idx_batch_step_job_execution_id	5	2	NONCLUSTERED
337501830	idx_id	1	1	CLUSTERED
*/
SELECT 
    DB_NAME(object_id) AS 'DB_NAME',
    OBJECT_SCHEMA_NAME(object_id) AS OBJECT_SCHEMA_NAME,
	OBJECT_NAME(object_id) as 'OBJECT_NAME',
	object_id as 'OBJECT_ID',
	*
FROM sys.indexes 
WHERE 1=1
and name in (
	'idx_execution_id',
	'idx_id',
	'idx_batch_step_job_execution_id',
	'idx_batch_job_execution_instance_id')
and (object_id = OBJECT_ID('[dbo].[BATCH_EXECUTION_CONTEXT]') or
     object_id = OBJECT_ID('[dbo].[BATCH_JOB_EXECUTION_SEQ]') or
     object_id = OBJECT_ID('[dbo].[BATCH_JOB_SEQ]') or
     object_id = OBJECT_ID('[dbo].[BATCH_STEP_EXECUTION_SEQ]') or
     object_id = OBJECT_ID('[dbo].[BATCH_STEP_EXECUTION]') or
     object_id = OBJECT_ID('[dbo].[BATCH_JOB_EXECUTION]')
)

check if index is created for tables.  or you just go to tables and drill down index from microsoft sql studio

BATCH_EXECUTION_CONTEXT
BATCH_JOB_SEQ
BATCH_JOB_EXECUTION_SEQ
BATCH_JOB_EXECUTION
BATCH_STEP_EXECUTION_SEQ
BATCH_STEP_EXECUTION
