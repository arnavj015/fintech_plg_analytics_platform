with events as (

    select
        e.user_id_clean as user_id,
        e.event_type,
        e.event_time,
        {{ dbt_utils.generate_surrogate_key(['user_id_clean', 'event_type', 'event_time']) }} as event_id
    from {{ ref('stg_events') }} e
    where e.is_bad_timestamp = 0
)

select
    event_id,
    user_id,
    event_type,
    cast(event_time as date) as event_date,
    event_time
from events