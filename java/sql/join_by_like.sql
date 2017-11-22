select top 100 
	'' as 'otwsi',
	c.communication_id,
	c.status,
	otwsi.order_tracking_web_service_item_id as 'otwsi.order_tracking_web_service_item_id',
	otwsi.creation_date as 'otwsi.creation_date',
	otwsi.payload as 'otwsi.payload',
	otwsi.processing_stage as 'otwsi.processing_stage',
	otwsi.processing_status as 'otwsi.processing_status',
	otwsi.error_message as 'otwsi.error_message',
	otwsi.* 
from communication as c with (nolock)
left join order_tracking_web_service_item as otwsi with (nolock) on otwsi.payload like '%orderID="'+cast(c.communication_id as nvarchar(50))+'"%'
where 1=1
and c.communication_id = 252107
order by c.communication_id desc


select top 100
	'' as 'oti',
	c.communication_id,
	c.status,
	oti.order_tracking_item_id as 'oti.order_tracking_item_id',
	oti.creation_date as 'oti.creation_date',
	oti.payload as 'oti.payload',
	oti.processing_stage as 'oti.processing_stage',
	oti.processing_status as 'oti.processing_status',
	oti.error_message as 'oti.error_message',
	oti.*
from communication as c with (nolock)	
left join order_tracking_item as oti with (nolock) on oti.payload like '%orderID="'+cast(c.communication_id as nvarchar(50))+'"%'
where 1=1
and c.communication_id = 252107
order by c.communication_id desc


select top 100 
	'' as 'otwsi',
	c.communication_id,
	c.status,
	otwsi.order_tracking_web_service_item_id as 'otwsi.order_tracking_web_service_item_id',
	otwsi.creation_date as 'otwsi.creation_date',
	otwsi.payload as 'otwsi.payload',
	otwsi.processing_stage as 'otwsi.processing_stage',
	otwsi.processing_status as 'otwsi.processing_status',
	otwsi.error_message as 'otwsi.error_message',
	otwsi.* 
from communication as c with (nolock)
left join order_tracking_web_service_item as otwsi with (nolock) on otwsi.payload like '%orderID="'+cast(c.communication_id as nvarchar(50))+'"%'
where 1=1
and c.communication_id in (
	select top 10 ss.communication_id 
	from communication_itemized_shipment_status as ss with (nolock)
	where 1=1 
	and ss.fulfilled_by = 'pii_cards' 
	and ss.status = 'In Progress')
order by c.communication_id desc


select top 100
	'' as 'oti',
	c.communication_id,
	c.status,
	oti.order_tracking_item_id as 'oti.order_tracking_item_id',
	oti.creation_date as 'oti.creation_date',
	oti.payload as 'oti.payload',
	oti.processing_stage as 'oti.processing_stage',
	oti.processing_status as 'oti.processing_status',
	oti.error_message as 'oti.error_message',
	oti.*
from communication as c with (nolock)	
left join order_tracking_item as oti with (nolock) on oti.payload like '%orderID="'+cast(c.communication_id as nvarchar(50))+'"%'
where 1=1
and c.communication_id in (
	select top 10 ss.communication_id 
	from communication_itemized_shipment_status as ss with (nolock)
	where 1=1 
	and ss.fulfilled_by = 'pii_cards' 
	and ss.status = 'In Progress')
order by c.communication_id desc
