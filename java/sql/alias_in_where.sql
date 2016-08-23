
SELECT
   *
FROM
(
   SELECT
      logcount, logUserID, maxlogtm,
      DATEDIFF(day, maxlogtm, GETDATE()) AS daysdiff
   FROM statslogsummary   
) as innerTable
WHERE daysdiff > 120
