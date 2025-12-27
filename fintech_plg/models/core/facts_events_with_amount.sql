with events as (
    select *
    from {{ ref('fact_events') }}
),

txns as (
    select
        user_id_clean as user_id,
        transaction_time,
        amount
    from {{ ref('stg_transactions') }}
    where is_bad_timestamp = 0
),

-- For transaction events, find the closest transaction within 24 hours
transaction_events_with_amounts as (
    select
        e.event_id,
        e.user_id,
        e.event_type,
        e.event_time,
        e.event_date,
        t.amount,
        row_number() over (
            partition by e.event_id
            order by abs(extract(epoch from (e.event_time - t.transaction_time)))
        ) as rn
    from events e
    inner join txns t
        on e.user_id = t.user_id
        and e.event_type = 'transaction'
        and abs(extract(epoch from (e.event_time - t.transaction_time))) <= 86400  -- 24 hours in seconds
),

-- Non-transaction events (no amount needed)
non_transaction_events as (
    select
        event_id,
        user_id,
        event_type,
        event_time,
        event_date,
        0 as amount
    from events
    where event_type != 'transaction'
)

select
    event_id,
    user_id,
    event_type,
    event_time,
    event_date,
    amount
from transaction_events_with_amounts
where rn = 1

union all

select
    event_id,
    user_id,
    event_type,
    event_time,
    event_date,
    amount
from non_transaction_events
