select
  count(distinct tag) as tag_count,
  count(distinct (case when entryId > 0 then tag end)) as positive_tag_count
from
  your_table_name;
  
The first count(distinct...) is easy. The second one, looks somewhat complex, is actually the same as the first one, 
except that you use case...when clause. In the case...when clause, you filter only positive values. 
Zeros or negative values would be evaluated as null and won't be included in count.

----------

	,count(case when qpcode in (1020,1021) then email_statistic_id end) as attribute2--open count
	,count(case when qpcode in (1071,1070) then email_statistic_id end) as attribute3--click count

	,count(distinct case when qpcode in (1020,1021) then email_address end) as attribute6--unique open count
	,count(distinct case when qpcode in (1071,1070) then email_address end) as attribute8--unique click count
		  
///////////
		  
select ct.*
from communication_template as ct with(nolock)
where 1=1
and ct.communication_template_type in ('Email')

select
	count(case when ct.communication_template_type in ('Email') then ct.reporting_segment end) as count,
	count(distinct case when ct.communication_template_type in ('Email') then ct.reporting_segment end) as unique_count
from communication_template as ct with(nolock)

select ct.reporting_segment
from communication_template as ct with(nolock)
where 1=1
and ct.communication_template_type in ('Email')

select distinct ct.reporting_segment
from communication_template as ct with(nolock)
where 1=1
and ct.communication_template_type in ('Email')
		  
select distinct ct.*
from communication_template as ct with(nolock)
where 1=1
and ct.communication_template_id in (
	select max(ct2.communication_template_id)
	from communication_template as ct2 with(nolock)
	where 1=1
	and ct2.communication_template_type in ('Email')
	group by ct2.reporting_segment
)
	
/////////////////////////////////
	
select em2.*
FROM email_statistic em2 WITH(NOLOCK)
where 1=1
and em2.email_statistic_id in (
	select min(email_statistic_id)
	from email_statistic WITH(NOLOCK)
	where 1=1
	group by comm_wave_event_id,email_address
	having comm_wave_event_id = 62880
	
/////////////////
	
DECLARE 

@currentUserId bigint, 
@orderId bigint, 
@pageSize bigint, 
@eventId bigint, 
@viewId bigint, 
@pageNumber bigint, 
@firstRecord bigint, 
@lastRecord bigint

SET @currentUserId = ?
SET @eventId = ?
SET @viewId = ?
SET @orderId = ?
SET @pageSize = ?
SET @pageNumber = ?
SET @lastRecord = @pageSize * @pageNumber
SET @firstRecord = @lastRecord - @pageSize + 1

SELECT *
FROM
  (SELECT *,
          row_number() over(
                            ORDER BY last_name DESC) AS num
   FROM
     (
SELECT
                      slm.phone_number,
                      slm.fax_number,
                      slm.mobile_number,
                      slm.company_name,
                      slm.prefix,
                      slm.title,
                      slm.suffix,
                      em.email_address,
                      em.click_url,
                      slm.first_name,
                      slm.last_name,
                      slm.address_line_1,
                      slm.address_line_2,
                      slm.city,
                      slm.state_province,
                      slm.postal_code,
                      slm.country_code,
                      em.comm_wave_event_id,
                      cwe.datetime_to_execute,
                      CURRENT_TIMESTAMP AS event_timestamp,
                      em.stored_list_member_id,
                      comm.communication_id
	FROM email_statistic em WITH(NOLOCK)
	INNER HASH JOIN stored_list_member slm WITH(NOLOCK) on slm.stored_list_member_id = em.stored_list_member_id
		and slm.email_addr = em.email_address	
INNER JOIN communication comm WITH(NOLOCK) on comm.communication_id = em.communication_id
	INNER JOIN communication_wave cw WITH(NOLOCK) on cw.communication_wave_id = isnull(em.comm_wave_id,0)
	INNER JOIN communication_wave_event cwe WITH(NOLOCK) on cwe.communication_wave_event_id = isnull(em.comm_wave_event_id,0)
	WHERE 1 = 1
AND ((
		(((@viewId = 1) AND (em.event_id = 1)) OR 			-- Sent (sentCount)
	 ((@viewId = 5) AND (em.qpcode in (1041,1040)))    	-- Bounces (bounces)
) 
AND em.email_statistic_id in (
			select em2.email_statistic_id 
			from email_statistic as em2 WITH(NOLOCK)
			INNER HASH JOIN stored_list_member slm2 on slm2.stored_list_member_id = em2.stored_list_member_id  
				--and slm2.email_addr = em2.email_address
				--and em2.comm_wave_event_id = @eventId
			where 1=1
			and em2.comm_wave_event_id = @eventId
	) 
	 ) OR
	 (
		(((@viewId = 2) AND (em.qpcode in (1020,1021))) OR 	-- Unique Opens (uniqueOpensCount)
	 	 ((@viewId = 3) AND (em.qpcode in (1071,1070))) OR 	-- Clicks (uniqueClicksCount)
	 	 ((@viewId = 4) AND (em.qpcode in (1042,1043,1044,1045,1046,1052,1054,1055,1056,1058,1064,1103))) 	-- Opt Outs (optOutCount)
		)
		AND em.email_statistic_id in (
			select max(em3.email_statistic_id)
			from email_statistic as em3 WITH(NOLOCK)
			INNER HASH JOIN stored_list_member slm3 on slm3.stored_list_member_id = em3.stored_list_member_id
				--and slm3.email_addr = em3.email_address
				--and em3.comm_wave_event_id = @eventId
			where 1=1
			group by em3.comm_wave_event_id, em3.email_address, em3.qpcode
			having em3.comm_wave_event_id = @eventId
		)
	 )
)
	AND em.comm_wave_event_id = @eventId
	AND comm.user_id = @currentUserId
     )AS a) AS b
WHERE (@pageSize = 0)
  OR (num BETWEEN @firstRecord AND @lastRecord)
ORDER BY num


