UPDATE [nylife_user_test].[dbo].[NYL_2017_calendar_schedule]
set cutoff_date =
 cast(
 CONVERT(VARCHAR(MAX),DATENAME(YYYY,cutoff_date)) + '-' +
 CONVERT(VARCHAR(MAX),DATEPART(mm,cutoff_date)) + '-' +
 CONVERT(VARCHAR(MAX),DATENAME(DD,cutoff_date)) + ' 06:00:00.000' as datetime)
