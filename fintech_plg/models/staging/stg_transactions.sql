with source as (

    select * from {{ ref('transactions') }}

),

deduped as (

    select
        *,
        row_number() over (
            partition by transaction_id
            order by timestamp desc
        ) as _rn
    from source
),

cleaned as (

    select
        transaction_id,

        user_id,
        lower(trim(cast(user_id as varchar))) as user_id_clean,

        try_cast(amount as double) as amount,

        try_cast(timestamp as timestamp) as transaction_time
        {{ add_loaded_at() }},
        case when try_cast(timestamp as timestamp) is null then 1 else 0 end as is_bad_timestamp,
        case when _rn > 1 then 1 else 0 end as is_duplicate_transaction

    from deduped
    where _rn = 1  
)

select * from cleaned