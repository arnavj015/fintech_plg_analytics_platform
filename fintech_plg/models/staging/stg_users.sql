SELECT 
    *
    {{ add_loaded_at() }}
FROM {{ ref('users') }}

