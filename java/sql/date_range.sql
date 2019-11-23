DECLARE @datetimetoExecute datetime;
SET @datetimetoExecute = GETDATE();
SET @datetimetoExecute = '2020-02-03 00:30:00.000';


		SELECT '' as 'ori',
       		ct.subscription_ind, 
       		ct.CT_type,
       		ct.CT_code,
       		slm.original_data_source,
       		slm.attribute_month,
       		slm.attribute_date_of_month,
       		count(*) as 'count'
		FROM C AS c WITH (NOLOCK) 
		inner JOIN CT as ct WITH(NOLOCK) ON ct.CT_id = c.CT_id
		inner join SL as sl WITH (NOLOCK) on sl.SL_id=c.SL_id
		inner join SLM as slm WITH (NOLOCK) on slm.SL_id=sl.SL_id
		LEFT HASH JOIN [PC] pc WITH(NOLOCK) 
		   ON CAST([pc].[client_id] AS NUMERIC(24,0)) = CAST( ( CASE ISNUMERIC([slm].[composite_id]) WHEN 1 THEN CAST([slm].[composite_id] AS NUMERIC(24,0)) ELSE 0 END ) AS NUMERIC(24,0))	
		WHERE 1=1
			AND ct.subscription_ind = 1
			and ct.CT_type='DMS'
			and ct.CT_code like '%aloha%'
			and ct.status in ('ACTIVE')
			AND c.status not IN ('CANCELLED')
		    --AND [slm].[SL_id] = #fromStoredListId#
			AND ( 
			      ( ISNULL([slm].[composite_id],'') = ''
			        AND ISNULL([slm].[original_data_source],'') = 'BIRTHDAY'   	--user entered contact with birthda
			        AND ISNUMERIC([slm].[attribute_month]) = 1  					--attribute_month contains the month
			        AND LEN([slm].[attribute_month]) = 2        					--valid values 01 thru 12   
			        AND 
			        (   
			            ( ((MONTH(@datetimetoExecute) + 2) % 12) = (CAST([slm].[attribute_month] AS INT) % 12)
				           AND [slm].[attribute_date_of_month] IN ( '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15' )
			 	        )
				        OR ( ((MONTH(@datetimetoExecute) + 1) % 12) = (CAST([slm].[attribute_month] AS INT) % 12)
				           AND [slm].[attribute_date_of_month] NOT IN ( '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15' )
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
		GROUP BY ct.subscription_ind, ct.CT_type, ct.CT_code, slm.original_data_source, slm.attribute_month, slm.attribute_date_of_month
		ORDER BY ct.subscription_ind, ct.CT_type, ct.CT_code, slm.original_data_source, slm.attribute_month, slm.attribute_date_of_month


--/////////////////////////////////////////////


		SELECT '' as 'updated',
       		slm.original_data_source,
       		slm.attribute_month,
       		slm.attribute_date_of_month,
       		count(*) as 'count'
		FROM
		(
					SELECT  
						SLM_id
						, CASE WHEN ISDATE(new_birthday) = 1 THEN new_birthday
						ELSE getdate() END AS new_birthday
					FROM (
						SELECT 
							SLM_id
							,case 
								when attribute_month = '01' and 
									 (DATEPART (year,DATEADD(day, 13, @datetimetoExecute) ) > DATEPART (year, @datetimetoExecute)  
									   OR 
									  DATEPART (year,DATEADD(day, 19, @datetimetoExecute) ) > DATEPART (year, @datetimetoExecute)  
									 ) 
								then CAST(DATEPART (year,DATEADD(year, 1, @datetimetoExecute)) AS VARCHAR(4)) + '-' + attribute_month + '-' + attribute_date_of_month 
								else CAST(DATEPART (year, @datetimetoExecute) AS VARCHAR(4)) + '-' + attribute_month + '-' + attribute_date_of_month
							end AS new_birthday
						FROM SLM WITH(NOLOCK)
						WHERE 1=1
						--AND SL_id = #fromStoredListId#
						AND SL_id in (
							select c.SL_id
							FROM C AS c WITH (NOLOCK) 
							inner JOIN CT as ct WITH(NOLOCK) ON ct.CT_id = c.CT_id
							inner join SL as sl WITH (NOLOCK) on sl.SL_id=c.SL_id
							where 1=1
							AND ct.subscription_ind = 1
							and ct.CT_type='DMS'
							and ct.CT_code like '%aloha%'
							and ct.status in ('ACTIVE')
							AND c.status not IN ('CANCELLED')	
						)
					) in_df 
					WHERE 1=1
					AND ISDATE(new_birthday) = 1
		) birthday    
		INNER JOIN [SLM] slm WITH(NOLOCK) ON slm.SLM_id = birthday.SLM_id
		LEFT HASH JOIN [PC] pc WITH(NOLOCK) 
		   ON CAST([pc].[client_id] AS NUMERIC(24,0)) = CAST( ( CASE ISNUMERIC([slm].[composite_id]) WHEN 1 THEN CAST([slm].[composite_id] AS NUMERIC(24,0)) ELSE 0 END ) AS NUMERIC(24,0))	
		WHERE 1=1
			AND ( 
			      ( ISNULL([slm].[composite_id],'') = ''
			        AND ISNULL([slm].[original_data_source],'') = 'BIRTHDAY'   	--user entered contact with birthda
			        AND ISNUMERIC([slm].[attribute_month]) = 1  					--attribute_month contains the month
			        AND LEN([slm].[attribute_month]) = 2        					--valid values 01 thru 12   
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
		GROUP BY slm.original_data_source, slm.attribute_month, slm.attribute_date_of_month
		ORDER BY slm.original_data_source, slm.attribute_month, slm.attribute_date_of_month
