with base as (

    select
        user_id,
        user_id_clean,
        signup_date,
        plan_type_clean,
        loaded_at,

        row_number() over (
            partition by user_id_clean
            order by loaded_at desc
        ) as rn

    from {{ ref('stg_users') }}
)

select
    user_id_clean as user_id,           
    signup_date,
    plan_type_clean as plan_type,
    cast(null as varchar) as country    
from base
where rn = 1
