
--return 1720 rows
select '' as 'c',
       a.*,
       '---' as '--',
       c.communication_id as 'c.communication_id'
from (
select
	   SUBSTRING(edr.notificationJson,
	             CHARINDEX('orderId=',edr.notificationJson) + 8, 
                 CHARINDEX(', communicationWaveId=',edr.notificationJson) - CHARINDEX('orderId=',edr.notificationJson) - 8) as 'communication_id',
	   SUBSTRING(edr.notificationJson,
	             CHARINDEX('storeListMemberId=',edr.notificationJson) + 8, 
                 CHARINDEX(', userId=',edr.notificationJson) - CHARINDEX('storeListMemberId=',edr.notificationJson) - 8) as 'stored_list_member_id',        
       edr.*
from [ERIE_dcoe_records] as edr with(nolock)
) as a
inner join communication as c WITH (nolock) on c.communication_id = a.communication_id

--create 'a' alias closure to capture alias field into 'a' closure
select a.*,
       '---' as '--',
       c.communication_id as 'c.communication_id',
	   cpe.communication_process_email_id as 'cpe.communication_process_email_id',
	   cpe.creation_date as 'cpe.creation_date',
	   cpe.delivered_timestamp as 'cpe.delivered_timestamp',
	   cpe.stored_list_member_id as 'cpe.stored_list_member_id',
       cpe.list_of_to_addresses as 'cpe.list_of_to_addresses', 
	   cpe.processing_stage as 'cpe.processing_stage', 
	   cpe.processing_status as 'cpe.processing_status'
from (
select
	   SUBSTRING(edr.notificationJson,
	             CHARINDEX('orderId=',edr.notificationJson) + 8, 
                 CHARINDEX(', communicationWaveId=',edr.notificationJson) - CHARINDEX('orderId=',edr.notificationJson) - 8) as 'communication_id',
	   SUBSTRING(edr.notificationJson,
	             CHARINDEX('storeListMemberId=',edr.notificationJson) + 8, 
                 CHARINDEX(', userId=',edr.notificationJson) - CHARINDEX('storeListMemberId=',edr.notificationJson) - 8) as 'stored_list_member_id',
	   '|'+SUBSTRING(edr.notificationJson,
	             CHARINDEX('storeListMemberId=',edr.notificationJson) + 8, 
                 CHARINDEX(', userId=',edr.notificationJson) - CHARINDEX('storeListMemberId=',edr.notificationJson) - 8) + '|' as 'stored_list_member_id2',				 
       edr.*
from [ERIE_dcoe_records] as edr with(nolock)
) as a
inner join communication as c WITH (nolock) on c.communication_id = a.communication_id
inner join communication_process_email AS cpe WITH (nolock) on cpe.communication_id = c.communication_id
	--and ('tMemberId='+cast(COALESCE(cpe.stored_list_member_id, '') as varchar) = a.stored_list_member_id)
	and cpe.list_of_to_addresses = a.emailToAddress
order by c.communication_id, cpe.communication_process_email_id

