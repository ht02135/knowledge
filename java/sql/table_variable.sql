/*
CREATE TABLE @creativeUsageDetail (
	creative_id bigint,
	channel_type varchar(max),
	usage int
);
///////////////////
DECLARE TABLE :- You will create table on fly and use that table later on in the query and not stored physically.
CREATE TABLE: You will create table physically inside the database.
*/
declare @creativeUsageDetail TABLE
(
	creative_id bigint,
	channel_type varchar(max),
	usage int
)
