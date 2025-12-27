-- Grain: one row per rejected transaction record

select
    t.*,

    case
        when is_bad_timestamp = 1 then 'BAD_TIMESTAMP'
        when u.user_id_clean is null then 'ORPHAN_USER'
        when is_duplicate_transaction = 1 then 'DUPLICATE_TRANSACTION'
        else 'UNKNOWN_REASON'
    end as rejection_reason,

    current_timestamp as quarantined_at

from {{ ref('stg_transactions') }} t

left join {{ ref('stg_users') }} u
  on t.user_id_clean = u.user_id_clean

where
    is_bad_timestamp = 1
    or u.user_id_clean is null
    or is_duplicate_transaction = 1
