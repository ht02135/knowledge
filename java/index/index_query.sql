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
SELECT * 
FROM sys.indexes 
WHERE 1=1
and name in (
	'idx_execution_id',
	'idx_id',
	'idx_batch_step_job_execution_id',
	'idx_batch_job_execution_instance_id')
and (object_id = OBJECT_ID('[aloha_user_prod].[dbo].[BATCH_EXECUTION_CONTEXT]') or
     object_id = OBJECT_ID('[aloha_user_prod].[dbo].[BATCH_JOB_EXECUTION_SEQ]') or
     object_id = OBJECT_ID('[aloha_user_prod].[dbo].[BATCH_JOB_SEQ]') or
     object_id = OBJECT_ID('[aloha_user_prod].[dbo].[BATCH_STEP_EXECUTION_SEQ]') or
     object_id = OBJECT_ID('[aloha_user_prod].[dbo].[BATCH_STEP_EXECUTION]') or
     object_id = OBJECT_ID('[aloha_user_prod].[dbo].[BATCH_JOB_EXECUTION]')
)
