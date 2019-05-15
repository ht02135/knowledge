https://smallbusiness.chron.com/integer-character-conversion-sql-48765.html
The CONVERT() function
The CONVERT() function is more sophisticated than STR(); it converts between characters, 
numbers and dates in different formats. It works just as well as STR() for changing 
integers into character data. A SQL statement using CONVERT() looks like the following:

SELECT item_name, CONVERT(CHAR(8), item_quantity) FROM items;

In this statement, CONVERT() turns the integer contained in "item_quantity" into an 
eight-character data item. Instead of the CHAR data type, you can use VARCHAR for 
variable-length character data, NCHAR for international Unicode data or NVARCHAR 
for variable-length Unicode.
//////////////////
CAST()
SQL’s CAST() function is similar to CONVERT(); it lacks the date formatting capabilities CONVERT() has, but otherwise works in a similar fashion. The following SQL statement converts integer data to characters using CAST():

SELECT item_name, CAST(item_quantity AS CHAR(8)) FROM items;

As with CONVERT(), CAST() can use any data type which receives characters: VARCHAR, NCHAR 
and NVARCHAR.
////////////
https://database.guide/6-ways-to-concatenate-string-and-number-sql-server/

SELECT 'Comments: ' + CONVERT(varchar(12), 9) AS Result;

SELECT 'Comments: ' + CAST(9 AS varchar(12)) AS Result;

select 'Time Sent : ' + CONVERT(VARCHAR(10), cpe.delivered_timestamp, 120)

/////////////

select top 100 
       'Order Number : ' + CONVERT(varchar(12), e.communication_id),
       'Time Sent : ' + CONVERT(VARCHAR(10), e.delivered_timestamp, 120),
       'Subject : ' + e.subject, 
       'To : ' + e.list_of_to_addresses, 
       'CC : ' + e.list_of_cc_addresses, 
       'BCC : ' + e.list_of_bcc_addresses
from email as e with (nolock)
where 1=1
and e.communication_id in (1)
order by email_id desc
