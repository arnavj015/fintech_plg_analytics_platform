SELECT
    user_id,
    signup_date,
    NULL AS country,  -- Placeholder for future country data
    plan_type
FROM {{ ref('stg_users') }}

