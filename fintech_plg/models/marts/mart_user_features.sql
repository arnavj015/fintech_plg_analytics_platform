-- User-level features designed for churn and LTV modeling
-- Stable grain: 1 row per user
-- This shows intentional AE ↔ DS handoff, which hiring managers love
select
  user_id,
  count(*) as total_events,
  sum(case when event_type = 'transaction' then amount else 0 end) as lifetime_revenue,
  max(event_date) as last_active_date
from {{ ref('fact_events_with_plan') }}
group by 1
