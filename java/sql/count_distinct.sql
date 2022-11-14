--you can do distinct inside count
SELECT 'DOWNLOAD' as 'c count',
	   cwt.order_type as 'cwt.order_type',
	   cwt.processing_type as 'cwt.processing_type',
	   cwt.delivery_channel as 'cwt.delivery_channel',
	   ct.subscription_ind,
	   ct.CT_type,
	   count(DISTINCT ct.CT_id) as ct_cnt,
	   count(DISTINCT cwt.CWT_id) as cwt_cnt,
	   count(DISTINCT c.C_id) as c_cnt     
from CT AS ct WITH (NOLOCK)
inner JOIN CWT as cwt WITH(NOLOCK) ON cwt.CT_id = ct.CT_id
left join C AS c WITH (NOLOCK) on c.CT_id = ct.CT_id 
WHERE 1=1
group by cwt.order_type,
		 cwt.processing_type,
		 cwt.delivery_channel,
		 ct.subscription_ind,
		 ct.CT_type
order by cwt.order_type,
		 cwt.processing_type,
		 cwt.delivery_channel,
		 ct.subscription_ind,
		 ct.CT_type
