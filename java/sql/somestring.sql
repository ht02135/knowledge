select 
	   f.code as 'f.code',
	   f.name as 'f.name',
       SUBSTRING(f.filter_xml_content, 
	             CHARINDEX('<namespace>',f.filter_xml_content) + 11, 
                 CHARINDEX('</namespace>',f.filter_xml_content) - CHARINDEX('<namespace>',f.filter_xml_content) - 11) as 'namespace',
       case when CHARINDEX('<columnName>',f.filter_xml_content) > 0 then
       SUBSTRING(f.filter_xml_content, 
	             CHARINDEX('<columnName>',f.filter_xml_content) + 12, 
                 CHARINDEX('</columnName>',f.filter_xml_content) - CHARINDEX('<columnName>',f.filter_xml_content) - 12) 
       else 'N/A'
       end as 'columnName',
	   f.filter_xml_content as 'f.filter_xml_content',
	   f.*
from filter as f with(nolock)
where 1=1
and f.code in (
	'Age Range',
)
