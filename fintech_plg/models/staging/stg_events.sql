with source as (

    select * from {{ ref('events') }}

),

cleaned as (

    select
        user_id,
        lower(trim(cast(user_id as varchar))) as user_id_clean,

        lower(trim(event_type)) as event_type,

        try_cast(event_time as timestamp) as event_time
        {{ add_loaded_at() }},
        case when try_cast(event_time as timestamp) is null then 1 else 0 end as is_bad_timestamp

    from source
)

select * from cleaned
