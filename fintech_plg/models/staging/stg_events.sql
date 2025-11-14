SELECT
    user_id,
    event_type,
    event_time
    {{ add_loaded_at() }}
FROM {{ ref('events') }}

