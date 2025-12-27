-- Grain: one row per event, enriched with the plan that was active at the time of the event. Falls back to current plan if no history match.

with events as (

    select
        event_id,
        user_id,
        event_type,
        event_time,
        event_date,
        amount
    from {{ ref('facts_events_with_amount') }}

),

plan_history as (

    select
        user_id,
        lower(trim(plan_type)) as plan_type,
        dbt_valid_from,
        dbt_valid_to
    from {{ ref('users_plan_history') }}
),

joined as (

    select
        e.event_id,
        e.user_id,
        e.event_type,
        e.event_time,
        e.event_date,
        e.amount,
        ph.plan_type as historical_plan

    from events e
    left join plan_history ph
      on e.user_id = ph.user_id
     and e.event_time >= ph.dbt_valid_from
     and e.event_time < coalesce(ph.dbt_valid_to, '9999-12-31')

)

select
    j.event_id,
    j.user_id,
    j.event_type,
    j.event_time,
    j.event_date,
    j.amount,
    coalesce(j.historical_plan, d.plan_type) as plan_type

from joined j
left join {{ ref('dim_users') }} d
  on j.user_id = d.user_id
