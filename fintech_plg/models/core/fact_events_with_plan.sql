-- Temporal join: Attach the plan the user was on at the time the event happened, not today's plan.
-- This is critical for revenue attribution, churn analysis, and plan upgrade funnels.
select
  f.event_id,
  f.user_id,
  f.event_date,
  f.event_type,
  f.amount,
  s.plan_type
from {{ ref('fact_events') }} f
left join {{ ref('users_plan_history') }} s
  on f.user_id = s.user_id
 and f.event_date >= s.dbt_valid_from::date
 and f.event_date < coalesce(s.dbt_valid_to::date, '9999-12-31'::date)

