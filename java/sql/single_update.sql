
declare @newCrId bigint;
declare @newInvCode varchar(200);


--///////////////////


SET @newInvCode = 'new_code';
select @newCrId = creative_id from creative cr with(nolock) where inventory_code = @newInvCode;

--update
update CWC
set
	version = version + 1,
	creative_id = @newCrId
where 1=1
and CWC_id in (
	select cwcr.CWC_id 
	FROM C AS c WITH (NOLOCK) 
	LEFT JOIN CW AS cw WITH (NOLOCK) ON cw.C_id = c.C_id 
	LEFT JOIN CWC AS cwcr WITH(NOLOCK) ON cwcr.CW_id = cw.CW_id
	WHERE 1=1
	AND (c.status <> 'CANCELLED')
	AND c.C_id in (1)
)
;

--//////////////


--update
update CWC
set
	version = version + 1,
	creative_id = (select creative_id from creative cr with(nolock) where inventory_code = 'new_code')
where 1=1
and CWC_id in (
	select cwcr.CWC_id 
	FROM C AS c WITH (NOLOCK) 
	LEFT JOIN CW AS cw WITH (NOLOCK) ON cw.C_id = c.C_id 
	LEFT JOIN CWC AS cwcr WITH(NOLOCK) ON cwcr.CW_id = cw.CW_id
	WHERE 1=1
	AND (c.status <> 'CANCELLED')
	AND c.C_id in ()
)
;

--sometime single update is much clean than using variables.
