-- Time-aware revenue mart: Revenue by the plan users were on at the time of purchase
-- This enables accurate revenue attribution and answers questions like:
-- "How much revenue did Pro users generate last month?"
-- "Did upgrades precede revenue or follow it?"
-- You could not answer this correctly without snapshots!
select
  event_date,
  plan_type,
  sum(amount) as revenue
from {{ ref('fact_events_with_plan') }}
where event_type = 'transaction'
group by 1, 2

