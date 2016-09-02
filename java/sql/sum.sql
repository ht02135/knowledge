
--sum(count(1)) OVER() AS total_count
SELECT distinct
       e.event_id as 'e.event_id',
       e.contact_count as 'e.contact_count',
       sum(e.contact_count) OVER() AS total_contact_count
FROM event AS e WITH (NOLOCK)
WHERE 1=1

select ow.delivery,
       count(1) as count,
       sum(count(1)) OVER() AS total_count
from order AS o WITH (NOLOCK)
inner join order_wave as ow WITH (NOLOCK) on ow.order_id = o.order_id
where 1=1
and ow.delivery in ('email')
group by delivery
