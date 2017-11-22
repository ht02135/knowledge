select top 100 
	'' as 'otwsi',
	c.C_id,
	c.status,
	otwsi.OTWSI_id as 'otwsi.OTWSI_id',
	otwsi.creation_date as 'otwsi.creation_date',
	otwsi.payload as 'otwsi.payload',
	otwsi.processing_stage as 'otwsi.processing_stage',
	otwsi.processing_status as 'otwsi.processing_status',
	otwsi.error_message as 'otwsi.error_message',
	otwsi.* 
from C as c with (nolock)
left join OTWSI as otwsi with (nolock) on otwsi.payload like '%orderID="'+cast(c.C_id as nvarchar(50))+'"%'
where 1=1
and c.C_id = 252107
order by c.C_id desc


select top 100
	'' as 'oti',
	c.C_id,
	c.status,
	oti.OTI_id as 'oti.OTI_id',
	oti.creation_date as 'oti.creation_date',
	oti.payload as 'oti.payload',
	oti.processing_stage as 'oti.processing_stage',
	oti.processing_status as 'oti.processing_status',
	oti.error_message as 'oti.error_message',
	oti.*
from C as c with (nolock)	
left join OTI as oti with (nolock) on oti.payload like '%orderID="'+cast(c.C_id as nvarchar(50))+'"%'
where 1=1
and c.C_id = 252107
order by c.C_id desc


select top 100 
	'' as 'otwsi',
	c.C_id,
	c.status,
	otwsi.OTWSI_id as 'otwsi.OTWSI_id',
	otwsi.creation_date as 'otwsi.creation_date',
	otwsi.payload as 'otwsi.payload',
	otwsi.processing_stage as 'otwsi.processing_stage',
	otwsi.processing_status as 'otwsi.processing_status',
	otwsi.error_message as 'otwsi.error_message',
	otwsi.* 
from C as c with (nolock)
left join OTWSI as otwsi with (nolock) on otwsi.payload like '%orderID="'+cast(c.C_id as nvarchar(50))+'"%'
where 1=1
and c.C_id in (
	select top 10 ss.C_id 
	from C_itemized_shipment_status as ss with (nolock)
	where 1=1 
	and ss.fulfilled_by = 'p2' 
	and ss.status = 'In Progress')
order by c.C_id desc


select top 100
	'' as 'oti',
	c.C_id,
	c.status,
	oti.OTI_id as 'oti.OTI_id',
	oti.creation_date as 'oti.creation_date',
	oti.payload as 'oti.payload',
	oti.processing_stage as 'oti.processing_stage',
	oti.processing_status as 'oti.processing_status',
	oti.error_message as 'oti.error_message',
	oti.*
from C as c with (nolock)	
left join OTI as oti with (nolock) on oti.payload like '%orderID="'+cast(c.C_id as nvarchar(50))+'"%'
where 1=1
and c.C_id in (
	select top 10 ss.C_id 
	from C_itemized_shipment_status as ss with (nolock)
	where 1=1 
	and ss.fulfilled_by = 'p2' 
	and ss.status = 'In Progress')
order by c.C_id desc
