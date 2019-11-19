DECLARE @datetimetoExecute datetime;
SET @datetimetoExecute = GETDATE();
SET @datetimetoExecute = '2020-02-03 00:30:00.000';


		SELECT '' as 'ori',
       		ct.subscription_ind, 
       		ct.communication_template_type,
       		ct.communication_template_code,
       		slm.original_data_source,
       		slm.attribute38,
       		slm.attribute39,
       		count(*) as 'count'
		FROM communication AS c WITH (NOLOCK) 
		inner JOIN communication_template as ct WITH(NOLOCK) ON ct.communication_template_id = c.communication_template_id
		inner join stored_list as sl WITH (NOLOCK) on sl.stored_list_id=c.stored_list_id
		inner join stored_list_member as slm WITH (NOLOCK) on slm.stored_list_id=sl.stored_list_id
		LEFT HASH JOIN [population_client] pc WITH(NOLOCK) 
		   ON CAST([pc].[client_id] AS NUMERIC(24,0)) = CAST( ( CASE ISNUMERIC([slm].[composite_id]) WHEN 1 THEN CAST([slm].[composite_id] AS NUMERIC(24,0)) ELSE 0 END ) AS NUMERIC(24,0))	
		WHERE 1=1
			AND ct.subscription_ind = 1
			and ct.communication_template_type='DMS'
			and ct.communication_template_code like '%aloha%'
			and ct.status in ('ACTIVE')
			AND c.status not IN ('CANCELLED')
		    --AND [slm].[stored_list_id] = #fromStoredListId#
			AND ( 
			      ( ISNULL([slm].[composite_id],'') = ''
			        AND ISNULL([slm].[original_data_source],'') = 'BIRTHDAY'   	--user entered contact with birthda
			        AND ISNUMERIC([slm].[attribute38]) = 1  					--attribute38 contains the month
			        AND LEN([slm].[attribute38]) = 2        					--valid values 01 thru 12   
			        AND 
			        (   
			            ( ((MONTH(@datetimetoExecute) + 2) % 12) = (CAST([slm].[attribute38] AS INT) % 12)
				           AND [slm].[attribute39] IN ( '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15' )
			 	        )
				        OR ( ((MONTH(@datetimetoExecute) + 1) % 12) = (CAST([slm].[attribute38] AS INT) % 12)
				           AND [slm].[attribute39] NOT IN ( '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15' )
					    )
				    )
			      )
			      /*
			      OR
			      ( [pc].[client_id] IS NOT NULL 
			        AND ISNULL([slm].[original_data_source],'') != 'BIRTHDAY'
			        AND rtrim(ltrim([pc].[cnt_segment_ind_05])) = 'Y'
			      )
			      */
				)
		GROUP BY ct.subscription_ind, ct.communication_template_type, ct.communication_template_code, slm.original_data_source, slm.attribute38, slm.attribute39
		ORDER BY ct.subscription_ind, ct.communication_template_type, ct.communication_template_code, slm.original_data_source, slm.attribute38, slm.attribute39


		SELECT '' as 'updated',
       		slm.original_data_source,
       		slm.attribute38,
       		slm.attribute39,
       		count(*) as 'count'
		FROM
		(
					SELECT  
						stored_list_member_id
						, CASE WHEN ISDATE(new_birthday) = 1 THEN new_birthday
						ELSE getdate() END AS new_birthday
					FROM (
						SELECT 
							stored_list_member_id
							,case 
								when attribute38 = '01' and 
									 (DATEPART (year,DATEADD(day, 13, @datetimetoExecute) ) > DATEPART (year, @datetimetoExecute)  
									   OR 
									  DATEPART (year,DATEADD(day, 19, @datetimetoExecute) ) > DATEPART (year, @datetimetoExecute)  
									 ) 
								then CAST(DATEPART (year,DATEADD(year, 1, @datetimetoExecute)) AS VARCHAR(4)) + '-' + attribute38 + '-' + attribute39 
								else CAST(DATEPART (year, @datetimetoExecute) AS VARCHAR(4)) + '-' + attribute38 + '-' + attribute39
							end AS new_birthday
						FROM stored_list_member WITH(NOLOCK)
						WHERE 1=1
						--AND stored_list_id = #fromStoredListId#
						AND stored_list_id in (
							select c.stored_list_id
							FROM communication AS c WITH (NOLOCK) 
							inner JOIN communication_template as ct WITH(NOLOCK) ON ct.communication_template_id = c.communication_template_id
							inner join stored_list as sl WITH (NOLOCK) on sl.stored_list_id=c.stored_list_id
							where 1=1
							AND ct.subscription_ind = 1
							and ct.communication_template_type='DMS'
							and ct.communication_template_code like '%aloha%'
							and ct.status in ('ACTIVE')
							AND c.status not IN ('CANCELLED')	
						)
					) in_df 
					WHERE 1=1
					AND ISDATE(new_birthday) = 1
		) birthday    
		INNER JOIN [stored_list_member] slm WITH(NOLOCK) ON slm.stored_list_member_id = birthday.stored_list_member_id
		LEFT HASH JOIN [population_client] pc WITH(NOLOCK) 
		   ON CAST([pc].[client_id] AS NUMERIC(24,0)) = CAST( ( CASE ISNUMERIC([slm].[composite_id]) WHEN 1 THEN CAST([slm].[composite_id] AS NUMERIC(24,0)) ELSE 0 END ) AS NUMERIC(24,0))	
		WHERE 1=1
			AND ( 
			      ( ISNULL([slm].[composite_id],'') = ''
			        AND ISNULL([slm].[original_data_source],'') = 'BIRTHDAY'   	--user entered contact with birthda
			        AND ISNUMERIC([slm].[attribute38]) = 1  					--attribute38 contains the month
			        AND LEN([slm].[attribute38]) = 2        					--valid values 01 thru 12   
					AND CAST(birthday.new_birthday as datetime) 
						BETWEEN CAST(CONVERT(VARCHAR(10),DATEADD(day, 13, @datetimetoExecute),121) AS DATETIME)
						AND CAST(CONVERT(VARCHAR(10),DATEADD(day, 19, @datetimetoExecute),121)AS DATETIME)
			      )
			      /*
			      OR
			      ( [pc].[client_id] IS NOT NULL 
			        AND ISNULL([slm].[original_data_source],'') != 'BIRTHDAY'
			        AND rtrim(ltrim([pc].[cnt_segment_ind_05])) = 'Y'
			      )
			      */
				)
		GROUP BY slm.original_data_source, slm.attribute38, slm.attribute39
		ORDER BY slm.original_data_source, slm.attribute38, slm.attribute39
