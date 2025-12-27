-- Self-serve analytics entry point for product & growth teams
-- This is exploratory
select
  event_date,
  plan_type,
  sum(amount) as total_revenue,
  count(distinct user_id) as paying_users,
  sum(amount) / nullif(count(distinct user_id), 0) as arpu
from {{ ref('fact_events_with_plan') }}
where event_type = 'transaction'
group by 1, 2
order by 1, 2

