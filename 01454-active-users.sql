-- my approach- unique
-- CTE- select only distinct dates for a user
-- do a lead() on rows- because we need 5 consecutive days, and 1st day would be the current login date, and 4 leading dates- eg- for 30 May, leading dates would be 31 May, 1, 2, 3 June = 5 consecutive days
-- diff between current date and leading date should be 4- eg. 30 May and 3 June = 4
-- join for getting names

with distinct_logins as
    (select distinct id, login_date
    from Logins)
select distinct t.id, a.name
from 
    (select id, login_date, 
      lead(login_date, 4, null) over(partition by id order by login_date) as lead_date,
      datediff(lead(login_date, 4, null) over(partition by id order by login_date), login_date) as diff
    from distinct_logins) t
join Accounts a
using(id)
where diff = 4
order by 1
