Tab	char(9)
Line feed	char(10)
Carriage return	char(13)

--////////////////

select * from parameters where name like '%'+char(13)+'%' or name like '%'+char(10)+'%'
WHERE CHARINDEX(CHAR(13), name) <> 0 OR CHARINDEX(CHAR(10), name) <> 0

remove
Select replace(replace(Name,char(10),''),char(13),'')

--///////////////////

declare @textToReplace nvarchar(2000);
declare @replacementText nvarchar(2000);

set @textToReplace = char(13)
set @replacementText = '\r'

select 
	cto.name as 'cto.name',
	cto.value as 'cto.value',
	replace(convert(varchar(max), cto.name), @textToReplace, @replacementText) as 'cto.name (contains \r)',
	replace(convert(varchar(max), cto.value), @textToReplace, @replacementText) as 'cto.value (contains \r)',
cto.*
from CTO AS cto WITH (NOLOCK)
where 1=1
and (CHARINDEX(CHAR(13), cto.value) <> 0 OR 
     CHARINDEX(CHAR(10), cto.value) <> 0)
     
PRINT 'update cto: begin ================================================================================'
update cto
set cto.version = cto.version + 1,
    cto.name = replace(cto.name,char(13),'')
from CTO as cto
where 1=1
and cto.CTO_id in (
11139,
11140,
11141,
11142,
11143
)
PRINT 'update ct0: end ================================================================================'
 
