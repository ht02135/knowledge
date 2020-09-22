normally column that store json is nvarchar(max)

here is way to get json
select json
from saved_object with(nolock)
where 1=1
and saved_object = 1
FOR XML PATH('')

then you need to click on the return value in microsoft editor.  
then it will pop up another screen displaying all text.  
then you can copy

dont bother with ctrl-c and ctrl-p.  in my find this is more intuitive and common sense, 
but fucktard implemented microsoft sql studio that way.  what can i do?
