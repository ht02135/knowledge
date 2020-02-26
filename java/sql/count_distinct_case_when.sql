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
