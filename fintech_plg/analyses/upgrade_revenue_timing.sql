-- Question: Do plan upgrades lead to higher revenue, or does revenue precede upgrades?

with events as (
  select
    user_id,
    event_date,
    event_type,
    amount,
    plan_type
  from {{ ref('fact_events_with_plan') }}
),

upgrades as (
  select
    user_id,
    min(event_date) as upgrade_date
  from events
  where plan_type in ('premium', 'enterprise')
  group by 1
),

revenue_window as (
  select
    e.user_id,
    e.event_date,
    e.amount,
    datediff('day', u.upgrade_date, e.event_date) as days_from_upgrade
  from events e
  join upgrades u using (user_id)
  where e.event_type = 'transaction'
)

select
  case
    when days_from_upgrade between -7 and -1 then 'Pre-upgrade'
    when days_from_upgrade between 0 and 7 then 'Post-upgrade'
  end as window,
  sum(amount) as revenue
from revenue_window
where days_from_upgrade between -7 and 7
group by 1

