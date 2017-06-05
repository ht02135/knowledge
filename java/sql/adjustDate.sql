UPDATE [calendar_schedule]
set cutoff_date =
 cast(
 CONVERT(VARCHAR(MAX),DATENAME(YYYY,cutoff_date)) + '-' +
 CONVERT(VARCHAR(MAX),DATEPART(mm,cutoff_date)) + '-' +
 CONVERT(VARCHAR(MAX),DATENAME(DD,cutoff_date)) + ' 06:00:00.000' as datetime)

--------------
--additional check insert
INSERT INTO schedule_date 
(	version
	,schedule_name
	,cutoff_date
	,execute_date
	,mail_date
	,created_by
	,creation_date) 
SELECT
	0
	,sd.schedule_name
	,sd.cutoff_date
	,sd.execute_date
	,sd.mail_date
	,@userId
    ,getdate()
from [calendar_schedule] as sd
where NOT EXISTS (
	SELECT sd2.schedule_date_id 
	from schedule_date as sd2 with(nolock)
	where 1=1
	and sd2.schedule_name = sd.schedule_name
	and sd2.cutoff_date = sd.cutoff_date
	and sd2.execute_date = sd.execute_date
	and sd2.mail_date = sd.mail_date
)

--regular insert
INSERT INTO schedule_date 
(	version
	,schedule_name
	,cutoff_date
	,execute_date
	,mail_date
	,created_by
	,creation_date) 
SELECT
	0
	,sd.schedule_name
	,sd.cutoff_date
	,sd.execute_date
	,sd.mail_date
	,@userId
    ,getdate()
from calendar_schedule as sd
where 1=1

--check new record
SELECT
	'' as 'new records',
	sd.schedule_name,
	sd.cutoff_date,
	sd.execute_date,
	sd.mail_date
from calendar_schedule as sd
where NOT EXISTS (
	SELECT sd2.schedule_date_id 
	from schedule_date as sd2 with(nolock)
	where 1=1
	and sd2.schedule_name = sd.schedule_name
	--and sd2.cutoff_date = sd.cutoff_date
	--and sd2.execute_date = sd.execute_date
	and sd2.mail_date = sd.mail_date
)

--check updated record
SELECT
	'' as 'updated records',
	sd.schedule_name as 'stg_sd.schedule_name',
	sd.cutoff_date as 'stg_sd.cutoff_date',
	sd.execute_date as 'stg_sd.execute_date',
	sd.mail_date as 'stg_sd.mail_date',
	sd2.cutoff_date as 'sd2.cutoff_date',
	sd2.execute_date as 'sd2.execute_date',
	sd2.mail_date as 'sd2.mail_date'
from calendar_schedule as sd
inner join schedule_date as sd2 with(nolock) on sd2.schedule_name = sd.schedule_name and sd2.mail_date = sd.mail_date
where 1=1
--and sd2.schedule_name = sd.schedule_name
--and sd2.mail_date = sd.mail_date
and (sd2.cutoff_date <> sd.cutoff_date or sd2.execute_date <> sd.execute_date)
