
if cto.value is ntext
if ccrc.value is nvarchar

then you get sql error.  to fix, convert ntext to nvarchar.

cast(cto.value as nvarchar(max)) = ccrc.value
