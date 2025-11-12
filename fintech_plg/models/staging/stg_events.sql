SELECT
    user_id,
    event_type,
    event_time
    {{ add_loaded_at() }}
FROM {{ source('raw_fintech', 'events') }}

