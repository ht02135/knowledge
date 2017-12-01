select '' as 'sd',
       DATEDIFF(day, sd.cutoff_date, sd.execute_date) AS exec_vs_cutoff_diff_days,
       DATEDIFF(day, sd.execute_date, sd.mail_date) AS mail_vs_exec_diff_days,
       sd.schedule_name as 'sd.name',
       CONVERT(VARCHAR(23), sd.cutoff_date, 121) + ' (' + datename(dw,sd.cutoff_date) + ')' as 'sd.cutoff_date',
       CONVERT(VARCHAR(23), sd.execute_date, 121) + ' (' + datename(dw,sd.execute_date) + ')' as 'sd.execute_date',
       CONVERT(VARCHAR(23), sd.mail_date, 121) + ' (' + datename(dw,sd.mail_date) + ')' as 'sd.mail_date',
	   sd.*
from SD as sd with (nolock)
where 1=1
and sd.schedule_name in ('Hello')
and sd.mail_date > '2017-01-01 00:00:00.000'
order by sd.schedule_name, sd.mail_date
