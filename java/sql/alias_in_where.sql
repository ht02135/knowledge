

--use alias in where clause via Parenthesis/Subselect

SELECT
	   *
FROM (
SELECT
	   logcount, 
	   logUserID, 
	   maxlogtm,
	   DATEDIFF(day, maxlogtm, GETDATE()) AS daysdiff
FROM statslogsummary   
where 1=1
) as innerTable
WHERE 1=1
and daysdiff > 120

select
       *
from (
select
       a.asset_id, 
       a.asset_file_path,
       a.remote_file_path,
       a.remote_asset,
       CASE WHEN a.asset_file_path = a.remote_file_path THEN 1 ELSE 0 END AS copy_remote_asset,
from asset as a with (nolock)
where 1=1
and a.remote_asset=1
) as innerTable
where 1=1
and copy_remote_asset = 1
order by copy_remote_asset desc, asset_id desc
