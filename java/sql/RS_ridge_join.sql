you do this bridge join when communication might be missing couple label rows, but you still want to see/display as null

select
	   rs2.communication_id,
	   rs2.inventory_code,
	   rs2.label,
	   rs2.customization_name,
	   rs2.communication_creative_customization_id,
	   rs2.customizationName,
	   rs2.customizationValue
from (
	select communication_id, 'Select Graphic' as label from communication where communication_id in (1000)
	union
	select communication_id, 'Select Second Graphic' as label from communication where communication_id in (1000)
	union
	select communication_id, 'Select Display Style' as label from communication where communication_id in (1000)
	union
	select communication_id, 'Return Date' as label from communication where communication_id in (1000)
	union
	select communication_id, 'Date Needed' as label from communication where communication_id in (1000)
	union
	select communication_id, 'Select Brochures (optional)' as label from communication where communication_id in (1000)
) as rs
left join (
	SELECT
	       c.communication_id,
	       cr.inventory_code,
	       ctag.label,
	       ctag.customization_name,
	       ccrc.communication_creative_customization_id,
	       ccrc.name AS 'customizationName',
	       ccrc.value AS 'customizationValue'
	FROM communication AS c WITH (nolock)
	LEFT JOIN communication_wave AS cw WITH (nolock) ON c.communication_id = cw.communication_id
	LEFT JOIN communication_wave_creative AS cwcr WITH (nolock) ON cw.communication_wave_id = cwcr.communication_wave_id
	LEFT JOIN communication_creative_customization AS ccrc WITH (nolock) ON cwcr.communication_wave_creative_id = ccrc.communication_wave_creative_id
	left JOIN creative cr WITH(NOLOCK) ON cr.creative_id = cwcr.creative_id
	LEFT JOIN customization_template AS ctmpl WITH (nolock) ON ctmpl.customization_template_id = cr.customization_template_id 
	LEFT JOIN customization_template_tag AS ctt WITH (nolock) ON ctmpl.customization_template_id = ctt.customization_template_id 
	left join customization_tag AS ctag WITH (nolock) ON ctag.customization_tag_id = ctt.customization_tag_id and ctag.customization_name = ccrc.name
	WHERE 1 = 1
	and c.communication_id in (
		1000
	)
) as rs2 on rs2.communication_id = rs.communication_id and rs2.label = rs.label
where 1=1
and (rs2.label like '%Select%Graphic%' or
     rs2.label like '%Select%Second%Graphic%' or
     rs2.label like '%Select%Display%Style%' or
     rs2.label like '%Return%Date%' or
	 rs2.label like '%Date%Needed%' or
	 rs2.label like '%Select%Brochures%(optional)%'
)
ORDER BY rs2.communication_id desc, rs2.inventory_code desc, rs2.label desc
