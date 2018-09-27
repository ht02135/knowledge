
--check cpe per min
select 
	   datepart(hour,cpe.creation_date) 'Hour',
	   datepart(minute,cpe.creation_date) 'Minute', 
	   cpe.processing_stage,cpe.processing_status,COUNT(*) 'Count'
from CPE cpe with (nolock)
join C c with (nolock) on c.C_id = cpe.C_id
where   cpe.creation_date > '2015-09-29 00:01' and cpe.creation_date < '2015-09-29 19:00'
Group by datepart(hour,cpe.creation_date), datepart(minute,cpe.creation_date), cpe.processing_stage, cpe.processing_status
order by Hour, minute


--check cpe per hour
select 
	   datepart(hour,cpe.creation_date) 'Hour' , 
	   cpe.processing_stage,cpe.processing_status,COUNT(*) 'Count'
from CPE cpe with (nolock)
join C c with (nolock) on c.C_id = cpe.C_id
where 1=100
and cpe.creation_date > '2018-09-25 00:01' and cpe.creation_date < '2018-09-25 19:00'
and ((processing_stage=100 and processing_status=1) or
     (processing_stage=100 and processing_status=999))
Group by datepart(hour,cpe.creation_date), cpe.processing_stage, cpe.processing_status
order by Hour
