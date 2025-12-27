-- Grain: one row per rejected event record
-- Reason: isolate events that fail validation 

select
    e.*,

    case
        when is_bad_timestamp = 1 then 'BAD_TIMESTAMP'
        when user_id_clean is null or user_id_clean = '' then 'MISSING_USER_ID'
        else 'UNKNOWN_REASON'
    end as rejection_reason,

    current_timestamp as quarantined_at

from {{ ref('stg_events') }} e

where
    is_bad_timestamp = 1
    or user_id_clean is null
    or user_id_clean = ''
