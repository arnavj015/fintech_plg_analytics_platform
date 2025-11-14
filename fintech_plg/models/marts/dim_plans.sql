SELECT DISTINCT
    plan_type AS plan_id,
    plan_type AS plan_name,
    CASE 
        WHEN plan_type = 'free' THEN 0
        WHEN plan_type = 'premium' THEN 99.99
        WHEN plan_type = 'enterprise' THEN 299.99
        ELSE NULL
    END AS monthly_price
FROM {{ ref('stg_users') }}
WHERE plan_type IS NOT NULL

