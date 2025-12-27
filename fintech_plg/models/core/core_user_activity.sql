with user_events as (

    select
        user_id_clean,
        count(*) as total_events,
        min(event_time) as first_event_time,
        max(event_time) as last_event_time
    from {{ ref('stg_events') }}
    where is_bad_timestamp = 0
    group by user_id_clean
),

user_txns as (

    select
        user_id_clean,
        count(*) as txn_count,
        sum(amount) as total_revenue
    from {{ ref('stg_transactions') }}
    where is_bad_timestamp = 0
    group by user_id_clean
)

select
    d.user_id,
    d.signup_date,
    d.plan_type,

    coalesce(ue.total_events, 0) as total_events,
    ue.first_event_time,
    ue.last_event_time,

    coalesce(ut.txn_count, 0) as txn_count,
    coalesce(ut.total_revenue, 0) as total_revenue

from {{ ref('dim_users') }} d
left join user_events ue on d.user_id = ue.user_id_clean
left join user_txns ut on d.user_id = ut.user_id_clean
