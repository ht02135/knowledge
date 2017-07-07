SELECT json
FROM saved_object WITH(NOLOCK)
WHERE 1=1
AND saved_object_id = 74609
AND user_id = 50172
FOR XML PATH('')
