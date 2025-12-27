with source as (

    select * from {{ ref('users') }}

),

cleaned as (

    select
        user_id,
        lower(trim(cast(user_id as varchar))) as user_id_clean,

        try_cast(signup_date as date) as signup_date,

        lower(trim(plan_type)) as plan_type_clean
        {{ add_loaded_at() }},
        case 
            when try_cast(signup_date as date) is null then 1 else 0 
        end as is_bad_signup_date

    from source
)

select * from cleaned
