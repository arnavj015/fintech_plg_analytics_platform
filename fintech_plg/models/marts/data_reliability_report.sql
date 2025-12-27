-- Grain: one row representing current data reliability snapshot
-- Purpose: answer “Can we trust our metrics right now?”

with
bad_event_timestamps as (
    select count(*) as bad_events
    from {{ ref('stg_events') }}
    where is_bad_timestamp = 1
),

bad_txn_timestamps as (
    select count(*) as bad_txns
    from {{ ref('stg_transactions') }}
    where is_bad_timestamp = 1
),

total_events as (
    select count(*) as total_events
    from {{ ref('stg_events') }}
),

total_txns as (
    select count(*) as total_txns
    from {{ ref('stg_transactions') }}
),

orphan_txns as (
    select count(*) as orphan_txns
    from {{ ref('stg_transactions') }} t
    left join {{ ref('stg_users') }} u
      on t.user_id_clean = u.user_id_clean
    where u.user_id_clean is null
),

duplicate_txns as (
    select count(*) as duplicate_txns
    from {{ ref('stg_transactions') }}
    where is_duplicate_transaction = 1
)

select
    current_timestamp as report_generated_at,

    be.bad_events,
    te.total_events,
    case when te.total_events > 0 then be.bad_events::double / te.total_events else 0 end as pct_bad_event_timestamps,

    bt.bad_txns,
    tt.total_txns,
    case when tt.total_txns > 0 then bt.bad_txns::double / tt.total_txns else 0 end as pct_bad_txn_timestamps,

    ot.orphan_txns,
    case when tt.total_txns > 0 then ot.orphan_txns::double / tt.total_txns else 0 end as pct_orphan_txns,

    dt.duplicate_txns

from bad_event_timestamps be
cross join bad_txn_timestamps bt
cross join total_events te
cross join total_txns tt
cross join orphan_txns ot
cross join duplicate_txns dt
