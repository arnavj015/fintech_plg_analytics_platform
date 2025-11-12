SELECT 
    *
    {{ add_loaded_at() }}
FROM {{ source('raw_fintech', 'users') }}

