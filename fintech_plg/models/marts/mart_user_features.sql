select
    user_id,

    count(*) as total_events,

    sum(case when event_type = 'transaction' then amount else 0 end) as lifetime_revenue,

    max(event_date) as last_active_date,

    datediff('day', min(event_date), max(event_date)) as tenure_days,

    case
        when datediff('day', max(event_date), CURRENT_DATE) > 30
            then 1
        else 0
    end as is_churned,

    arg_max(plan_type, event_date) as last_known_plan

from {{ ref('fact_events_with_plan') }}
group by 1
