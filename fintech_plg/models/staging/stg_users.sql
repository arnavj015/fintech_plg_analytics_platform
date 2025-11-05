SELECT 
    *,
    CURRENT_TIMESTAMP() AS loaded_at
FROM {{ ref('users') }}

