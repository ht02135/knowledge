select --communication_id,
    datepart(hour,cpe.creation_date) as Hour,
	CONVERT(VARCHAR(MAX),datepart(hour,cpe.creation_date)) + ':00:00.000' as 'military time', 
	cpe.processing_stage,
	cpe.processing_status,
	COUNT(*) as 'cpe count'
from communication_process_email cpe with (nolock)
join communication c with (nolock) on c.communication_id = cpe.communication_id
where  1=1
and cpe.creation_date > '2020-02-27 00:00:00.000' 
and cpe.creation_date < '2020-02-28 00:00:00.000'  --communication_id = 33327 
and processing_stage = 1000
Group by --communication_id,
	datepart(hour,cpe.creation_date), cpe.processing_stage, cpe.processing_status
order by --communication_id,
	Hour

/////////////////

DECLARE @StartDate DATETIME,
        @EndDate DATETIME,
        @ExecutionDates DATETIME,
        @NumberOfMonths BIGINT 
        SET @NumberOfMonths = 0 /* Use "-" + the number of months you want to pull the report for (For Example 6 months = -6) */ 
        SET @StartDate = dateadd(mm, @NumberOfMonths, getdate()) 
        SET @StartDate = dateadd(dd, datepart(dd, getdate())*-1, @StartDate) 
        SET @EndDate = dateadd(mm, 0, getdate()) 
			       
select --communication_id,
    datepart(year,cpe.creation_date) as Year,
    datepart(month,cpe.creation_date) as Month,
    datepart(day,cpe.creation_date) as Day,
    datepart(hour,cpe.creation_date) as Hour,
	CONVERT(VARCHAR(MAX),datepart(hour,cpe.creation_date)) + ':00:00.000' as 'military time', 
	cpe.processing_stage,
	cpe.processing_status,
	COUNT(*) as 'cpe count'
from communication_process_email cpe with (nolock)
join communication c with (nolock) on c.communication_id = cpe.communication_id
where  1=1
and cpe.creation_date between @StartDate and @EndDate
and processing_stage = 1000
Group by --communication_id,
    datepart(year,cpe.creation_date),
    datepart(month,cpe.creation_date),
    datepart(day,cpe.creation_date),
	datepart(hour,cpe.creation_date), cpe.processing_stage, cpe.processing_status
order by --communication_id,
	Year,Month,Day,Hour
				      
				      
