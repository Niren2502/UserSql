

-- 1. Select users whose id is either 3,2 or 4
-- - Please return at least: all user fields

-- Solution:

select * from users
where id in (2, 3, 4);




-- 2. Count how many basic and premium listings each active user has
-- - Please return at least: first_name, last_name, basic, premium

-- Solution:

create view data_data as (
select u.id, u.first_name, u.last_name
, CASE WHEN l.status = 2 then COUNT(l.status) else 0 end AS Basic
, CASE WHEN l.status = 3 then COUNT(l.status) else 0 end AS Premium
from users u
inner join listings l
on u.id = l.user_id
where u.status = 2
group by u.id, l.status
order by u.id);

select id, 
SUM(Basic) AS Basic,
Sum(Premium) AS Premium
from data_data
group by id;




-- 3. Show the same count as before but only if they have at least ONE premium listing
-- - Please return at least: first_name, last_name, basic, premium

-- Solution:

create view data_data as (
select u.id, u.first_name, u.last_name
, CASE WHEN l.status = 2 then COUNT(l.status) else 0 end AS Basic
, CASE WHEN l.status = 3 then COUNT(l.status) else 0 end AS Premium
from users u
inner join listings l
on u.id = l.user_id
where u.status = 2
group by u.id, l.status
order by u.id);

select id, 
SUM(Basic) AS Basic,
Sum(Premium) AS Premium
from data_data
group by id
having Sum(Premium) > 0;




-- 4. How much revenue has each active vendor made in 2013
-- - Please return at least: first_name, last_name, currency, revenue

-- Solution:

select u.id, u.first_name, u.last_name, c.currency, SUM(c.price) AS Revenue
from listings l
inner join clicks c 
on l.id = c.listing_id
inner join users u 
on l.user_id = u.id
where YEAR(c.created) = 2013 and u.status = 2
group by u.id, c.currency




-- 5. Insert a new click for listing id 3, at $4.00
-- - Find out the id of this new click. Please return at least: id

-- Solution:

insert into clicks 
(listing_id, price, currency, created)
VALUES
(3, 4.00, 'USD', UTC_TIMESTAMP());

select * from clicks;




-- 6. Show listings that have not received a click in 2013
-- - Please return at least: listing_name

-- Solution:

select distinct listing_id
from clicks
where YEAR(created) <> 2013
and listing_id not in
(select distinct listing_id
from clicks
where YEAR(created) = 2013);




-- 7. For each year show number of listings clicked and number of vendors who owned these listings
-- - Please return at least: date, total_listings_clicked, total_vendors_affected

-- Solution:

create view data_data as (
select YEAR(c.created) as date,u.id, count(l.id) as listings
from clicks c
inner join listings l
on c.listing_id = l.id
inner join users u
on l.user_id = u.id
group by YEAR(c.created), u.id
order by YEAR(created));

select 
date, 
count(id) as total_vendors_affected, 
SUM(listings) as total_listings_clicked
from data_data
group by date;




-- 8. Return a comma separated string of listing names for all active vendors
-- - Please return at least: first_name, last_name, listing_names

-- Solution:

select u.id, u.first_name, u.last_name, group_concat(l.name) as listing
from listings l
inner join users u
on l.user_id = u.id
where u.status = 2
group by u.id, u.first_name, u.last_name
order by u.id



