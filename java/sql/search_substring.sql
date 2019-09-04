SELECT '' as 'ct+f',
       ct.subscription_ind,
       ct.communication_template_type,
       ct.communication_template_code,
       SUBSTRING(f.filter_xml_content, 
	             CHARINDEX('<namespace>',f.filter_xml_content) + 11, 
                 CHARINDEX('</namespace>',f.filter_xml_content) - CHARINDEX('<namespace>',f.filter_xml_content) - 11) as 'namespace',
       count(*) as 'count'
FROM CT as ct WITH (nolock) 
inner JOIN CTF as ctf WITH (nolock) ON ct.communication_template_id = ctf.communication_template_id 
inner JOIN F as f with (nolock) ON ctf.filter_id = f.filter_id 
WHERE 1=1
and ct.status='ACTIVE'
and ct.communication_template_code in (
	'haha',
	'haha2',
	'haha4',
	'haha5',
	'haha6'
)
group by ct.subscription_ind, ct.communication_template_type, ct.communication_template_code, 
	     SUBSTRING(f.filter_xml_content, 
	               CHARINDEX('<namespace>',f.filter_xml_content) + 11, 
                   CHARINDEX('</namespace>',f.filter_xml_content) - CHARINDEX('<namespace>',f.filter_xml_content) - 11)
order by ct.subscription_ind, ct.communication_template_type, ct.communication_template_code
